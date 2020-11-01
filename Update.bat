@echo off

::Change to current batch file location
cd /D "%~dp0"

::Check for wscite
If Exist ..\wscite\. (
Echo Found %CD%\..\wscite and intend to update SciTE
echo preserving %CD%\SciTEGlobal.properties
pause
xcopy.exe ..\wscite\*.exe %CD% /d/e/v/c/r/y/h/i     >nul 2>nul
xcopy.exe ..\wscite\*.dll %CD% /d/e/v/c/r/y/h/i     >nul 2>nul
xcopy.exe ..\wscite\*.bat %CD% /d/e/v/c/r/y/h/i     >nul 2>nul
xcopy.exe ..\wscite\*.txt %CD% /d/e/v/c/r/y/h/i     >nul 2>nul
copy ..\wscite\*.properties %CD%\properties\*.*     >nul 2>nul
copy ..\wscite\*.ht* %CD%\doc\*.*                   >nul 2>nul
copy ..\wscite\*.png %CD%\doc\*.*                   >nul 2>nul
copy ..\wscite\*.jpg %CD%\doc\*.*                   >nul 2>nul
echo.
echo All done!
)

:End
pause
