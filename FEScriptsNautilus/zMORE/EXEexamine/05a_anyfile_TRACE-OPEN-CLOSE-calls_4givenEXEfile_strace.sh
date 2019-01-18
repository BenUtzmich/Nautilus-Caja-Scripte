#!/bin/sh
##
## Nautilus
## SCRIPT: 05a_anyfile_TRACE-OPEN-CLOSE-calls_4givenEXEfile_strace.sh
##
## PURPOSE: Starts up a user-specified executable and logs the system
##          'open' and 'close' (and 'stat') calls.
##
## METHOD:  This script uses a 'zenity' prompt for an executable name.
##
##          'strace' is applied to that executable.
##
##          When the executable is terminated, this script
##          shows the listing of calls in a text viewer/editor
##          of the user's choice.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory,
##             right-click and choose this Nautilus script to run
##             (script name is above).
##
## HELPFUL REFERENCES:
## - http://linuxhelp.blogspot.com/2006/05/strace-very-powerful-troubleshooting.html
## - man strace
##
#############################################################################
## Script
## Created: 2010apr30
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012apr18 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################

## FOR TESTING: (show statements as they execute)
# set -x

#################################
## Prompt for the executable name.
#################################

EXENAME=""

EXENAME=$(zenity --entry \
   --title "'strace' file Opens-and-Closes of an executable." \
   --text "\
Enter an executable name.

    If the name does not begin with '/', this script tries to determine the
    fully-qualified name of the executable using 'which' --- and if that
    fails, 'whereis' is tried.

    WARNING:
    The 'strace' output file can get huge if you allow the executable
    to perform over an extended period time or many processing cycles." \
   --entry-text "oowriter")

if test "$EXENAME" = ""
then
   exit
fi


###############################################
## Check for '/' in the first char of $EXENAME.
###############################################

## FOR TESTING: (show statements as they execute)
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
         exit
      fi
   fi
else
   EXENAME_FULL="$EXENAME"
fi


#######################################################
## Check that the specified file is an executable file.
#######################################################

## FOR TESTING: (show statements as they execute)
#  set -x

FILECHECK=`file "$EXENAME_FULL" | egrep 'executable|link'`
 
if test "$FILECHECK" = ""
then
   exit
fi


#######################################
## Initialize the output file.
##
## NOTE: If the current directory is not a directory
##       on which the user has write-permission,
##       we put the output file in /tmp rather than in the
##       current working directory.
#######################################

CURDIR="`pwd`"

OUTFILE="${USER}_temp_straceOpenClose4exe.txt"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then 
   rm -f "$OUTFILE"
fi


#######################################
## Generate the list, with heading.
#######################################

HOST_ID="`hostname`"

echo "\
.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................

'strace' of the executable

  $EXENAME_FULL

showing 'open' and 'close' (and 'stat') system calls.

.................. START OF 'strace' OUTPUT ............................
" >  "$OUTFILE"

strace -o "$OUTFILE" -e trace=open,close,stat "$EXENAME_FULL"


###########################
## Add report 'TRAILER'.
###########################

SCRIPT_BASENAME=`basename $0`
SCRIPT_DIRNAME=`dirname $0`

echo "
.........................  END OF 'strace' OUTPUT  ........................

   The output above is from script

$SCRIPT_BASENAME

   in directory

$SCRIPT_DIRNAME


   It ran the
           'strace -e trace=open,close,stat $EXENAME_FULL'
   command

   on host  $HOST_ID .

......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................
" >> "$OUTFILE"


############################
## Show the list.
############################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER  "$OUTFILE"
