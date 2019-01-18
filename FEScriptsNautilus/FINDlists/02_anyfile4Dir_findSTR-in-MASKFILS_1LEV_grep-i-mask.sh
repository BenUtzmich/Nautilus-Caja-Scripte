#!/bin/sh
##    
## Nautilus                        
## SCRIPT: 02_anyfile4Dir_findSTR_in_MASKFILS_1LEV_grep-i-mask.sh
##                            
## PURPOSE: For all files, in the current directory (one-level),
##          whose filenames satisfy a user-specified mask, this script lists
##          the lines in those files that contain a user-specified string
##          --- using 'grep' with a file mask.
##
## METHOD:  Uses a 'zenity --entry' prompt twice:
##
##          Once to get the file mask and once to get the string for which
##          to search inside the files matching the mask.
##
##          Puts the output of 
##                   grep -ni "$STRING" $MASK
##          into a text file.
##
##          Shows the text file using a text-file viewer of the user's
##          choice.
##
## HOW TO USE: Right-click on the name of any file (or directory) in a Nautilus 
##             directory list, after navigating to a 'base' directory.
##             Then choose this Nautilus script to run (name above).
##
## Created: 2010may17
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012feb29 Changed the script name in the comment above.

## FOR TESTING: (show statements as they execute)
#  set -x

######################################################################
## Prep a temporary filename, to hold the list of filenames.
## If the user does not have write-permission to the current directory,
## put the list in the /tmp directory.
##   Changed this. If the output file goes in the current directory,
##   the output file is found as one of the files containing the string.
##   So this always puts the output file in the /tmp directory.
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
## Enter a mask for the (text) files to be searched.
## Examples: *.sh *.html *.htm* *.txt
######################################################################

MASK=""

MASK=$(zenity --entry \
   --title "Enter a MASK to choose the TEXT files." \
   --text "\
Enter a MASK to determine the FILES search. Examples:
    *.sh  OR  *.html  OR  *.htm*  OR  *.txt  OR  *" \
   --entry-text "*")

if test "$MASK" = ""
then
   exit
fi


##############################################
## Prompt for the search string, using zenity.
##############################################

STRING=""

STRING=$(zenity --entry \
   --title "Enter the STRING to search for." \
   --text "\
Enter a STRING for the (Case-INsensitive) FILES search. Examples:
 awk  OR  grep  OR  sed  OR  sort  OR  zenity  OR  <body  OR  <a  OR  sugar" \
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

FILES  matching MASK: $MASK

and containing the STRING: $STRING

under directory
  $CURDIR
(one level only)


FORMAT of the OUTPUT LINES:

filename : line# : line-image


.................... START OF 'grep' OUTPUT ......................
" > "$OUTFILE"


#######################################################################
## Add the 'grep' output to the listing.
##
## NOTE: We could add a zenity prompt, above, to ask whether to
##       make the search case-sensitive or not.
#######################################################################

## FOR TESTING:
## Tried this xterm, but it did not work --- apparently because of the '>>'.
## May check this out, later.
#  xterm -hold -fg white -bg black -hold -e \

grep -ni "$STRING" $MASK  >> "$OUTFILE"

## Without the '-n', we get no line numbers.
# grep -i "$STRING" $MASK >> "$OUTFILE"


################################
## Add a trailer to the listing.
################################

SCRIPT_DIRNAME=`dirname $0`
SCRIPT_BASENAME=`basename $0`

HOST_ID="`hostname`"

echo "
.........................  END OF 'grep' OUTPUT  ........................

     The output above is from script

$SCRIPT_BASENAME

     in directory

$SCRIPT_DIRNAME

     which ran the 'grep' command on host  $HOST_ID .

.............................................................................

The actual command used was

grep -ni \"$STRING\" $MASK

......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................
" >> "$OUTFILE"


########################################################
## Show the list of directory-names that match the mask.
#######################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
