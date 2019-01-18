#!/bin/sh
##
## Nautilus
## SCRIPT: 00_anyfile_shoHELP_totem--help-all.sh
##
## PURPOSE: Shows the help that 'totem --help-all' displays.
##
## METHOD:  Puts the 'totem --help-all' output in a text file in /tmp.
##
##          Shows the text file with a text-file viewer of the user's
##          choice.
##
## HOW TO USE: Right-click on ANY file in ANY directory and choose this
##             nautilus script to run.
##
## Started: 2011jul08
## Changed: 2012feb29 Changed the script name in the comment above.
##                    Added the METHOD comments section above.

## FOR TESTING: (display statements that are executed)
# set -x


##################################
## Prepare the output filename.
##################################

FILEOUT="/tmp/${USER}_totem--help-all_HELP.txt"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


################################################
## Put the 'totem --help-all' output in the output file.
################################################

echo "\
######################
Output of 'totem --help-all' :
######################

" > "$FILEOUT"

totem --help-all >> "$FILEOUT"



###########################
## Show the output file.
###########################

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$FILEOUT" &

