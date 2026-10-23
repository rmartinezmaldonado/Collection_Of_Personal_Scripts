# download-organizer

# What is this
This is a Bash script that is designed to organize files within the target directory by their file extensions. 

The scope of this script is intentionally limited to the files on the directory itself, so it will not look into other subdirectories. This is intended to ensure that other applications or tools you're using don't have their critical components transferred over to the storage folders.

# Why does this exist?
I've been wanting to organize the files in my Downloads folder so that I can decide which to keep and what to discard. Unfortunately, there is a lot of clutter, so I'm forced to scroll down to see if I have duplicates or trash files.

# How to get this to work
It has no other dependencies, so it would run any other Bash script:
```
download_manager.sh
```