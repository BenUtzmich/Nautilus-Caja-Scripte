#!/bin/sh
##
## NAUTILUS
## SCRIPT: xx_anyfile_START-CAJA-at-selected-DIR_radiolist-caja.sh
##
## PURPOSE: This script starts up MATE-Caja at a selected directory.
##
## METHOD:  This script calls on utility script
##
##           .START-NAUTILUS-or-CAJA-at-selected-DIR_radiolist-filemgr.sh
##
##          which uses a 'zenity --radiolist' prompt to present a list
##          of directory 'nicknames'.
##
##          These nicknames correspond to 'bookmarked' or 'favorites'
##          directories of the user.
##
##          The user edits that 'hidden' script to add 'bookmarks' ---
##          nicknames and corresponding full-names (the latter in 'if'
##          statements, as seen below).
##
## HOW TO USE: 
##         1) In Nautilus, select ANY file in ANY directory.
##            (Note that the selected file and the
##            Nautilus current directory are not used by this script.
##            This is simply a way to get to the Nautilus 'Scripts' menu.)
##         2) Then right-click and choose this script to run (name above).
##
##########################################################################
## Script
## Created: 2012aug19
## Changed: 2012
##########################################################################

## FOR TESTING: (show statements as they execute, in a terminal window)
#   set -x


#. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
# $DIR_NautilusScripts/FILESlists/.START-NAUTILUS-or-CAJA-at-selected-DIR_radiolist-filemgr.sh "caja"

$HOME/.gnome2/nautilus-scripts/FILESlists/.START-NAUTILUS-or-CAJA-at-selected-DIR_radiolist-filemgr.sh "caja"
