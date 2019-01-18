#!/bin/sh
##
## Nautilus
## SCRIPT: 09_multi-img-files_APPEND_horizORvert_convert-append.sh
##
## PURPOSE: Passes a selected set of selected image filenames ('.jpg' or
##          '.png' or '.gif' or whatever) to the ImageMagick 'convert'
##          command.
##
## METHOD:  Uses 'zenity --list --radiolist' to prompt for 'Horiz' or 'Vert'.
##
##          Uses the 'convert' command with either the '-append' (vertical)
##          or '+append' (horizontal) option.
##
##          Makes the output filename based on the name of the FIRST
##          selected input file.
##
##          Shows the new output (appended) file in an image viewer of
##          the user's choice.
##
## HOW TO USE: In Nautilus, select one or more image files in a directory.
##             Then right-click and choose this script to run (name above).
##
##########################################################################
## Created: 2011dec30
## Changed: 2012may14 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x


#######################################################
## Prompt for Vertical or Horizontal appending.
#######################################################

APPENDTYPE=""

APPENDTYPE=$(zenity --list --radiolist \
   --title "VERTical or HORIZontal append?" \
   --text "Choose one of the following types:" \
   --column "" --column "Type" \
   FALSE Vert TRUE Horiz)

if test "$APPENDTYPE" = ""
then
   exit
fi

APPENDPARM="+append"

if test "$APPENDTYPE" = "Vert"
then
   APPENDPARM="-append"
fi



##########################################################
## Get the 'mid-name' of the FIRST selected image file ---
## a 'jpg', or 'png', or 'gif', or whatever file.
##
##   (Assumes one dot in filename, at the extension.)
#########################################################

FILENAME1="$1"

## FILENAMECROP=`echo "$FILENAME1" | sed 's|\.gif$||'`
   FILENAMECROP=`echo "$FILENAME1" | cut -d\. -f1`

#####################################################
## Get the extension of the FIRST selected file ---
## a 'jpg', 'png', 'gif', or whatever file.
## (Assumes one dot in filename, at the extension.)
#####################################################

FILEEXT=`echo "$FILENAME1" | cut -d\. -f2`
 
##################################################################
## Make full filename for the output file --- using the
## name of the first selected file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

OUTFILE="${FILENAMECROP}_APPENDED_${APPENDTYPE}.$FILEEXT"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


######################################################
## Call 'convert' with all the filenames passed on the
## command line.
#####################################################

convert "$@" $APPENDPARM "$OUTFILE"


####################################################
## Show the appended output image file.
####################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &
