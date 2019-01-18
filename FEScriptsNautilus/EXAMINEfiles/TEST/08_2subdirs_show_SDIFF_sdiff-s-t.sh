#!/bin/sh
##
## Nautilus
## SCRIPT: 00_2subdirs_show_SDIFF_sdiff-s-t.sh
##
## PURPOSE: For two selected directories, this script
##          shows the differences in the two
##          directories using the 'sdiff' command.
##
## METHOD:  Puts the output of the 'sdiff' command in a text file.
##
##          Shows the text file in a text-file viewer of the
##          user's choice.
##
## HOW TO USE: In Nautilus, navigate to a directory and select 2 directories,
##             right-click and choose this Nautilus script to run.
##
## Created: 2010oct31
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.


## FOR TESTING: (show statements as they execute)
# set -x

####################################
## Get the 2 directory names.
####################################

DIRNAM1="$1"
DIRNAM2="$2"
# DIRNAM3="$3"

if test "$DIRNAM2" = ""
then
   exit
fi


####################################
## Get the current working directory.
####################################

CURDIR="`pwd`"


################################################
## Check that the 2 selected files are directories,
## i.e. NOT 'regular' files or special files.
################################################

if test ! -d "$DIRNAM1"
then
   zenity --info \
--title "Not a directory.  EXITING." \
   --text "\
It appears that file
   $DIRNAM1
is not a directory.

Exiting ..."
   exit
fi

if test ! -d "$DIRNAM2" = ""
then
   zenity --info \
--title "Not a directory.  EXITING." \
   --text "\
It appears that file
   $DIRNAM2
is not a directory.

Exiting ..."
   exit
fi


######################################
## Initialize the output file.
##
## NOTE: If the two files are in a directory
##       for which the user does not have write-permission,
##       we put the output file in /tmp rather than in the
##       current working directory.
######################################

OUTFILE="${USER}_temp_sdiff_of2dirs.lis"

if test ! -w "$CURDIR"
then
   OUTFILE="/tmp/$OUTFILE"
fi

if test -f  "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


#####################################
## Generate a heading for the listing.
#####################################

HOST_ID="`hostname`"
BASENAM1=`basename "$DIRNAM1"`
BASENAM2=`basename "$DIRNAM2"`

echo "\
.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................
DIFFERENCES in the two directories
  $BASENAM1
and
  $BASENAM2

in directory
  $CURDIR

SHOWN SIDE-BY-SIDE, by 'sdiff'

................... START OF 'sdiff' ................................
" >  "$OUTFILE"


############################################
## Add the 'sdiff' output to the listing.
############################################

sdiff -t -s "$DIRNAM1" "$DIRNAM2" >> "$OUTFILE"


##################################
## Add a 'TRAILER' to the listing.
##################################

SCRIPT_BASENAME=`basename $0`
SCRIPT_DIRNAME=`dirname $0`

echo "
.........................  END OF 'sdiff'  ........................

   The output above is from script

$SCRIPT_BASENAME

   in directory

$SCRIPT_DIRNAME

   It ran the 'sdiff -t -s' command on host  $HOST_ID .

'-s' suppresses common (matching) lines.
'-t' replaces tabs by spaces.

.............................................................................
NOTE1: You can see the 'man' help on 'sdiff' to see a description of
       the formatting of the 'sdiff' report.

......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................
" >> "$OUTFILE"


###################################
## Show the list.
###################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
