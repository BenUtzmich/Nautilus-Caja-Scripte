#!/bin/sh
##
## Nautilus
## SCRIPT: ani02b_multi-jpg-png-gif-files_CROP_convert-crop-repage.sh
##
## PURPOSE: Crops a selected set of image files ('.gif' or '.jpg' or
##          '.png') according to a 'geometry' specification.
##                  Example: 200x100+0+50
##
## METHOD: Uses 'zenity --entry' to prompt the user for the geometry 
##         specification.   The one specification is used to crop
##         all the selected files.
##
##         Shows each file after it is cropped, using an image file editor
##         (or viewer) of the user's choice. Close the editor/viewer
##         to proceed to the next file.
##
## HOW TO USE: In Nautilus, select one or more '.jpg', '.png', or '.gif'
##             files.
##             Then right-click and choose this script to run (name above).
##
############################################################################
## Created: 2010apr01
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012may12 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x


###########################################################
## Get the geometry to use for the crop of ALL the files. 
## Example: 200x100+0+50
###########################################################

GEOMETRY=""

GEOMETRY=$(zenity --entry \
   --title "Enter GEOMETRY." \
   --text "\
Enter geometry for the crop :
      Example: 200x100+0+50 for ALL the selected files." \
   --entry-text "200x100+0+50")

if test "$GEOMETRY" = ""
then
   exit
fi

####################################
## START THE LOOP on the filenames.
####################################

for FILENAME
do

   ###################################################################
   ## Get and check that the file extension is 'jpg' or 'png' or 'gif'.
   ##    Assumes one period (.) in filename, at the extension.
   ###################################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
   if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
   then
      continue
      # exit
   fi


   ######################################################
   ## Get the 'stub' to use to name the new output file.
   ######################################################

   FILENAMECROP=`echo "$FILENAME" | sed 's|\.jpg$||'`
   FILENAMECROP=`echo "$FILENAMECROP" | sed 's|\.png$||'`
   FILENAMECROP=`echo "$FILENAMECROP" | sed 's|\.gif$||'`


   #######################################
   ## Use convert to do the cropping.
   #######################################

   FILEOUT="${FILENAMECROP}_cropped.$FILEEXT"
   convert "$FILENAME" -crop $GEOMETRY +repage  "$FILEOUT"


   #########################################################
   ## Show the cropped file.
   ## Close the viewer program to continue to the next file.
   #########################################################

   ## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

   . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
   . $DIR_NautilusScripts/.set_VIEWERvars.shi

   $IMGEDITOR "$FILEOUT"

   # $IMGVIEWER "$FILEOUT"

done
## END OF 'for FILENAME' loop
