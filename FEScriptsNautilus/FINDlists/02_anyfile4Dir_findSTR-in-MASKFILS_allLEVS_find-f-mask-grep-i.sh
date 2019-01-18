#!/bin/sh
##    
## Nautilus                        
## SCRIPT: 02_anyfile4Dir_findSTR_in_MASKFILS_allLEVS_find-f-mask-grep-i.sh
##                            
## PURPOSE: For all files, at all levels under the current directory,
##          whose names match a given mask --- such as *.htm* or *.txt or *.sh,
##          this script lists the lines in those files that contain a
##          user-specified string --- using 'find' for the directory tree
##          navigation and 'grep' to find lines containing the string.
##
## METHOD:  This script uses 'zenity --entry' twice --- to prompt for the
##          file mask and to prompt for the search string.
##
##          The 'find' command is used to navigate the directory tree and
##          apply the 'grep -Hni' command to files whose names match the
##          user-specified mask.
##
##          The 'grep' output, showing the lines that contain the user-specified
##          string, along with a line-number, is put in a text file.
##
##          This script shows the text file using a text-file viewer of the
##          user's choice.
##
## HOW TO USE: Right-click on the name of any file (or directory) in a Nautilus 
##             directory list, after navigating to a 'base' directory.
##             Then choose this Nautilus script to run (name above).
##
## Created: 2010aug29 
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
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

OUTFILE="${USER}_filesCONTAININGstring_temp.lis"

## if test ! -w "$CURDIR"
## then
OUTFILE="/tmp/$OUTFILE"
## fi

if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


######################################################################
## Use a zenity prompt to allow the option to exit ---
## if the current directory is the root (/) or /usr directory.
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

STRING=""

STRING=$(zenity --entry \
   --title "STRING to search for in the files." \
   --text "\
Enter a STRING for the (Case-INsensitive) search of the FILES
whose names match the mask '$MASK'.
Examples:
      awk  OR  sed  OR  sort  OR  break  OR  sugar  OR  <body  OR  zenity" \
   --entry-text "awk")

if test "$STRING" = ""
then
   exit
fi


############################################
## Generate a heading for the listing.
############################################

echo "\
.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................

FILES matching the filename MASK  $MASK
and containing the STRING '$STRING'
under directory
  $CURDIR


FORMAT of each line:

filename   : line# : line-image

.................... START OF 'find' OUTPUT ......................
" > "$OUTFILE"



#######################################################################
## Put the 'find-grep' output in the listing.
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
            -exec grep -Hni \"$STRING\" {} \\\; >> "$OUTFILE"


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


   It ran the 'find' and 'grep' commands on host  $HOST_ID .

.............................................................................

The actual command used was something like

find . -follow -type f  -name $MASK \\
       -exec grep -Hni \"$STRING\" {} ;

......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................
" >> "$OUTFILE"


########################################################
## Show the listing.
#######################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
