# Collection of Personal Scripts
## By Rodolfo Martinez-Maldonado
---
This is a collection of utility scripts that I've been working. These vary between multiple interests of mine.

Each folder will have a README.md to explain the purpose of each script as well as other relevant information.

Below is a high-level overview of each directory:
---
# download-organizer (ongoing)
A Bash script that performs various functions on file extension globs within the target directory only (e.g., will not target any subdirectories so it shouldn't target any downloads/tools that share file extensions).

Currently, target directory is my Downloads folder (hence the name of the script), but this will be updated later.

## Progress Status: Operable, but incomplete
Basic functionality works, but script is currently capable of performing a deep analysis only

Here is the progress for each flag so far:
 - `--audit`: Functionality complete, only need to tie into its flag correctly
 - `--move`: Incomplete, but will work on soon after I fully check that script reads only target directory
 - `--add`: Incomplete
 - `--help`: Flag integration complete, but help menu needs more polishing

# file-archiving (ongoing)
This is a Bash script that is designed to help me organize my files, particularly my classwork from CU Boulder.

Currently deciding what functionality I should add into this to make it a reliable tool.

## Progress Status: Incomplete
`archivemanager` is still in development. Not yet operable. `archiveclasswork` is operable, but it isn't as flexible as `archivemanager` would be: has very fixed targets that it looks at so you would need to tinker with it to change it.

# windows-audio-fix (ongoing)
C++ script that, when compiled, will restart the Window services responsible for the audio.

This script makes use of functions within the Win32 API, particularly those directly involved with the Service Control Manager (SCM).

You would also need to run this (as an executable) with Administrator Privileges as the functionality to modify the state of a given service is restricted to admin only. SCM allows anyone to look at the services (e.g., `OpenServiceW`) with certain rights, but doing anything more with them (e.g., `StartServiceW`) requires elevated privileges.

## Progress Status: Incomplete
Not yet operable. Currently testing dynamic memory allocation and reading the documentation for some of the `Win32` functionality.