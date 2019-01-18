#!/bin/sh
##
## Nautilus
## SCRIPT: ani00_1aniGIF_EXTRACTframeN_gifsicle.sh
##
## PURPOSE: Extract a user-specified frame from a user-selected
##          animated '.gif' file.
##
## METHOD:  Uses the 'gifsicle' program with '#' to indicate the frame number.
##
##          Uses 'zenity' to prompt for a frame number.
##
##          Shows the resulting UNanimated GIF file in an image viewer
##          of the user's choice.
##
## HOW TO USE: In a Nautilus list of directory files, select an
##             animated GIF file.
##             Then right-click and choose this script to run (name above).
##
## REFERENCE: http://www.lcdf.org/gifsicle/
##            Also 'man gifsicle'.
##
## Created: 2012feb29
## Changed: 2012may12 Changed script name in comments above.
###########################################################################


## FOR TESTING: (show statements as they execute)
# set -x

#########################################
## Get the filename of the selected file.
#########################################

# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
# FILENAMES="$@"
  FILENAME="$1"


#####################################################
## Check that the selected file is a 'gif' file.
##    (Assumes one dot in filename, at the extension.)
#####################################################
FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
# if test "$FILEEXT" != "gif" -a "$FILEEXT" != "GIF"
# then
#    exit
# fi


#######################################################################
## Get a 'stub' to use to name the output file.
#######################################################################

# FILENAMECROP=`echo "$FILENAMECROP" | sed 's|\..*$||'`

FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`


#######################################################
## Prompt for the frame number to be extracted.
#######################################################

FRAMENUM=""

FRAMENUM=$(zenity --entry \
   --title "FRAME NUMBER to extract?" \
   --text "\
Enter the FRAME NUMBER to extract from the file
$FILENAME
into a single-frame GIF file.

The frame numbers start with 0. You can use an INFO query
to see the number of frames in the animated GIF file.

The new GIF file will have the string '_FRAME_' in the filename.

The new file will be in this directory --- OR, if you do not have
write permission to this directory, the output will be in /tmp." \
   --entry-text "0")

 if test "$FRAMENUM" = ""
 then
    exit
 fi

##################################################################
## Make a filename for the optimized-file output --- using the
## name of a selected image file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

OUTFILE="${FILENAMECROP}_FRAME_${FRAMENUM}.gif"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


##################################################################
## Use 'gifsicle' to put the specified frame in a '.gif' file.
##################################################################

gifsicle "$FILENAME" \#$FRAMENUM > "$OUTFILE"


####################################################
## Show the gif files split from the animated gif.
####################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER  "$OUTFILE" &
