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
# 1.01   - 10/07/2020 - Carlos Ijalba, Latest updates.
# 1.02   - 07/09/2020 - Carlos Ijalba, updated due to changes in the SSH stack. 
#
#########################

# Var

set Version "1.02" 
set user     [lindex $argv 0]
set pass     [lindex $argv 1]
set hostname [lindex $argv 2]
# lower expect's default timeout:
set timeout 25


# Main

puts ">>> ssh_trust v$Version. for ==> $user@$hostname."

# invoke ssh-copy-id command to create SSH trust rel, and use expect to answer the
# authentication messages:
spawn sudo -u vagrant /usr/bin/ssh-copy-id -i /home/vagrant/.ssh/id_rsa.pub $user@$hostname
expect {
   "*yes/no*" { send "yes\r" ; exp_continue }
   "*assword:" { send "$pass\r" ; exp_continue }
   timeout { exit }
}

# now try to login to the machine for the first time
spawn sudo -u vagrant ssh $user@$hostname
expect {
   "*yes/no*" { send "yes\r" ; exp_continue }
   "*assword:" { send "$pass\r" ; exp_continue }
   "*vagrant*" { send "logout\r" ; exp_continue }
   timeout { exit }
}

# End
