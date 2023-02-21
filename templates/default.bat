@echo off
REM Change to current batch file location
cd /D "%~dp0"

REM Check %1 in not null
If [%1]==[] (
Echo No parameters passed
goto End
)
REM Check for a filename as %1
If Not Exist %1 (
echo Can't find: %1
pause
goto End
)

:: Do stuff
:End