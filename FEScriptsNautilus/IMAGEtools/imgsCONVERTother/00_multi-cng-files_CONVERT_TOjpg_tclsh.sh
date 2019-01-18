#!/bin/sh
##
## Nautilus
## SCRIPT: 00_multi-cng-files_CONVERT_TOjpg_tclsh.sh
##
## PURPOSE: For one or more '.cng' (CompleteNationalGeographic) files,
##          this script runs a 'hidden' Tcl script --- .cng2jpg.tcl ---
##          in the same directory as this script ---
##          to convert (decode) the '.cng' files to '.jpg' (JPEG) files.
##
## METHOD:  There is no prompt for a paramter.
##
##          The '.jpg' files are put into the directory with the '.cng'
##          files.
##
## HOW TO USE: In Nautilus, navigate to a directory of '.cng' files,
##             select one or more '.cng' files.
##             Then right-click and choose this script to run (name above).
##
###########################################################################
## Created: 2011dec15
## Changed: 2012may14 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################


## FOR TESTING: (show the statements as executed)
# set -x

DIR_THISSCRIPT=`dirname $0`

###############################################################
## If the user does not have write-permission in the
## current directory, we could put the output file in  /tmp.
##################################################################

CURDIR="`pwd`"

DIROUT=""
if test ! -w "$CURDIR"
then
   DIROUT="/tmp/"
fi


###########################################
## START THE LOOP on the selected filenames.
###########################################

for FILENAME
do

   ###########################################################
   ## Get and check that the file extension is 'cng'.
   ## Skip the files that are not '.cng' files.
   ##    Assumes one dot (.) in the filename, at the extension.
   ###########################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
   if test "$FILEEXT" != "cng"
   then
      continue 
      #  exit
   fi

   ###########################################################
   ## Get the 'midname' of the filename by removing the
   ## extension --- '.cng'.
   ###########################################################

   FILENAMECROP=`echo "$FILENAME" | sed 's|\.cng$||'`


   ###########################################################
   ## Prep the output filename.
   ###########################################################

   OUTFILE="${DIROUT}${FILENAMECROP}.jpg"

   if test -f "$OUTFILE"
   then
      rm -f "$OUTFILE"
   fi


   ###########################################################
   ## Use '.cng2jpg.tcl' to make the 'jpg' file.
   ###########################################################

   $DIR_THISSCRIPT/.cng2jpg.tcl "$FILENAME" "$OUTFILE"

done
## END OF 'for FILENAME' loop
