#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_1imgfile_POSTERIZE_convert-posterize.sh
##
## PURPOSE: Makes a 'posterized' image file (reduced number of colors)
##          from a selected image file.
##
## METHOD:  Uses 'zenity' to prompt the user for a posterize value ---
##          typically from 3 to 6 (or 8).
##
##          Uses ImageMagick 'convert' with the '-posterize' option.
##
##          This script shows the new image file in an image viewer (or editor)
##          of the user's choice.
##
## Reference: http://www.imagemagick.org/Usage/quantize/#posterize
##            http://studio.imagemagick.org/pipermail/magick-users/2004-February/012163.html
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##
############################################################################
## Created: 2012jan18
## Changed: 2012may14 Touched up the comments above. Changed some indenting below.
###########################################################################


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

# FILEMIDNAME=`echo "$FILENAME" | sed 's|\..*$||'`
FILEMIDNAME=`echo "$FILENAME" | cut -d'.' -f1`


#######################################################
## Prompt for the posterize parameter.
#######################################################

POSERTIZEPARM=""

POSERTIZEPARM=$(zenity --entry \
   --title "Enter POSTERIZE PARAMETER." \
   --text "\
Enter a POSTERIZE PARAMETER, to reduce the number of 'color levels'
(with no dithering) in the selected image file:
   $FILENAME

Examples:
2   or   3   OR   4   OR   5   OR   6

For example, '3' will provide 3 colors per RGB color channel
resulting in a colormap of 3 x 3 x 3 = 27 colors.
2 gives 8
4 gives 64
5 gives 125
6 gives 216" \
   --entry-text "6")

if test "$POSERTIZEPARM" = ""
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

OUTFILE="${FILEMIDNAME}_POSTERIZED_${POSERTIZEPARM}.$FILEEXT"

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

## FOR TESTING: (show statements as they execute)
#      set -x

convert  +dither "$FILENAME"  -posterize $POSERTIZEPARM  "$OUTFILE"

## FOR TESTING: (turn off display of statements)
#      set -


##########################
## Show the new image file.
##########################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &

# $IMGEDITOR "$OUTFILE" &
