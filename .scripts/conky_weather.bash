#!/bin/bash

main() {
	local field_separator=","
	local weather_data=$(\
		get_weather_html_data \
		| html_data_to_csv "$field_separator" \
		| select_relevant_columns "$field_separator")

	transpose_table "$weather_data" "$field_separator" | format

	#debug $field_separator
}

get_weather_html_data() {
	local WEATHER_URL="https://weather.com/en-GB/weather/hourbyhour/l/b79a975f5ebe516146715560b2cb2e9de56e7b6e90e002c2bcc465c14ef65e22"

	local weather_html_page=$(curl $WEATHER_URL 2>/dev/null)
	echo $weather_html_page \
	| xmllint --html --xpath "
		  //*[contains(@data-testid, 'daypartName')]
		| //*[contains(@data-testid, 'TemperatureValue')]
		| //*[contains(@data-testid, 'wxIcon')]/*/title
		| //*[contains(@data-testid, 'Precip')]/*[contains(@data-testid, 'PercentageValue')]" --nowarning --noblanks - 2>/dev/null \
	| xargs -L 5 2>/dev/null \
	| head -n 9
}

html_data_to_csv() {
	local field_separator="$1"
	local replace_html_tags_by_separator="s/<[^>]\+>/$field_separator/g"
	local deduplicate_separators="s/\(\( \)*$field_separator\)\+/$field_separator/g"

	sed -e "$replace_html_tags_by_separator" -e "$deduplicate_separators"
}

select_relevant_columns() {
 local field_separator="$1"
	awk -F "$field_separator" -v output_field_separator="$field_separator" '
		BEGIN { OFS = output_field_separator }
		{
			time=$2;
			weather=$4;
			precipitations=$5;
			real_temp=$3;
			gsub(/[^0-9]/, "", real_temp);
			feels=$6;
			gsub(/[^0-9]/, "", feels);
			if (real_temp==feels) temp=" "real_temp;
			else temp=real_temp"/"feels;

			print time, weather, temp"°", precipitations
		}'
}

transpose_table() {
	local weather_data="$1"
	local field_separator="$2"
	for field in {1..4}; do
		local transposed_column_to_line=$(echo "$weather_data" | cut -d "$field_separator" -f $field | paste -sd "$field_separator")
		local transposed_column_to_line_with_conky_offsets=$(replace_separator_with_conky_offset "$transposed_column_to_line" $field_separator)
		echo $transposed_column_to_line_with_conky_offsets
	done
}

replace_separator_with_conky_offset() {
	local hours_to_show=8
	local field_separator="$2"
	local left_margin_offset=70
	local hour_offset=55
	local result="$1"
	for field_number in $(seq $hours_to_show); do
		local offset="$(($left_margin_offset + $field_number * $hour_offset))"
		local result=$(echo "$result" | sed -e "s/$field_separator/\${goto $offset}/1")
	done
	echo "$result"
}

format() {
	extract_hours='1s/\([[:digit:]]\{2\}:[[:digit:]]\{2\}\)[[:alpha:]]*/\1/g'
	remove_0_precipitation='4s/-0%-//g'
	enclose_precipitations='4s/\([[:digit:]]\{1,3\}%\)/-\1-/g'
	format_precipitations='4s/-\([[:digit:]]\{1,3\}%\)-/\${font Font Awesome 5 Free Solid:style=Solid:size=9}\${font DejaVu Sans Mono:size=8}\1/g'
	prepend_conky_indent='s/^/\${goto 70}/'
	enclose_weather_icon_line_with_font_tags='2s/^\(.*\)$/\${font Font Awesome 5 Free Solid:style=Solid:size=18}\1\${font DejaVu Sans Mono:size=8}/'
	sed \
		-e "$extract_hours" \
		-e '2s/Mostly Sunny\( \/ Wind\)\?//g' \
		-e '2s/Sunny\( \/ Wind\)\?//g' \
		-e '2s/Partly Cloudy Night//g' \
		-e '2s/\(Mostly \)\?Clear Night//g' \
		-e '2s/Partly Cloudy\( \/ Wind\)\?//g' \
		-e '2s/\(Mostly Cloudy \/ \)\?Wind//g' \
		-e '2s/\(Mostly \)\?Cloudy\( \/ Wind\| Night\)\?//g' \
		-e '2s/Few Showers\( \/ Wind\)\?//g' \
		-e '2s/Scattered Showers\( \/ Wind\)\?//g' \
		-e '2s/Light Rain\( \/ Wind\)\?//g' \
		-e '2s/\(Heavy \)\?Rain\( \/ Wind\)\?//g' \
		-e '2s/Showers\( \/ Wind\)\?//g' \
		-e '2s/Foggy//g' \
		-e '2s/Heavy T-Storms//g' \
		-e '2s/\(\w\+ \)\?T-Storms//g' \
		-e "$enclose_precipitations" \
		-e "$remove_0_precipitation" \
		-e "$format_precipitations" \
		-e "$enclose_weather_icon_line_with_font_tags" \
		-e "$prepend_conky_indent"
}

debug() {
	echo "----------"
	echo "DEBUG INFO"
	echo "----------"
	local field_separator="$1"
	local weather_html_data="$(get_weather_html_data)"
	echo -e "HTML data:\n$weather_html_data"
	echo "----"
	local csv_data=$(echo "$weather_html_data" | html_data_to_csv $field_separator)
	echo -e "CSV data:\n$csv_data"
	echo "----"
	local csv_filtered_data=$(echo "$csv_data" | select_relevant_columns "$field_separator")
	echo -e "CSV filtered data:\n$csv_filtered_data"
}

main
