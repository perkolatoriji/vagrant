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
#  Program: ansible_install.sh
#
#  Description:
#
#    Shell Script to install ansible.
#
#  Documentation Followed:
#
#    https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html
#
# Versions       Date         Programmer, Modification
# -----------    ----------   -------------------------------------------
# Version=1.00   07/07/2020 - Carlos Ijalba, Original.
  Version=1.16 # 05/08/2020 - Carlos Ijalba, Latest updates.
#
#########################################################################
set -x

#Var ----------------------------------------- Variable Declarations ####

PATH="/home/vagrant/scripts"
apptool="apt"

#Function ------------------------------------ Function Declarations ####

function init_func
###########################################
# funtion to initialize the OS repository
###########################################
{
$apptool update -y
$apptool install epel-release -y
}

function update_func
###########################################
# funtion to initialize the OS repository
###########################################
{
$apptool update -y
}

function ansible_install_func
###########################################
# funtion to install ansible 
###########################################
{
$apptool install ansible -y
}

function tools_install_func
###########################################
# funtion to install needed tools 
###########################################
{
$apptool install python3 -y
$apptool install expect -y
$apptool install dos2unix -y
}

function tools_check_func
###########################################
# funtion to check the tools versions and installations 
###########################################
{
echo ">> python: ---"
python --version
echo ">> ansible: ---"
ansible --version
echo ">> expect: ---"
expect -v
echo ">> dos2unix: ---"
dos2unix --version
}

#Main ---------------------------------------------------- Main Code ####

echo ">>> Starting ansible_install.sh v$Version script."

#echo ">> identifying OS..."
#case OS=`$PATH/which_os.sh -lb` in
#
#  rhel)	apptool="yum"
#  		;;
#  debian)	apptool="apt"
#  		;;
#  *)		apptool="apt"	# by default assume it's a debian-based distro
#    		;;
#esac

echo ">> repo updates."
init_func

echo ">> tools install."
# Install neccesary tools for our scripts.
tools_install_func

echo ">> ansible install."
# Install Ansible.
update_func
ansible_install_func

#echo ">> vagrant user tweaks."
# first we add vagrant user to sudo:
#echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
# then we remove the requiretty def parameter from sudoers file if it exists:
#sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

#echo ">> vagrant SSH keygen."
# now we generate an ssh key for the user vagrant:
#echo vagrant | sudo -S su - vagrant -c "ssh-keygen -t rsa -f /home/vagrant/.ssh/id_rsa -q -P ''"

echo ">> Checks --- --- --- ---"
tools_check

echo ">>> Finished ansible_install.sh."
