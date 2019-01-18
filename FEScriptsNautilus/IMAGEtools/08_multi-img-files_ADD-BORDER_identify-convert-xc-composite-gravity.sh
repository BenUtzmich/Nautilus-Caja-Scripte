#!/bin/sh
##
## Nautilus
## SCRIPT: 08_multi-img-files_ADD-BORDER_identify-convert-xc-composite-gravity.sh
##
## PURPOSE: Adds a solid-colored border, of a user-specified color and
##          width, to a set of selected image files ('.jpg' or '.png' or
##          '.gif' or whatver).
##
## METHOD: Uses 'zenity --entry' to prompt for a color and pixel-wdith.
##
##         In a loop, for each selected image file:
##
##            1) The ImageMagick 'identify' command is used to get the actual
##               x-y pixel-size of the image file --- say M and N.
##
##            2) The ImageMagick 'convert' command  with the 'xc:' parameter
##               is used to make a solid colored image file, of the
##               specified color and width=N+W ,height=N+W, where W
##               is the border width specified by the user. Puts the
##               solid-color file in /tmp.
##
##            3) The ImageMagick 'composite' command  with the'-gravity' option
##               is used to overlay the selected image file onto the
##               temporary solid-color file.  Makes the output filename
##               based on the name of the selected image file.
##
##          Shows the last of the output (overlayed) files in an image viewer of
##          the user's choice.
##
## HOW TO USE: In Nautilus, select one or more image files.
##             Then right-click and choose this script to run (name above).
##
#########################################################################
## Created: 2012aug10 Based on scripts
##             '00_multi-jpg-png-gif-files_RENAMEto_actualXXXxYYY_identify-mv.sh'
##             'gen00_anyfile4Dir_GENrectSOLIDcolorFile_convert-size-xc.sh'
##                    and '12_2imgFiles_OVERLAY_composite-gravity.sh'.
## Changed: 2012
###########################################################################

## FOR TESTING: (show statements as they execute)
#  set -x

##########################################################
## Prompt for the borderwidth (pixels) and the solid color.
##########################################################

WIDTH_COLOR=""

WIDTH_COLOR=$(zenity --entry \
   --title "Enter BORDER-WIDTH and COLOR." \
   --text "\
Enter borderwidth (in pixels) and a color.
Example colors:

#000000   OR   black   OR   rgb(0,0,0)
#ffffff   OR   white   OR   rgb(255,255,255)   OR   rgb(100%,100%,100%)

#ff0000   OR   red   OR   rgb(255, 0, 0)   OR   rgb(100%, 0%, 0%)
          OR   rgba(255, 0, 0, 1.0)   OR   rgba(100%, 0%, 0%, 0.5)

#00ff00   OR   green  OR   rgb(0,255,0)
#0000ff   OR   blue  OR   rgb(0,0,255)
#ffff00   OR   yellow  OR   rgb(255,255,0)

tomato
LightSteelBlue

#808080   OR   gray   OR    gray(50%)   OR   graya(50%, 0.5)
gray0  to  gray100" \
        --entry-text "200 #000000")

if test "$WIDTH_COLOR" = ""
then
    exit
fi

BDWIDTH=`echo "$WIDTH_COLOR" | awk '{print $1}'`
SOLIDCOLOR=`echo "$WIDTH_COLOR" | awk '{print $2}'`


#####################################
## START THE LOOP on the filenames.
#####################################

for FILENAME
do

   ################################################################
   ## Get the file extension. 
   ##     Assumes one '.' in filename, at the extension.
   ################################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`


   ################################################################
   ## Check that file extension is 'jpg' or 'png' or 'gif'. 
   ##    COMMENTED, not used.
   ################################################################

   # if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
   # then 
   #   continue
   # fi

   ########################################
   ## Get image size (XXXxYYY) of $FILENAME.
   ########################################

   IMGSIZE=`identify "$FILENAME" | head -1 | awk '{print $3}'`
   XPIXELS=`echo "$IMGSIZE" | cut -dx -f1`
   YPIXELS=`echo "$IMGSIZE" | cut -dx -f2`

   XNEWPIXELS=`expr $XPIXELS + $BDWIDTH`
   YNEWPIXELS=`expr $YPIXELS + $BDWIDTH`
   NEWSIZE="${XNEWPIXELS}x$YNEWPIXELS"


   ##################################################################
   ## Make a filename for the temporary solid-color file.
   ##################################################################

   TEMPFILE="/tmp/SOLID-COLOR_${SOLIDCOLOR}_${NEWSIZE}.jpg"

   if test -f "$TEMPFILE"
   then
      rm -f "$TEMPFILE"
   fi


   ########################################################
   ## Call 'convert' to make the SOLID-COLOR image file.
   ########################################################

   convert  -size $NEWSIZE  xc:$SOLIDCOLOR  "$TEMPFILE"


   ######################################################
   ## Get file prefix (strip extension).
   ##     Assumes one '.' in filename, at the extension.
   ######################################################

   FILEPREF=`echo "$FILENAME" | cut -d\. -f1`

   # FILEPREF=`echo "$FILENAME" | sed "s|\.${FILEEXT}\$||"`


   ####################################################
   ## Make the new filename --- with actual image size
   ## attached to the filename.
   ####################################################

   NEWFILENAME="${FILEPREF}_${NEWSIZE}_ADDED-BORDER.$FILEEXT"


   ####################################################
   ## Call 'composite' to make the border-added file.
   ####################################################

   composite -gravity center "$FILENAME" "$TEMPFILE" "$NEWFILENAME"

done
## END OF 'for FILENAME' loop


####################################################
## Show the LAST border-added output image file.
####################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$NEWFILENAME" &
