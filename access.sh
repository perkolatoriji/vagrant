#!/bin/bash

VER=1.02

echo -e "\nO-> Proj. #01 Ver $VER, Loading vagrant SSH vars...\n"

alias graf1="ssh vagrant@localhost -p 2211"

alias web1="ssh vagrant@localhost -p 2212"

alias web2="ssh vagrant@localhost -p 2213"

alias prom1="ssh vagrant@localhost -p 2214"

alias | grep -e graf -e web -e prom

echo -e "\no-> prometheus port: 9090\no-> grafana port:    3000"

