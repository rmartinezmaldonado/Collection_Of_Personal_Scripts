# windows-audio-fix

# What is this
This is a C++ script that is supposed to help me fix my audio problems. I'm serious.

For some tragic reason, my audio occassionally cuts out. There were times where I'm on Zoom or Discord and it suddenly goes mute, regardless of audio input (e.g., laptop speakers or headphones).

The solution I found was to open the Service Control Manager UI and restart either the Windows Audio or Windows Audio Endpoint Builder services, but this is really time-consuming. Admittedly I'm still trying to find a better solution aside from this and Powershell.

Aside from my personal grievances, this is also a personal pet project that would allow me to try out the Windows APIs ever since I learned about them from my reverse engineering project.

# Why does this exist?
In all honesty? It's a pet project of mine. The truth is that this file can be simplified by using the `Restart-Service` PowerShell command. This is mainly for me to explore how Windows APIs connected with the Windows Service Control Manager (SCM) work, ever since I learned and analyzed them in my C++ WannaCry reverse-engineering project.

# How to get this to work

You will need to install MinGW (Minimum GNU for Windows) to get access to `windows.h` and the Microsoft Windows API headers.

Simplist way of doing this is to install `mingw-w64 GCC` through [MSYS2](https://www.msys2.org/). The site itself is helpful enough on giving the instructions to doing this, so we don't need to include it here.

After that, open the Command Prompt as Administrator and compile the following:
```
g++ WindowsAudioFix.cpp -o test.exe
```

## Electric Boogaloo: Why CMD? Why not Linux/Ubuntu?

If you try running this in Linux with the `gcc` or `g++` compiler, such as the following:
```
g++ WindowsAudioFix.cpp -o test
```
You will run into something like this beautiful error:
```
WindowsAudioFix.cpp:11:10: fatal error: windows.h: No such file or directory
   11 | #include <windows.h>
      |          ^~~~~~~~~~~
compilation terminated.
```

Simply put, from what I found, the Linux/UNIX environment is incompatible with the Windows SDK (Software Development Kits). In layman's terms, unless you get a specific tool that would allow cross-compatibility between the Windows SDK (more specifically the Win32 API in this case) and Linux/UNIX, this will not be feasible and not worth your time.

You can easily find the tool online (forgot what it was called, but it had `gcc` and `MinGW` in the name), but it's simply more convenient to do it on `Command Prompt`. For the compiler tool I mentioned above, the name was very tedious to write out, compared to the CMD option where I can just write out `g++`.