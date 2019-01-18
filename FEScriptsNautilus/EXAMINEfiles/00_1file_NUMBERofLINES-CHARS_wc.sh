#!/bin/sh
##
## Nautilus
## SCRIPT: 00_1file_NUMBERofLINES-CHARS_wc.sh
##
## PURPOSE: Shows the number of lines & characters in a user-selected file.
##
## METHOD:  Uses 'wc' and shows the numbers in a 'zenity' window popup.
##
## HOW TO USE: In Nautilus, navigate to a file, select it,
##             right-click and choose this Nautilus script to run.
##
## Created: 2010may25
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
## Check that the selected file is a text file.
## COMMENTED, for now.
#######################################################

#  FILECHECK=`file "$FILENAME" | egrep 'text|Mail|ASCII'`
 
#  if test "$FILECHECK" = ""
#  then
#     exit
#  fi


#######################################################
## Get the number of lines and characters in the file.
#######################################################

NLINES=` wc -l "$FILENAME" | cut -d' ' -f1`
NCHARS=` wc -c "$FILENAME" | cut -d' ' -f1`


############################
## Show the number.
############################

CURDIRFOLDED=`echo "$CURDIR" | fold -55`

zenity --info --title "Number of LINES in a file." \
   --text "\
There are $NLINES lines and $NCHARS characters in file 

    $FILENAME

in directory

    $CURDIRFOLDED"
