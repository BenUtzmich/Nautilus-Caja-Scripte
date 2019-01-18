#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_anyfile_SHOW_ROOT-SESSIONS_from_var_logs_auth.sh
##
## PURPOSE: Show the file /var/log/auth.log to show 'root' sessions.
##
## METHOD: The auth.log file is shown in an text-viewer/editor of
##         the user's choice.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
#######################################################################
## Created: 2010may04
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################


## FOR TESTING: (show statements as they execute)
#  set -x

LOGFILE="/var/log/auth.log"

################################
## Show the 'auth' log file.
################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER  "$LOGFILE"
