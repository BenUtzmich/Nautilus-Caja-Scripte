#!/bin/sh
##
## Nautilus
## SCRIPT: 11_2imgFiles_DISSOLVE_onCenters_composite-dissolve.sh
##
## PURPOSE: For two selected image files in a directory ('.jpg' or
##          '.png' or '.gif' or whatever), 'dissolves' the two image files
##          together using the ImageMagick 'composite' command.
##
## METHOD:  Uses 'zenity --entry' to ask the user for a dissolve percentage ---
##          0 to 200 percent.
##
##          Uses the 'composite' command with the '-dissolve' and
##          '-gravity Center' and '-alpha Set' options.
##
##          Makes the output filename based on the 'midnames' of the
##          selected image files. Makes the output file of a type
##          determined by the extension of the 'first' of the 2 selected files.
##
##          Shows the new output (dissolved) file in an image viewer of
##          the user's choice.
##
## REFERENCE: http://www.imagemagick.org/Usage/compose/#dissolve
##
## HOW TO USE: In Nautilus, select a pair of image files in a directory.
##             Then right-click and choose this script to run (name above).
##
############################################################################
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
## Prompt for the 'dissolve' percent.
#######################################################

PERCENT=""

PERCENT=$(zenity --entry \
   --title "Enter DISSOLVE PERCENT." \
   --text "\
Enter the DISSOLVE-PERCENT of one image versus the other.
Enter a number between 0 and 200.

In the 0 to 100 percent range, the 2nd image is not dissolved at all.
In the 100 to 200 range, the 1st image is left as is, and the 2nd
image is dissolved. The 2nd image is completely gone when the percent
reaches a value of 200." \
   --entry-text "100")

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

OUTFILE="${FILENAME1MID}_${FILENAME2MID}_DISSOLVED_PERCENT${PERCENT}.$FILEEXT1"

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

composite -dissolve $PERCENT -gravity Center \
         "$FILENAME1"  "$FILENAME2"  -alpha Set "$OUTFILE"


####################################################
## Show the appended output image file.
####################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &
