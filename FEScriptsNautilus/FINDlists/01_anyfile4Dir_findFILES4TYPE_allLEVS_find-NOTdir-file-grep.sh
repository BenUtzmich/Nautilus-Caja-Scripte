#!/bin/sh
##
## Nautilus
## SCRIPT: 01_anyfile4Dir_findFILES4TYPE_allLEVS_find-f-file-grep.sh
##
## PURPOSE: Finds ALL the files (non-directory) whose file-type matches
##          a user-specified mask --- ALL files under the current Nautilus
##          working directory, multiple levels, if any --- using
##          'find', 'file', and 'grep'.
##
## METHOD:  Uses 'zenity --entry' to prompt for a type string.
##
##          Puts the output of the 'find-file-grep' combo of commands
##          into a text file.
##
##          Shows the text file using a text-file viewer of the user's
##          choice.
##
##        This utility will look for all files matching a user-specified
##        'type' --- searching recursively under the 'current' directory,
##         that is, the directory in which the selected file lies.
##
##        The valid 'types' are strings that are returned when the 'file'
##        command is applied to a file. Example: 'ASCII HTML document text'
##        In this case, the user might simply specify 'HTML' or 'text' or
##        'ASCII' for the mask, depending on what he/she is looking for.
##
## HOW TO USE: Right-click on the name of any file (or directory) in
##             a Nautilus list, after navigating to a 'base' directory.
##             Then choose this Nautilus script (name above).
##
## Created: 2010apr03
## Changed: 2010apr12 Touched up the comment statements. Changed
##                    the output file to go into the current working
##                    directory if the user has write-permission.
## Changed: 2010aug29 Added TXTVIEWER var.
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012feb29 Changed the script name in the comment above.
## Changed: 2013oct26 Changed the script name from 'find-f' to 'find-NOTdir'
##                    to indicate this script will list 'special' files
##                    as well as 'regular' files. Correspondingly, change
##                    the '-type f' in the 'find' command to '! -type d'.

## FOR TESTING: (show statements as they execute)
#  set -x


####################################################################
## Prep a temporary filename, to hold the list of NON-directory-filenames.
## If the user does not have write-permission to the current directory,
## put the list in the /tmp directory.
####################################################################

CURDIR="`pwd`"

OUTFILE="${USER}_files4type_temp.lis"

if test ! -w "$CURDIR"
then
   OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


###############################################
## Prompt for the file-type string, using zenity.
###############################################

FILETYPE=""

FILETYPE=$(zenity --entry \
   --title "Enter a fileTYPE string to find FILES of that type." \
   --text "\
Enter a TYPE string for this NON-directory-file search.
Examples:

  for TEXT files:     'text'  OR  'ascii text'  OR  'c program text'  OR  'English text'
                  OR  'commands text'           OR  'c program text with garbage'
  for EXECUTABLES:    'executable'  OR  'ELF 32-bit LSB executable'
                  OR  'POSIX shell script text executable'
  for binary DATA:    'data'  OR  'image'  OR   'GIF'  OR  'JPEG'
                  OR  'compressed'  OR  'compressed data'  OR  'tar'" \
   --entry-text "text")

if test "$FILETYPE" = ""
then
   exit
fi


############################################
## Generate a heading for the listing.
############################################

   echo "\
.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................
NON-directory-FILES of type '$FILETYPE'

under directory
`pwd`

at ALL levels under the directory (that is, recursive search)

.................... START OF 'find' OUTPUT ......................
" > "$OUTFILE"


########################################################################
## Add the 'find-file-grep' output to the listing.
########################################################################

## WAS:
# find . -type f -exec file {} \; | grep ":.*$FILETYPE" | sort -k1 >> "$OUTFILE"

find . ! -type d -exec file {} \; | grep ":.*$FILETYPE" | sort -k1 >> "$OUTFILE"


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



   It ran the 'find', 'file', 'grep', and 'sort' commands on host  $HOST_ID .

.............................................................................

The actual command used was

    find . ! -type d -exec file {} \; | grep ":.*$FILETYPE" | sort -k1

......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................
" >> "$OUTFILE"


##########################################################
## Show the listing.
##########################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
