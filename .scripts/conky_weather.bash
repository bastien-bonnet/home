#!/bin/bash

weather_url="https://weather.com/en-GB/weather/hourbyhour/l/b79a975f5ebe516146715560b2cb2e9de56e7b6e90e002c2bcc465c14ef65e22"
weather_html_page=$(curl $weather_url 2>/dev/null)
#weather_html_page=$(cat html)
weather_html_table=$(echo $weather_html_page | xmllint --html --xpath "//table[contains(@class, 'twc-table')]" --nowarning --noblanks - 2>/dev/null)
weather_data=$(echo $weather_html_table \
	| sed \
		-e 's/<\/tr>/\n/g' \
		-e "s/\(<t[^>]\+>\)\+/,/g" \
		-e 's/<[^>]\+>//g' \
	| head -n 11 \
	| tail -n +2 \
	| cut -d ',' -f3-7)

for row in {1..5}; do
	transposed_line=$(echo "$weather_data" | cut -d ',' -f $row | paste -sd,)
	for field_number in {1..9}; do
		transposed_line=$(echo "$transposed_line" | sed -e "s/,/\${goto $((50 + $field_number * 50))}/1")
	done
	echo $transposed_line
done \
| sed \
	-e '1s/\([[:digit:]]\{2\}:[[:digit:]]\{2\}\)[[:alpha:]]*/\1/g' \
	-e '2s/Mostly Sunny//g' \
	-e '2s/Sunny//g' \
	-e '2s/Mostly Clear//g' \
	-e '2s/Clear//g' \
	-e '2s/Mostly Cloudy//g' \
	-e '2s/Partly Cloudy//g' \
	-e '2s/Cloudy//g' \
	-e '2s/Few Showers//g' \
	-e '2s/Light Rain//g' \
	-e '2s/Rain//g' \
	-e '2s/Showers//g' \
	-e '2s/^\(.*\)$/\${font Font Awesome 5 Free Solid:style=Solid:size=18}\1\${font DejaVu Sans Mono:size=8}/' \
	-e 's/^/\${goto 50}/'

