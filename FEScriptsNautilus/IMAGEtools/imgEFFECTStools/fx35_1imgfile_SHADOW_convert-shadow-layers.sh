#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_1imgfile_SHADOW_convert-shadow-layers.sh
##
## PURPOSE: Makes a 'SHADOW' PNG image file (gray shadow, 'under' the lower
##          right of the image) from a selected image file.
##
## METHOD:  Uses 'zenity --entry' to prompt the user for the '-shadow' 
##          parameter ---  percent-opacity{xsigma}{+-}x{+-}y{%}.
##          Examples: 80x3+5+5  OR  60x0+4+4
##
##          Uses ImageMagick 'convert' with the '-shadow' option.
##
##          This script shows the new image file in an image viewer (or editor)
##          of the user's choice.
##
## Reference: http://www.imagemagick.org/Usage/blur/#shadow
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##
############################################################################
## Created: 2012jan18
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
## COMMENTED, not used, for now.
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
## Prompt for the shadow parameter.
#######################################################

SHADOWPARM=""

SHADOWPARM=$(zenity --entry \
   --title "Enter SHADOW PARAMETER." \
   --text "\
Enter a SHADOW PARAMETER --- percent-opacity{xsigma}{+-}x{+-}y{%} ---
where sigma is a fuzziness factor (in pixels), and x and y are offsets.

Examples: 80x3+5+5  OR  60x0+4+4" \
   --entry-text "80x3+5+5")

if test "$SHADOWPARM" = ""
then
   exit
fi


##################################################################
## Make full filename for the output file --- using the
## name of the input file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

OUTFILE="${FILEMIDNAME}_SHADOWED.png"

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

## FOR TESTING:
#      set -x

convert "$FILENAME"  \( +clone  -background black  -shadow $SHADOWPARM \) \
        +swap  -background none  -layers merge  +repage  "$OUTFILE"

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
