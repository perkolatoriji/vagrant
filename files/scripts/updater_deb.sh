#!/bin/bash
#
  Copyright="(C) 2020-21 Carlos Ijalba GPLv3" # <perkolator @ gmail.com>
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
#  Program: updater_deb.sh
#
#  Description:
#
#    Shell Script to setup and update basic debian boxes.
#
#
# Versions       Date         Programmer, Modification
# -----------    ----------   -------------------------------------------
# Version=1.00   10/08/2020 - Carlos Ijalba, Original.
  Version=1.01 # 03/08/2021 - Carlos Ijalba, used apt-get instead of apt 
#
#########################################################################
#set -x

#Var ----------------------------------------- Variable Declarations ####

#Function ------------------------------------ Function Declarations ####

#Main ---------------------------------------------------- Main Code ####

echo ">>> Starting updater_deb.sh v$Version script."

echo ">> set timezone."
# if you have installed a minimal server, you'll need to install tzdata if you want to change to other TZs:
#apt install tzdata
# Set timezone to UTC, or if you prefer to use your local TZ, modify this:
timedatectl set-timezone UTC

echo ">> repo updates."
apt-get update
#apt-get upgrade -y
apt-get autoremove -y
apt-get autoclean -y
apti-get update

echo ">> essential tools install."
# Install essential tools.
apt-get install htop -y

echo ">> add vagrant user to sudo & remove requiretty."
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

echo ">> vagrant SSH keygen."
echo vagrant | sudo -S su - vagrant -c "ssh-keygen -t rsa -f /home/vagrant/.ssh/id_rsa -q -P ''"

echo ">>> Finished updater_deb.sh."
