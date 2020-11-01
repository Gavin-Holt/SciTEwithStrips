@echo off

::Change to current batch file location
cd /D "%~dp0"

::Check %1 in not null
If [%1]==[] (
Echo No parameters passed
goto End
)

::Check for a filename as %1
If Not Exist %1 (
echo Can't find: %1
pause
goto End
)

:: Do stuff

:End