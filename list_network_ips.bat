@echo off
setlocal enabledelayedexpansion
echo Scanning network for IP addresses...
echo.

REM Create results directory if it doesn't exist
if not exist "results" mkdir "results"

REM Generate timestamp for filename
set "datetime=%date:~-4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
set "datetime=%datetime: =0%"
set "outputfile=results\network_scan_%datetime%.txt"

REM Get your IP address and subnet
ipconfig | findstr /i "IPv4"
echo.

echo Gathering network information (this may take a few moments)...
echo.
echo IP Address          MAC Address         Hostname                    Vendor
echo ---------------------------------------------------------------------------

REM Process each line of the ARP output
for /f "tokens=1,2,3" %%a in ('arp -a ^| findstr "dynamic"') do (
    set "ip=%%a"
    set "mac=%%b"
    
    REM Get hostname with improved method
    for /f "tokens=*" %%h in ('ping -a -n 1 %%a ^| find "Pinging"') do (
        set "hostname=%%h"
        set "hostname=!hostname:~8!"
        set "hostname=!hostname:[=!"
        set "hostname=!hostname:]=!"
        for /f "tokens=1 delims= " %%x in ("!hostname!") do set "hostname=%%x"
    )
    if "!hostname!"=="%%a" set "hostname=N/A"
    
    REM Get vendor from MAC prefix (first 6 characters)
    set "macprefix=%%b"
    set "macprefix=!macprefix:~0,8!"
    
    REM Extended vendor mapping
    if "!macprefix!"=="dc-2c-6e" set "vendor=TP-Link"
    if "!macprefix!"=="c4-79-05" set "vendor=Samsung"
    if "!macprefix!"=="24-0f-9b" set "vendor=Intel"
    if "!macprefix!"=="a4-4c-62" set "vendor=Dell"
    if "!macprefix!"=="00-0c-29" set "vendor=VMware"
    if "!macprefix!"=="7c-8b-ca" set "vendor=Hewlett Packard"
    if "!macprefix!"=="e4-54-e8" set "vendor=Dell/EMC"
    if "!macprefix!"=="74-86-e2" set "vendor=Huawei"
    if "!macprefix!"=="6c-f1-7e" set "vendor=Xiaomi/MiPhone"
    if "!macprefix!"=="ac-b9-2f" set "vendor=Intel Corp"
    if "!macprefix!"=="d4-e8-53" set "vendor=Dell Inc"
    if "!macprefix!"=="24-28-fd" set "vendor=Huawei"
    if "!macprefix!"=="48-8f-5a" set "vendor=Intel"
    if "!macprefix!"=="84-25-19" set "vendor=Samsung"
    if "!macprefix!"=="2c-ea-7f" set "vendor=Xiaomi"
    if "!macprefix!"=="08-92-04" set "vendor=Texas Instruments"
    if "!macprefix!"=="3c-1b-f8" set "vendor=D-Link"
    if "!macprefix!"=="a8-93-4a" set "vendor=Huawei"
    if "!macprefix!"=="44-a6-42" set "vendor=Apple"
    if "!macprefix!"=="c4-5b-be" set "vendor=Amazon"
    if "!macprefix!"=="2c-a5-9c" set "vendor=Intel Corp"
    REM Adding Security and IoT Vendors
    if "!macprefix!"=="c0-56-27" set "vendor=HIKVISION"
    if "!macprefix!"=="54-c4-15" set "vendor=HIKVISION"
    if "!macprefix!"=="44-47-cc" set "vendor=HIKVISION"
    if "!macprefix!"=="bc-ad-28" set "vendor=HIKVISION"
    if "!macprefix!"=="4c-f5-dc" set "vendor=HIKVISION"
    if "!macprefix!"=="08-54-11" set "vendor=HIKVISION"
    if "!macprefix!"=="18-68-cb" set "vendor=HIKVISION"
    if "!macprefix!"=="5c-34-5b" set "vendor=HIKVISION"
    if "!macprefix!"=="4c-11-bf" set "vendor=DAHUA"
    if "!macprefix!"=="90-02-a9" set "vendor=DAHUA"
    if "!macprefix!"=="d4-22-3f" set "vendor=UNIVIEW"
    if "!macprefix!"=="48-ea-63" set "vendor=UNIVIEW"
    if "!macprefix!"=="00-50-fc" set "vendor=PAXTON ACCESS"
    if "!macprefix!"=="2c-c8-1b" set "vendor=PAXTON ACCESS"
    if "!macprefix!"=="64-d1-54" set "vendor=MICROTIK"
    if "!macprefix!"=="b8-69-f4" set "vendor=MICROTIK"
    if "!macprefix!"=="24-0a-c4" set "vendor=ESPRESSIF"
    if "!macprefix!"=="24-b2-de" set "vendor=ESPRESSIF"
    if "!macprefix!"=="84-f3-eb" set "vendor=ESPRESSIF"
    if "!macprefix!"=="84-cc-a8" set "vendor=ESPRESSIF"
    if "!macprefix!"=="3c-71-bf" set "vendor=ESPRESSIF" 
    if "!macprefix!"=="48-55-19" set "vendor=ESPRESSIF" 
    
    if not defined vendor set "vendor=Unknown"
    
    REM Output to screen
    echo %%a        %%b    !hostname!    !vendor!
    
    REM Output to file if user chose to save
    (
        echo %%a        %%b    !hostname!    !vendor!
    ) >> "%outputfile%"
    
    set "hostname="
    set "vendor="
)

REM Ask user about saving to file
set /p "savetofile=Save results to file? [y/n]: "

REM Redirect header to file if user chooses yes
if /i "%savetofile%"=="y" (
    echo Saving results to %outputfile%
    (
        echo Scanning network for IP addresses...
        echo.
        ipconfig | findstr /i "IPv4"
        echo.
        echo Gathering network information (this may take a few moments)...
        echo.
        echo IP Address          MAC Address         Hostname                    Vendor
        echo ---------------------------------------------------------------------------
    ) > "%outputfile%"

    REM Append results to file
    type "%outputfile%" > temp_arp.txt
    type temp_arp.txt >> "%outputfile%"
    del temp_arp.txt
)

echo.
if /i "%savetofile%"=="y" (
    echo Results saved to %outputfile%
)

echo Scan complete!
pause
