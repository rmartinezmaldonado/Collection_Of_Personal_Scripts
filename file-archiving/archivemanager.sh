#!/bin/bash

set -euo pipefail

# ---------------------------------------------------------------

# archivemanager.sh - a simple archiving manager

# Purpose: To locate files across the filesystem, remotely archive files/directories to target directory, and delete unwanted files

# Status: Incomplete


# Notes:
# - The absolute path for the current target directory is currently static; will be dynamic soon
# - Most options are currently incomplete

# The Why?
# It started to get really cumbersome to manually move some of my files from my classes into my personal archive directiries for future reference.
# It especially got really irritating to constantly use different variants of 'find' commands to comb through misc files. 

# ------------------------------------------------------------------


# Global variables

# Currently static; will change to dynamic soon
main_path=/mnt/c/Users/rodol/Desktop/"CU Boulder Classwork"


# Functions

help() {
	echo "Not implemented yet"	
}

archivelookup() {
	echo "Here are the current subdirectories within the main archive folder"
	ls "$main_path"

	echo ""
	read -p "Is there a specific subdirectory you would like to look at? (Y/n) " answer

	# Don't bother with a while loop; just have it be a one and done
	if [[ -z "$answer" ]];
	then
		echo "Invalid response"
		return 1
	fi

	# Treat everything except Yes as a No
	if ! [[ "$answer" == "y" || "$answer" == "Y" || "$answer" == "yes" || "$answer" == "Yes" ]];
	then
		echo "Understood; returning to main menu"
		return 0
	fi

	# Prompt for class number of the subdirectory; don't trust user (aka you) to have proper spelling
	read -p "Enter course number corresponding to subdirectory: " num

	# Handle multiple subdirectories and outputs the permissions and names of the files/directories within target
	#find "$main_path" -maxdepth 1 -iname "*$num*" -printf "\n%f\n" -exec sh -c 'ls -lh "$1" | awk "!/^total/ {print \$1, \$NF}"' _ {} \;
	
	# Since the last command is messy, have have user choose only one subdirectory to look at a time
	
	result=$(ls "$main_path" | grep "$num")

	# Check how many directories were retrieved earlier; ignore if more than 1
	if [[ $(echo "$result" | wc -l) -gt 1 ]];
	then
		echo "More than 1 subdirectory was retrieved. Please narrow your search"
		return 1
	fi
	
	# Print only the permissions and names; leaves ghost spaces
	# ls -lh "$main_path/$result" | awk '{perms=$1; for(i=1; i<=8; i++) $i=""; print perms, $0}'

	printf "\n===$result===\n"

	# Print only the permissions and names
	find "$main_path/$result" -maxdepth 1 -printf "%f: %M\n"
}


while true;
do
	printf "\n\n"
	echo "Simple Archive Manager"
	echo "Menu Options:"
	echo "0) Terminate program"
	echo "1) Help on using this"
	echo "2) Look at current directories in the CU Boulder archives"
	echo "3) Manage the directories in the CU Boulder archives"
	echo "4) Archive files to a target archive directory"

	read -r -p "Type in an option number: " option

	if [ -z "$option" ];
	then
		echo "Empty ass string"
		continue
	fi

	if ! [[ $option =~ ^[0-9]+$ ]];
	then
		echo "Not a number"
		continue
	fi

	printf "\n\n"

	case $option in

		0)
			echo "Terminating $(basename $0 | awk -F '.' '{print $1}')"
			break
			;;
		1)
			help
			;;
		2)
			archivelookup
			;;
		*)
			echo "Not implemented yet"
			;;
	esac
done




exit 1


# Remnants of my original 'archiveclasswork' script, from which this 'archivemanager' script is based on

# Functions

syntax () {
	echo Syntax:
	echo ./archiveclasswork.sh \<OPTIONS\>
}

if [[ $1 == "-h" || $1 == "--h" || $1 == "-help" || $1 == "--help" ]];
then
	#print general syntax
	syntax
	printf "\n\n\n"
	printf "\nSyntax:\n1st Arg: Target Directory in main path: $main_path\n"
	printf "All args afterwards: Files to yeet in target directory\n"
	printf -- "-h, --h, -help, --help: This message\n"
	printf -- "Deprecated: --newdir: Make new directory in main path\n"
	printf "\nExample: ./archiveclasswork.sh \"CSCI 0000 Being a Harvard Dropout\" transcript.pdf expel.sh yada yada\n"
	reference_target

	exit 2
fi

if [ $# -lt 2 ];
then
	printf "\nError: Need arg for target dir and at least 1 for target files to move\n"
	reference_target

	exit 1
fi

# Deny if first arg not a directory in main dir
if [ ! -d "$main_path/$1" ];
then
	printf "\nError: Not a valid directory in $main_path.\n\n"
	reference_target

	exit 1
fi

target_path=$main_path/$1

echo Target directory is $target_path

# Remove target dir from args
shift

terminate=0

echo ""
for checkf in "$@";
do
	

	if [ ! -f "$checkf" ];
	then
		echo "Error: $checkf is not an existing file"

		terminate=1
	fi
done

if [ $terminate -eq 1 ];
then
	printf "\nTerminating before archiving\nCheck all spotted files\n"
	exit 1
fi

mv "$@" "$target_path"
printf "Task complete\nMoved all files to target directory"
exit 0
