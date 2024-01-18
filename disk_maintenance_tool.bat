mode 80,30
CLS
@echo off
setlocal enabledelayedexpansion

rem Check for admin privleges. User must run as administrator. If user is not administrator, launch notAdmin function.
NET SESSION >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    goto title
) else ( goto notAdmin )

:title
rem script title
echo        __                   __ && color 03
echo   ____/ /    ____ ___      / /_
echo  / __  /    / __ `__ \    / __/
echo / /_/ /    / / / / / /   / /_  
echo \____/____/_/ /_/ /_/____\__/  
echo    /_____/        /_____/     
echo         disk_maintenance_tool
echo.
echo ++++++++++++++++++++++++++++++
goto admin

:notAdmin
echo Admin privlege needed. Run as administrator.
echo.
goto exit

rem Admin function. Display options, take in input and launch appropriate functions.
:admin
rem Write two arrays. One with Integers that pair with function names.
set "array1[0]=1"
set "array1[1]=2"
set "array1[2]=3"
set "array1[3]=4"
set "array1[4]=0"
set "array2[0]=chkdsk"
set "array2[1]=cleanup"
set "array2[2]=defrag"
set "array2[3]=listdisk"
set "array2[4]=exit"

rem Display available functions decending alphabetical order.
echo.
echo Number     Function
echo -------------------
echo.
for /L %%x in (0, 1, 4) do (
    echo !array1[%%x]!          !array2[%%x]!
)

rem Prompt user and goto function based on %input%
echo.
set /p input=select option 
goto %input%

:chkdsk
:1
    CLS
    chkdsk /f /r /x
    goto admin

:cleanup
:2
    CLS
    "%windir%\system32\cleanmgr.exe" /sageset:65535
    "%windir%\system32\cleanmgr.exe" /sagerun:65535
    goto admin

:defrag
:3
    CLS
    "%windir%\system32\dfrgui.exe"
    goto admin

:listdisk
:4
    CLS
    ( echo List Disk ) | diskpart
    goto admin

:exit
:0
CLS
@echo off
pause
