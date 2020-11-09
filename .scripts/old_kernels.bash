#!/bin/bash

VERSION_PATTERN="[[:digit:]][[:digit:].-]*[[:digit:]]"

installed_kernel_pkgs=$(dpkg -l | awk '/ii/{print $2}' | grep -E "^linux-.*$VERSION_PATTERN-.*")

found_versions=$(grep -o "$VERSION_PATTERN" <<< "$installed_kernel_pkgs" | sort -u)

running_version=$(uname -r | grep -o "$VERSION_PATTERN")
last_2_versions=$(tail -n 2 <<< "$found_versions")
versions_to_keep=$(sort -u <<< "$running_version"$'\n'"$last_2_versions" )

versions_to_delete=$(comm -23 <(echo "$found_versions") <(echo "$versions_to_keep"))

pkgs_to_delete=$([[ -z "$versions_to_delete" ]] || grep -f <(echo "$versions_to_delete") <<< "$installed_kernel_pkgs")

echo "$pkgs_to_delete"
