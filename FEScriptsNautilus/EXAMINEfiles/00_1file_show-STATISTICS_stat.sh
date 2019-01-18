#!/bin/sh
##
## Nautilus
## SCRIPT: 00_1file_show_STATISTICS_stat.sh
##
## PURPOSE: Shows the properties of a user-selected file.
##
## METHOD:  Runs the 'stat' command on a user-selected file.
##
##          Shows the 'stat' output in a 'zenity' window popup.
##
## HOW TO USE: In Nautilus, navigate to a file, select it,
##             right-click and choose this Nautilus script to run.
##
## Created: 2011may23
## Changed: 2012feb29 Changed the script name in the comment above.

## FOR TESTING: (show statements as they execute)
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
## Get the 'stat' output for the file.
#######################################################

STATOUT=`stat "$FILENAME"`


############################
## Show the output.
############################

CURDIRFOLDED=`echo "$CURDIR" | fold -55`

zenity --info --title "'stat' (statistics) output for a file." \
   --text "\
For file 

    $FILENAME

in directory

    $CURDIRFOLDED

'stat' shows
_________________________________________________________________

$STATOUT
"
