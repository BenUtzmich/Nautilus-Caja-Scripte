#!/bin/sh
##
## Nautilus
## SCRIPT: 00_anyfile_shoHELP_vlc-h.sh
##
## PURPOSE: Shows the help that 'vlc -h' displays.
##
## METHOD:  Puts the 'vlc -h' output in a text file in /tmp.
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
