@echo off
REM Associate as default for opening *.session files - then you can double click them!

REM Change to current batch file location
cd /D "%~dp0"

REM Check %1 in not null
If [%1]==[] (
echo No parameters passed
pause
goto End
)

REM Check for a filename as %1
If Not Exist %1 (
echo Can't find: %1
pause
goto End
)

set Filename=%~1
set Filename=%Filename:\=/%
start scite.exe "-loadsession:%Filename%"

:End

exit
