#!/bin/sh
##
## Nautilus
## SCRIPT: 02c_multi-png-files_TRANSPpngTOgif_convert-bordercolor-white.sh
##
## PURPOSE: Converts a selected set of TRANSPARENT '.png' files
##          to TRANSPARENT '.gif' files.
##
## METHOD:  Uses 'zenity --entry' to ask user for a 'palette-size' to use
##          for the '.gif' output file(s).
##
##          Uses ImageMagick 'convert' with '-bordercolor white -border 0x0'.
##          (Works on certain kinds of PNG files. See the Reference below.)
##
## References:
##    http://saltybeagle.com/2006/12/converting-a-png-to-gif-with-transparency-matte/
##
## HOW TO USE: In Nautilus, select one or more '.png' files.
##             Then right-click and choose this script to run (name above).
##
##############################################################################
## Created: 2011oct19 Based on '00_multiCONVERT_pngORjpgFiles_TOgif.sh'.
## Changed: 2012jan21 Added 'convert-bordercolor-white' to the script name.
## Changed: 2012feb11 Changed script name.
## Changed: 2012may14 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
## Changed: 2015feb07 Added code to show the last new image file.
###########################################################################


## FOR TESTING: (show statements as they execute)
# set -x


####################################################
## Get the 'palette size' for the output GIF files.
####################################################

PALSIZE=""

PALSIZE=$(zenity --entry \
   --title "Enter the GIF palette size (2-256)." \
   --text "\
Enter the GIF palette size (2-256).
      Typically use 2 for monochrome (2 color) images ---
      8 or more if they are anti-aliased images.

Typical values:
256, 128, 64, 32, 16, 8, 4, 2

Enter 0 to let ImageMagick 'convert' determine a minimum palette." \
        --entry-text "256")

if test "$PALSIZE" = ""
then
   exit
fi

PALPARM="-colors $PALSIZE"

if test "$PALSIZE" = "0"
then
   PALPARM=""
fi



####################################
## START THE LOOP on the filenames.
####################################

for FILENAME
do

   ###########################################################
   ## Get and check that the file extension is 'png' or 'jpg'.
   ## Assumes one dot (.) in the filename, at the extension.
   ###########################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
   if test "$FILEEXT" != "png"
   then
      continue 
      #  exit
   fi

   ###########################################################
   ## Get the 'midname' of the filename --- by stripping
   ## the '.png' suffix.
   ###########################################################

   FILENAMECROP=`echo "$FILENAME" | sed 's|\.png$||'`

   #####################################################
   ## Make the output filename with '.gif' suffix ---
   ## and delete the filename if it exists.
   #####################################################

   OUTFILE="${FILENAMECROP}_wasPNG_PALETTE${PALSIZE}_TRANSPbordercolorWhite.gif"

   if test -f "$OUTFILE"
   then
      rm -f "$OUTFILE"
   fi


   ##########################################################
   ## Use 'convert' to make the GIF file from the PNG file.
   ##########################################################

   convert "$FILENAME" -bordercolor white -border 0x0 \
         $PALPARM "$OUTFILE"

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
