#!/bin/sh
##
## Nautilus
## SCRIPT: ani06_1ani-gif_CHG-LOOPS-NUM_convert-loop.sh
##
## PURPOSE: Resets the number of loops in an animated '.gif' file.
##
## METHOD:  Uses ImageMagick 'convert' with the '-loop' option.
##
##          Uses 'zenity --entry' to prompts the user for a loop integer
##          (0 means keep looping).
##
##          Shows the new animated '.gif' file in an animated gif file
##          viewer of the user's choice.
##
## Reference: http://www.fmwconcepts.com/imagemagick/transitions/index.php
##            See sample code at the bottom of that web page.
##
## HOW TO USE: In Nautilus, select one animated '.gif' file.
##             Then right-click and choose this script to run (name above).
##
###########################################################################
## Created: 2012feb11
## Changed: 2012may12 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################


## FOR TESTING: (show statements as they execute)
# set -x

################################################
## Get the filename of the animated '.gif' file.
################################################

  FILENAME="$1"
# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
# FILENAMES="$@"


#########################################################
## Check that the selected file is a 'gif' file.
##   Assumes one dot (.) in the filename, at the extension.
#########################################################

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
if test "$FILEEXT" != "gif"
then
   exit
fi


###########################################################################
## Use 'zenity' to ask the user for the (new) number of loops.
###########################################################################

LOOPS=""

LOOPS=$(zenity --entry \
--title "NUMBER OF LOOPS?" \
--text "\
Enter the (new) NUMBER OF LOOPS for the selected animated '.gif' file:

$FILENAME

(0 means to loop indefinitely.)" \
   --entry-text "0")

if test "$LOOPS" = ""
then
   exit
fi



##################################################################
## Make full filename for the output ani-gif file --- using the
## 'midname' of the selected image file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

FILEMIDNAME=`echo "$FILENAME" | cut -d\. -f1`

OUTFILE="${FILEMIDNAME}_resetLOOPSto${LOOPS}_ani.gif"

CURDIR="`pwd`"

if test ! -w "$CURDIR"
then
   OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


###########################################################################
## Use 'convert' with the '-loop' parameter to reset the number of loops
## of the selected animated gif file.
###########################################################################

convert "$FILENAME" -loop $LOOPS  "$OUTFILE"


############################################
## Show the new animated gif file.
############################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$ANIGIFVIEWER "$OUTFILE" &
