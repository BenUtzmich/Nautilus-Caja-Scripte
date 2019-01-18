#!/bin/sh
##
## Nautilus
## SCRIPT: 00_anyfile_shoHELP_gnome-mplayer--hlep.sh
##
## PURPOSE: Shows the help that 'gnome-mplayer --help' displays.
##
## METHOD:  Puts the 'gnome-mplayer --help' output in a text file in /tmp.
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

FILEOUT="/tmp/${USER}_gnome-mplayer--help_HELP.txt"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


###########################################################
## Put the 'gnome-mplayer --help' output in the output file.
###########################################################

echo "\
#################################
Output of 'gnome-mplayer --help' :
#################################

" > "$FILEOUT"

gnome-mplayer --help >> "$FILEOUT"



###########################
## Show the output file.
###########################

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$FILEOUT" &

