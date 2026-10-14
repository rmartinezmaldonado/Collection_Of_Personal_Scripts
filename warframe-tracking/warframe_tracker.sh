#!/bin/bash

# if [ ! -e "warframe_sheet.txt" ];
# then
# 	echo "Unable to find warframe sheet"
# 	exit 1
# else
# 	echo "Found warframe sheet"
# fi

target="warframe_sheet.txt"
# Create the .txt file if you need to
touch "$target"

# Add this as first line
sed -i '1s/.*/Warframe,Main_Blueprint,Chassis_Blueprint,System_Blueprint,Neuroptics_Blueprint' "$target"

cat "$target"