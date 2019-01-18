#!/bin/sh
##
## Nautilus
## SCRIPT: ani00_1aniGIF_INFO_gifscile-info.sh
##
## PURPOSE: Shows the info for a user-selected animated '.gif' file.
##
## METHOD:  Uses the 'gifsicle' program with '--info'.
##
##          Shows the resulting text file in a text-file viewer of
##          the user's choice.
##
## HOW TO USE: In a Nautilus list of directory files, select an
##             animated GIF file.
##             Then right-click and choose this script to run (name above).
##
## REFERENCE: http://www.lcdf.org/gifsicle/
##            Also 'man gifsicle'.
##
## Created: 2012feb29
## Changed: 2012


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
## (Assumes one dot in filename, at the extension.)
##          (Assumes no spaces in filename.)
#####################################################
FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
# if test "$FILEEXT" != "gif" -a "$FILEEXT" != "GIF"
# then
#    exit
# fi


##################################################################
## Make a filename for the text output.
##
##    If the user has write-permission on the
##    current directory, put the file in the pwd.
##    Otherwise, put the file in /tmp.
##
## On second thought, to avoid junking up the 
## current directory, ALWAYS put the file in /tmp.
##################################################################

CURDIR="`pwd`"

OUTFILE="${USER}_temp_gifsicle_GIFfile_INFO.txt"

# if test ! -w "$CURDIR"
# then
  OUTFILE="/tmp/$OUTFILE"
# fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


##################################################################
## Use 'gifsicle' to put the info in a text file.
##################################################################

gifsicle --version > "$OUTFILE"

echo "
" >> "$OUTFILE"

## FOR TESTING:  (remove the '>> "$OUTFILE"' part to avoid an error)
#  xterm -hold -fg white -bg black -e \

gifsicle --info "$FILENAME" >> "$OUTFILE"


####################################################
## Show the gif files split from the animated gif.
####################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER  "$OUTFILE" &
