#!/bin/sh
##
## Nautilus
## SCRIPT: 00_1imgfile_makeCOLORtableGIFfile_convert-unique-colors.sh
##
## PURPOSE: For one image file (jpg, png, gif, whatever),
##          makes a color table file from the image file
##          --- in a GIF file.
##
## METHOD:  There is no prompt for a parameter.
##
##          Uses ImageMagick 'convert' with '-unique-colors' and
##          '-scale' options.
##
##          Shows the resulting GIF file in an image viewer of the
##          user's choice.
##
## Reference: http://ubuntuforums.org/showthread.php?t=1565455
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##
############################################################################
## Created: 2011feb03
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
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
## Check that the selected file is a 'jpg', 'png', or
## 'gif' file.
## (Assumes one dot in filename, at the extension.)
#####################################################
## NOT USED NOW.
#####################################################
#  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
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

## FILENAMECROP=`echo "$FILENAME" | sed 's|\.gif$||'`
   FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`

##################################################################
## Make full filename for the text output.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##
## NOT USED NOW.
##################################################################

# CURDIR="`pwd`"

# OUTFILE="${USER}_temp_histogram_info.txt"

# if test ! -w "$CURDIR"
# then
#   OUTFILE="/tmp/$OUTFILE"
# fi
# 
# if test -f "$OUTFILE"
# then
#   rm -f "$OUTFILE"
# fi



##################################################################
## Use 'convert' to make the color table file from the image file.
##################################################################

OUTFILE="${FILENAMECROP}_ColorTable.gif"

convert "$FILENAME"  -unique-colors -scale 1000%  "$OUTFILE"


####################################################
## Show the ColorTable image file.
####################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &
