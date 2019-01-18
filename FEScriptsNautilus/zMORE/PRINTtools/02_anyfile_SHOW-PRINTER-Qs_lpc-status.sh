#!/bin/sh
##
## Nautilus
## SCRIPT: 02_anyfile_SHOW-PRINTER-Qs_lpc-status.sh
##
## PURPOSE: Runs the 'lpc status' command to show printer queues.
##
## METHOD:  Shows the 'lpc status' output in a 'zenity' popup.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
##########################################################################
## Created: 2011may23
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################

## FOR TESTING: (show statements as they execute)
# set -x


#######################################################
## Get the 'lpc status' output.
#######################################################

LPCOUT=`lpc status`


############################
## Show the output.
############################

HOST_ID=`hostname`

zenity --info \
   --title "Printer QUEUES." \
   --text "\
QUEUES for Printers defined to host $HOST_ID :

'lpc status' shows
___________________________________________________________________________

$LPCOUT
"

## NOTE: If this output is too many lines for a site with lots of printers,
##       one can put the output in a temp file and show it with $TXTVIEWER,
##       as seen in code in many other FE Nautilus Scripts.
