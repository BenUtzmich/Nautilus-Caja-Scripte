#!/bin/sh
##
## Nautilus
## SCRIPT: 06_anyfile_SHOW-CUPS-ADMIN-MENU_localhost-631_html-viewer.sh
##
## PURPOSE: Show the CUPS menu via 'http//localhost:631'.
##
## METHOD: Uses an html-viewer of the user's choice to access the
##         'localhost:631' URL.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
#########################################################################
## Created: 2011may23
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################


## FOR TESTING: (show statements as they execute)
# set -x


#################################
## Show the CUPS menu.
#################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$HTMLVIEWER "http://localhost:631/"

## Alternativel, we could start at the admin help.
# $HTMLVIEWER "http://localhost:631/help"
