#!/bin/sh
##
## Nautilus
## SCRIPT: 00_multi-img-files_chgBRIGHTorCONTRAST_convert-brightness-contrast.sh
##
## PURPOSE: CHanges BRIGHTNESS and/or CONTRAST of user-selected image file(s)
##          (such as '.jpg' or '.png' or '.gif') according to
##          2 values entered, between -100 and 100 --- zero being no change.
##
## METHOD:  Uses 'zenity' to prompt the user for the 2 values.
##
##          Uses the ImageMagick 'convert' program.
##
##          Shows the (last) new image file in an image viewer (or editor) of
##          the user's choice.
##
## HOW TO USE: In the Nautilus file manager, navigate to the desired directory
##             and select one or more image files. Then right-click and
##             select this script to run (name above).
##
## REFERENCE:  Linux Format Magazine, LXF142, March 2011, page 104
##
## Created: 2011nov11 
## Changed: 2012feb24 Changed to handle multiple image files. (Added do-loop.)
## Changed: 2012feb29 Changed the script name in the comment above.

## FOR TESTING: (show statements as they execute)
# set -x

####################################################################
## Get the color to use for converting blacks and grays to
## shades of the specified color.
## Reference:  http://www.imagemagick.org/Usage/color/#level-colors
####################################################################

BRIGHT_CONTRAST=""

BRIGHT_CONTRAST=$(zenity --entry \
   --title "Change Brightness and/or Contrast" \
   --text "\
Enter 2 values between -100 and 100  --- for BRIGHTNESS and CONTRAST.
where zero indicates NO CHANGE.

Separate the 2 values with a comma.

Example: 20,0   to increase brightness without changing contrast." \
   --entry-text "20,0")

if test "$BRIGHT_CONTRAST" = ""
then
   exit
fi


####################################
## START THE LOOP on the filenames.
####################################

for FILENAME
do

   ##########################################################
   ## Get the 'extension' of a selected image file,
   ## to use to name the new output file.
   ##     Assumes just one period (.) in the filename,
   ##     at the suffix.
   ##########################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   ####################################################################
   ## Get and check that the file extension is 'jpg' or 'png' or 'gif'.
   ##     Assumes one period (.) in filename, at the extension.
   ## COMMENTED. We allow any image file that 'convert' can handle.
   ####################################################################

   #    if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
   #    then 
   #
   #       zenity --question --title "CONTINUE ??" \
   #             --text "
   # File suffix was not '.jpg' or '.png' or '.gif'.
   # Continue processing image file ?
   # Cancel = Exit = Stop processing."
   # 
   #       if test ! $? = 0
   #       then
   #          continue
   #          # exit
   #       fi
   #    fi


   ################################################################
   ## Get the 'stub' to use to name the new output file.
   ##   Assumes one period (.) in the filename --- at the extension.
   ################################################################

   # FILENAMECROP=`echo "$FILENAME" | sed 's|\..*$||'`

   FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`


   #############################################
   ## Use 'convert' to make the new output file.
   #############################################

   BRIGHT_CONTRAST_TEMP=`echo "$BRIGHT_CONTRAST" | sed 's|,|_|g'`

   FILEOUT="${FILENAMECROP}_BRIGHT_CONTRAST_${BRIGHT_CONTRAST_TEMP}.$FILEEXT"

   convert -brightness-contrast $BRIGHT_CONTRAST "$FILENAME" "$FILEOUT"

done
## END OF LOOP: for FILENAME


#############################################################
## Show the LAST new image file.
## NOTE: The viewer may be able to go back through the other
##       image files if multiple image files were resized.
#############################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$FILEOUT" &

# $IMGEDITOR "$FILEOUT" &
