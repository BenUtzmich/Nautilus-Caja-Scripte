#!/bin/sh
##
## NAUTILUS
## SCRIPT: fx57_1imgfile_toBADGE_inPNG_convert-compose.sh
##
## PURPOSE: Makes a 'badge' image (a high-lighted, shadowed badge - on a
##          transparent background - in a PNG file) from a selected image file.
##
## METHOD:  There is no prompt for a parameter.
##
##          Uses ImageMagick 'convert' with the '-compose' option --- and
##          other options --- along with a re-sized gray-scale badge file.
##          ('convert' is used to resize the badge file.)
##
##          Shows the new (PNG) image file in an image viewer (or editor)
##          of the user's choice.
##
## Reference: http://www.imagemagick.org/Usage/thumbnails/#badge_lighting
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##
############################################################################
## Created: 2012feb01
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
## Get the file extension - for use in naming output file(s).
##     Assumes one period (.) in filename, at the extension.
## COMMENTED, for now.  (We will use a PNG file for output.)
####################################################################

# FILEEXT=`echo "$FILENAME" | cut -d\. -f2`


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


##########################################################
## Get the input filesize, x and y, in pixels.
##########################################################

SIZEXY=`identify "$FILENAME" | head -1 | awk '{print $3}'`
SIZEX=`echo "$SIZEXY" | cut -dx -f1`
SIZEY=`echo "$SIZEXY" | cut -dx -f2`

##########################################################
## Get the smaller of the x and y sizes, in pixels.
##########################################################

PIXELS=$SIZEX

if test $SIZEY -lt $SIZEX
then
   PIXELS=$SIZEY
fi


#######################################################
## Resize a badge gray scale file to PIXELS square.
#######################################################

DIR_THISSCRIPT=`dirname $0`

TEMPBADGEFILE="/tmp/temp_badge_lighting_gray.png"

if test -f "$TEMPBADGEFILE"
then
  rm -f "$TEMPBADGEFILE"
fi

convert  "$DIR_THISSCRIPT/.badges/badge_lighting_gray_transpBkgnd_opaqueCenter_84x84.png" \
         -resize ${PIXELS}x$PIXELS\!  "$TEMPBADGEFILE"


##################################################################
## Make full filename for the (PNG) output file --- using the
## name of the input file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

OUTFILE="${FILEMIDNAME}_BADGE_${PIXELS}x${PIXELS}.png"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


#################################################################
## Use 'convert' with '-compose' to make the new image file..
#################################################################

## FOR TESTING: (show statements as they execute)
#      set -x

convert "$FILENAME" -alpha set -gravity center -extent ${PIXELS}x$PIXELS \
         "$TEMPBADGEFILE" \
          \( -clone 0,1 -alpha Opaque -compose Hardlight -composite \) \
          -delete 0 -compose In -composite \
          "$OUTFILE"

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
