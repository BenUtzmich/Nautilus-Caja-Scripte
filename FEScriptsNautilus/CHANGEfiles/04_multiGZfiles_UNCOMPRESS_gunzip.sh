#!/bin/sh
##
## Nautilus
## SCRIPT: 01_multiGZfiles_UNCOMPRESS_gunzip.sh
##
## PURPOSE: UNCOMPRESSES user-selected '.gz' file(s).
##
## METHOD:  No 'zenity' prompt.
##          In a for-loop,
##             1) checks that the file suffix is '.gz',
##                as 'gunzip' requires that
##          and
##             2) if so, uses 'gunzip' to uncompress the selected file.
##
## HOW TO USE: In Nautilus, select one or more '.gz' files in a directory.
##             Right click and, from the 'Scripts >' submenus,
##             choose to run this script (name above).
##
## Created: 2015oct04
## Changed: 2015

## FOR TESTING: (show statements as they execute)
#  set -x

###################################
## START THE LOOP on the filenames.
###################################

for FILENAME
do

   ## FOR TESTING: (show statements as they execute)
   # set -x

   ##########################################
   ## Get file suffix. Check that it is 'gz'.
   ## (NOTE: There should be only one '.' in each filename.)
   ## If not, go to the next selected file.
   ##########################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
   if test "$FILEEXT" != "gz"
   then
      zenity  --info --title "Suffix after first '.' is not 'gz'." \
         --no-wrap \
         --text  "\
The filename
   $FILENAME
does not end with '.gz' --- or it has more than one period
in the filename. Will skip this file."
      continue 
      #  exit
   fi

   ###################################################
   ## Use 'gunzip' to compress the file.
   ###################################################

   gunzip "$FILENAME"

   ## FOR TESTING: (turn off 'set -x')
   # set -

done
## END OF LOOP: for FILENAME
