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
  Version=1.12 # 15/07/2020 - Carlos Ijalba, Latest updates.
#
#########################################################################
#set -x

#Var ----------------------------------------- Variable Declarations ####

echo ">>> Starting ansible_install.sh v$Version script."

echo ">> repo updates."
dnf makecache -y
dnf install epel-release -y
dnf makecache -y

echo ">> ansible install."
# Install Ansible.
dnf install ansible -y

echo ">> tools install."
# Install neccesary tools for our scripts.
dnf install expect -y
dnf install dos2unix -y

echo ">> set timezone."
# if you have installed a minimal server, you'll need to install tzdata if you want to change to other TZs:
#yum install tzdata
# Set timezone to UTC, or if you prefer to use your local TZ, modify this:
timedatectl set-timezone UTC

echo ">> add vagrant user to sudo."
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

echo ">> vagrant SSH keygen."
echo vagrant | sudo -S su - vagrant -c "ssh-keygen -t rsa -f /home/vagrant/.ssh/id_rsa -q -P ''"


echo ">> Checks --- --- --- ---"
ansible --version
expect -v
dos2unix --version

echo ">>> Finished ansible_install.sh."
