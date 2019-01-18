#!/bin/sh
##
## Nautilus
## SCRIPT: exe00_1EXEfile_shoSTRINGS_exeInThisDir_strings.sh
##
## PURPOSE: Shows the human-readable strings in an executable file,
##          using the 'strings' command.
##
## METHOD:  Puts the output of the strings command in a text file.
##
##          Shows the text file in a text-file viewer of the
##          user's choice.
##
## HOW TO USE: In Nautilus, navigate to an executable file, select it,
##             right-click and choose this Nautilus script to run.
##
## NOTE: Made another version of this script, to do a
##       'zenity' prompt for an executable name and, if the
##       file name is not fully qualified,
##       use the 'which' or 'whereis' command to get the
##       fully-qualified name of the executable file. Then
##       apply 'strings' to that full filename.
##
## Created: 2010apr11
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
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
## Check that the selected file is an executable file.
#######################################################

FILECHECK=`file "$FILENAME" | grep 'executable'`
 
if test "$FILECHECK" = ""
then
   zenity --info --title "Exiting." \
   --text "\
The file 
   $FILENAME
does not seem to be an executable.

Exiting..."
   exit
fi


##############################################################
## Initialize the output file.
##
## NOTE: Since the executable file is typically in a directory
##       for which the user does not have write-permission,
##       we put the output file in /tmp rather than in the
##       current working directory.
#############################################################

OUTFILE="/tmp/${USER}_temp_strings4exe.txt"

if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


#######################################
## Generate a heading for the list.
#######################################

HOST_ID="`hostname`"

echo "\
.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................
STRINGS in the executable
  $FILENAME
in directory
  $CURDIR
.................... START OF 'strings' OUTPUT ......................
" >  "$OUTFILE"


#######################################
## Add the 'strings' output to the list.
#######################################

strings "$FILENAME" >> "$OUTFILE"


###########################
## Add report 'TRAILER'.
###########################

SCRIPT_BASENAME=`basename $0`
SCRIPT_DIRNAME=`dirname $0`

echo "




.........................  END OF 'strings' OUTPUT  ........................

   The output above is from script

$SCRIPT_BASENAME

   in directory

$SCRIPT_DIRNAME

   It ran the 'strings' command on host  $HOST_ID .

.............................................................................
NOTE1: Some alphanumeric characters and punctuation may show that are
       actually strings of binary data in the file that just happened
       to correspond to the ASCII codes for such characters.

NOTE2: You can use a hex-editor like 'bless' to examine the hex and ASCII
       strings in the file more thoroughly.

NOTE3: If the executable is a script, all the lines will be shown (except
       the null/empty lines).

......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................
" >> "$OUTFILE"


############################
## Show the list.
############################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
