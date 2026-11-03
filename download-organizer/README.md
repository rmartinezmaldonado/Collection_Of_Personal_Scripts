# download-organizer

# What is this
This is a Bash script that is designed to target file extension globs within the target directory and perform the following functions based on flags used:
- `--audit`: Provide a deep analysis of each glob. The analysis in question is as follows:
    - Total size count
    - Largest file found
    - Size range breakdown:
        - Count of files with size between 0MB and 1MB (exclusive)
        - Count of files with size between 1MB (inclusive) and 10MB (inclusive)
        - Count of files with size between 10MB (exclusive) and 50MB (inclusive)
        - Count of files with size greater than 50MB
- `--move`: Organize all file extension globs to their respective subdirectories (right now it's {file_extension}_dir)
- `--add`: Allow the user to provide additional file extensions they would like to target
- `--help`: Will print out the help menu. Will override every other flag set.

The scope of this script is intentionally limited to the files on the directory itself, so it will not look into other subdirectories. This is intended to ensure that other applications or tools you're using don't have their critical components transferred over to the storage folders.

# Why does this exist?
I've been wanting to organize the files in my Downloads folder so that I can decide which to keep and what to discard. Unfortunately, there is a lot of clutter, so I'm forced to scroll down to see if I have duplicates or trash files.

# How to get this to work
Set the flags you want as follows:
```
./download_manager.sh <flags>
```
Note that this will return an error as flags are required:
```
./download_manager.sh
```