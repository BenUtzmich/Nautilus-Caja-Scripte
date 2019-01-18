#!/bin/sh
##
## Nautilus
## SCRIPT: 00_anyfile4Dir_findFILES4MASK_allLEVS_find-NOTdir-mask.sh
##
## PURPOSE: Finds ALL the files (non-directory) that match a user-specified
##          mask, under the current working directory, multiple levels, if any
##          --- using the 'find' command with the '-f' and '-name' options.
##
## METHOD:  Uses 'zenity --entry' to prompt for the file mask.
##
##          Puts the output of the 'find' command in a text file.
##
##          Shows the text file using a text-file viewer of the user's
##          choice.
##
##        This utility will look for all non-directory filenames
##        matching a user-specified 'mask' ---
##        searching recursively under the 'current' directory,
##        that is, the directory in which the selected file lies.
##
## HOW TO USE: Right-click on the name of any file (or directory) in a Nautilus 
##             directory list, after navigating to a 'base' directory.
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
## Changed: 2012jun19 Added 'CASE-SENSITIVE' note to zenity prompt and the list
##                    heading.
## Changed: 2013oct26 Changed the script name from 'find-f' to 'find-NOTdir'
##                    to indicate this script will list 'special' files
##                    as well as 'regular' files.

## FOR TESTING: (show statements as they execute)
#  set -x


#############################################################
## Prep a temporary filename, to hold the list of filenames.
## If the user does not have write-permission to the current directory,
## put the list in the /tmp directory.
#############################################################

CURDIR="`pwd`"

OUTFILE="${USER}_files4mask_temp.lis"

if test ! -w "$CURDIR"
then
   OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


############################################
## Prompt for the mask string, using zenity.
############################################

MASK=""

MASK=$(zenity --entry \
   --title "Filename MASK to use in finding FILES." \
   --text "\
Enter a filename MASK for the regular (non-directory) file search.
Examples:
      *.jpg  OR  *.htm*  OR  *Blue* OR  *.*  OR  a*  OR  .a*  OR  *

CASE-SENSITIVE search." \
   --entry-text "*.jpg")

if test "$MASK" = ""
then
   exit
fi


############################################
## Generate a heading for the listing.
############################################

  echo "\
.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................
FILES for mask '$MASK'

under directory
$CURDIR

at ALL levels under the directory (that is, recursive search)
--- and CASE-SENSITIVE search.

.................... START OF 'find' OUTPUT ......................
" > "$OUTFILE"


#######################################################################
## Add the 'find' output to the listing.
########################################################################

find  . ! -type d -name "$MASK" -print | sort -k1 >> "$OUTFILE"


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


   It ran the 'find' and 'sort' commands on host  $HOST_ID .

.............................................................................

The actual command used was

  find  . ! -type d -name "$MASK" -print | sort -k1 

......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................
" >> "$OUTFILE"


##################################################
## Show the list of filenames that match the mask.
##################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
