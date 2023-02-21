# Run from a batch file to process multiple files
#	for /f "delims=" %%f in ('dir Y:\*.doc /b /s /a-d-h-s') do ( gawk.exe -f FindNHSNumbers.awk "%%f" >> FindNHSNumbers.txt )

# Include library files (if not added by init.awk)
@include "O:/MyProfile/gawk/extensions/header.awk"      # Read header names
@include "O:/MyProfile/gawk/extensions/FPAT.awk"        # Set up to read CSV files
@include "O:/MyProfile/gawk/extensions/valid.awk"       # Checks for equal NF

BEGIN{
    # Hard code the parameters
    # ARGV[0] is the filename of the script itself.
    # ARGV[1] can be the input file
    # ARGC    you must set the ARGV length.
    ARGV[1] = "O:/MyProfile/gawk/tests/data/NJRCGH.csv" # Set input file
    ARGC    = 2                                         # Set input file part II

    # Define and overwrite an output file
    OF      = "O:/MyProfile/gawk/tests/test10.out"
    print "All NJR Hips 2003-2018\n----------------------\n" > OF

}

# FUNCTIONS
@include "O:/MyProfile/gawk/extensions/functions.awk"   # Import functions that use ARG and OF
header_names()                                          # Read header names into $f


#MIDDLE
{


}


END{

}




