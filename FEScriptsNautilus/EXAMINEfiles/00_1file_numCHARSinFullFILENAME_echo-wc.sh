#!/bin/sh
##
## Nautilus
## SCRIPT: 00_1file_numCHARSinFullFILENAME_echo-wc.sh
##
## PURPOSE: Shows the length of the filename of the user-selected file.
##          The file can be a directory.
##
## METHOD:  Uses 'echo' to pipe the filename into 'wc -c'.
##
##          Shows the length in a 'zenity' window popup.
##
## HOW TO USE: In Nautilus, navigate to a file, select it,
##             right-click and choose this Nautilus script to run.
##
## Created: 2010may25
## Changed: 2012feb29 Changed the script name in the comment above.

## FOR TESTING:  (show statements as they execute)
# set -x

#######################################
## Get the filename.
#######################################

#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

# FILENAME="$@"
  FILENAME="$1"

#  CURDIR="$NAUTILUS_SCRIPT_CURRENT_URI"
   CURDIR="`pwd`"


#######################################################
## Get the length of the filename and its directory.
#######################################################

FILENAMELEN=`echo "$FILENAME" | wc -c | cut -d' ' -f1`
FILENAMELEN=`expr $FILENAMELEN - 1`

CURDIRNAMELEN=`echo "$CURDIR" | wc -c | cut -d' ' -f1`
CURDIRNAMELEN=`expr $CURDIRNAMELEN - 1`

TOTALCHARS=`expr $FILENAMELEN + $CURDIRNAMELEN`


############################
## Show the length.
############################

CURDIRFOLDED=`echo "$CURDIR" | fold -55`

zenity --info --title "Length of a filename." \
   --text "\
The length of filename 

    $FILENAME

is  $FILENAMELEN characters.

The length of the name of its directory

    $CURDIRFOLDED

is  $CURDIRNAMELEN characters.

TOTAL characters = $TOTALCHARS"
