#!/bin/sh
##
## Nautilus
## SCRIPT: F1a_anyfile4Dir_LIST_FILESdirs-all_1LEV_WITHoUTtypeIDs_ls-Ap.sh
##
## PURPOSE: Lists ALL files in a directory --- including directories,
##          indicated by an ending slash (/) --- at ONE-level under
##          the current directory, using 'ls'.
##
## METHOD:  Puts the output of the 'ls' command in a text file.
##
##          Shows the text file in a text-file viewer of the user's
##          choice.
##
## HOW TO USE: In Nautilus, select any file in the desired directory.
##             Then right-click and choose this Nautilus script to run.
##
## Started: 2010mar23 Based on 00_list_allDirFILES_1lev_ls-aF.sh
## Changed: 2011jun13 Changed '-a' to '-A'. Renamed script.
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

CURDIR="`pwd`"

OUTFILE="${USER}_temp_dirFILESlist_1lev_ls-Ap.txt"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


#####################################
## Generate a heading for the listing.
#####################################

DATETIME=`date '+%Y %b %d  %a  %T%p'`

echo "\
..................... $DATETIME ............................

List of files (and directories) under the directory
  $CURDIR
--- ONE-LEVEL only.

...........................................................................
" >  "$OUTFILE"


#################################################################
## Add the 'ls' output to the listing.
##
##  The '-p' parm shows directories with an ending slash.
#################################################################

ls -A -p  >> "$OUTFILE"


#####################################
## Add a trailer to the listing.
#####################################

SCRIPT_BASENAME=`basename $0`
SCRIPT_DIRNAME=`dirname $0`

echo "
.......................................................................

This list was generated by script
   $SCRIPT_BASENAME
in directory
   $SCRIPT_DIRNAME

Used command
     ls -A -p 

The '-p' requests that directories be listed with an ending slash (/).

..................... $DATETIME ............................
" >>  "$OUTFILE"


###################
## Show the list.
###################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
