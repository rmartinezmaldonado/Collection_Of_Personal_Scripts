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

		# Let user know at the end of breakdown that directory was created
		if [[ -n "${folder_status}" ]]; then
			special_status+=("${folder_status}")
		fi

		# Dry run of ls (until I'm sure mv does as intended)
		#files_affected=$(find . -maxdepth 1 -iname "${expanded_ext}" -execdir ls {} +)


		# Using mapfile and process substitution to create a file array
		mapfile -t target_files < <(find . -maxdepth 1 -iname "${expanded_ext}")

		# Get running count for size ranges
		declare -i size_less_than_1M=0
		declare -i size_1M_to_10M=0
		declare -i size_more_than_10M_to_50M=0
		declare -i size_more_than_50M=0
		for file in "${target_files[@]}"; do
			getSize=$(stat -c "%s" "${file}")

			if (( getSize < 1024 * 1024)); then
				size_less_than_1M+=1
			elif (( getSize >= 1024 * 1024)) && (( getSize <= 1024 * 1024 * 10)); then
				size_1M_to_10M+=1
			elif (( getSize > 1024 * 1024 * 10)) && (( getSize <= 1024 * 1024 * 50)); then
				size_more_than_10M_to_50M+=1
			else
				size_more_than_50M+=1
			fi
		done

		# Start adding size breakdowns to the special_status array
		if (( size_less_than_1M > 0)); then
			special_status+=("${size_less_than_1M} files sized < 1M")
		fi
		if (( size_1M_to_10M > 0)); then
			special_status+=("${size_1M_to_10M} files sized >= 1M and <= 10M")
		fi
		if (( size_more_than_10M_to_50M > 0)); then
			special_status+=("${size_more_than_10M_to_50M} files sized > 10M and <= 50M")
		fi
		if (( size_more_than_50M > 0)); then
			special_status+=("${size_more_than_50M} files sized > 50M")
		fi

		# Record file count
		# file_ext_count=$(echo "${files_affected}" | wc -l)

		# Perform sequential status breakdown
		echo "${extension} | ${#target_files[@]} | Check first file: ${target_files[0]}"

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