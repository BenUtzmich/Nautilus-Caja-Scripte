#!/bin/sh
##
## Nautilus
## SCRIPT: 00_anyfile_show_SHARED-OBJECTS_dynloads_4givenEXEfile_ldd.sh
##
## PURPOSE: Runs the 'ldd' command on a user-specified executable.
##
## METHOD:  This script uses a zenity prompt for an executable name.
##          'ldd' is applied to that executable.
##
##          Shows the resulting listing in a text viewer/editor of the
##          user's choice, as seen at the bottom of this script.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory,
##             right-click and choose this Nautilus script to run
##             (name above).
##
## A HELPFUL REFERENCES:
##   man ldd
##
############################################################################
## Script
## Created: 2010apr30
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012apr18 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
############################################################################

## FOR TESTING: (show statements as they execute)
# set -x

#################################
## Prompt for the executable name.
#################################

EXENAME=""

EXENAME=$(zenity --entry \
   --title "Run 'ldd' on an executable." \
   --text "Enter an executable name.

    If the name does not begin with '/', this script attempts to find the
    fully-qualified name of the executable file by using the 'which' command,
    --- and if that fails, the 'whereis' command is tried." \
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


###########################################################
## Initialize the output file.
##
## NOTE: If the current directory is a directory on which
##       the user does not have write-permission,
##       we put the output file in /tmp rather than in the
##       current working directory.
##########################################################

CURDIR="`pwd`"

OUTFILE="${USER}_temp_ldd4exe.txt"
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

'ldd' output for the executable

  $EXENAME

showing dynamic 'shared objects' that could be called by the executable.

.................. START OF 'ldd' OUTPUT ............................
" >  "$OUTFILE"

ldd "$EXENAME" >> "$OUTFILE"



###########################
## Add report 'TRAILER'.
###########################

SCRIPT_BASENAME=`basename $0`
SCRIPT_DIRNAME=`dirname $0`

echo "
.........................  END OF 'ldd' OUTPUT  ........................

   The output above is from script

$SCRIPT_BASENAME

   in directory

$SCRIPT_DIRNAME


   It ran the command  'ldd $EXENAME'

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
