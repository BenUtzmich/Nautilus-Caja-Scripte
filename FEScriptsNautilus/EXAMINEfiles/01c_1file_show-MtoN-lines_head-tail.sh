#!/bin/sh
##
## Nautilus
## SCRIPT: 01c_show_1file_MtoNlines.sh
##
## PURPOSE: Show the lines M to N of the user-selected file.
##
## METHOD:  Uses 'head' and 'tail' to put the lines in a text file.
##
##          Uses 'zenity --entry' to prompt for M and N.
##
##          Shows the text file in a text-file viewer of the
##          user's choice.
##
## HOW TO USE: In Nautilus, navigate to a file, select it,
##             right-click and choose this Nautilus script to run.
##
## Created: 2010sep19
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012feb29 Changed the script name in the comment above.

## FOR TESTING:  (turn ON display of executed-statements)
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
#######################################################

OUTFILE="${USER}_temp_MtoNlines.txt"

if test ! -w "$CURDIR"
then
   OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


#################################
## Prompt for M and N.
#################################

CURDIRFOLD=`echo "$CURDIR" | fold -55`

MandN=""

MandN=$(zenity --entry \
   --title "Enter M-N." \
   --text "\
Enter M and N separated by a hyphen (i.e. minus sign).
Example: 170-355

Those lines of file

     $FILENAME

in directory

     $CURDIRFOLD

will be extracted into output file

     '$OUTFILE'." \
   --entry-text "200-500")

if test "$MandN" = ""
then
   exit
fi


#######################################
## Separate M and N at the '-' sign.
#######################################

## FOR TESTING:  (turn ON display of executed-statements)
# set -x

M=`echo "$MandN" | cut -d'-' -f1`
N=`echo "$MandN" | cut -d'-' -f2`

NM1=`expr 1 + $N - $M`

## FOR TESTING:  (turn OFF display of executed-statements)
# set -


#######################################
## Generate the head output.
#######################################

echo "\
Show lines $M through $N of file $FILENAME.
########################
" > "$OUTFILE"

head -$N "$FILENAME" | tail -$NM1 | nl -ba -v$M >> "$OUTFILE"


############################
## Show the list.
############################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
