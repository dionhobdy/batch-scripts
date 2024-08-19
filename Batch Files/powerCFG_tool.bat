CLS
@echo off
setlocal enabledelayedexpansion

rem dateStr variable used for creating a older when report functions launch
for /f "tokens=1-3 delims=/" %%a in ('echo %date%') do (
    set "year=%%c"
    set "month=%%a"
    set "day=%%b"
)
rem dateStr variable used to create a folder of the current date.
set dateStr="%day%-%month%-%year%"

rem dirFlag variable used to create a directory of the power reports if user states.
set dirFlag=false


rem Check for admin privleges. User must run as administrator. If user is not administrator, launch notAdmin function.
NET SESSION >nul 2>&1
if %ERRORLEVEL% EQU 0 ( 
    goto dir_
) else ( goto notAdmin )

rem notAdmin function. If user is not admin echo needed privlege. Exit application.
:notAdmin
echo.
echo admin privlege needed. run as administrator.
echo.
goto exit

rem dir_ function. Create folder for host computer if not existing. CD to host computer folder.
:dir_
cd INSERT_FOLDER_PATH_HERE
echo             _______&& color 0E
echo      ______/  ____/_____    
echo     /     /  /         /
echo    /  ___/  /___   ___/
echo   /  /  /  /___/  /
echo  /__/  /______/__/ powercfg_Tool
echo.
echo create a current director for this PC?
set /p input = y/n 
if %input% EQU y (
    rem create a flag for the directory and set it to ture. it will signal other functions to create text files of their outputs.
    set dirFlag = true
    rem create a folder for the name of the computer.
    if not exist %ComputerName%\ ( mkdir %ComputerName% )
    cd %ComputerName%
    rem create a folder with the current date. navigate to this folder.
    if not exist %dateStr%\ ( mkdir %dateStr% )
    cd %dateStr%
) else (
    if %input% EQU yes (
        rem create a flag for the directory and set it to true. it will signal other functions to create text files of their outputs.
        set dirFlag = true
        rem create a folder for the name of the computer.
        if not exist %ComputerName%\ (mkdir %ComputerName%)
        cd %ComputerName%
        rem create a folder with current date. navigate to this folder.
        if not exist %dateStr%\ ( mkdir %dateStr% )
        cd %dateStr%
    )
    goto menu
)

rem  menu function. Display options, take in input and launch appropriate functions.
:menu
rem array0 is function numbers. array1 is function names. both arrays are paired with one another. 
set "array0[0]=1"
set "array0[1]=2"
set "array0[2]=3"
set "array0[3]=4"
set "array0[4]=5"
set "array0[5]=6"
set "array0[6]=7"
set "array0[7]=8"
set "array0[8]=9"
set "array0[9]=0"
set "array0[10]=?"
set "array1[0]=aliases"
set "array1[1]=batteryreport"
set "array1[2]=energyreport"
set "array1[3]=hibernation"
set "array1[4]=lastwake"
set "array1[5]=powerplans"
set "array1[6]=query"
set "array1[7]=sleepstates"
set "array1[8]=sleepstudy"
set "array1[9]=exit"
set "array1[10]=help"

rem create two lists to be iterated through. this wil be needed in order to check user input.
set numOptions=1 2 3 4 5 6 7 8 9 0
set funOptions=aliases batteryreport energyreport hibernation lastwake powerplans query sleepstates sleepstudy exit help

rem display available functions at decending alphabetical order.
echo.
echo Number     Function
echo -------------------
echo.
rem x iterates through both array0 and array1. prints array elements.
for /L %%x in (0, 1, 8) do (
    echo !array0[%%x]!          !array1[%%x]!
)
echo.
goto input

rem input function used to validate user input and return requested function
:input
rem input prompt go to associated function based on input.
set /p input=select option 
rem set validation flag to false by default.
set valid=false
rem iterate through numOptions and funOptions lists. if input matches x, set validation flag to true and go to the inputed function.
for %%x in (%numOptions%) do (
    if %input% EQU %%x ( set valid=true )
)
for %%x in (%funOptions%) do (
    if %input% EQU %%x ( set valid=true )
)
rem if the validation flag is set to true, go to the input function. if the validation flag is set to false go to fail function.
if %valid% EQU true (
    goto %input%
) else (
    goto fail
)
goto %input%

rem fail function. indicate to user their input was incorrect and return to menu function.
:fail
echo invalid input. please inut a valid function.
pause
goto menu

rem help function. displays what each available function does in same formato to :menu
:help
:?
rem array2 is for function names. array3 is for function descriptions.
set "array2[0]=aliases:"
set "array2[1]=batteryreport:"
set "array2[2]=energyreport:"
set "array2[3]=hibernation:"
set "array2[4]=lastwake:"
set "array2[5]=powerplans:"
set "array2[6]=query:"
set "array2[7]=sleepstates:"
set "array2[8]=sleepstudy:"
set "array3[0]=displays all aliases and their corresponding GUIDs"
set "array3[1]=generates a report of battery usage"
set "array3[2]=analyzes the system for common energy-efficiency and battery life problems"
set "array3[3]=toggles hibernation off and on"
set "array3[4]=reports information about what woke the system from the last sleep transition"
set "array3[5]=lists all power schemes"
set "array3[6]=displays the contents of a power scheme"
set "array3[7]=reports the sleep states available on the system"
set "array3[8]=generates a diagnostic system power transition report"
rem display function names and function descriptions in two columns side by side.
echo Function: Description
echo ---------------------
echo.
rem x iterates thugh both array3 and array4. prints array elements.
for /L %%x in (0, 1, 8) do (
    echo !array2[%%x]! !array3[%%x]!
    echo.
)
echo.
pause
rem return to menu function.
goto menu

rem aliases function. Displays aliases with GUIDs.
:aliases
:1
echo.
rem print powercfg aliases.
powercfg /aliases
rem write aliases to powercfg_aliases.txt.
if %dirFlag% EQU true (
    rem if powercfg_aliases.txt does not exist create .txt.
    if not exist powercfg_aliases.txt ( type nul > powercfg_aliases.txt )
    powercfg /aliases >powercfg_aliases.txt
)
echo.
pause
rem return to menu function.
goto menu

rem  batteryreport function. Generate battery report and then return to admin function.
:batteryreport
:2
echo.
rem  initialize powercfg batteryreport. batteryreport saves to where the script is CD'd to.
powercfg /batteryreport
rem launch batter-report.html
start battery-report.html
pause
rem return to menu function.
goto menu

rem energy report function. Generate energy report and the nreturn to menu function.
:energyreport
:3
echo.
rem initialize powercfg energy. energy saves to where the script is CD'd to.
powercfg /energy
rem launch energy-report.html
start energy-report.html
pause
rem return to admin function.
goto menu

rem hibernation function. enable user to toggle hibernation on and off.
:hibernation
:4
echo.
rem array4 is for function numbers. array5 is for function names.
set "array4[0]=1"
set "array4[1]=2"
set "array4[2]=0"
set "array5[0]=off"
set "array5[1]=on"
set "array5[2]=back"
rem display function numbers and function names in two columns side by side.
echo Number and Function
echo -------------------
rem x iterates through both array5 and array6. prints array elements.
for /L %%x in (0, 1, 2) do (
    echo !array4[%%x]! !array5[%%x]!
)
echo.
rem input prompt go to associated function based on input.
set /p input=select option
echo.

if %input%==1 (
    rem set hibernate to off.
    powercfg.exe /hibernate off
    rem announce hibernate turned off.
    echo hibernation set to off
    echo.
    pause
    rem return to menu.
    goto menu
)
if %input%==off (
    rem set hibernate to off.
    powercfg.exe /hibernate off
    rem announce hibernate turned off.
    echo hibernation set to off
    echo.
    pause
    rem return to menu.
    goto menu
)
if %input%==2 (
    rem set hibernate to on.
    powercfg.exe /hibernate on
    rem announce hibernate turned on.
    echo hibernation set to on
    echo.
    pause
    rem return to menu.
    goto menu
)
if %input%==3 (
    rem return to menu.
    goto menu
)
if %input%==back (
    rem return to menu.
    goto menu
)

rem lastwake function. Reports information about what woke the system from last sleep transition and then return to admin function?
:lastwake
:5
echo.
rem print lastwake to console
powercfg /lastwake
if %dirFlag%EQU true (
    rem if powercfg_lastwake.txt does not exist create .txt.
    if not exist powercfg_lastwake.txt ( type nul > powercfg_lastwake.txt )
    rem write lastwake to powercfg_lastwake.txt
    powercfg /lastwake >powercfg_lastwake.txt
)
pause
rem return to menu
goto menu

rem powerplans function. display all available power plans.
:powerplans
:6
echo.
rem print list to console.
powercfg /list
if %dirFlag% EQU true (
    rem if powercfg_powerplans.txt does not exist create .txt.
    if not exist powercfg_powerplans.txt ( type nul > powercfg_powerplans.txt )
    rem write list to powercfg_powerplans.txt.
    powercfg /list > powercfg_powerplans.txt
)
pause
rem return to menu.
goto menu

rem query function. Displays the details of all power schemes and then return to admin function.
:query
:7
echo.
rem print query to console.
powercfg /query
if %dirFlag% EQU true (
    rem if powercfg_query.txt does not exist create .txt.
    if not exist powercfg_query.txt ( type nul > powercfg_query.txt )
    rem write query to powercfg_query.txt.
    powercfg /query >powercfg_query.txt
)
pause
rem return to menu
goto menu

rem sleepstates function. Displays available and unavailable sleep states and then return to admin function.
:sleepstates
:8
echo.
rem print availablesleepstates to console.
powercfg /availablesleepstates
if %dirFlag% EQU true (
    rem if powercfg_sleepstates.txt does not exist create .txt.
    if not exist powercfg_sleepstates.txt ( type nul > powercfg_sleepstates.txt )
    rem write available sleepstates to powercfg_sleepstates.txt.
    powercfg /availablesleepstates >powercfg_sleepstates.txt
)
pause
rem return to menu
goto menu

rem sleepstudy function. generate sleepstudy-report.html.
:sleepstudy
:9
echo.
rem initialize powercfg systempowerreport. systempowerreport saves to where the script is CD'd to.
powercfg /systempowerreport
rem launch sleepstudy-report.html
start sleepstudy-report.html
pause
rem return to menu
goto menu

rem Exit function. Use to exit application.
:exit
:0
@echo off
pause

rem thank you for visiting the code behind powerCFG_tool!
rem script built by Dion Hobdy.
