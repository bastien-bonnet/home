#!/bin/bash

# This script prints a list of working days (monday to friday) dates in ISO-8601 format, date only (e.g., 2015-09-24)
# Accepts two optional arguments:
#		- string that will be appended after each date in the output ;
#		- the number of months to go back (i.e. "1" for last month).

stringToAppendToDate="$1"
monthsToGoBack="$2"

fifteenthOfCurrentMonth=$(date +%Y-%m-15)
monthsToGoBack="${2:-0}"
currentYear=$(date -d "$fifteenthOfCurrentMonth - $monthsToGoBack month" +%Y)
currentMonth=$(date -d "$fifteenthOfCurrentMonth - $monthsToGoBack month" +%m)
lastDayOfMonth="$(date -d "$currentYear-$currentMonth-1 + 1 month - 1 day" "+%d")"
TRUE="true"
FALSE="false"

for day in $(seq 1 $lastDayOfMonth); do
	currentDayString="$(date -d "$currentYear-$currentMonth-$day" "+%F")"
	dayOfWeek="$(date -d "$currentDayString" "+%u")"
	isWorkingDay="$([[ $dayOfWeek != "6" && $dayOfWeek != "7" ]] && echo $TRUE || echo $FALSE)"
	[[ $isWorkingDay == $TRUE ]] && echo $currentDayString $stringToAppendToDate
done


