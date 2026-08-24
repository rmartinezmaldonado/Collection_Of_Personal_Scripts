# windows-audio-fix

# What is this

# Why does this exist?
In all honesty? It's a pet project of mine. The truth is that this file can be simplified by using the `Restart-Service` PowerShell command. This is mainly for me to explore how Windows APIs connected with the Windows Service Control Manager (SCM) work, ever since I learned and analyzed them in my C++ WannaCry reverse-engineering project.


# Error Log As of Now
## Error #1 (As of August 2026)
### Electric Boogaloo
When you use the `gcc` or `g++` compiler, such as the following:
```
g++ WindowsAudioFix.cpp -o test
```
You may encounter this error:
```
WindowsAudioFix.cpp:11:10: fatal error: windows.h: No such file or directory
   11 | #include <windows.h>
      |          ^~~~~~~~~~~
compilation terminated.
```

### The solution:
From what I found, the Linux/UNIX environment is incompatible with the Windows SDK (Software Development Kits).

As such, I'll need to use whatever tool to make the Windows SDK workable with Linux/UNIX. Yay.