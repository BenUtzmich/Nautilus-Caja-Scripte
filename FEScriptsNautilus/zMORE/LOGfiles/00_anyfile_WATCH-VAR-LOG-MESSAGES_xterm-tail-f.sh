#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_anyfile_WATCH_VAR-LOG-MESSAGES_xterm-tail-f.sh
##
## PURPOSE: Watches output to /var/log/messages by running 
##          'tail -f /var/log/messages'.
##
## METHOD:  Runs 'tail -f /var/log/messages' in an 'xterm'
##          so that the messages can be watched --- and stopped
##          by closing the 'xterm' window.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above)
##             --- in the 'NETWORKqueries' group.
##
## REFERENCE: Linux Format Magazine answer to '3G gone',
##            Apr2012, LXF issue # 156, page 104.
##
########################################################################
## Created: 2012jun04
## Changed: 2012
#######################################################################

## FOR TESTING: (show statements as they execute)
#  set -x


################################################################
## Start the 'xterm' running 'tail -f /var/log/messages'.
################################################################

xterm -fg white -bg black -hold -geometry 90x40+100+100 \
   -title "tail -f /var/log/messages" \
   -e tail -f /var/log/messages
