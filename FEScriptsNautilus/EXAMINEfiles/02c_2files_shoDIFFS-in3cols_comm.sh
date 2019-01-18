#!/bin/sh
##
## Nautilus
## SCRIPT: 02c_2files_shoDIFFS_in3cols_comm.sh
##
## PURPOSE: For two selected files [in a directory],
##          shows the differences in the two files,
##          using the 'comm' command.
##
## METHOD:  Puts the output from 'comm' in a text file.
##
##          Shows the text file with a text-file viewer of the
##          user's choice.
##
## From 'man comm':
##
## "With  no  options,  produce  three-column  output.  Column one contains
##  lines unique to FILE1, column two contains lines unique to  FILE2,  and
##  column three contains lines common to both files.
##
##   -3     suppress lines that appear in both files"
##
## HOW TO USE: In Nautilus, navigate to a directory and select 2 files,
##             right-click and choose this Nautilus script to run.
##
## Created: 2010oct31
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and use '$1' and '$2' ---
##                     or 'shift' --- to get the 2 filenames.)

## FOR TESTING: (show statements as they execute)
# set -x

####################################
## Get the 2 filenames.
####################################

FILENAM1="$1"
FILENAM2="$2"

## ALTERNATIVE WAY of getting the 2 filenames:

# FILENAM1="$1"
# shift
# FILENAM2="$1"


####################################
## Get the current working directory.
####################################

CURDIR="`pwd`"

###################################################
## Check that the 2 selected files are 'text' files,
## i.e. NOT 'binary' files.
###################################################

FILECHECK=`file "$FILENAM1" | egrep 'text|Mail'`
 
if test "$FILECHECK" = ""
then
   zenity --info \
--title "Not a text file(?) - EXITING." \
   --text "\
It appears that file
   $FILENAM1
is not a text file.

Exiting ..."
   exit
fi

FILECHECK=`file "$FILENAM2" | egrep 'text|Mail'`
 
if test "$FILECHECK" = ""
then
   zenity --info \
--title "Not a text file(?) - EXITING." \
   --text "\
It appears that file
   $FILENAM2
is not a text file.

Exiting ..."
   exit
fi


###########################################################
## Initialize the output file.
##
## NOTE: If the two files are in a directory
##       for which the user does not have write-permission,
##       we put the output file in /tmp rather than in the
##       current working directory.
##########################################################

OUTFILE="${USER}_temp_diff_of2files_comm.lis"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f  "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


#####################################
## Generate a heading for the list.
#####################################

HOST_ID="`hostname`"
BASENAM1=`basename "$FILENAM1"`
BASENAM2=`basename "$FILENAM2"`

echo "\
.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................

DIFFERENCES in the two files
  $BASENAM1
and
  $BASENAM2

     in directory
        $CURDIR

SHOWN via the 'comm' command.

................... START OF 'comm' ................................
" >  "$OUTFILE"


#####################################
## Put the 'comm' output in the list.
#####################################

comm "$FILENAM1" "$FILENAM2" >> "$OUTFILE"


##################################
## Add report 'TRAILER'.
##################################

SCRIPT_BASENAME=`basename $0`
SCRIPT_DIRNAME=`dirname $0`

echo "
.........................  END OF 'comm'  ........................

   The output above is from script

$SCRIPT_BASENAME

   in directory

$SCRIPT_DIRNAME

   which ran the 'comm' command on host  $HOST_ID .

.............................................................................
NOTE1: With  no  options, 'comm' produces  three-column  output.
       Column one contains lines unique to FILE1, column two contains
       lines unique to  FILE2, and column three contains lines common 
       to both files.
       
       The '-3' option can be used to suppress lines that appear in both files.

       This script uses no options. The script could be edited to add a prompt
       whether to include the 3rd column --- the identical lines in both files.

NOTE2: Alternatives are 'sdiff' and 'diff'. AND ...
       You can use a GUI alternative to 'diff' to see some other
       ways of presenting the differences. Example: 'tkdiff'
       ('xdiff' is available on some Unix OSes.)

......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................
" >> "$OUTFILE"


###################################
## Show the list.
###################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &



