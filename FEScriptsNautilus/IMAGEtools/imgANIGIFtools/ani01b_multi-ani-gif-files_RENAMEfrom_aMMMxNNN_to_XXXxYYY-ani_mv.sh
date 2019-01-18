#!/bin/sh
##
## Nautilus
## SCRIPT: 00_multi-ani-gif-files_RENAMEfrom_aMMMxNNN_toXXXxYYY-ani_mv.sh
##
## PURPOSE: Renames a set of animated GIF files with the suffix
##          '_aMMMxNNN.gif' (my old ani-gif file naming convention)
##          to '_XXXxYYY_ani.gif'.
##
## METHOD:  Uses ImageMagick 'identify' to get the ACTUAL x-y
##          pixel-size of the file. Uses 'mv' to rename the files.
##
## HOW TO USE: In Nautilus, select one or more animated '.gif' files.
##             Then right-click and choose this script to run (name above).
##
#######################################################################
## Created: 2010mar14
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012may12 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x


####################################
## START THE LOOP on the filenames.
####################################

for FILENAME
do

   ####################################################
   ## Get and check that file extension is 'gif'. 
   ##    Assumes one '.' in filename, at the extension.
   ####################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   if test "$FILEEXT" != "gif" 
   then 
      continue
      # exit
   fi

   #######################################
   ## Get the filesize (XXXxYYY).
   #######################################

   FILESIZE=`identify "$FILENAME" | head -1 | awk '{print $3}'`


   ###############################################
   ## Get the file prefix (strip the extension).
   ###############################################

   # FILEPREF=`echo "$FILENAME" | sed 's|\.gif$||'`

   ## Strip off suffix like _aMMMxNNN_yadayada.gif
   FILEPREF=`echo "$FILENAME" | sed 's|_a[0-9X][0-9X]*x[0-9Y][0-9Y]*.*\.gif$||'`


   ##########################################################
   ## Rename the file to include the actual size in the name.
   ##########################################################

   mv "$FILENAME" "${FILEPREF}_${FILESIZE}_ani.gif"

done
## END OF 'for FILENAME' loop
