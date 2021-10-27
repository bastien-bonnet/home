#!/bin/bash

TODO_FILE=~/todo.txt

main() {
	local context="$1"
	local bold="\o033[1;38m"

	echo "@${context:-ALL}" | bold

	local context_pattern="@$context[^ ]*"
	local todoList="$([ -z $context ] && grep -v "@att" $TODO_FILE || grep "$context_pattern" $TODO_FILE)"

	echo -e "$todoList" | sort | sed \
		-e "s/$context_pattern//" \
		| colorPriorities
}

colorPriorities () {
	local red="\o033[31m"
	local orange="\o033[38;5;166m"
	local yellow="\o033[33m"
	local green="\o033[38;5;46m"
	local grey="\o033[37m"
	local default_text_color="\o033[39m"

	sed \
	-e "s/(A)/${red}A${default_text_color}/" \
	-e "s/(B)/${orange}B${default_text_color}/" \
	-e "s/(C)/${yellow}C${default_text_color}/" \
	-e "s/(\(.\))/${grey}\1${default_text_color}/"
}

bold() {
	local default_text_color="\o033[39m"
	local normal_text_intensity="\o033[22m"
	local fg_format_off="$default_text_color$normal_text_intensity"

	sed "s/\(.*\)/${bold}\1${fg_format_off}/"
}

main "$@"
