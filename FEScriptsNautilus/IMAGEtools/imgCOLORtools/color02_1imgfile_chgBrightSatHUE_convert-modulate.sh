#!/bin/sh
##
## Nautilus
## SCRIPT: color02_1imgfile_chgBrightSatHUE_convert-modulate.sh
##
## PURPOSE: Changes BRIGHTNESS and/or SATURATION and/or HUE of an
##          image file --- '.jpg' or '.png' or '.gif' or whatever ---
##          according to 3 percentage values entered --- 100 (%) being no change.
##
## METHOD:  Uses 'zenity --entry' to prompt the user for the 3 percentages.
##
##          Uses the ImageMagick 'convert' program with the '-modulate' option
##          to make a new image file.
##
##          Shows the new image file in an image viewer of the user's choice.
##
## Reference:  Linux Format Magazine, LXF142, March 2011, page 104
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##
#############################################################################
## Created: 2011nov11 
## Changed: 2011jan12 Allowed other img files besides '.jpg', '.gif', '.png'.
##                    Also touched up a couple of other sections.
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
# 
#    zenity --question --title "CONTINUE ??" \
#          --text "
# File suffix was not '.jpg' or '.png' or '.gif'.
# Continue processing image file ?
# Cancel = Exit = Stop processing."
# 
#    if test ! $? = 0
#    then
#       exit
#    fi
# fi


#################################################################
## Get the 'midname' of the selected image file, to use
## to name the new output file.
##    Assumes one period (.) in the filename --- at the extension.
#################################################################

# FILENAMECROP=`echo "$FILENAME" | sed 's|\..*$||'`
FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`



################################################################
## Get the 3 percents to use -- for brightness, saturation, hue.
################################################################

PERCENTS_3=""

PERCENTS_3=$(zenity --entry --title "Enter 3 percents." \
--text "\
Enter 3 percents for BRIGHTNESS, SATURATION, and HUE ...
where 100 indicates NO CHANGE.
The percents can be greater than 100.

Example: 100,100,150     to increase hue, but leave
                         brightness and saturation unchanged.
" \
--entry-text "100,100,150")

if test "$PERCENTS_3" = ""
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

PERCENTS_TEMP=`echo "$PERCENTS_3" | sed 's|,|_|g'`

OUTFILE="${FILENAMECROP}_BrightSatHue_${PERCENTS_TEMP}.$FILEEXT"

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

convert -modulate $PERCENTS_3 "$FILENAME" "$OUTFILE"


##############################################################
## Show the new image file --- with an image viewer or editor.
##############################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &

# $IMGEDITOR "$OUTFILE" &
