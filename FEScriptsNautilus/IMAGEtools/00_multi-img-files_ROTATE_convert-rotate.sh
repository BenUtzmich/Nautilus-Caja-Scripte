#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_multi-img-files_ROTATE_convert-rotate.sh
##
## PURPOSE: Makes rotated file(s) from selected image file(s).
##
## METHOD:  Uses ImageMagick 'convert' with the '-rotate' option.
##
##          Uses 'zenity' to prompt the user for a rotation angle.
##
##          Shows the (last) new image file in an image viewer (or editor)
##          of the user's choice.
##
## HOW TO USE: In the Nautilus file manager, navigate to the desired directory
##             and select one or more image files. Then right-click and
##             select this script to run (name above).
##
## REFERENCE: http://www.imagemagick.org/Usage/warping/
##
## Created: 2012jan18
## Changed: 2012feb08 Add the rotate-angle to the output filename.
## Changed: 2012feb22 To handle multiple image files (added do-loop).
## Changed: 2012feb29 Changed the script name in the comment above.

## FOR TESTING: (show statements as they execute)
#  set -x

#######################################################
## Prompt for the rotate (angle) parameter.
#######################################################

ROTATEANGLE=""

ROTATEANGLE=$(zenity --entry \
   --title "Enter ANGLE of rotation." \
   --text "\
Enter an angle to rotate the image file.
Examples:  90    OR    -90    OR    35

NOTE: 90 is clockwise, -90 is counter-clockwise." \
   --entry-text "90")

if test "$ROTATEANGLE" = ""
then
   exit
fi


####################################
## START THE LOOP on the filenames.
####################################

for FILENAME
do

   ####################################################################
   ## Get the file extension.
   ##     Assumes one period (.) in filename, at the extension.
   ####################################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`


   ####################################################################
   ## Check that the file extension is 'jpg' or 'png' or 'gif'.
   ##     Assumes one period (.) in filename, at the extension.
   ## COMMENTED, for now.
   ####################################################################
 
   # if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
   # then
   #    exit
   # fi


   ##########################################################
   ## Get the 'midname' of the input file, to use to name the
   ## new output file.
   ##     Assumes just one period (.) in the filename,
   ##     at the suffix.
   ######################################################

   FILEMIDNAME=`echo "$FILENAME" | cut -d'.' -f1`


   ##################################################################
   ## Make full filename for the output file --- using the
   ## name of the input file.
   ##
   ## If the user has write-permission on the
   ## current directory, put the file in the pwd.
   ## Otherwise, put the file in /tmp.
   ##################################################################

   CURDIR="`pwd`"

   OUTFILE="${FILEMIDNAME}_ROTATED${ROTATEANGLE}.$FILEEXT"

   if test ! -w "$CURDIR"
   then
      OUTFILE="/tmp/$OUTFILE"
   fi

   if test -f "$OUTFILE"
   then
      rm -f "$OUTFILE"
   fi


   ###########################################
   ## Use 'convert' to make the new image file.
   ###########################################

   ## FOR TESTING:
   #      set -x

   convert "$FILENAME"  -rotate $ROTATEANGLE  "$OUTFILE"

   ## FOR TESTING:
   #      set -

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

$IMGVIEWER "$OUTFILE" &

# $IMGEDITOR "$OUTFILE" &
