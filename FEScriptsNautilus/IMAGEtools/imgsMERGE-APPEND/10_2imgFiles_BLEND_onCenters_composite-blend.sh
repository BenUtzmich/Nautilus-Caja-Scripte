#!/bin/sh
##
## Nautilus
## SCRIPT: 10_2imgFiles_BLEND_onCenters_composite-blend.sh
##
## PURPOSE: For two selected image files in a directory ('.jpg' or
##          '.png' or '.gif' or whatever), 'blends' the two image files
##          together using the ImageMagick 'composite' command.
##
## METHOD:  Uses 'zenity --entry' to ask the user for a blend percentage ---
##          0 to 100 percent.
##
##          Uses the 'composite' command with the '-blend' and
##          '-gravity Center' and '-alpha Set' options.
##
##          Makes the output filename based on the 'midnames' of the
##          2 selected image files. The output file is made
##          to be the same type (extension) as the 1st selected file.
##
##          Shows the new output (blended) file in an image viewer of
##          the user's choice.
##
## REFERENCE: http://www.imagemagick.org/Usage/compose/#blend
##
## HOW TO USE: In Nautilus, select a pair of image files in a directory.
##             Then right-click and choose this script to run (name above).
##
##########################################################################
## Created: 2012jan17
## Changed: 2012may14 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x

####################################
## Get the 2 filenames.
##    (Ignore any others selected.)
####################################

FILENAME1="$1"
FILENAME2="$2"

## ALTERNATIVE WAY of getting the 2 filenames:

# FILENAME1="$1"
# shift
# FILENAME2="$1"


##########################################################
## Get the 'mid-name' of the FIRST selected image file ---
## a 'jpg', or 'png', or 'gif', or whatever file.
##
##   (Assumes one dot in filename, at the extension.)
#########################################################

## FILENAME1MID=`echo "$FILENAME1" | sed 's|\.gif$||' | sed 's|\.jpg$||' | sed 's|\.png$||' `
   FILENAME1MID=`echo "$FILENAME1" | cut -d\. -f1`

   FILENAME2MID=`echo "$FILENAME2" | cut -d\. -f1`


#####################################################
## Get the extension of the FIRST selected file ---
## a 'jpg', 'png', 'gif', or whatever file.
## (Assumes one dot in filename, at the extension.)
#####################################################

FILEEXT1=`echo "$FILENAME1" | cut -d\. -f2`
 

#######################################################
## Prompt for the 'blend' percent.
#######################################################

PERCENT=""

PERCENT=$(zenity --entry \
   --title "Enter BLEND PERCENT." \
   --text "\
Enter the BLEND-PERCENT of one image versus the other.
Enter a number between 0 and 100." \
   --entry-text "50")

if test "$PERCENT" = ""
then
    exit
fi


##################################################################
## Make full filename for the output file --- using the
## name of the first selected file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

OUTFILE="${FILENAME1MID}_${FILENAME2MID}_BLENDED_PERCENT${PERCENT}.$FILEEXT1"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


########################################################
## Call 'composite' with all the filenames passed on the
## command line.
########################################################

composite -blend $PERCENT -gravity Center \
         "$FILENAME1"  "$FILENAME2" -alpha Set "$OUTFILE"


####################################################
## Show the appended output image file.
####################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &
