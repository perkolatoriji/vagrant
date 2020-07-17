#!/bin/sh
#
# Unix/Linux OS & CPU identyfier script
#
  Version=1.02 # Original Script
#
###########################################################33

os=`uname -s 2> /dev/null | tr "[:upper:]" "[:lower:]" 2> /dev/null`

case "$os" in
  *aix*)  osd="aix"
          cpu=`lscfg -pl proc0 | grep -i name | awk '{ print $2 $3 }'`
          ;;
  *compaq*|*dg*|*osf*) osd="tandem"
          cpu="unknown, possibly an HP Integrity"
          ;;
  *cygwin*) osd="cygwin"
          cpu=`uname -m 2>/dev/null`
	  ;;
  *freebsd*) osd="freebsd"
          cpu=`uname -p 2> /dev/null`
          ;;          
  *hp-ux*|*hpux*)
          osd="hp-ux"
          cpu=`uname -m 2> /dev/null`
          ;;
  *irix*) osd="irix"
          cpu="unknown, possibly a MIPS"
          ;;
  *linux*) osd="linux"
          cpu=`uname -m 2> /dev/null`
          ;;
  *rhapsody*|*darwin*) osd="macosx"
          cpu=`uname -p 2> /dev/null`
          ;;
  *solaris*|*sunos*)
          osd="solaris"
          cpu=`uname -p 2> /dev/null`
          ;;
  *)      osd="unknown, sorry!: `uname -a 2> /dev/null`"
          cpu="previously shown"
          ;;
esac

if [ "$1" == "-b" ] 
  then
    echo $osd
  else
    echo ">>> OS Identyfied as: $osd, and CPU as $cpu."
fi
