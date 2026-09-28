# Collection of Personal Scripts
## By Rodolfo Martinez-Maldonado
---
This is a collection of utility scripts that I've been working. These vary between multiple interests of mine.

Each folder will have a README.md to explain the purpose of each script as well as other relevant information.

Below is a high-level overview of each directory:
---
# file-archiving (ongoing)
This is a Bash script that is designed to help me organize my files, particularly my classwork from CU Boulder.

Currently deciding what functionality I should add into this to make it a reliable tool.

# windows-audio-fix (ongoing)
C++ script that, when compiled, will restart the Window services responsible for the audio.

This script makes use of functions within the Win32 API, particularly those directly involved with the Service Control Manager (SCM).

You would also need to run this (as an executable) with Administrator Privileges as the functionality to modify the state of a given service is restricted to admin only. SCM allows anyone to look at the services (e.g., `OpenServiceW`) with certain rights, but doing anything more with them (e.g., `StartServiceW`) requires elevated privileges.

# warframe-tracking (ongoing)
This is a Bash script that would help me track some prime sets on Warframe without constantly opening my inventory.

Yes, it's not necessary, like at all. But it's fun.