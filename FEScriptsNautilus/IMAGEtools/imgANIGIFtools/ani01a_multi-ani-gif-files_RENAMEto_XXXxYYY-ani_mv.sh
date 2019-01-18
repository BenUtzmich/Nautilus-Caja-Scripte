#!/bin/sh
##
## Nautilus
## SCRIPT: ani01a_multi-ani-gif-files_RENAMEto_XXXxYYY-ani_mv.sh
##
## PURPOSE: Renames a user-selected set of animated '.gif' files to
##          a suffix of the form '_XXXxYYY_ani.gif'.
##
## METHOD:  Uses the ImageMagick program 'identify' to get
##          the ACTUAL x-y pixel-size of the file.
##          Uses 'mv' to rename the files.
##
## HOW TO USE: In Nautilus, select one or more animated '.gif' files.
##             Then right-click and choose this script to run (name above).
##
##########################################################################
## Created: 2010feb
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

   #####################################################
   ## Get and check that file extension is 'gif'. 
   ##     Assumes one '.' in filename, at the extension.
   #####################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   if test "$FILEEXT" != "gif"
   then 
      continue
      # exit
   fi

   ############################
   ## Get filesize (XXXxYYY).
   ############################

   FILESIZE=`identify "$FILENAME" | head -1 | awk '{print $3}'`


   ######################################
   ## Get file prefix (strip extension).
   ######################################

   FILEPREF=`echo "$FILENAME" | sed 's|\.gif$||'`


   ## Strip off suffix like _123...x123..._yadayada
   ##                    OR _XXXxYYY_yadayada
   ##                    OR _XXXx123..._yadayada

   FILEPREF=`echo "$FILEPREF" | sed 's|_[0-9X][0-9X]*x[0-9Y][0-9Y]*.*$||'`


   #########################################################
   ## Rename the file to include the actual size in the name.
   #########################################################

   mv "$FILENAME" "${FILEPREF}_${FILESIZE}_ani.gif"

done
## END OF 'for FILENAME' loop
