#!/bin/sh
##
## Nautilus
## SCRIPT: 00_anyfile_SHOW_NET-INTERFACES_ifconfig.sh
##
## PURPOSE: Runs the 'ifconfig' command to show network interfaces
##          of 'this' host.
##
## METHOD: Shows the 'ifconfig' output in a 'zenity' popup.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this Nautilus script to run
##             (name above).
##
#######################################################################
## Created: 2011may23
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################

## FOR TESTING: (show statements as they execute)
# set -x


#######################################################
## Get the 'ifconfig' output.
#######################################################

IFOUT=`ifconfig 2>&1`


############################
## Show the output.
############################

HOST_ID=`hostname`

zenity --info \
      --title "Net INTERFACES info." \
      --text "\
Network (non-wireless) INTERFACES defined to host  '$HOST_ID' :

'ifconfig' shows
___________________________________________________________________________

$IFOUT
"

## NOTE: If ifconfig output is too lengthy on your host, you can
##       put the ifconfig output in a temp file and show the file
##       with $TXTVIEWER --- as is done in many feNautilusScripts,
##       such as in the FILElists group.
