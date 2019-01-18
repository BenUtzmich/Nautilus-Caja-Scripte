#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_1imgfile_toPENCIL-SKETCH_convert-sketch.sh
##
## PURPOSE: Makes a 'pencil sketch' (gray-scale) file from a
##          selected image file.
##
## METHOD:  Uses ImageMagick 'convert' with the '-sketch' option.
##
##          Uses 'zenity --info' to indicate to the user about how
##          long it will take to generate the 'pencil sketch'.
##
##          COULD use 'zenity' to prompt the user for a sketch parameter.
##          For now, we use the hardcoded value '-sketch 0x20+120', from
##          the Reference web page below.
##
##          Shows the new image file in an image viewer (or editor)
##          of the user's choice.
##
## Reference: http://www.imagemagick.org/Usage/photos/#pencil
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##
#########################################################################
## Created: 2012jan18
## Changed: 2012jan25 Add 'zenity --info' popup to give time estimate.
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
## COMMENTED, for now.
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


#######################################################
## Prompt for the '-sketch' parameter.
## COMMENTED, for now.
#######################################################

# SKETCHPARM=""

# SKETCHPARM=$(zenity --entry \
#    --title "Enter SKETCH PARAMETER." \
#    --text "\
# Enter yada yada yada.
# Example: 0x20+120
# 
# NOTE: yada yada yada" \
#    --entry-text "0x20+120")

# if test "$SKETCHPARM" = ""
# then
#    exit
# fi



##################################################################
## Make full filename for the output file --- using the
## name of the input file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

OUTFILE="${FILEMIDNAME}_PENCIL-SKETCH.gif"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


##################################################################
## Warn the user that this may take about half a minute.
##################################################################

zenity --info \
   --title "NOTE: This may take about half a minute." \
   --text "\
The process of making a 'pencil-sketch' from an image file ---
using the ImageMagick 'convert' command with the '-sketch' option ---
may take a while depending on the size of the image file.
 
Some example times (on one computer):
___________________    _________________
                                                APPROX
Image size (pixels)    Number of seconds
___________________    _________________
     300x200                           4
     500x400                          10                
     800x600                          20
    1200x800                         40

The processing is going on right now. The GIF file

   $OUTFILE

should be ready soon.
" &

###########################################
## Use 'convert' to make the new image file.
###########################################

## FOR TESTING:
#      set -x

convert "$FILENAME"  -colorspace gray  -sketch 0x20+120  "$OUTFILE"

## FOR TESTING:
#      set -


##########################
## Show the new image file.
##########################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &

# $IMGEDITOR "$OUTFILE" &
