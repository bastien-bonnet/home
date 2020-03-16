#!/bin/bash

main() {
	local field_separator=","
	local weather_data=$(\
		get_weather_html_table \
		| html_table_to_simple_table "$field_separator" \
		| select_relevant_columns "$field_separator")

	transpose_table "$weather_data"	"$field_separator" | format
}

get_weather_html_table() {
	local WEATHER_URL="https://weather.com/en-GB/weather/hourbyhour/l/b79a975f5ebe516146715560b2cb2e9de56e7b6e90e002c2bcc465c14ef65e22"

	local weather_html_page=$(curl $WEATHER_URL 2>/dev/null)
	echo $weather_html_page | xmllint --html --xpath "//table[contains(@class, 'twc-table')]" --nowarning --noblanks - 2>/dev/null
}

html_table_to_simple_table() {
	local field_separator="$1"
	local replace_closing_trs_by_newlines='s/<\/tr>/\n/g'
	local replace_opening_tds_by_separator="s/<td[^>]\+>/$field_separator/g"
	local remove_all_html_tags='s/<[^>]\+>//g'
	sed \
		-e "$replace_closing_trs_by_newlines" \
		-e "$replace_opening_tds_by_separator" \
		-e "$remove_all_html_tags"
}

select_relevant_columns() {
 local field_separator="$1"
	awk -F "$field_separator" -v field_separator="$field_separator" 'BEGIN { OFS = field_separator } NR>=2&&NR<=10{ print $3, $4, substr($5,1,length($5)-2)"/"substr($6,1,length($6)-2)"°", $7}; NR==12{ exit }'
}

transpose_table() {
local weather_data="$1"
local field_separator="$2"
for row in {1..4}; do
		local transposed_line=$(echo "$weather_data" | cut -d "$field_separator" -f $row | paste -sd "$field_separator")
		local transposed_line_with_conky_offsets=$(replace_separator_with_conky_offset "$transposed_line" $field_separator)
		echo $transposed_line_with_conky_offsets
	done
}

replace_separator_with_conky_offset() {
	local hours_to_show=8
	local field_separator="$2"
	local result="$1"
	for field_number in $(seq $hours_to_show); do
		local offset="$((50 + $field_number * 58))"
		local result=$(echo "$result" | sed -e "s/$field_separator/\${goto $offset}/1")
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
		-e '2s/Cloudy\( \/ Wind\)\?//g' \
		-e '2s/Few Showers\( \/ Wind\)\?//g' \
		-e '2s/Light Rain\( \/ Wind\)\?//g' \
		-e '2s/Rain\( \/ Wind\)\?//g' \
		-e '2s/Showers\( \/ Wind\)\?//g' \
		-e '2s/Foggy//g' \
		-e '4s/\([[:digit:]]\{1,2\}%\)/-\1-/g' \
		-e '4s/-0%-//g' \
		-e '4s/-\([[:digit:]]\{1,3\}%\)-/\${font Font Awesome 5 Free Solid:style=Solid:size=9}\${font DejaVu Sans Mono:size=8}\1/g' \
		-e "$enclose_weather_icon_line_with_font_tags" \
		-e "$prepend_conky_indent"
}

main
