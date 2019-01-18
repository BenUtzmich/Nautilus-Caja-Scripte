#!/bin/sh
##
## Nautilus
## SCRIPT: color00_1imgfile_THRESHOLD2WhiteBlackUnchanged_convert-black-white-threshold.sh
##
## PURPOSE: Makes a darks-to-black-and-lights-to-white file from a
##          selected image file --- '.jpg' or '.png' or '.gif' or whatever.
##
##          Leaves colors between dark and light unchanged.
##
## METHOD:  Uses 'zenity' to prompt the user for a black-threshold (%) and
##          a white-threshold level (%).
##
##          Uses ImageMagick 'convert' with the '-black-threshold' and
##          '-white-threshold' options.
##
##          Shows the new image file in an image viewer of the user's choice.
##
## Reference:  http://www.imagemagick.org/Usage/quantize/#threshold
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##
###########################################################################
## Created: 2012jan19
## Changed: 2012may14 Touched up the comments above. Changed some indenting below.
## Changed: 2013jan05 Just changed the name of the script slightly, from
##                    'someWhiteBlack' to 'WhiteBlackUnchanged'. 
###########################################################################


## FOR TESTING: (show statements as they execute)
# set -x

########################################
## Get the filename of the selected file.
########################################

   FILENAME="$1"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"


####################################################################
## Get the file extension from the selected filename.
##     Assumes one period (.) in filename, at the extension.
####################################################################

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`


####################################################################
## Check that the file extension is 'jpg' or 'png' or 'gif'.
##     Assumes one period (.) in filename, at the extension.
## COMMENTED, for now
####################################################################
 
# if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
# then
#    exit
# fi


#######################################################
## Get the 'midname' of the selected input file, to use
## to name the new output file.
#######################################################

# FILENAMECROP=`echo "$FILENAME" | sed 's|\..*$||'`
FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`


############################################################
## Get the black and white threshold levels (%) to use ---
## a pair of values --- space separated
############################################################

THRESHOLDS=""

THRESHOLDS=$(zenity --entry --title "Enter BLACK & WHITE THRESHOLD percents." \
   --text "\
Enter a BLACK-THRESHOLD percent and a WHITE-THRESHOLD percent.
(Generally the black percent should be smaller than the white percent.)

Examples :
   10 90
   40 60
Pixels at or below the black-threshold will be changed to black, and
pixels at or above the white-threshold will be changed to white.
The pixels 'between these thresholds' will be unchanged." \
                --entry-text "10 90")

if test "$THRESHOLDS" = ""
then
   exit
fi

BLACK_THRESHOLD=`echo "$THRESHOLDS" | awk '{print $1}'`
WHITE_THRESHOLD=`echo "$THRESHOLDS" | awk '{print $2}'`

##################################################################
## Make full filename for the output file --- using the
## name of the selected image file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

OUTFILE="${FILENAMECROP}_THRESHOLD_BLACK${BLACK_THRESHOLD}_WHITE${WHITE_THRESHOLD}.$FILEEXT"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


#############################################
## Use 'convert' to make the new output file.
#############################################

convert "$FILENAME" -black-threshold ${BLACK_THRESHOLD}%  \
        -white-threshold ${WHITE_THRESHOLD}%  "$OUTFILE"


#############################
## Show the new image file.
#############################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &

# $IMGEDITOR "$OUTFILE" &
