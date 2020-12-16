#!/bin/bash
#
  Copyright="(C) 2020 Carlos Ijalba GPLv3" # <perkolator @ gmail.com>
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
##########################################################################
#
#  Program: ansible_config.sh
#
#  Description:
#
#    Shell Script to configure an ansible infrastructure.
#
#    First we configure the ansible control node, and then we issue all the 
#    necessary playbooks to deploy our infra.
#
# Versions       Date         Programmer, Modification
# -----------    ----------   -------------------------------------------
# Version=1.00   07/07/2020 - Carlos Ijalba, Original.
  Version=1.35 # 13/12/2020 - Carlos Ijalba, Latest updates.
#
#########################################################################
#set -x

#Var ----------------------------------------- Variable Declarations ####

HOSTS="/etc/hosts"
AHOSTS="/etc/ansible/hosts"
ACFG="/etc/ansible/ansible.cfg"
PBOOKS="/home/vagrant/playbooks"
PSCRIPTS="/home/vagrant/scripts"
PSECRETS="/home/vagrant/secrets"
USER=$( cat $PSECRETS/ansible_user.sec )
PASSWORD=$( cat $PSECRETS/ansible_pass.sec )
SUDO="sudo -u $USER"


#Function ------------------------------------------ Local Functions ####

function if_error
 ######################
 #
 # function to show if a previous command execution has been successful or not,
 # it's invoked as following:
 #
 #    function         $1              $2          $3
 #    -------- ---------------------  ------  ------------------------
 #    if_error "operation X failed."  ACTION  "operation X successful."
 #
 # Note: ACTION ($2) is the action to use in error, can be "exit" or "return", depending on how
 # we want to act if error has ocurred, return continues and exit aborts the script.
 #
 ######################
{
if [ $? -ne 0 ]
  then                                  # check the last return code, if rc <> 0...
    echo "--- ERROR: $1"                # ...print msg & return original's rc.
    $2 $?
  else                                  # if rc OK, print success msg.
    echo "+++ OK: $3"
fi
}


#Begin Main -------------------------------------- Main Programs code ####

echo ">>> ansible_config  v$Version - $Copyright - Configuring ansible infra in `hostname`. `date`"

echo ">> populating /etc/hosts with our environment"
echo "192.168.11.11	graf1.local   grafana"  | sudo tee -a $HOSTS 
echo "192.168.11.12	web1.local    nginx"    | sudo tee -a $HOSTS 
echo "192.168.11.13	web2.local    apache2"  | sudo tee -a $HOSTS
echo "192.168.11.14	prom1.local   ansible"  | sudo tee -a $HOSTS 

echo ">> creating /etc/ansible/hosts file"
sudo mkdir -p /etc/ansible 
sudo touch $AHOSTS

echo ">> populating /etc/ansible/hosts file"
echo "[prometheus]" | sudo tee -a $AHOSTS
echo "prom1.local"  | sudo tee -a $AHOSTS
echo "[grafana]"    | sudo tee -a $AHOSTS
echo "graf1.local"  | sudo tee -a $AHOSTS
echo "[nginx]"      | sudo tee -a $AHOSTS
echo "web1.local"   | sudo tee -a $AHOSTS
echo "[apache2]"    | sudo tee -a $AHOSTS
echo "web2.local"   | sudo tee -a $AHOSTS

echo ">> adding no host-key checking to ansible config"
sed -i '/\[defaults\]/a host_key_checking = False' $ACFG
if_error "problem addind host_key_checking = False to $ACFG" return "ansible host_key_checking set to False."

cd $PSCRIPTS
dos2unix *.sh
if_error "problem converting scripts to Linux format (check dos2unix tool)." return "scripts converted to Linux format."

chmod +x *.sh 
if_error "problem making scripts executable." exit "scripts made executable."

echo "o-> setup SSH trust relationship using Expect..."
$PSCRIPTS/ssh_trust.sh $USER $PASSWORD "prom1.local" 
$PSCRIPTS/ssh_trust.sh $USER $PASSWORD "graf1.local" 
$PSCRIPTS/ssh_trust.sh $USER $PASSWORD "web1.local" 
$PSCRIPTS/ssh_trust.sh $USER $PASSWORD "web2.local" 

echo ">> doing some quick ansible CHECKS..."
$SUDO ansible -m ping all
if_error "ansible PING has failed somewhere." exit "ansible PING OK."

$SUDO ansible -m shell -a "cat /etc/issue" all
if_error "ansible config has failed somewhere." exit "ansible configured OK."


echo ">> setup infrastructure using ansible playbooks..."
$SUDO ansible-playbook $PBOOKS/apt_upgrade.yaml
if_error "all servers update/upgrade failed." return "all servers repos have been updated & upgraded, Nice!."


# Start Prometheus & Grafana install
echo ">> setup prometheus..."
$SUDO $PSCRIPTS/prom_blackbox_install.sh 
if_error "ansible blackbox-exporter role install failed." return "ansible blackbox-exporter role installed."

$SUDO ansible-playbook $PBOOKS/prometheus_install.yaml
if_error "prometheus install failed." return "prometheus installed."

$SUDO ansible-playbook $PBOOKS/prom_blackbox-exporter_install.yaml
if_error "prometheus blackbox-exporter install failed." return "prometheus blackbox-exporter installed."

$SUDO ansible-playbook $PBOOKS/prom_alert-manager_install.yaml
if_error "prometheus alert-manager install failed." return "prometheus alert-manager installed."

$SUDO ansible-playbook $PBOOKS/prom_pushgateway_install.yaml
if_error "prometheus pushgateway install failed." return "prometheus pushgateway installed."

$SUDO ansible-playbook $PBOOKS/prometheus_config.yaml
if_error "prometheus config failed." return "prometheus configured."

echo ">> setup grafana..."
$SUDO ansible-playbook $PBOOKS/grafana_install.yaml
if_error "grafana install failed." return "grafana installed."

echo ">> install prometheus agent in all hosts..."
$SUDO ansible-playbook $PBOOKS/prom_node-exporter_install.yaml
if_error "prometheus node-exporter install failed." return "prometheus node-exporter installed."


# Start Nginx install
echo ">> setup nginx..."
$SUDO ansible-playbook $PBOOKS/nginx_install.yaml
if_error "nginx install failed (check ansible-playbook)." return "nginx installed."

$SUDO ansible-playbook $PBOOKS/nginx_config.yaml
if_error "nginx config failed (check ansible-playbook)." return "nginx configured."


# Start Apache2 install
echo ">> setup apache2..."
$SUDO ansible-playbook $PBOOKS/apache2_install.yaml
if_error "apache2 install failed (check ansible-playbook)." return "apache2 installed."

$SUDO ansible-playbook $PBOOKS/apache2_config.yaml
if_error "apache2 config failed (check ansible-playbook)." return "apache2 configured."


echo ">>> ansible_config Finished."                # final message 

#End Main ----------------------------------------------- End Program ####
