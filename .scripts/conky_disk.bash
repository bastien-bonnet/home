#!/bin/bash

function main() {
	fs_path=$1
	fs_partition=$2
	fs_warn_treshold=$3

	# We use exec variants this way because of their behavior:
	# exec are executed all the time, even inside conditionals like if_match
	if grep -qs "$fs_path " /proc/mounts; then
		echo "#
# File system name and space
	\${template7}\${template0  10}  \${template9 $fs_path} \${goto 220} \${fs_size $fs_path} \${goto 270}\${fs_free $fs_path} free #
# Color selection for bar, according to warn treshold
	\${if_match $(diskUsagePercent $fs_path) >= $fs_warn_treshold}\${color2}\${else}\${endif}#
# Bar (unlike fs_bar, df does count superuser reserved space as used)
	\${alignr}\${execibar 60 echo '$(diskUsagePercent $fs_path)'}\${color}
# Graphs
	\${goto 350}R\${goto 390}\${diskiograph_read $fs_partition 20,50 -t}#
	\${goto 460}W\${alignr}\${diskiograph_write $fs_partition 20,50 -t}
# Read & Write numeric values
	\${voffset -20}\${goto 350}\${diskio_read $fs_partition}\${goto 460}\${diskio_write $fs_partition}\${voffset 20}
		"
	fi
}

function diskUsagePercent() {
	df --output=pcent $1 | tr -dc 0-9
}

main "$@"

