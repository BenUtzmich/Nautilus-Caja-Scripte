#!/bin/sh
##
## Nautilus
## SCRIPT: 01_oneKMLfile_EXTRACT-COORDS_sed.sh
##
## PURPOSE: For a user-selected KML (Keyhole Markup Language) file,
##          the file contents are scanned via the 'sed' utility and
##          the coordinate data is extracted into a separate text file.
##
##          The coordinate data is between <coordinates> and
##          </coordinates> markup indicators.
##
##          The output file may include a few miscellaneous 
##          markup and data lines --- but the intent of this
##          utility is to make a file that is easily edited to contain
##          only the coordinate, along with a comment line at the
##          top that may incorporate some <name> data.
##
##          A major purpose of this utility is to 'fold' extra-long
##          lines of coordinate data into short lines containing
##          only 2 (or 3) coordinate numbers.
##
## METHOD:  In the 'sed' command, to accomplish the folding,
##          several types of character replacement are used:
##            - each occurrence of the '>' character is replaced
##              by that character followed by a line-feed
##            - then each occurrence of a space character is
##              replaced by a line-feed character
##           Also
##            - each occurrence of a comma character is replaced
##              by a space character.
##
##   In addition to the above formatting, several markup-tags
##   are replaced by a null character (nothing), including:
##
##    </coordinates>
##    </LinearRing>
##    </outerBoundaryIs>
##    </Polygon>
##    <Polygon>
##    <outerBoundaryIs>
##    <LinearRing>
##    <coordinates>
##
##  The selected file is processed via 'sed' and the 'sed' output
##  is put in a file with a string like '_COORDS'
##  appended to the midname of the selected file.
##
##  The output file is put in the same directory with the
##  original selected file.
##
## HOW TO USE: In Nautilus, select a KML (text) file in a directory.
##             (The selected file should NOT be a directory.)
##             Right click and, from the 'Scripts >' submenus,
##             choose to run this script (name above).
##
## Created: 2016nov08 Based on the a similar FE Nautilus script
##                    '00_oneKMLfile_REFORMAT_sed.sh'
##                    which does the folding-into-short-lines
##                    mentioned above.
## Changed: 2016nov09 Add 'grep -v' to the pipeline of 'sed' commands.

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
   --title "KML file processor - (reformat and) EXTRACT COORDINATE DATA" \
   --text "\
This utility expects the file you chose
   $BASENAME
to be a KML (Keyhole Markup Language) file, and this script
scans the file contents with the 'sed' utility and the
coordinate data is extracted into a separate text file.

The coordinate data is between #coordinate# and
#/coordinates# markup indicators.

The output file may include some miscellaneous 'markup'
and data lines --- but the intent of this utility is
to make a file that is easily edited to contain
only the coordinate data, along with a comment line at the
top that may incorporate some #name# data.

A major purpose of this utility is to 'fold' extra-long
lines of coordinate data into short lines containing
only 2 (or 3) coordinate numbers.

The selected file is processed via 'sed' and the 'sed' output
is put in a file with a string like '__COORDS'
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

OUTNAME="${MIDNAME}_EXTRACTED-COORD-DATA.$FILEEXT"

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
## The 1st of the 'sed' statements in the pipe below do:
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
#    set -x

sed -e "s|>|>\n|g" "$FILENAME" | \
   sed -e "s|^ *||g" | \
   sed -e "s|</|\n</|g" | \
   sed -e "s|  *| |g" | \
   sed -e "s| |\n|g" | \
   sed -e "s|,| |g" | \
   sed -e "s|</coordinates>|#|g" | \
   sed -e "s|</LinearRing>||g" | \
   sed -e "s|</outerBoundaryIs>||g" | \
   sed -e "s|</Polygon>||g" | \
   sed -e "s|<Polygon>||g" | \
   sed -e "s|<outerBoundaryIs>||g" | \
   sed -e "s|<LinearRing>||g" | \
   sed -e "s|<coordinates>||g" | \
   sed -e "s|</MultiGeometry>||g" | \
   sed -e "s|</Placemark>||g" | \
   sed -e "s|</Document>||g" | \
   sed -e "s|<Document>||g" | \
   sed -e "s|<description>||g" | \
   sed -e "s|</description>||g" | \
   sed -e "s|<LineStyle>||g" | \
   sed -e "s|<PolyStyle>||g" | \
   sed -e "s|</PolyStyle>||g" | \
   sed -e "s|</LineStyle>||g" | \
   sed -e "s|</LineString>||g" | \
   sed -e "s|<LineString>||g" | \
   sed -e "s|<Placemark>||g" | \
   sed -e "s|<MultiGeometry>||g" | grep -v '^\s*$' > "$OUTNAME"

## The '^\s*$' pattern in the 'grep -v' command is intended to remove
## null lines and lines containing only 'white-space' characters ---
## spaces and tabs.

## Reference for trying to remove null lines with sed (and grep):
## http://stackoverflow.com/questions/16414410/delete-empty-lines-using-sed

## Reference for trying to replace a string by a backspace with sed:
## http://unix.stackexchange.com/questions/183330/sed-to-replace-with-backspace

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
