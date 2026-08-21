/*
Fixing Audio in Windows by restarting the Audio Endpoint Builder service.
This is a temporary fix for the issue of no audio in Windows 10/11.
The issue is caused by a bug in the Windows Audio service that causes
it to stop working after a certain period of time.
This script will restart the service and fix the issue.
*/

#define WIN32_LEAN_AND_MEAN

#include <windows.h>
#include <winsvc.h>
#include <iostream>


int main(){
    //
    // BOOL temp = QueryServiceObjectSecurity();

    // Try opening the SCM
    SC_HANDLE temp = OpenSCManager(NULL, NULL, SC_MANAGER_ALL_ACCESS);

    if (!temp){
        DWORD grab = GetLastError();
        LPWSTR lpMsg = nullptr;

        DWORD e = FormatMessage(
            FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
            NULL,
            grab,
            MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
            (LPWSTR)&lpMsg,
            0,
            NULL);
        
        if (!e){
            std::cout << "Doesn't work" << std::endl;
        } else {
            MessageBox(NULL, (LPCWSTR)lpMsg, TEXT("Error"), MB_OK);
            LocalFree(lpMsg);
        }
    }
}