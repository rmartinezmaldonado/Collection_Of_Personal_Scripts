#!/bin/bash

set -euo pipefail

# BIG TODO: transform this into a multi-purpose utility script based on flags mentioned in main README


# Global variables

# Currently focuses on the Downloads but it will be changed in the future
main_path=/mnt/c/Users/rodol/Downloads

common_file_extensions=("pdf" "png" "jpg" "txt" "jpeg" "dummy" "docx")
status_separator=$(printf '%0.s-' {1..23})

# Operation flags in order of execution
ADD_flag=0
AUDIT_flag=0
MOVE_flag=0


# Global functions

help() {
	# Display the help functionality
	echo "Help flag is triggered, override all other flags"
	
	echo "Syntax (for now): $(basename $0) <flags>"
	echo ""
	echo "Flag options"
	echo "--help: Print this page"
	echo "--audit: Print a deep analysis of file globs for each file extension"
	echo "     Will print: Total amount of bytes analyzed, size breakdown, and any other special statuses"
	echo "--move: Move file globs of each file extension to their pre-designated subdirectories within the parent folder"
	echo "--add: Allow script to target additional file extensions, along with default set of file extensions"
	echo "     Note: Only the file extension itself, do not include the delimiter '.'"
	echo "          Ex: 'yaml' is fine, '.yaml' will throw an error though"
	echo ""
	echo "     Default set currently used by script: (${common_file_extensions[@]})"
}


# Print an error if no arguments were set
if [[ $# == 0 ]]; then
	echo "Missing arguments"
	echo "Try '$0 --help' for more information"
	exit 1
fi

for option in "$@"; do
	if [[ "${option}" == "--help" ]]; then
		# No need to look at other flags since this overrides ALL
		help

		# Only print the help function and nothing else
		exit 0

	elif [[ "${option}" == "--add" ]]; then
		# echo "Setting add flag"
		ADD_flag=1

	elif [[ "${option}" == "--audit" ]]; then
		# echo "Setting audit flag"
		AUDIT_flag=1

	elif [[ "${option}" == "--move" ]]; then
		# echo "Setting move flag"
		MOVE_flag=1

	fi
done

echo "ADD_flag=${ADD_flag}"
echo "AUDIT_flag=${AUDIT_flag}"
echo "MOVE_flag=${MOVE_flag}"




# Jump to the target directory for simpler management
original_path=$PWD
echo "Jumping to ${main_path}"
cd "${main_path}"


# Begin organizing the target directory without altering the subdirectories
{
	echo "Extension Type | File Count | Special Notes"
	echo "${status_separator}|${status_separator}|${status_separator}"
	for extension in "${common_file_extensions[@]}"; do
		# Create and flush the special statuses array
		special_status=()

		# Using mapfile and process substitution to create a file array
		mapfile -t target_files < <(find . -maxdepth 1 -iname "*.${extension}")


		# Only create directories for extensions found
		if [[ ${#target_files[@]} != 0 ]]; then
			# Create the folder that stores target files if it didn't exist
			folder_status=$(mkdir -p -v "${extension}_dir")

			# Let user know at the end of breakdown that directory was created
			if [[ -n "${folder_status}" ]]; then
				# Remove 'mkdir:' and capitalize 'created'
				special_status+=("$(echo "${folder_status}" | cut -d ' ' -f 2- | sed 's/created/Created/')")
			fi
		fi


		# Get running count for size ranges
		declare -i size_less_than_1M=0
		declare -i size_1M_to_10M=0
		declare -i size_more_than_10M_to_50M=0
		declare -i size_more_than_50M=0

		# Track largest file
		largest_file=""

		# Start with first file if there are any files
		if [[ ${#target_files[@]} != 0 ]]; then
			largest_file="${target_files[0]}"
		fi

		for file in "${target_files[@]}"; do
			get_size=$(stat -c "%s" "${file}")

			if (( get_size < 1024 * 1024)); then
				size_less_than_1M+=1
			elif (( get_size >= 1024 * 1024)) && (( get_size <= 1024 * 1024 * 10)); then
				size_1M_to_10M+=1
			elif (( get_size > 1024 * 1024 * 10)) && (( get_size <= 1024 * 1024 * 50)); then
				size_more_than_10M_to_50M+=1
			else
				size_more_than_50M+=1
			fi

			largest_size=$(stat -c "%s" "${largest_file}")
			if (( get_size > largest_size )); then
				# Update largest_file
				largest_file="${file}"
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

		# TODO: Do the file moving here



		# Perform sequential status breakdown
		if [[ ${#target_files[@]} == 0 ]]; then
			echo "${extension} | ${#target_files[@]} | No files found"
		else
			echo "${extension} | ${#target_files[@]} | Largest file: ${largest_file}"
		fi

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