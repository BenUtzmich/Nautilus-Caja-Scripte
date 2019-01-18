#!/bin/sh
##
## Nautilus
## SCRIPT: color10_1imgfile_HISTOGRAMgif_convert-histogram.sh
##
## PURPOSE: For a selected image file --- jpg, png, gif, or whatever ---
##          shows histogram info as a red-green-blue-white plot in a GIF file.
##          (Grays are shown as white in the plot.)
##
## METHOD:  There is no prompt for a parameter.
##
##          Uses ImageMagick 'convert' with the 'histogram:' option.
##
##          Shows the resulting histogram GIF file in an image viewer
##          of the user's choice.
##
## Reference: http://www.imagemagick.org/Usage/color_mods/#histogram
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##
###########################################################################
## Created: 2012jan18
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
## Check that the selected file is a 'jpg', 'png', or
## 'gif' file.
## (Assumes one dot in filename, at the extension.)
#####################################################
## COMMENTED. NOT USED NOW.
#####################################################
#  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
#  if test "$FILEEXT" != "jpg" -o  "$FILEEXT" != "png" -o \
#          "$FILEEXT" != "gif"
#  then
#     exit
#  fi


#######################################################
## Get the 'midname' of the selected input file, to use
## to name the new GIF histogram file.
##     (Assumes one dot in filename, at the extension.)
#######################################################

# FILENAMECROP=`echo "$FILENAME" | sed 's|\..*$||'`
FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`


##################################################################
## Make full filename for the GIF output file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

OUTFILE="${FILENAMECROP}_HISTOGRAM.gif"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


##################################################################
## Use 'convert' to make the histogram GIF file.
##################################################################

convert "$FILENAME"  histogram:"$OUTFILE"


####################################################
## Show the histogram GIF file.
####################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &
