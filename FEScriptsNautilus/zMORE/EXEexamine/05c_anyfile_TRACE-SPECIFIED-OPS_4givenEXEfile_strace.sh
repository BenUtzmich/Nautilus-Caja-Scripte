#!/bin/sh
##
## Nautilus
## SCRIPT: 05c_anyfile_TRACE-SPECIFIED-OPS_4givenEXEfile_strace.sh
##
## PURPOSE: Starts up a user-specified executable and logs the 
##          user-specified system calls.
##
## METHOD:  This script uses a 'zenity' prompt for an executable name.
##
##          'strace' is applied to that executable.
##
##          A 2nd 'zenity' prompt is used to specify the 'trace=' types
##          for the 'strace' command. Valid types include:
##             - file    (open,stat,chmod,unlink,lstat,...)
##             - desc    (file descriptor related system calls)
##             - process (fork,wait,exec,...)
##             - network (network related system calls)
##             - signal  (signal related system calls)
##             - ipc     (IPC related system calls)
##
##          When the executable is terminated, this script
##          shows the listing of calls in a text viewer/editor
##          of the user's choice.
##
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory,
##             right-click and choose this Nautilus script to run
##             (script name is above).
##
## HELPFUL REFERENCES:
## - man strace
##
#############################################################################
## Script
## Created: 2010apr30
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012apr18 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#############################################################################

## FOR TESTING: (show statements as they execute)
# set -x

#################################
## Prompt for the executable name.
#################################

EXENAME=""

EXENAME=$(zenity --entry \
   --title "Run 'strace' on which executable?" \
   --text "\
Enter an executable name.

    If the name does not begin with '/', this script tried to determine the
    fully-qualifed name of the executable using 'which' --- and if that
    fails, 'whereis' is tried.

    WARNING:
    The 'strace' output file can get huge if you allow the executable
    to perform over an extended period time or processing cycles." \
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


###############################################################
## Prompt for the type of 'strace' to perform.
###############################################################
##             - file    (open,stat,chmod,unlink,lstat,...)
##             - desc    (file descriptor related system calls)
##             - process (fork,wait,exec,...)
##             - network (network related system calls)
##             - signal  (signal related system calls)
##             - ipc     (IPC related system calls)
###############################################################

 STYPE=""

 STYPE=$(zenity --list --radiolist \
   --title "Type of 'strace' to perform?" \
   --text "\
Choose one of the following types:

'file'    for open,stat,chmod,unlink,lstat,... calls
'desc'    for file descriptor related system calls
'process' for fork,wait,exec,... calls
'network' for network related system calls
'signal'  for signal related system calls
'ipc'     for IPC related system calls
" \
   --column "" --column "Type" \
   TRUE file FALSE desc FALSE process FALSE network \
   FALSE signal FALSE ipc)

 if test "$STYPE" = ""
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

OUTFILE="${USER}_temp_strace_TYPE${STYPE}.txt"

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

showing system calls of TYPE: $STYPE.

.................. START OF 'strace' OUTPUT ............................
" >  "$OUTFILE"

strace -o "$OUTFILE" -e trace=$STYPE "$EXENAME_FULL"


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


    It ran the command 'strace -e trace=$STYPE $EXENAME_FULL'

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
