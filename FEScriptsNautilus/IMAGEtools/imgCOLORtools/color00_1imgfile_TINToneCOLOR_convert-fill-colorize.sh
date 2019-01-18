#!/bin/sh
##
## Nautilus
## SCRIPT: color00_1imgfile_TINToneCOLOR_convert-fill-colorize.sh
##
## PURPOSE: Tints a selected image file --- '.jpg' or '.png' or '.gif'
##          or whatever --- according to a color specified by the user.
##
## METHOD:  Uses 'zenity' to prompt the user for a color.
##
##          Uses ImageMagick 'convert' --- with the '-fill' (TO-color)
##          and '-colorize' (percent) options.
##
##          Puts the new image file in a file of the same type (suffix) as
##          the selected input file.
##
##          Shows the new image file in an image viewer of the user's choice.
##
## Reference:  http://www.imagemagick.org/Usage/color_mods/#tinting
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
## Get the 'TO' (tint) color to use.
############################################################

TINTCOLOR=""

TINTCOLOR=$(zenity --entry --title "Enter TINT COLOR." \
   --text "\
Enter a color --- to 'tint' the selected image file.
Examples:
  white
  #ffffff
  red
  #ff0000
  green
  #00ff00
  blue
  #0000ff" \
   --entry-text "#0000ff")

if test "$TINTCOLOR" = ""
then
   exit
fi


############################################################
## Get the 'colorize' PERCENT to use.
############################################################

COLORIZEPERCENT=""

COLORIZEPERCENT=$(zenity --entry --title "Enter COLORIZE PERCENT." \
   --text "\
Enter a percent --- to 'colorize' the selected image file with
the specified color --- $TINTCOLOR.
Example: 50" \
   --entry-text "50")

if test "$COLORIZEPERCENT" = ""
then
   exit
fi


##################################################################
## Make full filename for the output file --- using the
## name of the selected image file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

OUTFILE="${FILEMIDNAME}_COLORTINT.$FILEEXT"

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

## FOR TESTING:
# set -x

convert "$FILENAME" -fill "$TINTCOLOR" -colorize ${COLORIZEPERCENT}%  "$OUTFILE"

## FOR TESTING:
# set -

#############################
## Show the new image file.
#############################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &

# $IMGEDITOR "$OUTFILE" &
