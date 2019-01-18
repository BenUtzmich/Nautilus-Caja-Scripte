#!/bin/sh
##
## Nautilus
## SCRIPT: 05_oneTEXTfile_REMOVE-NULL-LINES_grep_2newFile.sh
##
## PURPOSE: For a user-selected text file,
##          the file contents are scanned via the 'sed' utility and
##          any null lines are removed.
##
## METHOD:  In the 'sed' command, to accomplish the removals.
##
##          The 'sed' output is put in a file with a string like
##          '_REMOVED-NULL-LINES' appended to the midname of
##          the selected file.
##
##          The output file is put in the same directory with the
##          original selected file.
##
## HOW TO USE: In Nautilus, select a text file in a directory.
##             (The selected file should NOT be a directory.)
##             Right click and, from the 'Scripts >' submenus,
##             choose to run this script (name above).
##
## Created: 2016nov09 Based on the a similar FE Nautilus script
##                    '00_oneKMLfile_REFORMAT_sed.sh'
## Changed: 2016

## FOR TESTING: (show statements as they execute)
# set -x

############################
## Set the filename var.
############################

FILENAME="$1"

BASENAME=`basename $FILENAME`

############################################
## Show an informative message with 'zenity'. 
############################################

   zenity --info \
   --title "Text file processor - REMOVE NULL LINES" \
   --text "\
This utility expects the file you chose
   $BASENAME
to be a text file, and this script scans the file contents
with the 'sed' utility.

The selected file is processed via 'sed' and the 'sed' output
is put in a file with a string like '__REMOVED-NULL-LINES'
appended to the midname of the selected file.

The output file is put in the same directory with the
original selected file.

This script:
   $0" &


###############################################
## Skip the selected file if it is a directory.
###############################################

if test -d "$FILENAME"
then
   exit
fi


####################################################
## Get the file extension and check that it is not
## blank. Skip the filename if it has no extension.
##  (Assumes one '.' in filename, at the extension.)
####################################################

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

if test "$FILEEXT" = "" 
then 
   exit
fi

####################################################
## Get the 'midname' of the file, the part before
## the period and the extension.
####################################################

MIDNAME=`echo "$FILENAME" | cut -d\. -f1`


###################################
## Make the output filename.
###################################

OUTNAME="${MIDNAME}_REMOVED-NULL-LINES.$FILEEXT"

rm -f "$OUTNAME"

#########################################
## Use 'sed' to make the new output file.
#######################################################
## Could try running the command in a window,
## to see err msgs, if any.
## Could use zenity to offer this as an option.
##
## xterm -fg white -bg black -hold -e \
#######################################################

## FOR TESTING:
#    set -x

# egrep -v '^$' "$FILENAME" > "$OUTNAME"

grep -v '^\s*$' "$FILENAME" > "$OUTNAME"

## Reference for trying to remove null lines with sed (and grep):
## http://stackoverflow.com/questions/16414410/delete-empty-lines-using-sed


## FOR TESTING:
#    set -

###################################
## Show the output file.
###################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

# $TXTVIEWER "$OUTNAME" &

$TXTEDITOR "$OUTNAME" &
