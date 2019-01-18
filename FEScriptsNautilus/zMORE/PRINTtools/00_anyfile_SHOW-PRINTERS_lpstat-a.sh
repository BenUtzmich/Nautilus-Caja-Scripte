#!/bin/sh
##
## Nautilus
## SCRIPT: 00_anyfile_SHOW-PRINTERS_lpstat-a.sh
##
## PURPOSE: Runs the 'lpstat -a' command to show printers.
##
## METHOD: Shows the 'lpstat -a' output in a 'zenity' popup.
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


#######################################################
## Get the 'lpstat -a' output.
#######################################################

LPSTATOUT=`lpstat -a`


############################
## Show the output.
############################

HOST_ID=`hostname`

zenity --info \
   --title "Printers." \
   --text "\
Printers defined to host $HOST_ID :

'lpstat -a' shows
___________________________________________________________________________

$LPSTATOUT
"
