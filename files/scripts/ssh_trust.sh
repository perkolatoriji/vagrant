#!/usr/bin/expect -f
# 
##########################################################################
#
#  Program: ssh_trust.sh
#
#  Description:
#
#    Expect Script to create SSH trust relationships for vagrant infrastructure.
#
# Version  Date         Programmer, Modification
# -------  ----------   -------------------------------------------
# 1.00   - 07/07/2020 - xxx, Original.
# 1.03   - 19/11/2020 - Carlos Ijalba, Latest updates.
#
#########################

# Var

set Version "1.03" 
set user     [lindex $argv 0]
set pass     [lindex $argv 1]
set hostname [lindex $argv 2]
# lower expect's default timeout:
set timeout 25


# Main

puts ">>> ssh_trust v$Version. for ==> $user@$hostname."

# invoke ssh-copy-id command to create SSH trust rel, and use expect to answer the
# authentication messages:
spawn sudo -u $user /usr/bin/ssh-copy-id -i /home/vagrant/.ssh/id_rsa.pub $user@$hostname
expect {
   "*yes/no*" { send "yes\r" ; exp_continue }
   "*assword:" { send "$pass\r" ; exp_continue }
   timeout { exit }
}

# End
