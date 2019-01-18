#!/bin/sh
##
## Nautilus
## SCRIPT: 12_2imgFiles_OVERLAY_composite-gravity.sh
##
## PURPOSE: For two selected image files in a directory ('.jpg' or
##          '.png' or '.gif' or whatever), 'overlays' the two image files
##          together using the ImageMagick 'composite' command.
##
## METHOD:  Uses 'zenity --list --radiolist' twice:
##            1) to ask the user for which image to overlay on which
##               --- 1-on-2, or 2-on-1.
##            2) To ask the user for the location of the overlay ---
##               for the '-gravity' parameter of 'composite'.
##
##          Runs the 'composite' command with the '-gravity' option.
##          Feeds the names of the 2 files to 'composite' depending
##          on the user choice of '1-on-2' or '2-on-1'.
##
##          Makes the output filename based on the name of the two
##          selected image files. The output file type is determined
##          by the extension of the 'first' of the 2 selected files.
##
##          Shows the new output (overlayed) file in an image viewer of
##          the user's choice.
##
## REFERENCE: http://www.imagemagick.org/Usage/annotating/#overlay
##
## HOW TO USE: In Nautilus, select a pair of image files in a directory.
##             Then right-click and choose this script to run (name above).
##
##########################################################################
## Created: 2012feb01
## Changed: 2012feb28 Added the prompt for overlay location, 'gravity'.
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
## Prompt for the which file to overlay which ---
## 1-on-2, or 2-on-1.
#######################################################

OVERLAYTYPE=""

OVERLAYTYPE=$(zenity --list --radiolist \
   --title "OVERLAY file1-on-2 OR file2-on-1?" \
   --text "\
FILE1: $FILENAME1
FILE2: $FILENAME2

Choose one of the following file overlay types:" \
   --column "" --column "OverlayType" \
   TRUE 1-on-2 FALSE 2-on-1)

if test "$OVERLAYTYPE" = ""
then
   exit
fi

#######################################################
## Prompt for the 'gravity' location of the overlay.
#######################################################

 GRAVITY=""

 GRAVITY=$(zenity --list --radiolist \
   --title "Position of the overlay?" \
   --text "Choose one of the following locations:" \
   --column "" --column "Type" \
   TRUE Center \
   FALSE North \
   FALSE South \
   FALSE East \
   FALSE West \
   FALSE NorthEast \
   FALSE NorthWest \
   FALSE SouthEast \
   FALSE SouthWest)

 if test "$GRAVITY" = ""
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

if test "$OVERLAYTYPE" = "1-on-2"
then
   OUTFILE="${FILENAME1MID}_ON_${FILENAME2MID}_OVERLAY.$FILEEXT1"
else
   OUTFILE="${FILENAME2MID}_ON_${FILENAME1MID}_OVERLAY.$FILEEXT1"
fi

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi



########################################################
## Call 'composite' with the two filenames passed on the
## command line.
########################################################

if test "$OVERLAYTYPE" = "1-on-2"
then
   composite -gravity $GRAVITY  "$FILENAME1"  "$FILENAME2"  "$OUTFILE"
else
   composite -gravity $GRAVITY  "$FILENAME2"  "$FILENAME1"  "$OUTFILE"
fi

####################################################
## Show the appended output image file.
####################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &
