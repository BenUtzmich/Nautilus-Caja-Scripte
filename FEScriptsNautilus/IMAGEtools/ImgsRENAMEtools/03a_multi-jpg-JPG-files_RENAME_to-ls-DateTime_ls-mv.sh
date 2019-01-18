#!/bin/sh
##
## Nautilus
## SCRIPT: 01b_multi-jpg-JPG-files_RENAME_to-ls-DateTime_ls-mv.sh
##
## PURPOSE: Renames a set of selected '.jpg' (or '.JPG') files to contain
##          date-time --- in the form from the 'ls' command,
##          fields 6 and 7.
##
## METHOD: Uses 'ls' to get the date-time for each selected file.
##         Uses 'mv' to rename each file.
##
## HOW TO USE: In Nautilus, select one or more '.jpg' or '.JPG' files.
##             Then right-click and choose this script to run (name above).
##
#############################################################################
## Created: 2010feb22
## Changed: 2011mar28 Changed from working just on JPG files - jpg files also.
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012may12 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
## Changed: 2012jul12 Fixed setting of FILEPREF for case when suffix is '.jpg'.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x


####################################
## START THE LOOP on the filenames.
####################################

for FILENAME
do

   ######################################################
   ## Get and check that file extension is 'jpg' or 'JPG'. 
   ## Assumes one '.' in filename, at the extension.
   ######################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "JPG"
   then
      continue
      # exit
   fi

   ########################################
   ## Get and apply the file date and time.
   ########################################

   FILEDATE=`ls -l "$FILENAME" | awk '{print $6}'`
   FILETIME=`ls -l "$FILENAME" | awk '{print $7}'`

   FILEPREF=`echo "$FILENAME" | sed 's|\.jpg$||'`
   FILEPREF=`echo "$FILEPREF" | sed 's|\.JPG$||'`

   mv "$FILENAME" "${FILEPREF}_${FILEDATE}_${FILETIME}.jpg"

done
## END OF 'for FILENAME' loop
