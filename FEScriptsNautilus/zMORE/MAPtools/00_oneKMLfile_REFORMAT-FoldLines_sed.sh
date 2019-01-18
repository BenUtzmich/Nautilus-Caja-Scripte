#!/bin/sh
##
## Nautilus
## SCRIPT: 00_oneKMLfile_REFORMAT-FoldLines_sed.sh
##
## PURPOSE: For a user-selected KML (Keyhole Markup Language) file,
##          the file contents are reformatted via the 'sed' utility
##          to make sure that the lines are not extra-long.
##
##          Several types of character replacement are used:
##            - each occurrence of the '>' character is replaced
##              by that character followed by a line-feed
##            - then each occurrence of a space character is
##              replaced by a line-feed character
##            - each occurrence of a comma character is replaced
##              by a space character.
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
##          KML coordinate data is between <coordinates> and
##          </coordinates> markup indicators and can often 
##          go on for thousands of characters in a single line.
##          We especially want to 'fold' these extra-long lines
##          into lines with 2 or 3 numeric values.
##
## HOW TO USE: In Nautilus, select a KML (text) file in a directory.
##             (The selected file should NOT be a directory.)
##             Right click and, from the 'Scripts >' submenus,
##             choose to run this script (name above).
##
## Created: 2016nov06 Based on the 2010sep FE Nautilus script
##                    '06b_oneTextFile_CHG-STRING-WITHIN_2promptsFromTo_sed.sh'
## Changed: 2016nov09 Changed text in the 'zenity' popup.

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
   --title "KML file processor - REFORMAT - 'FOLD'" \
   --text "\
This utility expects the file you chose:
   $BASENAME
to be a KML (Keyhole Markup Language) file. This script
scans the file contents with the 'sed' utility and
reformats the data into a separate text file.

The coordinate data is between <coordinate> and
</coordinates> markup indicators.

The output file will include some miscellaneous 'markup' and
data lines. The main intent of this utility is to make a
file that is easily edited to contain only the coordinate
data --- along with a comment line or two at the top that
may incorporate some description data, like <name> data.

A major purpose of this utility is to 'fold' extra-long
lines of coordinate data into short lines containing
only 2 (or 3) coordinate numbers.

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
## Exit if the file extension is not 'kml'.
## COMMENTED, for now.
####################################################

# if test "$FILEEXT" != "kml"
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
##  1) each occurrence of the '>' character is replaced
##     by that character followed by a line-feed
##  2) remove leading spaces from each line
##  3) replace each '</' occurrence with those 2 chars
##     preceded by a line-feed
##  4) then each occurrence of one or more space characters
##     is replaced by one space character
##  5) each occurrence of a comma character is replaced
##     by a space character.
#######################################################

## FOR TESTING:
#   set -x

sed -e "s|>|>\n|g" "$FILENAME" | \
   sed -e "s|^ *||g" | \
   sed -e "s|</|\n</|g" | \
   sed -e "s|  *| |g" | \
   sed -e "s|  |\n|g" | \
   sed -e "s|,| |g" > "$OUTNAME"


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
