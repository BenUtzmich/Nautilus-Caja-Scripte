#!/bin/sh
##
## Nautilus
## SCRIPT: 00_oneGeoJSONfile_REFORMAT-FoldLines_sed.sh
##
## PURPOSE: For a user-selected GeoJSON (Geographic Javascript Object Notation)
##          file, the file contents are reformatted via the 'sed' utility
##          to make sure that the lines are not extra-long.
##
##          Several types of character replacement are used. Examples:
##            - each occurrence of the '],' (a right-bracket and a comma
##              character) is replaced by a line-feed
##            - then each occurrence of a left-bracket character is
##              replaced by a null character (nothing).
##
##          The output of a pipeline of 'sed' commands is directed
##          into a separate text file --- say, in the same directory
##          as the input file.
##
##         (An alternative is to put the output file into the /tmp
##          directory. This might be advisable if the output files
##          are typically huge.)
##
##          NOTE:
##          GeoJSON coordinate data is often in long-lines that look like
##
##    ...... "coordinates": [ [ -97.145567, 25.971132 ], [ -97.172633, 25.962883 ], [ -97.228025, 25.958936 ], ...
##
##          into lines with no more than 2 (or 3) numeric values.
##
## HOW TO USE: In Nautilus, select a GeoJSON (text) file in a directory.
##             (The selected file should NOT be a directory.)
##             Right click and, from the 'Scripts >' submenus,
##             choose to run this script (name above).
##
## Created: 2016nov06 Based on the 2010sep FE Nautilus script
##                    '00_oneKMLfile_REFORMAT_sed.sh'
## Changed: 2016nov07 Added 'zenity' popup.
## Changed: 2016nov09 Added to and changed the 'sed' pipeline.

## FOR TESTING: (show statements as they execute)
# set -x

############################
## Set the filename var.
############################

FILENAME="$1"


BASENAME=`basename $FILENAME`

SCRIPTDIRNAME=`dirname $0`
SCRIPTBASENAME=`basename $0`

############################################
## Show an informative message with 'zenity'. 
############################################

   zenity --info \
   --title "GeoJSON file processor - REFORMAT - 'FOLD'" \
   --text "\
This utility expects the file you chose:
   $BASENAME
to be a GeoJSON (JSON = Javascript Object Notification) file.
This script scans the file contents with the 'sed' utility
and reformats the data into a separate text file.

The coordinate data is typically in extremly long lines
with brackets and commas separating pairs of coordinate numbers.

The output file will include some miscellaneous 'markup' and
data lines --- reformatted; brackets, braces, commas removed.
The main intent of this utility is to make a file that is
easily edited to contain only the coordinate data in 2 or 3
columns --- along with a comment line or two at the top that
may incorporate description of the data.

Hence, a major purpose of this utility is to 'fold' extra-long
lines of coordinate data into short lines containing only
2 (or 3) coordinate numbers.

The selected file is processed via 'sed' and the 'sed' output
is put in a file with a string like '_REFORMATTED'
appended to the midname of the selected file.

The output file is put in the same directory with the
original selected file.

This script is:
   $SCRIPTBASENAME
in directory
   $SCRIPTDIRNAME" &


###############################################
## Exit if the selected file is a directory.
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
## Exit if the file extension is not 'json'.
## COMMENTED, for now.
####################################################

# if test "$FILEEXT" != "json"
# then
#    exit
# fi

####################################################
## Get the 'midname' of the file, the part before
## the period and the extension.
####################################################

MIDNAME=`echo "$FILENAME" | cut -d\. -f1`


###################################
## Make the output filename.
###################################

OUTNAME="${MIDNAME}_REFORMATTED.$FILEEXT"

rm -f "$OUTNAME"

#######################################################
## Use 'sed' to make the new output file.
#######################################################
## Could try running the command in a window,
## to see err msgs, if any.
## Could use zenity to offer this as an option.
##
## xterm -fg white -bg black -hold -e \
#######################################################
## Each of the 'sed' statements in the pipe below do:
##  1) replace each occurrence of '[' (left-bracket)
##     by a null character (nothing)
##  2) replace each occurrence of '],' (right-bracket and comma)
##     by a null character (nothing)
##  3) replace each occurrence of '},' (right-brace and comma)
##     by a null character (nothing)
##  4) replace each occurrence of '":' (double-quote and colon)
##     by those 2 chars followed by a line-feed
##  5) replace each occurrence of '{' (left-brace)
##     by a null character (nothing)
#######################################################

## FOR TESTING:
#   set -x

sed -e 's|\[||g' "$FILENAME" | \
   sed -e 's|\],|\n|g' | \
   sed -e 's|{||g' | \
   sed -e 's|\},|\n|g' | \
   sed -e 's|\":|\n|g' > "$OUTNAME"

## FOR TESTING:
#   set -


###################################
## Show the output file.
###################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

# $TXTVIEWER "$OUTNAME" &

$TXTEDITOR "$OUTNAME" &
