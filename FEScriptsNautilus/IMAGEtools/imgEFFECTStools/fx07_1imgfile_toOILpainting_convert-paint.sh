#!/bin/sh
##
## Nautilus
## SCRIPT: fx07_1imgfile_toOILpainting_convert-paint.sh
##
## PURPOSE: For one image file (jpg, png, gif, whatever),
##          makes an oil-painting type file from the image file.
##
## METHOD:  Uses 'zenity --entry' to prompt for a 'radius' parameter.
##
##          Uses ImageMagick 'convert' with the '-paint' option.
##
##          Makes the output file the same format (suffix) as the input file.
##
##          Shows the resulting output file in an image viewer of the
##          user's choice.
##
## Reference: http://www.imagemagick.org/Usage/transform/#paint
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##
###########################################################################
## Created: 2012jan17
## Changed: 2012may14 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################


## FOR TESTING: (show the statements as executed)
# set -x

#########################################
## Get the filename of the selected file.
#########################################

# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
# FILENAMES="$@"
  FILENAME="$1"


#####################################################
## Get the extension of the input file.
##    (Assumes one dot in filename, at the extension.)
#####################################################

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`


#####################################################
## Check that the selected file is a 'jpg', 'png', or
## 'gif' file.
## (Assumes one dot in filename, at the extension.)
#####################################################
## NOT USED NOW.
#####################################################

#  if test "$FILEEXT" != "jpg" -o  "$FILEEXT" != "png" -o \
#          "$FILEEXT" != "gif"
#  then
#     exit
#  fi


##########################################################
## Get the 'mid-name' of the selected image file (a 'jpg',
## or 'png', or 'gif', or whatever file).
##
## (Assumes one dot in filename, at the extension.)
#####################################################

## FILENAMEMID=`echo "$FILENAME" | sed 's|\.gif$||' | sed 's|\.jpg$||' | sed 's|\.png$||'`
   FILENAMEMID=`echo "$FILENAME" | cut -d\. -f1`


#######################################################
## Prompt for the 'oil painting radius' parameter.
#######################################################

RADIUS=""

RADIUS=$(zenity --entry --title "Enter OIL-PAINT RADIUS." \
        --text "\
Enter the OIL-PAINTING 'RADIUS' ---
an integer typically between 1 and 10." \
        --entry-text "3")

if test "$RADIUS" = ""
then
    exit
fi


##################################################################
## Make the full filename for the output image file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

OUTFILE="${FILENAMEMID}_OILpainting_RADIUS${RADIUS}.$FILEEXT"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


##################################################################
## Use 'convert' to make the 'oil painting' file.
##################################################################

convert "$FILENAME"  -paint $RADIUS  "$OUTFILE"

# convert "$FILENAME" -blur 0x3 -paint $RADIUS  "$OUTFILE"


####################################################
## Show the 'oil painting' file.
####################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &
