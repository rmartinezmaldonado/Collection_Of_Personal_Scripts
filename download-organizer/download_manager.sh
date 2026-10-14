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
# echo "File Extension Status"
# printf "\n\n"
{
	echo "Extension Type | File Count Moved/(ls) | Special Notes"
	echo "${status_separator}|${status_separator}|${status_separator}"
	for extension in "${common_file_extensions[@]}"; do
		# Create and flush the special statuses array
		special_status=()

		# Currently testing scope of the following
		expanded_ext="*.${extension}"

		# Create the folder that stores target files if it didn't exist
		target_dir="${extension}_dir"
		folder_status=$(mkdir -p -v "${target_dir}")
		# echo "Status to display: ${folder_status}"

		# Let user know at the end of breakdown that directory was created
		if [[ -n "${folder_status}" ]]; then
			# echo "Append to special statuses: ${folder_status}"
			special_status+=("${folder_status}")
		fi

		# Dry run of ls (until I'm sure mv does as intended)
		files_affected=$(find . -maxdepth 1 -iname "${expanded_ext}" -execdir ls {} + -quit)

		# Record file count
		file_ext_count=$(echo "$files_affected" | wc -l)



		# Perform sequential status breakdown
		echo "${extension} | Count (dry-run): ${file_ext_count} | Check first file: ${files_affected}"

		# Print out any special statuses that need to be reported
		for status in "${special_status[@]}"; do
			echo " | | ${status}"
		done

		echo "${status_separator}|${status_separator}|${status_separator}"
	done
} | column -t -s '|' -o '|'

# Return back
echo "Returning to ${original_path}"
cd "${original_path}"

exit 0