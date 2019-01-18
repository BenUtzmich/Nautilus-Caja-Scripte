#!/bin/sh
##
## Nautilus
## SCRIPT: 01a_multi-JPG-files_RENAME_JPG2jpg_cut-sed-mv.sh
##
## PURPOSE: Renames a set of selected '.JPG' files to change
##          the '.JPG' suffix to '.jpg'.
##
## METHOD: Uses 'cut', 'sed', and 'mv' to rename each selected
##         '.JPG' file.
##
# HOW TO USE: In Nautilus, select one or more '.JPG' files.
##             Then right-click and choose this script to run (name above).
##
########################################################################
## Created: 2010feb19
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
   ## Get and check that file extension is 'JPG'. 
   ## Assumes one '.' in filename, at the extension.
   #################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   if test "$FILEEXT" != "JPG" 
   then 
      continue
      # exit
   fi

   ########################################
   ## Make the new .jpg filename and rename.
   ########################################

   FILENAME2=`echo "$FILENAME" | sed 's|\.JPG$|\.jpg|'`

   mv "$FILENAME" "$FILENAME2"

done
## END OF 'for FILENAME' loop
