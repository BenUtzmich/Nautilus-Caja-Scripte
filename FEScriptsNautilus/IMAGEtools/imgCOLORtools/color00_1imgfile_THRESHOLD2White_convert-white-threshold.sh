#!/bin/sh
##
## Nautilus
## SCRIPT: color00_1imgfile_THRESHOLD2White_convert-white-threshold.sh
##
## PURPOSE: Makes a dull-whites-TO-white file from a selected image file ---
##          '.jpg' or '.png' or '.gif' or whatever.
##
## METHOD:  Uses 'zenity' to prompt the user for a threshold level (%) to
##          determine what range of whitish-shades to turn white.
##
##          Uses ImageMagick 'convert' with the '-white-threshold' option.
##
##          Shows the new image file in an image viewer of the user's choice.
##
## Reference: http://www.imagemagick.org/script/command-line-options.php#white-threshold
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##    
############################################################################
## Created: 2012jan19
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
## Get the white-threshold level (%) to use
## --- typically 50% or greater.
############################################################

WHITE_THRESHOLD=""

WHITE_THRESHOLD=$(zenity --entry --title "Enter WHITE-THRESHOLD percent." \
   --text "\
Enter a WHITE-THRESHOLD percent --- 0 to 100.

All pixels 'above the threshold' are forced to white,
while leaving all pixels at or below the threshold unchanged.." \
                --entry-text "50")

if test "$WHITE_THRESHOLD" = ""
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

OUTFILE="${FILENAMECROP}_WHITEthreshold${WHITE_THRESHOLD}.$FILEEXT"

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

convert "$FILENAME" -white-threshold ${WHITE_THRESHOLD}%  "$OUTFILE"


#############################
## Show the new image file.
#############################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &

# $IMGEDITOR "$OUTFILE" &
