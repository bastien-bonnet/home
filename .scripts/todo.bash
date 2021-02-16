#!/bin/bash

TODO_FILE=~/todo.txt

main() {
	local red="\o033[31m"
	local orange="\o033[38;5;166m"
	local yellow="\o033[33m"
	local green="\o033[38;5;46m"
	local grey="\o033[37m"
	local bold="\o033[1;38m"
	local default_text_color="\o033[39m"
	local normal_text_intensity="\o033[22m"
	local fg_format_off="$default_text_color$normal_text_intensity"

	local context_pattern="@$1[^ ]*"

	echo "@${1:-ALL}" | sed "s/\(.*\)/${bold}\1${fg_format_off}/"

	grep "$context_pattern" $TODO_FILE | sort | sed \
		-e "s/$context_pattern//" \
		-e "s/(A)/${red}A${default_text_color}/" \
		-e "s/(B)/${orange}B${default_text_color}/" \
		-e "s/(C)/${yellow}C${default_text_color}/" \
		-e "s/(\(.\))/${grey}\1${default_text_color}/"
}

main "$@"
