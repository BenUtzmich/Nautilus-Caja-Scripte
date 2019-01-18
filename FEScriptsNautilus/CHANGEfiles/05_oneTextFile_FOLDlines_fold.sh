#!/bin/sh
##
## Nautilus
## SCRIPT: 08_oneTextFile_FOLDlines_fold.sh
##
## PURPOSE: For a user-selected (text) file, the 'fold' command is
##          used to fold (or wrap) the lines of the file at a
##          user-specified column number.
##
## METHOD:  Uses 'zenity' to prompt for the column-number at which to
##          fold/wrap the lines of the file.
##
##          The 'fold' command is applied to the selected file
##          and the output is put in a file with the string
##          '_FOLDED$COLNUM' inserted into the filename.
##
##          The output file may be put in the /tmp directory,
##          just in case the file is huge.
##
##          The $TEXTVIEWER is used to show the new output file.
##
##          The user can check the output file to see if the result
##          is what was wanted. If the file is a 'keeper', the
##          user can move it and, optionally, rename it.
##
## HOW TO USE: In Nautilus, select one (text) file in a directory.
##             (The selected file should NOT be a directory.)
##             Right click and, from the 'Scripts >' submenus,
##             choose to run this script (name above).
##
## Created: 2014jun14
## Changed: 2014

## FOR TESTING: (show statements as they execute)
# set -x

##########################################
## Get the filename of the selected file.
##########################################

  FILENAME="$1"
# FILENAMES="$@"
# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"


#############################################
## Set the name of the output file directory.
#############################################

OUTDIR="/tmp"

############################################
## Prompt for the 'column-number'. 
############################################

COLNUM=""

COLNUM=$(zenity --entry \
   --title "Enter the COLUMN-NUMBER at which to 'fold'." \
   --text "\
Enter a COLUMN-NUMBER at which to fold/wrap the lines of
the selected file
$FILENAME

The new output file will be put in the directory
$OUTDIR
with a similar filename.

To exit, click 'Cancel' or enter nothing (null).
" \
   --entry-text "80")

if test "$COLNUM" = ""
then
   exit
fi


##################################################################
## Get the extension and middle name of the selected file.
##
##  (Assumes just one dot [.] in the filename, at the extension.)
##################################################################

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`


##########################################
## Prepare the output filename ---
## in directory '/tmp'.
##########################################

FILEOUT="$OUTDIR/${FILENAMECROP}_FOLDEDat${COLNUM}.$FILEEXT"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


#################################################
## Apply the 'fold' command to the selected file.
#################################################

fold -w$COLNUM "$FILENAME" > "$FILEOUT"


###################################
## Show the output file.
###################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$FILEOUT" &