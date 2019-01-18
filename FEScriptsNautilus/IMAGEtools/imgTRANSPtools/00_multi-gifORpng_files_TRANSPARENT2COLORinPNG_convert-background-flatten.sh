#!/bin/sh
##
## Nautilus
## SCRIPT: 00_multi-gifORpng-files_TRANSPARENT2COLORinPNG_convert-background-flatten.sh
##
## PURPOSE: For a selected set of image files --- '.png' or '.gif',
##          converts their (fully?) transparent pixels to a
##          user-specified color.
##
## METHOD:  Uses 'zenity --entry' to ask user for a color to apply to (fully?)
##          transparent pixels.
##
##          Uses ImageMagick 'convert' with the '-background' and '-flatten'
##          options.
##
##          Puts the new image files in the directory with the selected
##          image files.
##
## Reference: http://www.imagemagick.org/Usage/formats/#bgnd
##
## HOW TO USE: In Nautilus, select one or more '.png' and/or '.gif' files.
##             Then right-click and choose this script to run (name above).
##
##############################################################################
## Created: 2012jan22
## Changed: 2012feb11 Changed script name.
## Changed: 2012may14 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
## Changed: 2012jul28 Added '-repage' to the 'convert' command, to fix a
##                    shifting of the image when applying the color.
##                    Also made the output file a '.jpg' file.
## Changed: 2015nov07 Made the output file a '.png' rather than '.jpg'.
##                    Added 'inPNG' to the script name.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x


###################################################
## Get the 'color' to apply to transparent pixels.
##################################################

TRANSPCOLOR=""

TRANSPCOLOR=$(zenity --entry \
   --title "Enter a COLOR." \
   --text "\
Enter the COLOR to apply to TRANSPARENT PIXELS.

Examples:
#000000   OR   black
#0000ff   OR   blue
#ffffff   OR   white" \
   --entry-text "#000000")

if test "$TRANSPCOLOR" = ""
then
   exit
fi



####################################
## START THE LOOP on the filenames.
####################################

for FILENAME
do

   ###########################################################
   ## Get the file extension.
   ##    Assumes one dot (.) in the filename, at the extension.
   ###########################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   ###########################################################
   ## Check that the file extension is 'png' or 'gif'.
   ##   Assumes one dot (.) in the filename, at the extension.
   ## COMMENTED, for now.
   ###########################################################
 
   if test "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
   then
      continue 
      #  exit
   fi


   ###########################################################
   ## Get the 'midname' of the filename --- by stripping
   ## the file extension.
   ##    Assumes one dot (.) in the filename, at the extension.
   ###########################################################

   # FILEMIDNAME=`echo "$FILENAME" | sed 's|\..*$||'`
   FILEMIDNAME=`echo "$FILENAME" | cut -d\. -f1`


   #####################################################
   ## Make the output filename with '.png' suffix ---
   ## and delete the filename if it exists.
   #####################################################

   # OUTFILE="${FILEMIDNAME}_TRANSPARENTto${TRANSPCOLOR}.$FILEEXT"
   OUTFILE="${FILEMIDNAME}_TRANSPARENTto${TRANSPCOLOR}.png"

   if test -f "$OUTFILE"
   then
      rm -f "$OUTFILE"
   fi


   #####################################################
   ## Use 'convert' to make the transparent 'png' file.
   ## REFERENCE:
   ##  http://www.imagemagick.org/discourse-server/viewtopic.php?f=1&t=20823
   #####################################################

   convert "$FILENAME" -repage +0+0 \
           -background "$TRANSPCOLOR" -flatten "$OUTFILE"


done
## END OF 'for FILENAME' loop


#############################################################
## Show the LAST new image file.
## NOTE: The viewer may be able to go back through the other
##       image files if multiple image files were resized.
#############################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &

# $IMGEDITOR "$OUTFILE" &

