#!/bin/bash

# Move all files and directories from root directory (e.g., copied from other machines)
# Into a given folder within the main CU Boulder Classwork directory (accessible from Desktop)

# Required arguments:
# 1st: Target directory to move files and dirs to; must be an existing directory in the main CU Boulder Classwork directory
# 2nd-upwards: Files and directories to move over



# Why? Too lazy to memorize and write main path below everytime
# I want to copy classwork to main folder

# ------------------------------------------------------------------


# Global variables

main_path=/mnt/c/Users/rodol/Desktop/"CU Boulder Classwork"



# Functions

reference_target () {	
	echo ""
	echo For reference, here are the directories currently available in $main_path:
	ls "$main_path"
	echo ""
}

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
