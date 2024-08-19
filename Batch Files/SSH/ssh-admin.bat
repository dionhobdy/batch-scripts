CLS
@echo off
setlocal enabledelayedexpansion

echo.
echo    _____ _____ _____     _____ ____  _____ _____ ______
echo   /   __/   __/  /  /___/  _  /    \/     /     /   / /
echo  /__   /__   /     /___/     /  /  / / / /-   -/ / / /
echo /_____/_____/__/__/   /__/__/____ /_/_/_/_____/_/___/
echo.

rem create Script_Logs folder to store logging information
if not exist script_logs\ ( mkdir script_logs )
rem CD into Script_Logs folder to ensure that the logs are being saved into the correct folder
cd script_logs

rem create ssh-admin-use.txt to log when the script is ran
if not exist ssh-admin-use.txt ( type nul > ssh-admin-use.txt )

rem ping the host ip to verify that you can connect
ping HOST_IP_HERE
ping HOST_IP_HERE | find "TTL=" >nul
rem notify user of ping result before reaching host
if errorlevel 1 (
    echo.
    echo error: host is not reachable. please try again.
    rem write dateStr variable to ssh-admin-use.txt
    echo %date% - error: host is not reachable - %time% >>ssh-admin-use.txt
    echo.
    pause
) else (
    echo.
    echo success: host is reachable. proceed to ssh.
    rem write dateStr variable to ssh-admin-use.txt
    echo %date% - success: host is reachable - %time% >>ssh-admin-use.txt
    echo.
    pause
)

rem ssh into host
echo.
ssh admin@HOST_IP_HERE