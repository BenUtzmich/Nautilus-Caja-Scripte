#!/bin/sh
##
## Nautilus
## SCRIPT: grep02_1file_REGEXPmatchLines_egrep.sh
##
## PURPOSE: Show the lines of a file matching a user-specified
##          string or regular expression, using 'egrep'.
##
## METHOD:  Uses 'zenity --entry' to prompt for a regular expression
##          --- which can simply be a string, or strings separated by '|'.
##
##          Puts the 'egrep' output in a text file.
##
##          Shows the text file using a text-file viewer of the
##          user's choice.
##
## HOW TO USE: In Nautilus, navigate to a file, select it,
##             right-click and choose this Nautilus script to run.
##
## NOTE: Uses a 'zenity' prompt for the string or regular expression.
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


#######################################
## Initialize the output file.
##
## NOTE: If the user has write permission on the current
##       directory, we put the output file in the 'pwd'.
##       Otherwise, we put it in /tmp.
#######################################

OUTFILE="${USER}_temp_1file_egrepMatches.txt"

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
Enter a string or regular expression, with which to 'egrep'-search file

     $FILENAME

in case-sensitive mode.

Examples: 
  'error|Error|ERROR'    [finds lines containing at least one of the 3 forms]

  'warning|error|fail'   [finds lines containing at least one of the 3 words]

  'if|elif|else|fi'      [finds the lines in a script containing if,elif,else, or fi]

  'cut|tr|sed|awk|grep'  [finds the lines in a script containing cut,tr,sed,awk, or grep]

  '{|}'                  [finds the lines that contain left or right brace,
                               say in a Tcl-Tk script]

Do not use the single quotes at the start and end of the examples." \
           --entry-text "for|each|do|done")

if test "$STRING" = ""
then
   exit
fi


##########################################
## Generate a heading for the listing.
##########################################

HOST_ID="`hostname`"

echo "\
.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................

LINES CONTAINING THE STRING OR REGULAR EXPRESSION
  '$STRING'
IN THE FILE
  $FILENAME

.................. START OF 'egrep' OUTPUT ............................
" >  "$OUTFILE"


##########################################
## Add the 'egrep' output to the listing.
##########################################

egrep -n "$STRING" "$FILENAME"  >> "$OUTFILE" 2>&1


## The following might be needed if we try to egrep multiple files
## --- to get rid of a long filename at the start of each line.
##
## Find the matches to the reg-exp in $STRING, and
## remove the filename from the front of each egrep output line,
## leaving the linenumber and an image of the line.
##
## First, get the numChars in the string $BASENAME.
##
# BASENAME=`basename "$FILENAME"`
# FLEN=`echo "$BASENAME" | wc -c | cut -d' ' -f2`
##
# eval egrep -n '$STRING' \"$FILENAME\" | cut -c$FLEN- >> $OUTFILE 2>&1


##############
## ADD Trailer
##############

SCRIPT_BASENAME=`basename $0`
SCRIPT_DIRNAME=`dirname $0`

echo "\
.................. END OF 'egrep' OUTPUT ............................

  Output is from script

$SCRIPT_BASENAME

  in directory

$SCRIPT_DIRNAME
.....................................................................
" >>  "$OUTFILE"


############################
## Show the list.
############################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
