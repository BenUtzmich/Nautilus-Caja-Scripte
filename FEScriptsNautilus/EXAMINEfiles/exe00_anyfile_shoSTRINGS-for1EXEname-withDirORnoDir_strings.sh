#!/bin/sh
##
## Nautilus
## SCRIPT: exe00_anyfile_shoSTRINGS_for1EXEname_withDirORnoDir_strings.sh
##
## PURPOSE: Shows the human-readable strings in an executable file,
##          using the 'strings' command.
##
## METHOD:  This script uses a zenity prompt for an executable name
##          and then, if the executable name does not start with '/',
##          this script uses the 'which' or 'whereis' command to (try to)
##          get the fully-qualified name of the executable file.
##
##          Puts the output of 'strings' into a text file.
##
##          Shows the text file with a text-file viewer of the
##          user's choice.
##
## HOW TO USE: In Nautilus, navigate to any directory, any file, select it,
##             right-click and choose this Nautilus script to run.
##
## Created: 2010apr11
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012feb29 Changed the script name in the comment above.

## FOR TESTING: (show statements as they execute)
# set -x

#################################
## Prompt for the executable name.
#################################

EXENAME=""

EXENAME=$(zenity --entry --title "Show strings in an executable." \
   --text "\
Enter an executable name.
    If the name begins with '/', it is assumed that you gave the fully qualified
    name. The command 'strings' will be executed on that filename.
    Otherwise, 'which' is used to try to get the full filename. ('whereis' is
    tried if 'which' fails.)
        NOTE: If the executable is a script, all the text in the script is shown." \
   --entry-text "/usr/bin/nautilus")

if test "$EXENAME" = ""
then
   exit
fi


###############################################
## Check for '/' in the first char of $EXENAME.
###############################################

## FOR TESTING:  (show the statements as they execute)
# set -x

FIRSTCHAR=`echo "$EXENAME" | cut -c1`

if ! test "$FIRSTCHAR" = "/"
then
   EXENAME_FULL=`which "$EXENAME"`
   FIRSTCHAR=`echo "$EXENAME_FULL" | cut -c1`
   if ! test "$FIRSTCHAR" = "/"
   then
      EXENAME_FULL=`whereis "$EXENAME" | awk '{print $2}'`
      FIRSTCHAR=`echo "$EXENAME_FULL" | cut -c1`
      if ! test "$FIRSTCHAR" = "/"
      then
         zenity --info \
--title "Executable NOT FOUND.  EXITING." \
   --text "\
Cannot find the fully-qualified name for executable
   $EXENAME

Exiting ..."
         exit
      fi
   fi
else
   EXENAME_FULL="$EXENAME"
fi


#######################################################
## Check that the specified file is an executable file.
#######################################################

## FOR TESTING:  (show the statements as they execute)
# set -x

FILECHECK=`file "$EXENAME_FULL" | egrep 'executable|link'`
 
if test "$FILECHECK" = ""
then
   zenity --info \
--title "Not an executable file(?) - EXITING." \
   --text "\
It appears that file
   $EXENAME_FULL
is not an executable file.

Type:
   $FILECHECK

Exiting ..."
   exit
fi


#######################################
## Initialize the output file.
##
## NOTE: If the executable file is in a directory
##       for which the user does not have write-permission,
##       we put the output file in /tmp rather than in the
##       current working directory.
#######################################

CURDIR="`pwd`"

OUTFILE="${USER}_temp_strings4exe.txt"

if test ! -w "$CURDIR"
then
   OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then 
   rm -f "$OUTFILE"
fi

#######################################
## Generate a heading for the listing.
#######################################

HOST_ID="`hostname`"

echo "\
.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................
STRINGS in the executable
  $EXENAME_FULL

.................. START OF 'strings' OUTPUT ............................
" >  "$OUTFILE"


###########################################
## Add the 'strings' output to the listing.
###########################################

strings "$EXENAME_FULL" >> "$OUTFILE"


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
NOTE1: Some alphanumeric characters and punctuation may be shown that are
       actually strings of binary codes in the file that just happened to
       correspond to the ASCII codes for alphanumeric and punctuation characters.

NOTE2: You can use a hex-editor like 'bless' to examine the hex and ASCII
       strings in the file more thoroughly.

......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................
" >> "$OUTFILE"


############################
## Show the list.
############################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &



