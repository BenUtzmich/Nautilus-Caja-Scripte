#!/bin/sh
##
## Nautilus
## SCRIPT: 02_anyfile_SHOW-PRINTER-Qs_lpq-al.sh
##
## PURPOSE: Runs the 'lpq -al' command to show printer queues.
##
## METHOD:  Shows the 'lpq -al' output in a 'zenity' popup.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then Right-click and choose this script to run (name above).
##
##########################################################################
## Created: 2011may23
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################

## FOR TESTING: (show statements as they execute)
# set -x


#######################################################
## Get the 'lpq -al' output.
#######################################################

LPQOUT=`lpq -al`


############################
## Show the output.
############################

HOST_ID=`hostname`

zenity --info \
   --title "Printer QUEUES." \
   --text "\
QUEUES for Printers defined to host $HOST_ID :

'lpq -al' shows
___________________________________________________________________________

$LPQOUT
"
