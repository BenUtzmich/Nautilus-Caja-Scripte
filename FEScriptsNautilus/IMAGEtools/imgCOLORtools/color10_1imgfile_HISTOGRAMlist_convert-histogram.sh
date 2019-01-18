#!/bin/sh
##
## Nautilus
## SCRIPT: color10_1imgfile_HISTOGRAMlist_convert-histogram.sh
##
## PURPOSE: For a selected image file --- jpg, png, gif, or whatever ---
##          shows a list of histogram info on the colors in the file.
##
## METHOD:  There is no prompt for a parameter.
##
##          Uses ImageMagick 'convert' with the 'histogram:info:-' option.
##
##          Shows the resulting histogram info in a text viewer of the
##          user's choice.
##
## Reference: http://ubuntuforums.org/showthread.php?t=1565455
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##
#############################################################################
## Created: 2011feb03
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012jan18 Added a heading for the output histogram-list file.
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
## NOT USED NOW.
#####################################################
#  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
#  if test "$FILEEXT" != "jpg" -o  "$FILEEXT" != "png" -o \
#          "$FILEEXT" != "gif"
#  then
#     exit
#  fi


#######################################################
## Get the 'midname' of the selected input file, to use
## to name the new output file.
#######################################################

# FILENAMECROP=`echo "$FILENAME" | sed 's|\..*$||'`
FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`



##################################################################
## Make full filename for the text output.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

OUTFILE="${FILENAMECROP}_HISTOGRAM_info.lis"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


##################################################################
## PREP a heading for the histogram info list file.
##################################################################

echo "\
HISTOGRAM LIST for filename:
$FILENAME

in directory:
$CURDIR

Number of
pixels of
a color       RGB Color value     Color name
----------  --------------------- ----------
" > "$OUTFILE"


##################################################################
## Use 'convert' to show histogram info of the image file.
##################################################################

convert "$FILENAME"  -format %c -depth 8  histogram:info:- >> "$OUTFILE"


####################################################
## Show the histogram info output.
####################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
