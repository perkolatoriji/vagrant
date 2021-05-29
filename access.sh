#!/bin/bash
#
# This program's purpose is to load alias on memory to be able to connect
# to the vagrant boxes. This is because I use MobaXterm and cygwin, and 
# vagrant ssh does not work under those environments, therefore normal ssh
# login must be used instead.
# 
# to login to prom1 box, just type: "prom1" on the command line and in you are!
#
#######################################
VER=1.03

echo -e "\nO-> Proj. #01 Ver $VER, Loading vagrant SSH vars...\n"

alias graf1="ssh vagrant@localhost -p 2211"

alias web1="ssh vagrant@localhost -p 2212"

alias web2="ssh vagrant@localhost -p 2213"

alias prom1="ssh vagrant@localhost -p 2214"

alias | grep -e graf -e web -e prom

echo -e "\no-> prometheus port: 9090\no-> grafana port:    3000"

