#!/bin/sh
##
## Nautilus
## SCRIPT: tile04_1imgfile_SELF-APPEND-MrowsxNcols_convert-append-2loops.sh
##
## PURPOSE: For a selected (tile) image file ('.jpg' or '.png' or '.gif' or
##          whatever), this script makes a larger (tile) image file by
##          appending to itself M times vertically (rows) --- then appending
##          that M-rows-of-images file to itself N times horizontally (columns).
##
## METHOD:  Uses 'zenity --entry' to prompt for the number of rows and
##          columns to be made with the selected image file.
##
##          Uses the 'convert' command with the '-append' and '+append' options.
##
##          Shows the new MxN (tiled) image file in an image viewer (or
##          editor) of the user's choice.
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##
##############################################################################
## Created: 2010feb02
## Changed: 2012may14 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################


## FOR TESTING: (show statements as they execute)
# set -x

#########################################
## Get the filename of the selected file.
#########################################

  FILENAME="$1"
# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
# FILENAMES="$@"


###################################################################
## Get the extension of the input file.
##  (Assumes only one period in the filename, at the extension.)
###################################################################

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`


###################################################################
## Check that the selected file is a 'jpg' or 'png' or 'gif' file.
## COMMENTED, for now.
###################################################################
 
#  if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
#  then
#     exit
#  fi


#######################################################################
## Get the midname' of the input file, for naming output file(s).
#######################################################################

# FILEMIDNAME=`echo "$FILENAME" | sed 's|\..*$||'`
FILEMIDNAME=`echo "$FILENAME" | cut -d\. -f1`

#######################################################################
## Prompt the user for MxN, the number of rows and columns to create.
#######################################################################

MbyN=""

MbyN=$(zenity --entry \
   --title "Enter MxN --- ROWSxCOLUMNS." \
   --text "\
Enter the number of ROWS and COLUMNS to make from the selected (tile)
image file.

Examples:  2x3    OR    10x30" \
   --entry-text "4x6")

if test "$MbyN" = ""
then
   exit
fi

MROWS=`echo "$MbyN" | cut -dx -f1` 
NCOLS=`echo "$MbyN" | cut -dx -f2`


#######################################################################
## Make names for 2 temporary files (in /tmp) --- an IN file and
## an OUT file.
## Also make a name for the M-rows image file --- the output from
## the first loop that appends $FILENAME to itself M-rows times.
#######################################################################

TEMPFILEIN="/tmp/${FILEMIDNAME}_IN.$FILEEXT"
TEMPFILEOUT="/tmp/${FILEMIDNAME}_OUT.$FILEEXT"
TEMP_MROWS_FILE="/tmp/${FILEMIDNAME}_${MROWS}ROWS.$FILEEXT"
 

##################################################################
## Make full filename for the output file --- using the
## name of the selected file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

OUTFILE="${FILEMIDNAME}_SELF-APPENDED_${MbyN}times.$FILEEXT"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


#######################################################################
## Start the loop to make the M-rows image file from $FILENAME
## --- by appending $FILENAME to itself M times, vertically, with '-append'.
#######################################################################

cp "$FILENAME" "$TEMPFILEIN"

IDX=1

while test $IDX -lt $MROWS
do
   convert "$TEMPFILEIN" "$FILENAME" -append "$TEMPFILEOUT"
   rm "$TEMPFILEIN"
   mv  "$TEMPFILEOUT" "$TEMPFILEIN"
   IDX=`expr $IDX + 1`
done


##########################################################################
## Start the loop to make the N-cols image file from the M-rows image file
## --- by appending the M-rows-imgfile to itself N times, horizontally,
## with '+append'.
##########################################################################

cp "$TEMPFILEIN" "$TEMP_MROWS_FILE"

IDX=1

while test $IDX -lt $NCOLS
do
   convert "$TEMPFILEIN" "$TEMP_MROWS_FILE" +append "$TEMPFILEOUT"
   rm "$TEMPFILEIN"
   mv  "$TEMPFILEOUT" "$TEMPFILEIN"
   IDX=`expr $IDX + 1`
done


##########################################################################
## Put the Mrows-by-Ncols image file into $OUTFILE.
##########################################################################

cp "$TEMPFILEIN" "$OUTFILE"


#####################################################
## Show the new self-appended (MxN times) image file.
#####################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &

# $IMGEDITOR "$OUTFILE" &
