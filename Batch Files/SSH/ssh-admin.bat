CLS
@echo off
setlocal enabledelayedexpansion

echo.
echo ███████╗███████╗██╗  ██╗       █████╗ ██████╗ ███╗   ███╗██╗███╗   ██╗
echo ██╔════╝██╔════╝██║  ██║      ██╔══██╗██╔══██╗████╗ ████║██║████╗  ██║
echo ███████╗███████╗███████║█████╗███████║██║  ██║██╔████╔██║██║██╔██╗ ██║
echo ╚════██║╚════██║██╔══██║╚════╝██╔══██║██║  ██║██║╚██╔╝██║██║██║╚██╗██║
echo ███████║███████║██║  ██║      ██║  ██║██████╔╝██║ ╚═╝ ██║██║██║ ╚████║
echo ╚══════╝╚══════╝╚═╝  ╚═╝      ╚═╝  ╚═╝╚═════╝ ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝
echo.

rem dateStr variable used for logging whenever the script is launched
for /f "tokens=1-3 delims=/ " %%a in ('echo %date%') do (
    set 'year=%%c'
    set 'month=%%a'
    set 'day=%%b'

)
set dateStr="%day%-%month%-%year%"

rem create Script_Logs folder to store logging information
if not exist %Script_Logs%\ ( mkdir %Script_Logs% )
rem CD into Script_Logs folder to ensure that the logs are being saved into the correct folder
cd %Script_Logs%

rem create ssh-admin-use.txt to log when the script is ran
if not exist ssh-admin-use.txt ( type nul > ssh-admin-use.txt )
rem write dateStr variable to ssh-admin-use.txt
%dateStr% >ssh-admin-use.txt

rem ping the host ip to verify that you can connect
ping HOST_IP_HERE | find "TTL=" >nul
rem notify user of ping result before reaching host
if errorlevel 1 (
    echo {0C}error: host is not reachable. please try again.{#}{\n}
) else (
    echo {02}success: host is reachable. proceed to ssh.{#}{\n}
)

rem ssh into host
ssh admin@HOST_IP_HERE