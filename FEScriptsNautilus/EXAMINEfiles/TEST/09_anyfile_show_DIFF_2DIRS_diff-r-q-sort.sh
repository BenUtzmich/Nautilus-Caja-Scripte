#!/bin/sh
##
## Nautilus
## SCRIPT: 09_anyfile_show_DIFF_2DIRS_diff-r-q-sort.sh
##
## PURPOSE: For two selected directories,
##          shows the differences in the two
##          directories using the 'diff -r -q' command.
##
## METHOD:  Uses 'zenity' with the '--file-selection' option to prompt
##          the user for the 'FIRST' directory.
##
##          Uses 'zenity' with the '--file-selection' option, AGAIN,
##          to prompt the user for the 'SECOND' directory.
##
##          Puts the output of the 'diff -r -q $DIRNAME1 $DIRNAME2' command
##          in a text file.
##
##          We pipe the output of 'diff' through 'sort' to group the
##          'Only in [dirname-goes-here]:' lines so that the report clearly
##          shows whether files only exist in one directory --- and
##          THEN whether files only exist in the other directory. 
##
##          Shows the text file in a text-file viewer of the
##          user's choice.
##
## REFERENCES: 
##    http://linuxcommando.blogspot.com/2008/05/compare-directories-using-diff-in-linux.html
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory. Then
##             right-click and choose this Nautilus script to run.
##
##             Note: The current directory may be used to initially position
##                   at least one of the file selection GUIs.
#########################################################################
## Created: 2012jul14
## Changed: 2012
#########################################################################

## FOR TESTING: (show statements as they execute)
# set -x

#########################################################
## Get the CURRENT directory name --- to use as a basis
## for at least one of the following file-selection GUIs.
#########################################################

CURDIR="`pwd`"


####################################
## Get the FIRST directory name.
####################################

DIRNAME1=""

DIRNAME1=$(zenity --file-selection \
   --title "Select the FIRST directory for the directory-comparison." \
   --text "\
Select the 'FIRST' directory for the directory-comparison.
" \
   --directory --filename "$CURDIR" --confirm-overwrite)

if test "$DIRNAME1" = ""
then
   exit
fi


####################################
## Get the SECOND directory name.
####################################

DIRNAME2=""

DIRNAME2=$(zenity --file-selection \
   --title "Select the SECOND directory for the directory-comparison." \
   --text "\
Select the 'SECOND' directory for the directory-comparison.
" \
   --directory --filename "$CURDIR" --confirm-overwrite)

if test "$DIRNAME2" = ""
then
   exit
fi


###########################################################
## Initialize the output file.
##
## NOTE: If the directories may be 'far' from the current
##       directory, 
##       we put the output file in /tmp rather than in the
##       current working directory.
##########################################################

OUTFILE="${USER}_temp_diff_of2dirs.lis"

# if test ! -w "$CURDIR"
# then
   OUTFILE="/tmp/$OUTFILE"
# fi

if test -f  "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


#####################################
## Generate a heading for the listing.
#####################################

HOST_ID="`hostname`"

echo "\
.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................
DIFFERENCES in the two directories
  $DIRNAME1
and
  $DIRNAME2

by 'diff -r -q'

................... START OF 'diff' OUTPUT ................................
" >  "$OUTFILE"


###############################################
## Add the 'diff -r -q' output to the listing.
##########################################################################
## Diffing 2 directories will tell you which files only exist
## in 1 directory and not the other --- and which are common files.
##
## Files that are common in both directories are diffed to see the details
## of how the file contents differ.
##
## Since file-content differences could explode the size of this report,
## we add the the -q (or --brief) option.
##########################################################################

diff -r -q "$DIRNAME1" "$DIRNAME2" | sort >> "$OUTFILE"

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

   which ran the 'diff -r q' command on host  $HOST_ID
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
