#!/bin/bash
[ "$EUID" -ne 0 ] && echo "please run as root or sudo..." && exit

[ -z "$1" ] && echo "please input user to grant root permission" && 
	echo "[Usage]: $0 sophal" && exit

LOC=/etc/sudoers.d/$1
[ -f $LOC ] && echo "'$1' is already exist in '$LOC'" && exit ||
	echo "$1 ALL=(ALL) NOPASSWD:ALL" > $LOC &&
	chmod 0440 $LOC &&
	echo "[Done] set '$1' as root privilege without password..."

# when sudo syntax error execute $ pkexec visudo
