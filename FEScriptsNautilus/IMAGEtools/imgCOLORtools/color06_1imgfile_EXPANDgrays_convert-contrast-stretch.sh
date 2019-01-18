#!/bin/sh
##
## Nautilus
## SCRIPT: color06_1imgfile_EXPANDgrays_convert-contrast-stretch.sh
##
## PURPOSE: For one image file (jpg, png, gif, whatever),
##          expands the color range of the input image file.
##
## METHOD:  Uses 'zenity --entry' to prompt for top & bottom percents.
##
##          Uses ImageMagick 'convert' with the '-contrast-stretch' option.
##
##          '-contrast-stretch'is similar to '-normalize', except it
##          allows the user to specify the number of pixels that will be
##          clipped or burned-in. That is it provides you with some control
##          over its selection of the 'black-point' and 'white-point' that
##          it will use for the histogram stretching. Thus the user specifies
##          a count (or percent counts) of the darkest grays in the image
##          become black and the count of the lightest greys to become white. 
##
##          This script makes the output file the same format (suffix)
##          as the input file.
##
##          This script shows the resulting output file in an image viewer
##          of the user's choice.
##
## Reference: http://www.imagemagick.org/Usage/color_mods/#contrast-stretch
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##
###########################################################################
## Created: 2012jan17
## Changed: 2012may14 Touched up the comments above. Changed some indenting below.
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
## Prompt for the 'contrast-stretch' value(s).
#######################################################

STRETCH=""

STRETCH=$(zenity --entry --title "Enter CONTRAST-STRETCH value(s)." \
        --text "\
Enter the CONTRAST-STRETCH values to convert dark-grays to black and
to convert light-grays to white.

Example, 15%x15% will replace both the top and bottom 15% of colors
with their extremes (black and white), stretching the rest of the 70%
of colors appropriately." \
        --entry-text "15%x15%")

if test "$STRETCH" = ""
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

OUTFILE="${FILENAMEMID}_STRETCHED.$FILEEXT"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi



##################################################################
## Use 'convert' to make the 'stretched' file.
##
## See http://www.imagemagick.org/Usage/color_mods/#contrast-stretch
## for info on using the '-contrast-stretch' option.
##################################################################

convert "$FILENAME"  -contrast-stretch $STRETCH  "$OUTFILE"


####################################################
## Show the 'stretched' file.
####################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &
