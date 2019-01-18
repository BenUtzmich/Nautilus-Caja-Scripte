#!/bin/sh
##
## Nautilus
## SCRIPT: 01_anyfile_SHOW_PING-OUTPUT_4givenURL_xterm-ping.sh
##
## PURPOSE: Prompts the user for a URL and runs 'ping' in a terminal
##          window to get responses from the URL.
##
## METHOD: Uses 'zenity' to prompt for the URL.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this Nautilus script to run
##             (name above).
##
###########################################################################
## Created: 2011may23
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################


## FOR TESTING: (show statements as they execute)
#  set -x


##################################################
## Prompt for a URL (or IP address), using zenity.
##################################################

URLNAME=""

URLNAME=$(zenity --entry \
   --title "Enter a URL, for 'ping'." \
   --text "\
Enter a URL name (or IP address), for 'ping' to check for responses.
Examples:
      www.google.com  OR   www.cox.net  OR  68.10.14.65" \
   --entry-text "www.google.com")

if test "$URLNAME" = ""
then
   exit
fi


#######################################################
## Run 'ping -c5' in a terminal window.
#######################################################

xterm -title "ping $URLNAME." \
      -bg white -fg black -hold -geometry 85x15+10+25 \
      -e ping -c5 $URLNAME

#         -sb -leftbar -sl 1000 \
