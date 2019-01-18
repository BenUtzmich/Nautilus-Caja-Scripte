#!/bin/sh
##
## Nautilus
## SCRIPT: color00_1imgfile_THRESHOLD2allWhiteBlackFile_convert-threshold.sh
##
## PURPOSE: Makes a black-and-white file from a selected image file ---
##          '.jpg' or '.png' or '.gif' or whatever.
##
## METHOD:  Uses 'zenity' to prompt the user for a threshold level (%) to
##          determine what range of color shades to turn black and the
##          remaining pixels to white.
##               (0  = all colors to white except black;
##                99 = all colors but the whitest to black)
##
##          Uses ImageMagick 'convert' with the '-threshold' option.
##
##          Shows the new image file in an image viewer of the user's choice.
##
## Reference:  http://www.imagemagick.org/Usage/quantize/#threshold
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##
############################################################################
## Created: 2010apr01
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2011jan12 Allowed other img files besides '.jpg', '.gif', '.png'.
##                    Also touched up the threshold value prompt examples.
## Changed: 2011jan19 Added 'all' to the script name.
## Changed: 2012may12 Touched up the comments above. Changed some indenting below.
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
## Get the file extension from the selected filename.
##     Assumes one period (.) in filename, at the extension.
####################################################################

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`


####################################################################
## Check that the file extension is 'jpg' or 'png' or 'gif'.
##     Assumes one period (.) in filename, at the extension.
## COMMENTED, for now
####################################################################
 
# if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
# then
#    exit
# fi


#######################################################
## Get the 'midname' of the selected input file, to use
## to name the new output file.
#######################################################

# FILENAMECROP=`echo "$FILENAME" | sed 's|\..*$||'`
FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`


############################################################
## Get the threshold level (%) to use ---
##   -1 turns every color white
##    0 turns every color white, except black
##   50 turns lighter colors white, darker colors black
##  100 turns every color black.
##   http://www.imagemagick.org/Usage/quantize/#threshold
############################################################

THRESHOLD=""

THRESHOLD=$(zenity --entry --title "Enter THRESHOLD percent." \
   --text "\
Enter a threshold :
   -1 to change every color to white ;
    0 to change all colors, except black, to white ;
   50 to change light colors to white, dark colors to black ;
   99 to change all colors but the whitest to black ;
  100 to change all colors to black." \
                --entry-text "50")

if test "$THRESHOLD" = ""
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

OUTFILE="${FILENAMECROP}_THRESHOLD${THRESHOLD}.$FILEEXT"

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

convert "$FILENAME" -threshold ${THRESHOLD}%  "$OUTFILE"


#############################
## Show the new image file.
#############################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &

# $IMGEDITOR "$OUTFILE" &
