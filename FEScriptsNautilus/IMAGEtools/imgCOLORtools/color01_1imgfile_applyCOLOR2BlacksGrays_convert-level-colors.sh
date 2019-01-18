#!/bin/sh
##
## Nautilus
## SCRIPT: color01_1imgfile_applyCOLOR2BlacksGrays_convert-level-colors.sh
##
## PURPOSE: Converts blacks and grays of an image file  --- '.jpg' or
##          '.png' or '.gif' or whatever --- to shades of the specified color.
##
## METHOD:  Uses 'zenity --entry' to prompt the user for the color.
##
##          Uses the ImageMagick 'convert' program with the '+level-colors'
##          option.
##
##          Shows the new image file in an image viewer of the user's choice.
##
## Reference:  http://www.imagemagick.org/Usage/color/#level-colors
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##
############################################################################
## Created: 2010apr01
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012jan18 Allowed other img files besides '.jpg', '.gif', '.png'.
##                    Also touched up the level-color prompt examples.
## Changed: 2012may14 Touched up the comments above. Changed some indenting below.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x

##########################################
## Get the filename of the selected file.
##########################################

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
## COMMENTED, for now.
####################################################################
 
# if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
# then
#    exit
# fi


#####################################################
## Get the 'midname' of the selected input file, to use
## to name the new output file.
#####################################################

# FILENAMECROP=`echo "$FILENAME" | sed 's|\..*$||'`
FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`


####################################################################
## Get the color to use for converting blacks and grays to
## shades of the specified color.
## Reference:  http://www.imagemagick.org/Usage/color/#level-colors
####################################################################

LEVELCOLOR=""

LEVELCOLOR=$(zenity --entry --title "Enter a 'LEVEL-COLOR'." \
   --text "\
Enter a 'level color'. Examples:
blue
#0000ff

If you specify blue, blacks go to blue ;
grays go to light blue ; whites stay white" \
   --entry-text "#0000ff")

if test "$LEVELCOLOR" = ""
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

OUTFILE="${FILENAMECROP}_$LEVELCOLOR.$FILEEXT"

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

convert "$FILENAME" +level-colors $LEVELCOLOR,white \
        "$OUTFILE"

## FOR TESTING:
# set -


###########################
## Show the new image file.
###########################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &

# $IMGEDITOR "$OUTFILE" &
