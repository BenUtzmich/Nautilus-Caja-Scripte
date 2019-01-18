#!/bin/sh
##    
## Nautilus                        
## SCRIPT: 05_1file_findSTRover2lines_awk.sh
##                            
## PURPOSE: For a selected (text) file --- such as *.htm* or *.txt or *.sh ---
##          shows the PAIRS-OF-LINES that contain a pair of strings that stretch
##          over 2 lines.
##
##         NOTE: I found this 'awk' technique useful when I had to search about
##               100 '.htm' files to find pairs of lines of the form
##                 </tr>
##                 </td>
##               to change them to lines of the form
##                 </td>
##                 </tr>
##
## METHOD: This script uses 'zenity --entry' to prompt for a pair of strings ---
##         STRING1 and STRING2.
##
##         This script then uses an awk-based utility script named
##
##               .findANDshow_strings1and2_over2linesINfile_awk.sh
##
##         This awk-based script looks for STRING1 in a line and, if found,
##         looks for STRING2 in the next line. If a 2-line match is found,
##         the 2 lines are sent to stdout.
##
##         The 'awk' output is put in a text file.
##
##         This script shows the text file using a text-file viewer of
##         the user's choice.
##
## HOW TO USE: Right-click on the name of a (text) file in a Nautilus 
##             directory list.
##             Then choose this Nautilus script to run (name above).
##
## Created: 2011jun06
## Changed: 2012feb29 Changed the script name in the comment above.


## FOR TESTING: (show statements as they execute)
#  set -x

#########################################
## Get the filename of the selected file.
#########################################

#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

FILENAME="$1"


#######################################################
## Check that the selected file is a text file.
## COMMENTED, for now.
#######################################################

#  FILECHECK=`file "$FILENAME" | egrep 'text|Mail|ASCII'`
 
#  if test "$FILECHECK" = ""
#  then
#     exit
#  fi


######################################################################
## Prep a temporary filename, to hold the listing.
## If the user does not have write-permission to the current directory,
## put the list in the /tmp directory.
############
##   CHANGED this. If the output file goes in the current directory,
##   the output file is found as one of the files containing the string.
##   So the output file is always put in the /tmp directory.
######################################################################

CURDIR="`pwd`"

OUTFILE="${USER}_temp_fileLINEScontainingSTRINGSover2lines_ONEfile_awk.lis"

## if test ! -w "$CURDIR"
## then
OUTFILE="/tmp/$OUTFILE"
## fi

if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


#################################################
## Prompt for the 2 search strings, using zenity.
#################################################

STRINGS=""

STRINGS=$(zenity --entry \
   --title "STRINGS-over-2-lines to search for in the files." \
   --text "\
Enter STRING1 and STRING2 (separated by a space),
for the (Case-INsensitive) search of the selected file
  $FILENAME

in current directory 
  $CURDIR .

This utility looks for STRING1 in one line and then
for STRING2 in the next line after encountering a STRING1 match-line.
Examples:
      </tr> </td>     [out-of-order HTML tags, on adjacent lines]
      match- line     [hypenated words, on adjacent lines]" \
   --entry-text "</tr> </td>")

if test "$STRINGS" = ""
then
   exit
fi


##############################################################
## Parse STRING1 and STRING2 from STRINGS, and
## add an escape to '>' and '<' if they are in the strings.
############
## !NEEDED! to avoid syntax errors in the 'find' command when
## '<' or '>' are in STRINGS.
##############################################################

## FOR TESTING: (show cmds being executed, after var substitution)
#    set -x

STRING1=`echo "$STRINGS" | awk '{print $1}' | sed -e 's|<|\\\\<|g' -e 's|>|\\\\>|g'`
STRING2=`echo "$STRINGS" | awk '{print $2}' | sed -e 's|<|\\\\<|g' -e 's|>|\\\\>|g'`

## FOR TESTING: (resets 'set -x', .i.e. no longer show cmds executed)
#    set -


############################################
## Generate a heading for the listing.
############################################

echo "\
.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................

LINES containing the STRINGS '$STRING1' and '$STRING2'
in successive lines

in file
  $FILENAME
in directory
  $CURDIR


FORMAT of each line:

filename   : line# : line-image

.................... START OF 'find' OUTPUT ......................
" > "$OUTFILE"



#######################################################################
## Add 'awk' output to the listing.
#######################################################################

## FOR TESTING: (show cmds being executed, after var substitution)
#   set -x

## In the following 'find' command(s),
## '-follow' says to go to the link target, if the file is a link.

## FOR TESTING: (prints all type-f filenames)
# find . -follow -type f -print >> "$OUTFILE"

## FOR TESTING: (prints the filenames matching the MASK gathered above, like *.htm*)
# find . -follow -type f -name "$MASK"  -print
# exit

## Set the directory of this script, so that the utility script, which is in
## the same directory, can be specified in the following 'find' command.
DIR_ThisSCRIPT=`dirname $0`

## THE 'awk' COMMAND:

$DIR_ThisSCRIPT/.findANDshow_strings1and2_over2linesINfile_awk.sh \
              "$STRING1" "$STRING2" no "$FILENAME" >> "$OUTFILE"

## WORKS!! EVEN IF  '<' or '>' are in STRINGS 1 and 2.
## Works without using 'eval'
## and without prep-statements like STRING1="'${STRING1}'".
## BUT needs the pipe of STRING1 and STRING2 thru
## sed -e 's|<|\\\\<|g' -e 's|>|\\\\>|g'
## to escape any '<' and '>'.

## FOR TESTING: (resets 'set -x', .i.e. no longer show cmds executed)
#  set -


##################################
## Add a trailer to the listing.
##################################

SCRIPT_BASENAME=`basename $0`
SCRIPT_DIRNAME=`dirname $0`
HOST_ID="`hostname`"

echo "
.........................  END OF 'find' OUTPUT  ........................

     The output above is from script

$SCRIPT_BASENAME

     in directory

$SCRIPT_DIRNAME

     which ran an 'awk' utility script on host  $HOST_ID .

.............................................................................

The actual command used was something like

$DIR_ThisSCRIPT/.findANDshow_strings1and2_over2linesINfile_awk.sh \\
              \"$STRING1\" \"$STRING2\" no "$FILENAME"

The special characters '<' and '>', if any, in the two
search strings, are automatically 'escaped' with a back-slash.

Other special characters may need special handling also.

......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................
" >> "$OUTFILE"


########################################################
## Show the listing.
#######################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
