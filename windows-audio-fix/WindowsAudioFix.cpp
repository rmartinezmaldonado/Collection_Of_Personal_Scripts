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

#define messageSize 512

void FormatMessageWrapper(DWORD lastErrorResult, LPWSTR messageBuffer, DWORD bufferSize){
    DWORD check = FormatMessageW(
        FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS, // FORMAT_MESSAGE_ALLOCATE_BUFFER
        NULL,
        lastErrorResult,
        MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
        messageBuffer,
        bufferSize,
        NULL);

    // If message formatting failed
    if (!check){
        //
    }
}

int main(){
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

    // Get the required amount of buffer first
    // so that we can allocate necessary memory
    // As maximum required buffer for QueryServiceStatusEx is 8k bytes
    DWORD getRequiredLength = 0;
    BOOL getStatusLengthBool = QueryServiceStatusEx(windowsService, SC_STATUS_PROCESS_INFO, NULL, 0, &getRequiredLength);

    DWORD buffer_error = GetLastError();
    // GetLastError should return ERROR_INSUFFICIENT_BUFFER
    // If not, something went wrong so terminate early
    if (buffer_error != ERROR_INSUFFICIENT_BUFFER){
        MessageBoxW(NULL, L"Required buffer size was not returned", L"Error", MB_OK);
        wchar_t lpMsg[512] = { 0 };

        DWORD e = FormatMessageW(
            FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS, // FORMAT_MESSAGE_ALLOCATE_BUFFER
            NULL,
            buffer_error,
            MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
            lpMsg,
            sizeof(lpMsg)/sizeof(wchar_t),
            NULL);
        
        if (!e){
            MessageBoxW(NULL, L"Couldn't receive message", L"Error", MB_OK);
        } else {
            MessageBoxW(NULL, lpMsg, L"Error", MB_OK);
        }

        CloseServiceHandle(windowsService);
        CloseServiceHandle(hSCM);
        return 0;
    }

    std::cout << "Required buffer is " << getRequiredLength << std::endl;

    // Now get the SERVICE_STATUS_PROCESS struct for Windows Audio
    //BYTE audioStatus[getRequiredLength] = { 0 };
    BYTE* audioStatus = new (std::nothrow) BYTE[getRequiredLength];

    if (audioStatus == nullptr){
        MessageBoxW(NULL, L"Dynamic Allocation for Windows Audio Status failed", L"Error", MB_OK);
        CloseServiceHandle(windowsService);
        CloseServiceHandle(hSCM);
        return 0;
    }

    BOOL audioStatusBool = QueryServiceStatusEx(windowsService, SC_STATUS_PROCESS_INFO, audioStatus, getRequiredLength, NULL);

    delete[] audioStatus;
    audioStatus = nullptr;
    // Close the handles for both the Windows Audio and SCM
    CloseServiceHandle(windowsService);
    CloseServiceHandle(hSCM);

    return 0;
}