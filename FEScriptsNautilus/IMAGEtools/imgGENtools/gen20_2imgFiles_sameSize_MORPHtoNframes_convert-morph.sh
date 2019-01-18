#!/bin/sh
##
## Nautilus
## SCRIPT: gen20_2imgFiles_sameSize_MORPHtoNframes_convert-morph.sh
##
## PURPOSE: For two selected image files in a directory --- '.jpg' or
##          '.png' or '.gif' or whatever, this script 'morphs' the two
##          image files into a user-specified number of 'frames'.
##
## METHOD:  Uses 'zenity --entry' to ask the user for number of 'frames'
##          to generate.
##
##          Uses the ImageMagick 'convert' command with the '-morph' option.
##
##          Makes the output filenames based on the name of the first
##          selected image file.
##
##          Shows one of the new output 'frame' files in an image viewer
##          of the user's choice.
##
## REFERENCE: http://www.imagemagick.org/script/command-line-options.php#morph
##            For a command line example, see
##            http://www.imagemagick.org/script/command-line-options.php#adjoin
##
## HOW TO USE: In Nautilus, select a pair of image files in a directory.
##             Then right-click and select this script to run (name above).
##
###########################################################################
## Created: 2012jan19
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

## FILENAME1MID=`echo "$FILENAME1" | sed 's|\..*$||'`
   FILENAME1MID=`echo "$FILENAME1" | cut -d\. -f1`

#  FILENAME2MID=`echo "$FILENAME2" | cut -d\. -f1`

#####################################################
## Get the extension of the FIRST selected file ---
## a 'jpg', 'png', 'gif', or whatever file.
## (Assumes one dot in filename, at the extension.)
#####################################################

FILEEXT1=`echo "$FILENAME1" | cut -d\. -f2`
 


#######################################################
## Prompt for the number of FRAMES.
#######################################################

FRAMES=""

FRAMES=$(zenity --entry --title "Enter NUMBER of FRAMES." \
        --text "\
Enter the NUMBER of FRAMES to be generated (blended/merged)
from the two selected files.

The output filenames will be named starting with the name of one
of the selected files --- with 2 digit numbers indicating the frames.
Frames 0 and N+1, where N is the number you specified, are copies
of the 2 selected files.

You can use one of the feNautilusScript ANIGIF utilities to make
an animated GIF from the sequence of numbered 'frame' files." \
        --entry-text "5")

if test "$FRAMES" = ""
then
    exit
fi



##################################################################
## Make full filename for the output file --- using the
## name of the first and/or 2nd selected files --- and a
## printf() integer format string --- %02d.
##
## If the user has write-permission on the
## current directory, put the files in the pwd.
## Otherwise, put the files in /tmp.
##################################################################

CURDIR="`pwd`"

# OUTFILE="${FILENAME1MID}_${FILENAME2MID}_MORPHED_%02d.$FILEEXT1"
OUTFILE="${FILENAME1MID}_MORPHED_%02d.$FILEEXT1"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi



########################################################
## Call 'convert' with all the filenames passed on the
## command line.
########################################################

convert "$FILENAME1"  "$FILENAME2" -morph $FRAMES  "$OUTFILE"


####################################################
## Show the output image file(s).
####################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

OUTMASK=`echo "$OUTFILE" | sed 's|\%02d|\*|'`

$IMGVIEWER $OUTMASK &
