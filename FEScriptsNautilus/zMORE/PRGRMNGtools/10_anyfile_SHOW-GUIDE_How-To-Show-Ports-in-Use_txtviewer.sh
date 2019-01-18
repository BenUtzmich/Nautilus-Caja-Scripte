#!/bin/sh
##
## Nautilus
## SCRIPT: 10_anyfile_SHOW-GUIDE_How-To-Show-Ports-in-Use_txtviewer.sh
##
## PURPOSE: This script shows a text file that gives help on
##          how to show 'ports in use' on  Linux/Unix.
##
## METHOD: This script shows the text file with a textfile-viewer of
##         the user's choice.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
#############################################################################
## Created: 2010aug26
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
############################################################################


## FOR TESTING: (show statements as they execute)
#   set -x

##########################################################
## Get the name of the directory in which this script lies,
## because the help file is in the '.helps' subdirectory
## of that directory.
#######################################################

THISDIR=`dirname $0`

## FOR TESTING:
#   zenity -info -text "THISDIR = $THISDIR"

HELPFILE="$THISDIR/.helps/ports_in_use_howToShow.txt"


#############################################
## Show the help file.
##
#############################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER  "$HELPFILE"


#######################################################################
## The following statement keeps this script from completing,
## so that the script can be tested --- with output to stdout and
## stderr showing in a terminal --- when using Nautilus
## 'Open > Run in a Terminal'. NOTE: Since xpg runs as a 'background'
## process, the terminal window would, without the statement below,
## immediately close after xpg shows the file. (Also could use 'xpg -f'.)
##
## Comment this line, to deactivate it.
#######################################################################
#   read ANY_KEY_to_exit
