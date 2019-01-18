#!/bin/sh
##
## Nautilus
## SCRIPT: 00_anyfile_shoHELP_ffplay-h.sh
##
## PURPOSE: Shows the help that 'ffplay -h' displays.
##
## METHOD:  There is no prompt for a parameter.
##
##          This script puts the output of 'ffplay -h' in a text file
##          in the '/tmp' directory.
##
##          Shows the text output in a text viewer of the user's choice.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
#############################################################################
## Started: 2011jun16
## Changed: 2012may14 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (display statements that are executed)
# set -x


##################################
## Prepare the output filename.
##################################

FILEOUT="/tmp/${USER}_ffplay_HELP.txt"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


################################################
## Put the 'ffplay -h' output in the output file.
################################################

echo "\
######################
Output of 'ffplay -h' :
######################

" > "$FILEOUT"

ffplay -h >> "$FILEOUT"


###########################
## Show the output file.
###########################

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$FILEOUT" &
