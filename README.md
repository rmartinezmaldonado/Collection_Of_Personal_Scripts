# Collection of Personal Scripts
## By Rodolfo Martinez-Maldonado
---
This is a collection of utility scripts that I've been working. These vary between multiple interests of mine.

Each folder will have a README.md to explain the purpose of each script as well as other relevant information.

Below is a high-level overview of each directory:
---
# download-organizer (ongoing, name will be changed to in the forseeable future)
A bash script that organizes files, based on their file extensions, within the target directory itself (currently the Downloads folder, but will be updated), but NOT any within subdirectories (so it shouldn't target any downloads/tools that have critical files).

## Progress Status: Operable, but incomplete
Basic functionality works, but script currently performs a dry run only (no moving to target folders yet) to ensure everything works as intended.

Also intend to make this into a multi-purpose script that implementing the following flags:
 - `--audit` (default): Essentially what the script is doing
 - `--move`: Intended goal of this script. This will override the hidden `--audit` flag unless the user explicitly sets `--move` and `--audit` together, in which both are run.
 - `--add`: Allow the user to provide additional file extensions they would like to target
 - `--help`: Will print out the above. Will override every other flag set, including the hidden `--audit` flag.

# file-archiving (ongoing)
This is a Bash script that is designed to help me organize my files, particularly my classwork from CU Boulder.

Currently deciding what functionality I should add into this to make it a reliable tool.

## Progress Status: Incomplete
`archivemanager` is still in development. Not yet operable. `archiveclasswork` is operable, but it isn't as flexible as `archivemanager` would be: has very fixed targets that it looks at so you would need to tinker with it to change it.

# warframe-tracking (ongoing)
This is a Bash script that would help me track some prime sets on Warframe without constantly opening my inventory.

Yes, it's not necessary, like at all. But it's fun.

## Progress Status: Incomplete
Currently in initial stages. Essentially on the backburner as I want to prioritize my other scripts.

# windows-audio-fix (ongoing)
C++ script that, when compiled, will restart the Window services responsible for the audio.

This script makes use of functions within the Win32 API, particularly those directly involved with the Service Control Manager (SCM).

You would also need to run this (as an executable) with Administrator Privileges as the functionality to modify the state of a given service is restricted to admin only. SCM allows anyone to look at the services (e.g., `OpenServiceW`) with certain rights, but doing anything more with them (e.g., `StartServiceW`) requires elevated privileges.

## Progress Status: Incomplete
Not yet operable. Currently testing dynamic memory allocation and reading the documentation for some of the `Win32` functionality.