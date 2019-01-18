#!/bin/sh
##
## Nautilus
## SCRIPT: 10_anyfile_SHOW-TABLES_ASCII-Codes-and-Characters_txviewer.sh
##
## PURPOSE: This script shows the user the man help on 'ascii' --- which
##          shows tables of ASCII codes and the corresponding text
##          characters and control codes.
##
## METHOD: This script generates a help text file using the 'man -w' file
##         to get the compressed filename that holds the man text. Then
##         the man text is uncompressed into a plain text file.
##
##         The plain text file is shown using a textfile-viewer of the
##         user's choice.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
############################################################################
## Created: 2010may30
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################

## FOR TESTING: (show statements as they execute)
#  set -x

UTIL_NAME="ascii"


###############################################################
## Prep a temporary filename, to hold the manhelp text.
##
##      We put the outlist file in /tmp in case the user does
##      not have write-permission to the current directory
##      --- and because this manhelp often has nothing to do
##      with the current directory.
###############################################################

OUTFILE="/tmp/${USER}_manhelp4_${UTIL_NAME}.lis"
 
if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


########################################
## Prepare the output (man help) listing.
########################################

  echo "\
man help for '$UTIL_NAME' :
##########################
" > "$OUTFILE"


############################################################
## Use pipes 'zcat|groff|col' to format the man help text.
############################################################

MANFILE=`man -w $UTIL_NAME`

if test "$MANFILE" = ""
then

   echo "***** man file for $UTIL_NAME not found. *****" >> "$OUTFILE"

else

   # TERM="ansi-m"
   # export TERM

   ## On SGI-IRIX, 'pcat' with 'man -p' (and 'col' and 'ul') works.
   ##   CMD="pcat \`man -p $STRING | cut -d' ' -f2\` | col | ul -t dumb"

   ## On Mandriva 2007, 'groff -P -c' gets rid of color codes
   ## from the bz2-uncompressed man files.
   ## If '-P -c' stops working, use:   export GROFF_NO_SGR="yes"
   #   CMD="bzcat $MANFILE | /usr/bin/groff -t -Tascii -mandoc -P -c | col -b"

   ## On Ubuntu 2009 (9.10, Karmic), 'groff -P -c' gets rid of color codes
   ## from the gzip-uncompressed man files.
   ## If '-P -c' stops working, use:   export GROFF_NO_SGR="yes"
   zcat "$MANFILE" | /usr/bin/groff -t -Tascii -mandoc -P -c | col -b >> "$OUTFILE"

fi


###################################
## Show the man help.
###################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE"


## The following statement keeps this script from completing,
## so that the script can be tested --- with output to stdout and
## stderr showing in a terminal --- when using Nautilus
## 'Open > Run in a Terminal'. NOTE: Since xpg runs as a 'background'
## process, the terminal window would, without the statement below,
## immediately close after xpg shows the file. (Also could use 'xpg -f'.)
##
## Comment this line, to deactivate it.
#   read ANY_KEY_to_exit
