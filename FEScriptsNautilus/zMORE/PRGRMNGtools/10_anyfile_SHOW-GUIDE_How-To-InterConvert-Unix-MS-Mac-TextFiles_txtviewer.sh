#!/bin/sh
##
## Nautilus
## SCRIPT: 00_anyfile_SHOW-GUIDE_How-To-InterConvert-Unix-MS-Mac-TextFiles_txtviewer.sh
##
## PURPOSE: This script shows a text file that gives help
##          on using Linux/Unix commands to convert between
##          3 types of text files:
##            Unix/Linux, MS (aka DOS) (Microsoft), Mac (Apple)
##
## METHOD: This script shows the text file with a textfile-viewer of
##         the user's choice.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click on this script to run (name above).
##
###########################################################################
## Created: 2010aug26
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################


## FOR TESTING: (show statements as they execute)
#  set -x


#############################################
## Get the dir of this script, because the
## .helps directory is under that directory.
#############################################
THISDIR=`dirname $0`

## FOR TESTING:
#   zenity -info -text "THISDIR = $THISDIR"


############################
## Set the help filename.
############################

OUTFILE="$THISDIR/.helps/tr_linefeed_carrretn_unix_ms_mac.txt"


############################
## Show the help file.
############################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE"


######################################################################
## The following statement keeps this script from completing,
## so that the script can be tested --- with output to stdout and
## stderr showing in a terminal --- when using Nautilus
## 'Open > Run in a Terminal'. NOTE: Since xpg runs as a 'background'
## process, the terminal window would, without the statement below,
## immediately close after xpg shows the file. (Also could use 'xpg -f'.)
##
## Comment this line, to deactivate it.
######################################################################
#   read ANY_KEY_to_exit
