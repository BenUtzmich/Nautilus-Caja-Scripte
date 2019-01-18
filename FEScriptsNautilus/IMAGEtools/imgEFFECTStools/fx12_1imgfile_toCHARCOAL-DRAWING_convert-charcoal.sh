#!/bin/sh
##
## NAUTILUS
## SCRIPT: 12_1imgfile_CHARCOAL-DRAWING_convert-charcoal.sh
##
## PURPOSE: Makes a 'charcoal drawing' (gray-scale) file from a
##          selected image file.
##
##          Uses ImageMagick 'convert' with the '-charcoal' option.
##
##          Uses 'zenity' to prompt the user for a charcoal parameter,
##          which is basically a parameter to tell how thick (in pixels)
##          to make the edges detected.
##
##          Shows the new image file in an image viewer (or editor)
##          of the user's choice.
##
## References: http://www.imagemagick.org/Usage/transform/#charcoal
##             http://www.imagemagick.org/Usage/photos/#chroma_key
##
## HOW TO USE: Click on the name of an image file in a Nautilus
##             directory list.
##             Then right-click and choose this script to run (name above).
##
## Created: 2012feb01
## Changed: 2012

## FOR TESTING: (show statements as they execute)
#  set -x

########################################
## Get the filename of the selected file.
########################################

   FILENAME="$1"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"


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


#######################################################
## Prompt for the '-charcoal' parameter.
#######################################################

CHARCOALPARM=""

CHARCOALPARM=$(zenity --entry \
   --title "Enter CHARCOAL PARAMETER." \
   --text "\
Enter a charcoal parameter --- representing the thickness (in pixels)
of the edge lines of the selected image.
Examples: 1   OR   2   OR   3

NOTE: This utility does not work well for 'busy images' but for simpler images
it can generate a simplified gray-scale rendering of the image." \
   --entry-text "1")

if test "$CHARCOALPARM" = ""
then
   exit
fi



##################################################################
## Make full filename for the output file --- using the
## name of the input file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

OUTFILE="${FILEMIDNAME}_CHARCOAL-DRAWING${CHARCOALPARM}.$FILEEXT"

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

convert "$FILENAME"  -charcoal $CHARCOALPARM  "$OUTFILE"

## FOR TESTING:
#      set -


##########################
## Show the new image file.
##########################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

 . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
 . $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &

# $IMGEDITOR "$OUTFILE" &

