#!/bin/sh
##
## Nautilus
## SCRIPT: ani00_multi-ani-gif-files_DISPLAY_gifview_for-loop.sh
##
## PURPOSE: Shows (animates) a set of user-selected animated gif files.
##
## METHOD:  Uses 'gifview -a' in a 'for' loop.
##
##          When user exits/closes 'gifview', the next selected ani-gif
##          file is shown.
##
## HOW TO USE: In Nautilus, navigate to a directory and select
##             one or more animated GIF files.
##             Right-click and choose this script to run (name above).
##
###########################################################################
## Created: 2012jan27 Based on 'ani0D_DISPLAY_ONEanigifFile_gifview.sh'
## Changed: 2012feb27 Changed the name of this script in the comment above.
##                    Changed 'exit' to 'continue' in the FILEEXT check.
## Changed: 2012may12 Changed some comments above and below.
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

   gifview -a "$FILENAME"

done
## END OF 'for FILENAME' loop
