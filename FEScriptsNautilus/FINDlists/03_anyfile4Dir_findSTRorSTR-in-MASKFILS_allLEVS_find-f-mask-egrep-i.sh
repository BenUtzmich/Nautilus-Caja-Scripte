#!/bin/sh
##    
## Nautilus                        
## SCRIPT: 03_anyfile4Dir_findSTRorSTR_in_MASKFILS_allLEVS_find-f-mask-egrep-i.sh
##                            
## PURPOSE: For all files, at all levels under the current directory,
##          whose names match a given mask --- such as *.htm* or *.txt or *.sh,
##          this script lists the lines in those files that contain a
##          user-specified string (or strings) --- using 'find' for the
##          directory tree navigation and 'egrep' to find lines containing
##          the user-specified string(s).
##
## METHOD:  This script uses 'zenity --entry' twice --- to prompt for the
##          file mask and to prompt for the search string(s).
##
##          The 'find' command is used to navigate the directory tree and
##          apply the 'egrep -niH' command to files whose names match the
##          user-specified mask.
##
##          The 'egrep' output, showing the lines that contain the
##          user-specified string(s), along with a line-number, is put in
##          a text file.
##
##          This script shows the text file using a text-file viewer of the
##          user's choice.
##
## HOW TO USE: Right-click on the name of ANY file (or directory) in a Nautilus 
##             directory list, after navigating to a 'base' directory.
##             Then choose this Nautilus script to run (name above).
##
## Created: 2011may17
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

OUTFILE="${USER}_temp_fileLINEScontainingStringS_find-egrep.lis"

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
Examples:  *.htm*  OR  *.txt  OR  *.sh  OR  *.tcl  OR   *.tk" \
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
   --title "STRINGS to search for in the files." \
   --text "\
Enter one or more STRINGS for the (Case-INsensitive) search of the FILES
whose names match the mask '$MASK'.
Separate the strings by vertical bar (|).
Examples:
      awk|sed
      </tr>|</td>
      <table>|<tr>|<td>|</td>|</tr>|</table>" \
           --entry-text "</tr>|</td>")

if test "$STRINGS" = ""
then
   exit
fi


############################################
## Generate a heading for the listing.
############################################

echo "\
.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................

FILES matching the filename MASK  $MASK
and containing at least one of the STRINGS '$STRINGS'
( separated by the vertical bar | )
under directory
  $CURDIR


FORMAT of each line:

filename   : line# : line-image

.................... START OF 'find' OUTPUT ......................
" > "$OUTFILE"



#######################################################################
## Add the 'find-egrep' output to the listing.
#######################################################################

## FOR TESTING: (show cmds being executed, after var substitution)
#  set -x

## In the following 'find' command(s),
## '-follow' says to go to the link target, if the file is a link.

MASK="'${MASK}'"

## FOR TESTING:
# find . -follow -type f -print >> "$OUTFILE"

## FOR TESTING: (eval WORKS ; gets the filenames to print)
# eval  find . -follow -type f -name $MASK  -print >> $OUTFILE

## THE REAL DEAL:
## (after escaping the double-quotes and triple-escaping the semicolon!!!)
eval find . -follow -type f -name $MASK  \
            -exec egrep -niH \"$STRINGS\" {} \\\; >> "$OUTFILE"


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

     which ran the 'find' and 'egrep' commands on host  $HOST_ID .

.............................................................................

The actual command used was something like

find . -follow -type f  -name $MASK \\
       -exec egrep -niH \"$STRINGS\" {} \;

......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................
" >> "$OUTFILE"


########################################################
## Show the list of directory-names that match the mask.
#######################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
