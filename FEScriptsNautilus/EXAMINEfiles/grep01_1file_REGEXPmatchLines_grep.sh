#!/bin/sh
##
## Nautilus
## SCRIPT: grep01_1file_REGEXPmatchLines_grep.sh
##
## PURPOSE: Show the lines of a file matching a user-specified
##          string or regular expression, using 'grep' (not 'egrep').
##
## METHOD:  Uses 'zenity --entry' to prompt for a regular expression
##          --- which may simply be a string.
##
##          Puts the output of the 'grep' command in a text file.
##
##          Shows the text file in a text-file viewer of the
##          user's choice.
##
## HOW TO USE: In Nautilus, navigate to a file, select it,
##             right-click and choose this Nautilus script to run.
##
## Created: 2010may25
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
## Check that the selected file is a text file.
## COMMENTED, for now.
#######################################################

#  FILECHECK=`file "$FILENAME" | egrep 'text|Mail|ASCII'`
 
#  if test "$FILECHECK" = ""
#  then
#     exit
#  fi


########################################################
## Initialize the output file.
##
## NOTE: If the user has write permission on the current
##       directory, we put the output file in the 'pwd'.
##       Otherwise, we put it in /tmp.
########################################################

OUTFILE="${USER}_temp_1file_matchLines.txt"

if test ! -w "$CURDIR"
then
   OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


######################################################
## Prompt for the search string or regular expression.
######################################################

STRING=""

STRING=$(zenity --entry \
   --title "Enter a string or regular expression." \
   --text "\
Enter a string or regular expression, with which to 'grep'-search file

     $FILENAME

Examples:
 '^From \- '       [finds 'From -' lines in a mail file, 'From' starting in col 1.]

 '[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*'     [finds lines with IP address]

 '^$'              [finds empty lines in a file]

 '[\\\t ]*#'         [finds lines that start with zero or more spaces/tabs and '#'
                      --- shows essentially all the comment lines of a script]

 '^Received: from .*\(\['    [finds Received-from lines of a mail file with IPaddress.]

Do not use the single quotes at the start and end of the examples." \
   --entry-text "^$")

if test "$STRING" = ""
then
   exit
fi


##########################################
## Generate a HEADING for the listing.
##########################################

# HOST_ID="`hostname`"

echo "\
.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................

LINES CONTAINING THE STRING OR REGULAR EXPRESSION
  '$STRING'
IN THE FILE
  $FILENAME

.................. START OF 'grep' OUTPUT ............................
" >  "$OUTFILE"


##########################################
## Add the grep output to the listing.
##########################################

grep -n "$STRING" "$FILENAME"  >> "$OUTFILE" 2>&1

## An example of how to cut the filname from the front of output lines,
## if needed.
# FLEN=`echo "$FILENAME" | wc -c | cut -d' ' -f2`
# grep -n "$STRING" "$FILENAME" | cut -b$FLEN- >> $OUTFILE 2>&1


##########################################
## Generate a TRAILER for the listing.
##########################################

SCRIPT_BASENAME=`basename $0`
SCRIPT_DIRNAME=`dirname $0`

echo "\
.................. END OF 'grep' OUTPUT ............................

   from script

$SCRIPT_BASENAME

   in directory

$SCRIPT_DIRNAME

....................................................................
" >>  "$OUTFILE"


############################
## Show the list.
############################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
