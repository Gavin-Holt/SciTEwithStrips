# Run from a batch file to procees multiple files
#	for /f "delims=" %%f in ('dir Y:\*.doc /b /s /a-d-h-s') do ( gawk.exe -f YourScript.awk "%%f" >> YourScript.txt )

BEGIN{
FS=","
OFS="\n"


}

#MIDDLE
{


}


END{

}




