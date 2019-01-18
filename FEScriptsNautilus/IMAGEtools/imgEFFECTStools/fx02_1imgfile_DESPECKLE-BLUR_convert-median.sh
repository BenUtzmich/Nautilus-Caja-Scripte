#!/bin/sh
##
## NAUTILUS
## SCRIPT: fx02_1imgfile_DESPECKLE-BLUR_convert-median.sh
##
## PURPOSE: Makes a 'despeckled' image file from a selected image file.
##
## METHOD:  Uses 'zenity --entry' to prompt for a despeckle-radius value
##          --- the 'radius' parameter for the '-median' option of 'convert'.
##
##          Uses ImageMagick 'convert' with the '-median' option.
##
##          This script shows the new image file in an image viewer (or editor)
##          of the user's choice.
##
## References: http://www.imagemagick.org/script/convert.php
##             http://shortrecipes.blogspot.com/2006/12/imagemagic-apply-median-filter.html
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##
##########################################################################
## Created: 2012jan22
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

FILEMIDNAME=`echo "$FILENAME" | cut -d'.' -f1`


#######################################################
## Prompt for the '-median' 'radius' parameter.
#######################################################

MEDIAN_RADIUS=""

MEDIAN_RADIUS=$(zenity --entry \
   --title "Enter a DESPECKLE_RADIUS value." \
   --text "\
Enter a '-median'_parameter RADIUS value for the despeckling,
in pixels.

Examples: 2   OR   3   OR   4

NOTE: This will blur the image somewhat --- which may be
a good thing." \
   --entry-text "2")

if test "$MEDIAN_RADIUS" = ""
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

OUTFILE="${FILEMIDNAME}_DESPECKLED_MEDIAN${MEDIAN_RADIUS}.$FILEEXT"

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

convert "$FILENAME"  -median $MEDIAN_RADIUS "$OUTFILE"

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
