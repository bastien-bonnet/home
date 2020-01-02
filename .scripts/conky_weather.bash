#!/bin/bash

main() {
	local weather_data=$(\
		get_weather_html_table \
		| html_table_to_simple_table \
		| select_relevant_columns)

	transpose_table "$weather_data"	| format
}

get_weather_html_table() {
	WEATHER_URL="https://weather.com/en-GB/weather/hourbyhour/l/b79a975f5ebe516146715560b2cb2e9de56e7b6e90e002c2bcc465c14ef65e22"

	local weather_html_page=$(curl $WEATHER_URL 2>/dev/null)
	echo $weather_html_page | xmllint --html --xpath "//table[contains(@class, 'twc-table')]" --nowarning --noblanks - 2>/dev/null
}

html_table_to_simple_table() {
	local replace_closing_trs_by_newlines='s/<\/tr>/\n/g'
	local replace_opening_tds_by_separator="s/<td[^>]\+>/,/g"
	local remove_all_html_tags='s/<[^>]\+>//g'
	sed \
		-e "$replace_closing_trs_by_newlines" \
		-e "$replace_opening_tds_by_separator" \
		-e "$remove_all_html_tags"
}

select_relevant_columns() {
	awk -F, 'BEGIN { OFS = ","} NR>=2&&NR<=11{ print $3, $4, substr($5,1,length($5)-2)"/"substr($6,1,length($6)-2)"°", $7}; NR==12{ exit }'
}

transpose_table() {
local weather_data="$1"
for row in {1..4}; do
		local transposed_line=$(echo "$weather_data" | cut -d ',' -f $row | paste -sd,)
		local transposed_line_with_conky_offsets=$(replace_separator_with_conky_offset "$transposed_line")
		echo $transposed_line_with_conky_offsets
	done
}

replace_separator_with_conky_offset() {
	local hours_to_show=9
	local result="$1"
	for field_number in $(seq $hours_to_show); do
		local offset="$((50 + $field_number * 50))"
		local result=$(echo "$result" | sed -e "s/,/\${goto $offset}/1")
	done
	echo "$result"
}

format() {
	extract_hours='1s/\([[:digit:]]\{2\}:[[:digit:]]\{2\}\)[[:alpha:]]*/\1/g'
	prepend_conky_indent='s/^/\${goto 50}/'
	enclose_weather_icon_line_with_font_tags='2s/^\(.*\)$/\${font Font Awesome 5 Free Solid:style=Solid:size=18}\1\${font DejaVu Sans Mono:size=8}/'
	sed \
		-e "$extract_hours" \
		-e '2s/Mostly Sunny//g' \
		-e '2s/Sunny//g' \
		-e '2s/Mostly Clear//g' \
		-e '2s/Clear//g' \
		-e '2s/Mostly Cloudy \/ Wind//g' \
		-e '2s/Mostly Cloudy//g' \
		-e '2s/Partly Cloudy//g' \
		-e '2s/Cloudy//g' \
		-e '2s/Few Showers//g' \
		-e '2s/Light Rain//g' \
		-e '2s/Rain//g' \
		-e '2s/Showers//g' \
		-e '2s/Foggy//g' \
		-e "$enclose_weather_icon_line_with_font_tags" \
		-e "$prepend_conky_indent"
}

main
