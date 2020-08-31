#!/bin/bash
#
# Program:  which_os
#
# Description:
#
#   Unix/Linux OS & CPU identifier script.
#
#         Ver    Date       Developer      Notes
#         ----   ---------- -------------  --------------------------------------------------------------------------------
# Version=1.02 # 16/07/2020 Carlos Ijalba, Original Script written with help from snippets found in the internet years ago.
# Version=1.04 # 17/07/2020 Carlos Ijalba, Added cygwin detection.
# Version=1.05 # 23/07/2020 Carlos Ijalba, Added linux family detection.
# Version=1.07 # 24/07/2020 Carlos Ijalba, Added linux distro detection & families flag.
# Version=1.09 # 06/08/2020 Carlos Ijalba, Added linux distro batchmode & checked in diff distros.
  Version=1.10 # 30/08/2020 Carlos Ijalba, Changed SH script to BASH, for incompatibilities between shell & dash. 
#
###########################################################################################################################

# Var

os=$(uname -s 2>/dev/null | tr '[:upper:]' '[:lower:]' 2>/dev/null)     # define os var using uname
osd="This_Ain't_Linux"                                                  # initialize the linux distro variable

# Function

usage() 
{
cat << EOF

which_os    ver: $Version - Carlos Ijalba.

- Identifies a Unix/Linux OS and it's CPU (or at least, it tries to).

usage:    which_os         --> shows identified OS and CPU.

          which_os -b      --> gives the identified OS only (Batch mode, good for scripting).
          
          which_os -f      --> show OS families detected.
          
          which_os -l      --> for Linux, gives OS family and distro.
          
          which_os -lb     --> for Linux, gives distro (Batch mode, good for scripting).
          
          which_os -v      --> shows this script's version.
          
          which_os --help  --> shows this help page.

EOF
}

families() 
{
cat << EOF

which_os    ver: $Version - Carlos Ijalba.

-UNIX/Linux Families that which_os will try to detect:


  1.- IBM AIX: IBM Enterprise UNIX.
  
  2.- HP NonStop OSF: HP-Tandem NonStop OS, Unix compatible shell. 
  
  3.- CYGWIN: POSIX-compatible programming and runtime environment for windows.
  
  4.- FreeBSD: open-source Unix-like operating system descended from the Berkeley Software Distribution.
  
  5.- HP-UX: HP Enterprise UNIX.
  
  6.- IRIX: Silicon Graphics Enterprise UNIX.
  
  7.- Darwin: MacOSX.
  
  8.- Solaris: Solaris & SunOS Oracle-Sun Enterprise UNIX.
  
    - Linux:
            9.-  RHEL
            10.- Debian
            11.- Ubuntu
            12.- CentOS
            13.- OEL

EOF
}

# Main

case "$os" in
  *aix*)          osf="aix"
                  cpu=$(lscfg -pl proc0 | grep -i name | awk '{ print $2 $3 }')
                  ;;
  *compaq*|*dg*|*osf*) osf="nonstop"
                  cpu="unknown, possibly an HP Integrity"
                  ;;
  *cygwin*)       osf="cygwin"
                  cpu=$(uname -m 2>/dev/null)
	                ;;
  *freebsd*)      osf="freebsd"
                  cpu=$(uname -p 2>/dev/null)
                  ;;
  *hp-ux*|*hpux*) osf="hp-ux"
                  cpu=$(uname -m 2>/dev/null)
                  ;;
  *irix*)         osf="irix"
                  cpu="unknown, possibly a MIPS"
                  ;;
  *linux*)        case $(grep ^ID= /etc/os-release) in
                    *centos*) osf="rhel"
                              ;;
                    *debian*) osf="debian"
                              ;;
                    *oel*)    osf="rhel"
                              ;;
                    *rhel*)   osf="rhel"
                              ;;
                    *ubuntu*) osf="debian"
                              ;;
                    *)        osf="debian"                              # by default assume it's a debian-based distro
                              ;;
                  esac
                  cpu=$(uname -m 2>/dev/null)
                  osd=`for OS in $(find /etc -maxdepth 1 -type f \( ! -wholename /etc/os-release ! -wholename /etc/lsb-release ! -wholename /etc/\*release -o -wholename /etc/\*version \) 2>/dev/null; do echo ${OS:5:${#OS}-13}; done;`
                  ;;
  *darwin*|*rhapsody*) osf="macosx"
                  cpu=$(uname -p 2>/dev/null)
                  ;;
  *solaris*|*sunos*) osf="solaris"
                  cpu=$(uname -p 2>/dev/null)
                  ;;
  *)              osf="unknown, sorry!: $(uname -a 2>/dev/null)"
                  cpu="previously shown"
                  ;;
esac

case "$1" in
  -h|--help)  usage
              ;;
  -b)         printf "$osf"
              ;;
  -v)         echo ">>> which_os   Version: $Version."
              ;;
  -l)         echo ">>> OS Identified as: $osf, and CPU as $cpu. Linux distro: $osd"
              ;;
  -lb)        printf "$osd"
              ;;
  -f)         families
              ;;
  *)          echo ">>> OS Identified as: $osf, and CPU as $cpu."
              ;;
esac

# End
