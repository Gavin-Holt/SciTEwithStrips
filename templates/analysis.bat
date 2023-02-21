@echo off
REM This is a template for analysis of csv files
REM All generated (therefore disposable) files are prefixed with underscore.

REM Change to current directory to the location of this file
cd /D "%~dp0"
cls

REM Check this is working
REM dir /B *.*

REM Set input file - copy to get rid of spaces!
set infile=""

REM Extract top line and replace , with newlines and add field numbers - save results to ouput file
echo Field Numbers for %infile% > _Analysis%infile%.txt
echo. >> _Analysis%infile%.txt
REM echo. adds an empty line
head.exe -n1 %infile% ^
 | sed.exe s/,/\n/g ^
 | cat.exe -n ^
 >> _Analysis%infile%.txt

REM Check for duplicated field names
echo. >> _Analysis%infile%.txt
echo Duplicated Field Names (should be none) in %infile% >> _Analysis%infile%.txt
head.exe -n1 %infile% ^
 | sed.exe s/,/\n/g ^
 | uniq.exe -d  ^
 >> _Analysis%infile%.txt

REM Remove non-ASCII characters
echo. >> _Analysis%infile%.txt
echo Removing non-ASCII codes from %infile%, saved as _Analysis%infile%.csv >> _Analysis%infile%.txt
cat.exe %infile% ^
 | tr.exe -cd "\001-\177" ^
 > _Analysis%infile%.csv

REM Dimensions of _Analysis%infile%.csv
echo. >> _Analysis%infile%.txt
echo Dimensions of data in _Analysis%infile%.csv  >> _Analysis%infile%.txt
csvtk.exe dim  _Analysis%infile%.csv  ^
 >> _Analysis%infile%.txt 2>&1

REM Get number of columns
setlocal EnableDelayedExpansion
for /f %%a in ('csvtk.exe ncols _Analysis%infile%.csv') do set cols=%%a

REM Frequency tables
echo. >> _Analysis%infile%.txt
echo Frequency Tables for  _Analysis%infile%.csv  >> _Analysis%infile%.txt
echo. >> _Analysis%infile%.txt
for /L %%v in (1,1,!cols!) do (
csvtk.exe freq -f %%v _Analysis%infile%.csv -n -r ^
 | csvtk.exe pretty
 >> _Analysis%infile%.txt
echo. >> _Analysis%infile%.txt
)

REM Bespoke code

REM Make it pounds not dollars
sed.exe -i s/\$/\xA3/g _Analysis%infile%.txt

REM Change Font in all svg charts
sed.exe -i s/Times/Cursive/g  *.svg

REM Load output
start  _Analysis%infile%.txt
pause
