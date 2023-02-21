cls REM Clear the screen
@ REM Don't echo this line
echo $string REM Echo a line of text
echo. REM Echo a blank line
echo REM Toggle echoing of commands
@echo REM @ Lines are not echoed
cd /D "%~dp0" REM Change to current batch file location
%ALLUSERSPROFILE%
%APPDATA%
%CommonProgramFiles%
%CommonProgramFiles(x86)%
%CommonProgramW6432%
%COMPUTERNAME%
%ComSpec%
%DriverData%
%HOMEDRIVE%
%HOMEPATH%
%LOCALAPPDATA%
%LOGONSERVER%
%OS%
%PROCESSOR_ARCHITECTURE%
%PROCESSOR_ARCHITEW6432%
%PROCESSOR_IDENTIFIER%
%PROCESSOR_LEVEL%
%PROCESSOR_REVISION%
%ProgramData%
%ProgramFiles%
%ProgramFiles(x86)%
%ProgramW6432%
%PROMPT%
%PSModulePath%
%PUBLIC%
%SESSIONNAME%
%SystemDrive%
%SystemRoot%
%TEMP%
%TMP%
%USERDOMAIN%
%USERDOMAIN_ROAMINGPROFILE%
%USERNAME%
%USERPROFILE%
%windir%
for REM see \MyPrograms\Help\BAT\for.txt
for %%v in ($set|"$glob") do command REM How the glob is made matters!
for /F %%v in ($set|"$glob") do command REM For each file listed or matching directories
for /D %%v in ("$glob") do command REM For in each directory found
for /R $path  %%v IN ("$glob") do command REM Recursive for in each directory see help for $path=.
for /L %%v in ($start,$step,$end) do command REM Loop in bounds
for /F %%V in ("$string") do command REM
for /F %%V in ('$command') do command REM
for /F %%V in (`$command`) do command REM usebackq option
for /F %%V in ('$string') do command REM usebackq option
for %I in (.) do set repo=%~nxI REM Gets the CD as a name only
set REM see \MyPrograms\Help\BAT\set.txt
set LONGNAME=%LONGNAME:\=/% REM Convert directory separators to unix
set REM string operations
set REM math operations
setlocal EnableDelayedExpansion REM Allows variables to change during run time - reference with !var! instead of %var%
Dism.exe /online /Cleanup-Image /StartComponentCleanup REM Clean winSxS
C:\ProgramData\Microsoft\Windows Defender\Platform\4.18.2108.7-0\MpCmdRun.exe -Scan -ScanType 3 -File .
reg REM see \MyPrograms\Help\BAT\reg.txt
reg ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /V link /T REG_Binary /D 00000000 /F REM Disable - shortcut name part 1
reg ADD "HKEY_CLASSES_ROOT\.bat\ShellNew" /V "NullFile" /T REG_SZ REM Add Windows batch to new context menu
reg ADD "HKEY_CURRENT_USER\Control Panel\Accessibility" /V DynamicScrollbars /T REG_DWORD /D 0 /F REM Disable hiding scroll bars
reg ADD "HKEY_CURRENT_USER\Control Panel\Accessibility" /V DynamicScrollbars /T REG_DWORD /D 1 /F REM Enable hiding scroll bars
reg ADD "HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics" /V BorderWidth /D 0 /F REM Thin borders part 1
reg ADD "HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics" /V PaddedBorderWidth /D 0 /F REM Thin borders part 2
reg ADD "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer" /V ShowDriveLettersFirst /T REG_DWORD /D 1 /F REM Show Drive Letters First in File Explorer
reg ADD "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer" /V DisableSearchBoxSuggestions /T REG_DWORD /D 1 /F REM Disable Bing Searches
reg ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /V HubMode /T REG_DWORD /D 1 /F REM Remove Quicklinks Menu
reg ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /V AllowPrelaunch /T REG_DWORD /D 0 /F REM Prevent Edge "Preload"
reg ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Explorer" /V DisableSearchBoxSuggestions /T REG_DWORD /D 1 /F REM Disable Bing Searches
reg ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Configuration Manager" /V EnablePeriodicBackup /T REG_DWORD /D 1 /F REM Make registry backups
reg DELETE "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates" /V ShortcutNameTemplate /F REM Disable - shortcut name part 2
reg DELETE "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer" /V DisableSearchBoxSuggestions /F REM Enable Bing Searches
reg DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Explorer" /V DisableSearchBoxSuggestions /F REM Enable Bing Searches
paths.bat  REM List path with parts on separate lines
pathed.exe -h REM Pathed helps add, remove, query or sanitize the path variable
pathed.exe -p  >nul 2>nul REM Prune duplicates and none-existent parts of the path

"C:\Program Files (x86)\Microsoft\Edge\Application\setup.exe" --uninstall --system-level --verbose-logging --force-uninstall.


 | csvtk sort -k 2:n ^
 | csvtk.exe cut -f 12,13,9 ^
 | csvtk.exe grep -n -i -r -f "consultant" -p "consfoot.txt" ^
 | csvtk.exe grep -n -i -r -f "consultant" -p "conshand.txt" ^
 | csvtk.exe grep -n -i -r -f "consultant" -p "conshipandknee.txt" ^
 | csvtk.exe grep -n -i -r -f "consultant" -p "consshoulder.txt" ^
 | csvtk.exe grep -n -i -r -f "consultant" -p "consspine.txt" ^
 | csvtk.exe mutate -f posting_date -n posting_date_month -p "^(.{7})" ^
 | csvtk.exe pretty -s " | " -r  ^
 | csvtk.exe pretty -s " | " -r ^
 | csvtk.exe sort -k 1,2 ^
 | csvtk.exe sort -k 1:n ^
 | csvtk.exe sort -k 2:n ^
 | csvtk.exe summary -i -f invoice_value:sum,invoice_value:count,invoice_value:mean -g consultant ^
 | csvtk.exe summary  -i -f invoice_value:sum -g posting_date_month ^
 | csvtk.exe summary  -i -f invoice_value:sum -g supplier_name
 | datamash.exe  --field-separator=, --header-in --format=  crosstab 1,2 sum 3 ^


