#!/bin/sh
##
## Nautilus
## SCRIPT: exe00_anyfile_shoSharedObjects_for1EXEname_withDirORnoDir_ldd.sh
##
## PURPOSE: Shows the shared-objects (.so dynamic executable files)
##          that may be used by the user-specified executable file.
##
## METHOD:  This script uses a 'zenity' prompt for an executable name
##          and then, if the name does not start with '/', this script
##          uses the 'which' or 'whereis' command to (try to)
##          get the fully-qualified name of the executable file. Then
##          'ldd' is applied to that full filename.
##
##          Puts the output of the 'ldd' command in a text file.
##
##          Shows the text file using a text-file viewer of the
##          user's choice.
##
## HOW TO USE: In Nautilus, navigate to any directory, any file, select it,
##             right-click and choose this Nautilus script to run.
##
## Created: 2010may25
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012feb29 Changed the script name in the comment above.

## FOR TESTING: (show statements as they execute)
# set -x

#################################
## Prompt for the executable name.
#################################

EXENAME=""

EXENAME=$(zenity --entry \
   --title "Show Shared-Objects of an executable." \
   --text "\
Enter an executable name.
    If the name begins with '/', it is assumed that you gave the
    fully qualified name. The command 'ldd' will be executed on that filename.
    Otherwise, 'which' is used to try to get the full filename. ('whereis'
    is tried if 'which' fails.)" \
   --entry-text "/usr/bin/nautilus")

if test "$EXENAME" = ""
then
   exit
fi


###############################################
## Check for '/' in the first char of $EXENAME.
###############################################

## FOR TESTING:  (show statements as they execute)
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
         zenity --info --title "Not Found. EXITING." \
           --text "\
Could not find a fully-qualified name for executable
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

## FOR TESTING: (show statements as they execute)
# set -x

FILECHECK=`file "$EXENAME_FULL" | egrep 'executable|link'`
 
if test "$FILECHECK" = ""
then
   zenity --info \
--title "Not an executable(?) - EXITING." \
   --text "\
It appears that file
   $EXENAME_FULL
is not an executable.

Type:
  $FILECHECK

Exiting ..."
   exit
fi


##########################################################
## Initialize the output file.
##
## NOTE: If the executable file is in a directory
##       for which the user does not have write-permission,
##       we put the output file in /tmp rather than in the
##       current working directory.
##########################################################

CURDIR="`pwd`"

OUTFILE="${USER}_temp_sharedObjects4exe.txt"

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

SHARED OBJECTS callable by the executable
  $EXENAME_FULL

.................. START OF 'ldd' OUTPUT ............................
" >  "$OUTFILE"


#######################################
## Add the 'ldd' output to the listing.
#######################################

ldd "$EXENAME_FULL" >> "$OUTFILE"


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

   It ran the 'ldd' command on host  $HOST_ID .

.............................................................................

NOTE1: You can use a hex-editor like 'bless' to examine the hex and ASCII
       strings in the executable more thoroughly.

......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................
" >> "$OUTFILE"


############################
## Show the list.
############################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
