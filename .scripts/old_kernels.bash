#!/bin/bash

VERSION_PATTERN="[[:digit:]][[:digit:].-]*[[:digit:]]"
installed_kernel_pkgs=$(dpkg -l | awk '/ii/{print $2}' | grep -E "^linux-.*$VERSION_PATTERN-.*")

found_versions=$(grep -o "$VERSION_PATTERN" <<< "$installed_kernel_pkgs" | sort -Vu)
echo "
Found versions:
$found_versions"

running_version=$(uname -r | grep -o "$VERSION_PATTERN")
echo "
Current kernel version:
$running_version"

last_2_versions=$(tail -n 2 <<< "$found_versions")
versions_to_keep=$(sort -Vu <<< "$running_version"$'\n'"$last_2_versions" )
echo "
Versions that should be kept (last 2 kernels):
$versions_to_keep"

versions_to_delete=$(comm -23 <(echo "$found_versions" | sort) <(echo "$versions_to_keep" | sort))
echo "
Versions that can be deleted:
$versions_to_delete"

pkgs_to_delete=$([[ -n "$versions_to_delete" ]] && grep -f <(echo "$versions_to_delete") <<< "$installed_kernel_pkgs")
echo "
Command to delete them:"
echo sudo apt purge $pkgs_to_delete | grep --color=always "$VERSION_PATTERN"
