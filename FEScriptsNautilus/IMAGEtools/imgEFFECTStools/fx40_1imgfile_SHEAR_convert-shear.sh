#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_1imgfile_SHEAR_convert-shear.sh
##
## PURPOSE: Makes a 'sheared' file from a selected image file.
##
## METHOD:  Uses 'zenity --entry' to prompt the user for a shear
##          parameter --- for X and Y shear. Examples:
##          20x0   OR   0x50   OR   20x50
##
##          COULD also use 'zenity' to ask for a background fill color.
##          'none' makes a transparent background.
##          Using '#050505' (almost black) for now.
##
##          Uses ImageMagick 'convert' with the '-shear' option.
##
##          Shows the new image file in an image viewer (or editor)
##          of the user's choice.
##
## Reference: http://www.imagemagick.org/Usage/warping/#shear
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##
##########################################################################
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
## Prompt for the 'shear' parameter.
#######################################################

SHEARPARM=""

SHEARPARM=$(zenity --entry \
   --title "Enter X and Y SHEAR parameters." \
   --text "\
Enter a pair of values --- for X and Y shear, angles, in degrees.

Examples: 20x0   OR   0x50   OR   20x50" \
   --entry-text "20x0")

if test "$SHEARPARM" = ""
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

OUTFILE="${FILEMIDNAME}_SHEARED.$FILEEXT"

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

convert "$FILENAME" -background '#050505' -shear $SHEARPARM  "$OUTFILE"
# convert "$FILENAME" -background none -shear $SHEARPARM  "$OUTFILE"

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
