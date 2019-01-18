#!/bin/sh
##
## Nautilus
## SCRIPT: 00_1pdfFile_SHOW_via_gs.sh
##
## PURPOSE: Runs the 'gs' (Ghostscript) command in an 'xterm'
##          to show a user-selected PDF file.
##
## METHOD:  The 'xterm' allows the user to page through the PDF
##          using 'gs' commands (or simply hitting Return) in the X-terminal.
##
## HOW TO USE: In Nautilus, navigate to a PDF file, select it,
##             right-click and choose this Nautilus script to run.
##
## WARNING: The output of 'gs' in the X-terminal gets pretty messy.
##
############################################################################
## Created: 2010may12
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################

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
## Check that the selected file is a PDF file.
#######################################################

FILECHECK=`file "$FILENAME" | grep 'PDF'`
 
if test "$FILECHECK" = ""
then
   exit
fi


########################################################
## Show the PDF file via 'gs' running in an X terminal.
########################################################

xterm -fg white -bg black -hold -e gs "$FILENAME"

#  gnome-terminal -e gs "$FILENAME"
