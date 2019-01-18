#!/bin/sh
##
## Nautilus
## SCRIPT: ani00_multi-ani-gif-files_DISPLAY_animate_for-loop.sh
##
## PURPOSE: Shows (animates) selected animated gif files.
##
##          Uses ImageMagick 'animate'.
##
##          When user exits 'animate', the next selected ani-gif
##          file is shown.
##
## HOW TO USE: Navigate to a directory using Nautilus and select
##             one or more animated GIF files.
##             Right-click and choose this script to run.
##
###########################################################################
## Created: 2012feb09 Based on 'ani00_multiAniGIF_DISPLAY_gifview_for-loop.sh'
## Changed: 2012may12 Changed script name in comments above and touched up
##                    the comments.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x


###################################
## START THE LOOP on the filenames.
###################################

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


   ##########################################################
   ## Show the gif file --- in animated mode.
   ##########################################################

   animate "$FILENAME"

done
## END OF 'for FILENAME' loop
