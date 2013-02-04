#!/bin/sh

output="${target}/custom-install.txt";
echo "exec custom-install.sh as $0";
echo "pwd: ${PWD}";
echo "target: ${target}";
echo "output: ${output}";
printf "$0" >| "${output}";
