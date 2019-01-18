#!/bin/sh
##
## Nautilus
## SCRIPT: color00_1imgfile_oneCOLORchange_convert-fill-opaque.sh
##
## PURPOSE: Changes one color to another in a selected image file ---
##          '.jpg' or '.png' or '.gif' or whatever.
##
## METHOD:  Uses 'zenity --entry' to prompt the user for a
##          FROM-color and a TO-color.
##
##          Uses ImageMagick 'convert' with the '-fill' (TO-color)
##          and '-opaque' (FROM-color) options.
##
##          Puts the new image file in a file of the same type (suffix) as
##          the selected input file.
##
##          Shows the new image file in an image viewer of the user's choice.
##
## Reference:  http://studio.imagemagick.org/pipermail/magick-users/2006-May/017672.html
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##
###########################################################################
## Created: 2012jan18
## Changed: 2012may14 Touched up the comments above. Changed some indenting below.
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
## Get the file extension of the selected image file.
##     Assumes one period (.) in filename, at the extension.
####################################################################

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`


####################################################################
## Check that the file extension is 'jpg' or 'png' or 'gif'.
##     Assumes one period (.) in filename, at the extension.
## COMMENTED for now.
####################################################################
 
# if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
# then
#    exit
# fi


#######################################################
## Get the 'midname' of the selected image file, to use
## to name the new output file.
##     Assumes one period (.) in filename, at the extension.
#######################################################

FILEMIDNAME=`echo "$FILENAME" | sed 's|\..*$||'`
# FILEMIDNAME=`echo "$FILENAME" | cut -d\. -f1`


############################################################
## Get the FROM and TO colors to use.
############################################################

COLORS2=""

COLORS2=$(zenity --entry --title "Enter FROM and TO COLORS." \
   --text "\
Enter a pair of colors --- the FROM color, then the TO color.
Examples:
  black white
  #000000 #ffffff
  black red
  #000000 #ff0000" \
   --entry-text "black white")

FROMCOLOR=`echo "$COLORS2" | awk '{print $1}'`
TOCOLOR=`echo "$COLORS2" | awk '{print $2}'`


##################################################################
## Make full filename for the output file --- using the
## name of the selected image file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

OUTFILE="${FILEMIDNAME}_COLORchange.$FILEEXT"

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

convert "$FILENAME" -fuzz 5% -fill "$TOCOLOR" -opaque "$FROMCOLOR"  "$OUTFILE"


#############################
## Show the new image file.
#############################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &

# $IMGEDITOR "$OUTFILE" &
