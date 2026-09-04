/*
Fixing Audio in Windows by restarting the Windows Audio/Audio Endpoint Builder service.
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
    SC_HANDLE hSCM = OpenSCManagerW(NULL, NULL, SC_MANAGER_ALL_ACCESS);

    if (!hSCM){
        DWORD grab = GetLastError();
        // LPWSTR lpMsg = nullptr;

        wchar_t lpMsg[512] = { 0 };

        DWORD e = FormatMessageW(
            FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS, // FORMAT_MESSAGE_ALLOCATE_BUFFER
            NULL,
            grab,
            MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
            lpMsg,
            sizeof(lpMsg)/sizeof(wchar_t),
            NULL);
        
        if (!e){
            std::cout << "Doesn't work" << std::endl;
            return 0;
        } else {
            MessageBoxW(NULL, lpMsg, L"Error", MB_OK);
            // LocalFree(lpMsg);
            return 0;
        }
    }

    // Successfully opened the SCM
    MessageBoxW(NULL, L"Cool popup", L"Success", MB_OK);

    // Get the lpServiceName for the Windows Audio service
    wchar_t audioBuffer[512] = { 0 };
    DWORD audioBufferSize = sizeof(audioBuffer)/sizeof(wchar_t);
    BOOL service = GetServiceKeyNameW(hSCM, L"Windows Audio", audioBuffer, &audioBufferSize);

    if (!service){
        MessageBoxW(NULL, L"Service Name Retrieval Failed", L"Error", MB_OK);
        CloseServiceHandle(hSCM);
        return 0;
    }

    // Open the Windows Audio
    SC_HANDLE windowsService = OpenServiceW(hSCM, audioBuffer, SERVICE_ALL_ACCESS);

    if (!windowsService){
        MessageBoxW(NULL, L"Service failed", L"Error", MB_OK);
        CloseServiceHandle(hSCM);
        return 0;
    }

    MessageBoxW(NULL, L"Was able to open Audio", L"Success", MB_OK);

    // Close the handles for both the Windows Audio and SCM
    CloseServiceHandle(windowsService);
    CloseServiceHandle(hSCM);

    return 0;
}