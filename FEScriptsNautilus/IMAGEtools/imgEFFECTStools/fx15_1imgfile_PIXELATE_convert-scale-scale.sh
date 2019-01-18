#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_1imgfile_PIXELATE_convert-scale-scale.sh
##
## PURPOSE: Makes a 'pixelated' image file from a
##          selected image file.
##
## METHOD:  Uses 'zenity --entry' to prompt the user for the two scale
##          parameters --- a scale-down parameter and a scale-up parameter.
##
##          Uses ImageMagick 'convert' with the '-scale' option used twice.
##
##          Example scale values:  '-scale 25%  -scale 400%', from
##          the Reference web page below.
##
##          This script shows the new image file in an image viewer (or editor)
##          of the user's choice.
##
## Reference: http://www.imagemagick.org/Usage/photos/#anonymity
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##
###########################################################################
## Created: 2012jan18
## Changed: 2012jan21 Add a scale factor to the output filename.
## Changed: 2012jan21 Add 'factor' to the output filename.
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
## Prompt for the 2 '-scale' parameters.
#######################################################

SCALEPARMS=""

SCALEPARMS=$(zenity --entry \
   --title "Enter 2 SCALE PARAMETERS." \
   --text "\
Enter a SCALE-DOWN PERCENT --- and a SCALE-UP PERCENT.
Examples:
25 400  to scale DOWN AND UP by a factor of 4
10 1000 to scale DOWN AND UP by a factor of 10" \
   --entry-text "25 400")

if test "$SCALEPARMS" = ""
then
   exit
fi

SCALE1=`echo "$SCALEPARMS" | awk '{print $1}'`
SCALE2=`echo "$SCALEPARMS" | awk '{print $2}'`


##################################################################
## Make full filename for the output file --- using the
## name of the input file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

OUTFILE="${FILEMIDNAME}_PIXELATED${SCALE2}factor.$FILEEXT"

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

convert "$FILENAME"  -scale ${SCALE1}%  -scale ${SCALE2}%  "$OUTFILE"

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
