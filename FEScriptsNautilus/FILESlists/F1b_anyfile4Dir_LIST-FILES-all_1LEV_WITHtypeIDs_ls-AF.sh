#!/bin/sh
##
## Nautilus
## SCRIPT: F1b_anyfile4Dir_LIST_FILESdirs-all_1LEV_WITHtypeIDs_ls-AF.sh
##
## PURPOSE: Lists ALL files in a directory --- including directories first,
##          indicated with an ending slash (/). Also indicates files with
##          execute permissions with an ending asterisk (*). And indicates
##          files that are soft-links with an ending 'at sign' ( @ ).
##
## METHOD:  Puts the output of 'ls' in a text file.
##
##          Shows the text file using a text-file viewer of the user's
##          choice.
##
## HOW TO USE: In Nautilus, select any file in the 'navigated-to' directory.
##             Then right-click and choose this Nautilus script to run.
##
## Started: 2010mar09
## Changed: 2010apr04 Used 'ls -a -F' to separate directories
##                    from files --- and show hidden files.
## Changed: 2010apr11 Touched up the comments. Added logic to
##                    determine the directory for the OUTFILE.
## Changed: 2010sep17 Added header and trailer to listing. 
## Changed: 2011apr23 Changed format of the listing a little bit.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2011may23 Added comments on '*' and '@' indicators to the
##                    trailer section of the list.
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

OUTFILE="${USER}_temp_dirFILESlist_1lev_ls-AF.txt"

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

List of files (and directories) under/in the directory

  ${CURDIR}/

--- ONE-LEVEL only.

...........................................................................
" >  "$OUTFILE"


#################################################################
## Add the 'ls' output to the listing.
##
##  The '-F' parm shows directories with an ending slash
##  and it shows execute-permission files with an ending asterisk
##  and it shows soft-link files with an ending '@' sign.
#################################################################

## Show the directories, then the non-directories.
ls -A -F | grep '/$' >> "$OUTFILE"
echo ""  >> "$OUTFILE"
ls -A -F | grep -v '/$' >> "$OUTFILE"


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

Used commands
     ls -A -F | grep '/$' (to show directories first)
and
     ls -A -F | grep -v '/$' (to show non-directories)

The '-F' asks for file-type indicators after the filenames.
Examples:
 - Asterisk (*) indicates files with execute permission.
 - At sign  (@) indicates files that are 'soft-links'.

..................... $DATETIME ............................
" >>  "$OUTFILE"


###################
## Show the list.
###################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
