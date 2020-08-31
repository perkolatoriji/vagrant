#!/bin/bash
#
# Program:  which_webserver
#
# Description:
#
#   Web Server identifier script.
#
#         Ver    Date       Developer      Notes
#         ----   ---------- -------------  --------------------------------------------------------------------------------
# Version=1.00 # 30/08/2020 Carlos Ijalba, Original Script written with help from posts found in the internet.
  Version=1.01 # 31/08/2020 Carlos Ijalba, Added ping check to avoid long timeouts 
#
###########################################################################################################################
#set -x

# Var

# Function

usage() 
{
cat << EOF

which_webserver   ver: $Version - Carlos Ijalba.

- Identifies a Unix/Linux OS and it's CPU (or at least, it tries to).

usage:    which_webserver   www.example.com    --> identify web server by FQDN.

          which_webserver   192.168.11.12      --> identify web server by IP.
          
          which_webserver   -v                 --> shows this script's version.
          
          which_webserver   --help             --> shows this help page.

EOF
}


# Main

URL="$1 "

case "$1" in

  ""|-h|--help)  usage
              ;;
  -v)         echo ">>> which_webserver   Version: $Version."
              ;;
  *)          ping $1 -nc 1 > /dev/null 2>&1 
	      if [ $? == 0 ]
	        then
                  curl -sI $URL | grep -i "server"
                else
		  echo ">>> $1 not reachable from this box, or it doesn't have WEB server headers, sorry."
              fi
              ;;
esac

# End
