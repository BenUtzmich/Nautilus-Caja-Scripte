#!/bin/sh
##
## Nautilus
## SCRIPT: svg00_multi-svg-files_DISPLAY_inkview_for-loop.sh
##
## PURPOSE: Shows a set of user-selected SVG files.
##
## METHOD:  Uses 'inkview' --- in a 'for' loop.
##
##          When user exits/closes 'inkview', the next selected SVG
##          file is shown.
##
## HOW TO USE: In Nautilus, navigate to a directory and select
##             one or more SVG files.
##             Right-click and choose this script to run (name above).
##
###########################################################################
## Created: 2012jun01 Based on FE Nautilus Script
##                    'ani00_multi-ani-gif-files_DISPLAY_gifview_for-loop.sh'
## Changed: 2012f
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x


###################################
## START THE LOOP on the filenames.
###################################

for FILENAME
do

   ####################################################
   ## Get and check that file extension is 'svg'. 
   ##    Assumes one '.' in filename, at the extension.
   ####################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   if test "$FILEEXT" != "svg" 
   then
      continue
      # exit
   fi


   ##########################################################
   ## Show the SVG file.
   ##########################################################

   inkview "$FILENAME"

done
## END OF 'for FILENAME' loop
