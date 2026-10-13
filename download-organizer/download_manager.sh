#!/bin/bash

set -euo pipefail

# Global variables

# Currently focuses on the Downloads but it will be changed in the future
main_path=/mnt/c/Users/rodol/Downloads
common_file_extensions=("pdf" "png" "jpg" "txt" "jpeg") # ("txt") # ("pdf" "png" "jpg" "txt")
status_separator=$(printf '%0.s-' {1..23})

# Jump to the target directory for simpler management
original_path=$PWD
echo "Jumping to ${main_path}"
cd "${main_path}"


# Begin organizing the target directory without altering the subdirectories
echo "File Extension Status"
printf "\n\n"
{
	echo "Extension Type | File Count Moved/(ls) | Any special thing to note"
	echo "${status_separator} | ${status_separator} | ${status_separator}"
	for extension in "${common_file_extensions[@]}"; do
		# Currently testing scope of the following
		test="*.${extension}"

		# Check if file extension folder exists, and create it if not
		storage="${extension}_dir"
		# TODO: Create folder once dry run is successful

		# Dry run of ls (until I'm sure mv does as intended)
		files_affected=$(find . -maxdepth 1 -iname "$test" -execdir ls {} + -quit)

		# Record file count
		file_ext_count=$(echo "$files_affected" | wc -l)

		# Perform sequential status breakdown
		echo "${extension} | Count (dry-run): ${file_ext_count} | Special check: ${files_affected}"
		echo "${status_separator} | ${status_separator} | ${status_separator}"
	done
} | column -t -s '|' -o '|'

# Return back
echo "Returning to ${original_path}"
cd "${original_path}"

exit 0