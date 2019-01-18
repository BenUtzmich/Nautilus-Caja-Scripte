#!/bin/sh
##
## Nautilus
## SCRIPT: 00_anyfile_LIST_OPEN-FILES_all-processes_lsof.sh
##
## PURPOSE: Lists ALL open files in Linux on 'this' host.
##
## METHOD:  Uses the 'lsof' command.
##
##          Shows the list in a text viewer/editor of the user's choice.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory. Then
##             right-click and choose this Nautilus script to run
##             (name of script is above).
##
#############################################################################
## Script:
## Started: 2010apr30
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012apr18 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
############################################################################

## FOR TESTING: (show statements as they execute)
# set -x

##############################################
## Prepare the output file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##############################################

CURDIR="`pwd`"

OUTFILE="${USER}_temp_openFilesLIST.txt"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


#################################################################
## Generate the list.
#################################################################

lsof > "$OUTFILE"


###################
## Show the list.
###################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER  "$OUTFILE"
