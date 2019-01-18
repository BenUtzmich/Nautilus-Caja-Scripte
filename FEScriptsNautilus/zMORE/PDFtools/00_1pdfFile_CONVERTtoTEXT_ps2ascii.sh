#!/bin/sh
##
## Nautilus
## SCRIPT: 00_1pdfFile_CONVERTtoTEXT_pdf2ascii.sh
##
## PURPOSE: Runs the 'ps2ascii' command against a user-selected PDF file
##          extract the text from the PDF file.
##
## METHOD:  The user is put in view mode on the output text file, using
##          an text-viewer of the user's choice.
##
## HOW TO USE: In Nautilus, navigate to a PDF file, select it,
##             right-click and choose this Nautilus script to run.
##
##############################################################################
## Created: 2010may12
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#############################################################################

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


#######################################
## Initialize the output file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
#######################################

OUTFILE="${USER}_temp_pdf2ascii.txt"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


###########################################
## Generate the text file from the PDF file.
###########################################

EXECHECK=`which ps2ascii`

if test -f "$EXECHECK"
then
   ps2ascii "$FILENAME" > "$OUTFILE"
else
   zenity --info \
   --title "'pdf2ascii' not found. EXITING." \
   --text "\
It appears that the executable
'pdf2ascii' is not installed.

Exiting."
   exit
fi


############################
## Show the text file output.
############################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER  "$OUTFILE"
