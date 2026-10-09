#!/bin/bash

set -euo pipefail

# Global variables

# Currently focuses on the Downloads but it will be changed in the future
main_path=/mnt/c/Users/rodol/Downloads

common_file_extensions=("pdf" "png" "jpg" "txt") # ("txt") # ("pdf" "png" "jpg" "txt")

original_path=$PWD
echo "Jumping to ${main_path}"
cd "${main_path}"

for extension in "${common_file_extensions[@]}"; do
	# Currently testing scope of the following
	test="*.${extension}"

	# Dry run of ls (until I'm sure mv does as intended)
	files_affected=$(find . -maxdepth 1 -iname "$test" -execdir ls {} + -quit)
	echo "$files_affected"

	# Repeating dry run, but we're recording file count this time
	moved=$(echo "$files_affected" | wc -l)
	storage="${extension}_dir"
	echo "All ${moved} files with extension ${extension} are found"
done

# Return back
echo "Returning to ${original_path}"
cd "${original_path}"

exit 0