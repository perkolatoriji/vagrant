#!/bin/bash

VER=1.00

echo -e "\nO-> Proj. #01 Ver $VER, Loading vagrant SSH vars...\n"

alias prom1="ssh vagrant@localhost -p 2211"

alias graf1="ssh vagrant@localhost -p 2212"

alias web1="ssh vagrant@localhost -p 2213"

alias web2="ssh vagrant@localhost -p 2214"

alias | grep -e prom -e graf -e web

