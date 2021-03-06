#!/bin/sh
##    
## Nautilus                        
## SCRIPT: 05_anyfile4Dir_findSTRover2lines_in_MASKFILS_allLEVS_awk.sh
##                            
## PURPOSE: For all files, at all levels under the current directory,
##          whose names match a given mask --- such as *.htm* or *.txt or *.sh,
##          this script lists the lines in those files that contain a
##          user-specified pair of strings that stretch over 2 lines.
##          The 'find' and 'awk' commands are used.
##
##         NOTE: I found this 'find-awk' technique, vover multiple levels
##               of directories, useful when I had to search about
##               100 '.htm' files to find pairs of lines of the form
##                 </tr>
##                 </td>
##               to change them to lines of the form
##                 </td>
##                 </tr>
##
## METHOD:  This script uses 'zenity --entry' twice --- to prompt for the
##          file mask and to prompt for the pair of search strings.
##
##          This script uses the 'find' command and an awk-based
##          utility script named
##               '.findANDshow_strings1and2_over2linesINfile_awk.sh'
##          that is in the scripts directory with this script.
##
##          This awk-based utility script looks for STRING1 in a line and,
##          if found, looks for STRING2 in the next line. If a 2-line match is
##          found, the 2 lines are sent to stdout.
##
##          This script uses the 'find' command to limit the search to files
##          matching the user-specified file mask --- and traverses,
##          recursively, the direcories under the current directory.
##
##         The 'awk' output is put in a text file.
##
##         This script shows the text file using a text-file viewer of
##         the user's choice.
##
## HOW TO USE: Right-click on the name of ANY file (or directory) in a Nautilus 
##             directory list, after navigating to a 'base' directory.
##             Then choose this Nautilus script to run (name above).
##
## Created: 2011jun06
## Changed: 2012feb29 Changed the script name in the comment above.


## FOR TESTING: (show statements as they execute)
#  set -x

######################################################################
## Prep a temporary filename, to hold the list of filenames.
## If the user does not have write-permission to the current directory,
## put the list in the /tmp directory.
############
##   CHANGED this. If the output file goes in the current directory,
##   the output file is found as one of the files containing the string.
##   So the output file is always put in the /tmp directory.
######################################################################

CURDIR="`pwd`"

OUTFILE="${USER}_temp_fileLINEScontainingSTRINGSover2lines_find-awk.lis"

## if test ! -w "$CURDIR"
## then
OUTFILE="/tmp/$OUTFILE"
## fi

if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


######################################################################
## Warn user that they may want to
## exit if the current directory is the root (/) or /usr directory.
######################################################################

if test \( "$CURDIR" = "/" -o "$CURDIR" = "/usr" \)
then
   zenity --question --title "Exit?" \
   --text "\
There are very many directory levels under $CURDIR.
This search Search could take many minutes.
Cancel or OK (Go)?" 
               
   if test $? = 0
   then
      ANS="Yes"
   else
      ANS="No"
   fi

   if test "$ANS"= "No"
   then
      exit
   fi

fi
## END OF  if test \( "$CURDIR" = "/" -o "$CURDIR" = "/usr" \)


##############################################
## Prompt for the file mask, using zenity.
##############################################

MASK=""

MASK=$(zenity --entry \
   --title "MASK for the (text) filenames to search." \
   --text "\
Enter a MASK for the filenames to search.
Examples:  *.htm*  OR  *.txt  OR  *.sh  OR  *.tcl  OR   *.tk   OR  *.log" \
   --entry-text "*.htm*")

if test "$MASK" = ""
then
   exit
fi


##############################################
## Prompt for the search string, using zenity.
##############################################

STRINGS=""

STRINGS=$(zenity --entry \
   --title "STRINGS-over-2-lines to search for in the files." \
   --text "\
Enter STRING1 and STRING2 (separated by a space),
for the (Case-INsensitive) search of the FILES
whose names match the mask '$MASK' --- ALL LEVELS
under current directory 
  $CURDIR .

This utility looks for STRING1 in one line and then
for STRING2 in the next line after a STRING1 match-line.
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
#   set -x

STRING1=`echo "$STRINGS" | awk '{print $1}' | sed -e 's|<|\\\\<|g' -e 's|>|\\\\>|g'`
STRING2=`echo "$STRINGS" | awk '{print $2}' | sed -e 's|<|\\\\<|g' -e 's|>|\\\\>|g'`

## FOR TESTING: (resets 'set -x', .i.e. no longer show cmds executed)
#   set -


############################################
## Generate a heading for the listing.
############################################

echo "\
.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................

FILES matching the filename MASK  $MASK
and containing the STRINGS '$STRING1' and '$STRING2'
in successive lines

under directory
  $CURDIR


FORMAT of each line:

filename   : line# : line-image

.................... START OF 'find' OUTPUT ......................
" > "$OUTFILE"



#######################################################################
## Add the 'find-awk' output to the listing.
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

## THE 'find' COMMAND:

find . -follow -type f -name "$MASK"  \
      -exec $DIR_ThisSCRIPT/.findANDshow_strings1and2_over2linesINfile_awk.sh \
      "$STRING1" "$STRING2" no {} \; >> "$OUTFILE"

## WORKS!! EVEN IF  '<' or '>' are in STRINGS 1 and 2.
## Works without using 'eval'
## and without prep-statements like STRING1="'${STRING1}'".
## BUT needs the pipe of STRING1 and STRING2 thru
## sed -e 's|<|\\\\<|g' -e 's|>|\\\\>|g'
## to escape any '<' and '>'.

## FOR TESTING: (resets 'set -x', .i.e. no longer show cmds executed)
#  set -

################################
## Add a trailer to the listing.
################################

SCRIPT_BASENAME=`basename $0`
SCRIPT_DIRNAME=`dirname $0`
HOST_ID="`hostname`"

echo "
.........................  END OF 'find' OUTPUT  ........................

     The output above is from script

$SCRIPT_BASENAME

     in directory

$SCRIPT_DIRNAME

     which ran the 'find' and 'awk' commands on host  $HOST_ID .

The awk program is in a separate utility script.

.............................................................................

The actual command used was something like

find . -follow -type f  -name \"$MASK\"  \\
              -exec $DIR_ThisSCRIPT/.findANDshow_strings1and2_over2linesINfile_awk.sh \\
              \"$STRING1\" \"$STRING2\" no {} \;

The special characters '<' and '>', if any, in the two
search strings, are automatically 'escaped' with a back-slash.

Other special characters may need special handling also.

......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................
" >> "$OUTFILE"


########################################################
## Show the list of directory-names that match the mask.
#######################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
