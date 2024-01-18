mode 80,30
CLS
@echo off
setlocal enabledelayedexpansion

rem Check for admin privleges. User must run as administrator. If user is not administrator, launch notAdmin function.
NET SESSION >nul 2>&1
if %ERRORLEVEL% EQU 0 ( 
    goto title
) else ( goto notAdmin )

rem dateStr variable used for creating a older when report functions launch
for /f "tokens=1-3 delims=/" %%a in ('echo %date%') do (
    set "year=%%c"
    set "month=%%a"
    set "day=%%b"
)
set dateStr="%day%-%month%-%year%"

rem Directory function. Create folder for host computer if not existing. CD to host computer folder.
:title
echo        ___________________________________ && color 0B
echo       /__________________________________/ 
echo      /  __ / / ____/  ____/ ____/__   __/
echo     / /__/ / /    / /__ / /  __   / /   
echo    /  ___// /    /  __// / /_ /  / /   
echo   / /    / /____/ /   / /__/ /  / /   
echo  /_/_____/_____/_/____/_____/__/_/_
echo /________powerCFG_tool____________/
echo.
echo +++++++++++++++++++++++++++++++++++++
echo.
goto dir_

:dir_
cd C:\Users\dionh\OneDrive\Desktop\sys_logs\windows\powercfg
if not exist %ComputerName%\ ( mkdir %ComputerName% )
cd %ComputerName%
if not exist %dateStr%\ ( mkdir %dateStr% )
cd %dateStr%
goto admin

rem +++++ admin/notAdmin functions +++++

rem If user is not admin echo needed privlege. Exit application.
:notAdmin
echo.
echo admin privlege needed. run as administrator.
echo.
goto exit

rem Admin function. Display options, take in input and launch appropriate functions.
:admin
rem Write two arrays. One with Integers that pair with function names.
set "array1[0]=1"
set "array1[1]=2"
set "array1[2]=3"
set "array1[3]=4"
set "array1[4]=5"
set "array1[5]=6"
set "array1[6]=7"
set "array1[7]=8"
set "array1[8]=0"
set "array2[0]=aliases"
set "array2[1]=batteryreport"
set "array2[2]=energyreport"
set "array2[3]=lastwake"
set "array2[4]=powerplans"
set "array2[5]=query"
set "array2[6]=sleepstates"
set "array2[7]=sleepstudy"
set "array2[8]=exit"

rem Display available functions decending alphabetical order.
echo.
echo Number     Function
echo ------------------------
echo.
for /L %%x in (0, 1, 8) do (
    echo !array1[%%x]!          !array2[%%x]!
)

rem Instruct user to add a #r tag if obtaining information for a remote computer.
echo.
set /p input=select option 
goto %input%

rem ++++++++ powercfg command functions ++++++++

rem Aliases function. Displays aliases with GUIDs and then return to admin function.
:aliases
:1
CLS
echo powercfg /aliases >>aliases.txt
goto admin

rem Battery Report function. Generate battery report and the nreturn to admin function.
:batteryreport
:2
CLS
powercfg /batteryreport
start battery-report.html
echo.
set /p del=remove battery-report.html from directory? (yes/no) 
if %del% == yes (
    del /f battery-report.html
    echo.
    echo battery-report.html removed from %cd%.
    goto admin
) else ( goto admin )

rem Energy Report function. Generate energy report and the nreturn to admin function.
:energyreport
:3
CLS
powercfg /energy
start energy-report.html
echo.
set /p del=remove energy-report.html from directory? (yes/no) 
if %del% == yes (
    del /f energy-report.html
    echo.
    echo energy-report.html removed from %cd%.
    cd..
    goto admin
) else ( 
    cd..
    goto admin 
)

rem Last Wake function. Reports information about what woke the system from last sleep transition and then return to admin function?
:lastwake
:4
CLS
powercfg /lastwake
goto admin

rem Power Plans function. Display all power plans and then return to admin function.
:powerplans
:5
CLS
powercfg /list
goto admin

rem Query function. Displays the details of all power schemes and then return to admin function.
:query
:6
CLS
powercfg /query
goto admin

rem Sleep States function. Displays available and unavailable sleep states and then return to admin function.
:sleepstates
:7
CLS
powercfg /availablesleepstates
goto admin

rem Sleep Study Report function. Generate sleep study report and then return to admin function.
:sleepstudy
:8
CLS
echo.
powercfg /systempowerreport
start sleepstudy-report.html
echo.
set /p del=remove sleepstudy-report.html from directory? (yes/no) 
if %del% == yes (
    del /f sleepstudy-report.html
    echo.
    echo sleepstudy-report.html removed from %cd%.
    cd..
    goto admin
) else ( 
    cd..
    goto admin 
)

rem Exit function. Use to exit application.
:exit
:0
@echo off
pause