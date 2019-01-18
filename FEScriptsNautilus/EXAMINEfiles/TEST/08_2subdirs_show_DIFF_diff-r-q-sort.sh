#!/bin/sh
##
## Nautilus
## SCRIPT: 08_2subdirs_show_DIFF_diff-r-q-sort.sh
##
## PURPOSE: For two selected SUB-directories of the current directory,
##          this utility shows the differences in the two
##          directories using the 'diff -r -q' command.
##
## METHOD:  Puts the output of the 'diff -r -q' command in a text file
##          --- after piping the output through the 'sort' command.
##
##          Shows the text file in a text-file viewer of the
##          user's choice.
##
## REFERENCES: 
##    http://linuxcommando.blogspot.com/2008/05/compare-directories-using-diff-in-linux.html
##
##
## HOW TO USE: In Nautilus, navigate to a directory and select two
##             SUB-directories. Then
##             right-click and choose this Nautilus script to run.
##
#############################################################################
## Created: 2010oct31
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012feb29 Changed the script name in the comment above.
## Changed: 2012jul14 Added the '-q' option on the 'diff' command. Added the
##                    pipe to 'sort'. Changed and added some comments.
############################################################################


## FOR TESTING: (show statements as they execute)
# set -x

####################################
## Get the 2 SUB-directory names.
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

OUTFILE="${USER}_temp_diff_of2dirs.lis"

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

SHOWN by 'diff -r -q'

................... START OF 'diff' OUTPUT ................................
" >  "$OUTFILE"


########################################
## Add the 'diff' output to the listing.
###################################################################
## Diffing 2 directories will tell you which files only exist
## in 1 directory and not the other --- and which are common files.
##
## Files that are common in both directories are diffed to see the details
## of how the file contents differ.
##
## Since file-content differences could explode the size of this report,
## we add the the -q (or --brief) option.
##########################################################################

diff -r -q "$DIRNAM1" "$DIRNAM2" | sort >> "$OUTFILE"

# --brief


##################################
## Add a 'TRAILER' to the listing.
##################################

SCRIPT_BASENAME=`basename $0`
SCRIPT_DIRNAME=`dirname $0`

echo "
.........................  END OF 'diff' OUTPUT ........................

   The output above is from script

$SCRIPT_BASENAME

   in directory

$SCRIPT_DIRNAME

   which ran the 'diff -r -q' command on host  $HOST_ID
   and piped the output through 'sort'.

'-r' means recursive.

'-q' means quiet (or brief) --- that is, do not show the differences
     in file contents for files that differ. In other words, we use
     '-q' to report only  whether  the  files  differ,  not  the
     details of the differences.

.............................................................................
NOTE1: You can see the 'man' help on 'diff' to see a description of
       the formatting of the 'diff' report.

......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................
" >> "$OUTFILE"


###################################
## Show the list.
###################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
