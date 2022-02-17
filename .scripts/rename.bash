#!/bin/bash

from="${1:- }"
to="${2:-_}"

main () {
	for file in *"$from"*; do
	  echo mv -i -- "$file" "${file//$from/$to}"
	done


	echo "ok (y/n) ?"
	read ok
	if [[ $ok = y ]];then
		for file in *"$from"*; do
		  mv -i -- "$file" "${file//$from/$to}"
		done
	fi
}

main "$@"
