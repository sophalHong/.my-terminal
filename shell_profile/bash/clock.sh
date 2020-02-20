#!/bin/bash

[[ "$CLOCK_BASH" == "Running" ]] && return

export CLOCK_BASH='Running'
while sleep 1
do
	tput sc
	tput cup 0 $(($(tput cols)-13))
	echo -e "[\e[31m`date +%r`\e[39m]"
	tput rc
done &
