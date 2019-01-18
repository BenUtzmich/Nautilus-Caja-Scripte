#!/bin/sh
##
## Nautilus
## SCRIPT: 09_anyfile_show_OPEN-FILES4processes_lsof.sh
##
## PURPOSE: Lists ALL open files in Linux on 'this' host.
##
## METHOD:  Puts the output of the 'lsof' command in a text file.
##
##          Shows the text file in a text-file viewer of the user's
##          choice.
##
## HOW TO USE: In Nautilus, right-click on ANY file in ANY directory.
##             Then select this Nautilus script to run (name above).
##
## Started: 2010apr30
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012feb29 Changed the script name in the comment above.

## FOR TESTING: (show statements as they execute)
# set -x

##############################################
## Prepare the output file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##############################################
## CHANGED. Since the list of processes and their
## open files does not really relate to the
## current directory or any of the files in it,
## rather than junking-up the current directory,
## we put the list in /tmp.
##############################################

CURDIR="`pwd`"

OUTFILE="${USER}_temp_openFilesLIST.txt"

## if test ! -w "$CURDIR"
## then
OUTFILE="/tmp/$OUTFILE"
## fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


##############################################
## Generate the list.
##############################################

lsof > "$OUTFILE"


###################
## Show the list.
###################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER  "$OUTFILE"
