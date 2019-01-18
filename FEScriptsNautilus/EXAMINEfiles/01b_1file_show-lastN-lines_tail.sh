#!/bin/sh
##
## Nautilus
## SCRIPT: 01b_1file_show_lastN-lines_tail.sh
##
## PURPOSE: Show the last N lines of the user-selected file.
##
## METHOD:  Uses 'tail' to put the last N lines in a text file.
##
##          Uses 'zenity --entry' to prompt for N.
##
##          Shows the text file using a text-file viewer of the
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

OUTFILE="${USER}_temp_tail_Nlines.txt"

if test ! -w "$CURDIR"
then
   OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


#################################
## Prompt for N.
#################################

CURDIRFOLD=`echo "$CURDIR" | fold -55`

NLINES=""

NLINES=`zenity --entry \
   --title "How many lines of the tail of the file?" \
   --text "\
Enter a positive integer. That many lines of the 'tail' of file

     $FILENAME

in directory

     $CURDIRFOLD

will be extracted into output file

     '$OUTFILE'." \
   --entry-text "2000"`

if test "$NLINES" = ""
then
   exit
fi


#######################################
## Generate the tail output.
#######################################

echo "\
Last $NLINES lines of file $FILENAME.
##########################
" > "$OUTFILE"

tail -$NLINES "$FILENAME" | nl -ba  >> "$OUTFILE"


############################
## Show the list.
############################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
