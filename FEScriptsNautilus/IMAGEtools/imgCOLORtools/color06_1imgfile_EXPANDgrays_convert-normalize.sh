#!/bin/sh
##
## Nautilus
## SCRIPT: color06_1imgfile_EXPANDgrays_convert-normalize.sh
##
## PURPOSE: For one image file (jpg, png, gif, whatever),
##          expands the color range of the input image file.
##
## METHOD:  There is no prompt for a parameter, but we could add a
##          prompt for whether to use the '-channel all' or
##          '-separate ... -combine' options of 'convert'.
##
##          Uses ImageMagick 'convert' with the '-normalize' option.
##
##          '-normalize' expands the grayscale histogram so that it
##          occupies the full dynamic range of gray values, while clipping
##          or burning 2% on the low (black) end and 1% on the on the high
##          (white) end of the histogram. That is, 2% of the darkest grays
##          in the image will become black and 1% of the lightest grays
##          will become white. 
##
##          Makes the output file the same format (suffix) as the input file.
##
##          Shows the resulting output file in an image viewer of the
##          user's choice.
##
## Reference: http://www.imagemagick.org/Usage/color_mods/#normalize
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##
#########################################################################
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


##################################################################
## Make the full filename for the output image file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

OUTFILE="${FILENAMEMID}_NORMALIZED.$FILEEXT"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


##################################################################
## Use 'convert' to make the 'normalized' file.
##
## See http://www.imagemagick.org/Usage/color_mods/#normalize
## for info on using the '-channel all' and '-separate ... -combine'
## options.
##################################################################

convert "$FILENAME"  -normalize  "$OUTFILE"

# convert "$FILENAME"  -channel all -normalize  "$OUTFILE"

# convert "$FILENAME" -separate -normalize -combine "$OUTFILE"


####################################################
## Show the 'normalized' file.
####################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &
