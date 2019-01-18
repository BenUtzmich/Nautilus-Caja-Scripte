#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_1imgfile_SHADE-EMBOSS_convert-shade.sh
##
## PURPOSE: Makes an shaded/embossed file from a selected image file.
##
## METHOD:  Uses 'zenity --entry' to prompt the user for a shade parameter
##          --- light-direction and elevation-angle. Examples:
##          0x45  OR  45x15  OR  90x30  OR  135x45  OR  180x60
##
##          Uses ImageMagick 'convert' with the '-shade' option.
##
##          Shows the new image file in an image viewer (or editor)
##          of the user's choice.
##
## Reference: http://www.imagemagick.org/Usage/transform/#shade
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##
###########################################################################
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

FILEMIDNAME=`echo "$FILENAME" | cut -d'.' -f1`


#######################################################
## Prompt for the embossing 'radius' parameter.
#######################################################

DIRECTION_ELEVATION=""

DIRECTION_ELEVATION=$(zenity --entry \
   --title "Enter light DIRECTION and ELEVATION for shading." \
   --text "\
Enter a pair of angles --- for light DIRECTION angle (in the plane of
the image) and for light ELEVATION angle (above the plane of the image).
Examples: 0x45  OR  45x15  OR  90x30  OR  135x45  OR  180x60

NOTE: The grays of the image are considered a 'height map'. The two angles
of the light are applied to that height map." \
   --entry-text "120x45")

if test "$DIRECTION_ELEVATION" = ""
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

OUTFILE="${FILEMIDNAME}_SHADED-EMBOSSED.$FILEEXT"

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

convert "$FILENAME"  -shade $DIRECTION_ELEVATION  "$OUTFILE"

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
