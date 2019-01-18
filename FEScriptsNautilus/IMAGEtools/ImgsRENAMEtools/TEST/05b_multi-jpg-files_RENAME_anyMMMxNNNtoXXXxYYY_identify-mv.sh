#!/bin/sh
##
## Nautilus
## SCRIPT: 05b_multi-jpg-files_RENAME_anyMMMxNNNtoXXXxYYY_identify-mv.sh
##
## PURPOSE: Renames a set of selected '.jpg' files. Looks for
##          a string of the form MMMxNNN in the filename to change it
##          to the ACTUAL XXXxYYY pixel-size of the file.
##
##             Example: joe_1024x768_EDITme.jpg  to  joe_997x723.jpg
##
## METHOD: Uses ImageMagick 'identify' to get the actual x-y  pixel-size
##         of the file, and uses 'mv' to do the rename.
##
## HOW TO USE: In Nautilus, select one or more '.jpg' files.
##             Then right-click and choose this script to run (name above).
##
###########################################################################
## Created: 2010feb17
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012may12 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x


###################################
## START THE LOOP on the filenames.
###################################

for FILENAME
do

   #################################################
   ## Get and check that file extension is 'jpg'. 
   ##   Assumes one '.' in filename, at the extension.
   #################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   if test "$FILEEXT" != "jpg" 
   then 
      continue
      # exit
   fi

   ##########################################
   ## Get the filesize (XXXxYYY).
   ##########################################

   FILESIZE=`identify "$FILENAME" | awk '{print $3}'`


   #####################################
   ## Get file prefix (strip extension).
   #####################################

   # FILEPREF=`echo "$FILENAME" | sed 's|\.jpg$||'`

   ## Strip off suffix like _123...x123..._yadayada.jpg
   ##                    OR _XXXxYYY_yadayada.jpg
   ##                    OR _XXXx123..._yadayada.jpg
   FILEPREF=`echo "$FILENAME" | sed 's|_[0-9X][0-9X]*x[0-9Y][0-9Y]*.*\.jpg$||'`


   ##############################################################
   ## Rename the file to include its size (XXXxYYY) in the name.
   ##############################################################

   mv "$FILENAME" "${FILEPREF}_${FILESIZE}.jpg"

done
## END OF 'for FILENAME' loop
