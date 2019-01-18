#!/bin/sh
##
## Nautilus
## SCRIPT: 00_anyfile_shoHELP_vlc-h.sh
##
## PURPOSE: Shows the help that 'vlc -h' displays.
##
## METHOD:  Puts the output of 'vlc -h' in a text file.
##
##          Shows the text file in a textfile-viewer of the user's
##          choice.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
###########################################################################
## Started: 2011jul08
## Changed: 2012may22 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (display statements that are executed)
# set -x


##################################
## Prepare the output filename.
##################################

FILEOUT="/tmp/${USER}_vlc-h_HELP.txt"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


################################################
## Put the 'vlc -h' output in the output file.
################################################

echo "\
######################
Output of 'vlc -h' :
######################

" > "$FILEOUT"

vlc -h >> "$FILEOUT"


###########################
## Show the output file.
###########################

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$FILEOUT" &
