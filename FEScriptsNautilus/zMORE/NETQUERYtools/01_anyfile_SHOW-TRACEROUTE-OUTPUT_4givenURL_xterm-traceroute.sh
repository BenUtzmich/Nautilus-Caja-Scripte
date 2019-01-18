#!/bin/sh
##
## Nautilus
## SCRIPT: 01_anyfile_SHOW_TRACEROUTE-OUTPUT_4givenURL_xterm-traceroute.sh
##
## PURPOSE: Prompts the user for a URL and runs 'traceroute' in a terminal
##          window to eke out the 'hops'.
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
   --title "Enter a URL, for 'traceroute'." \
   --text "\
Enter a URL name (or IP address), for 'traceroute' to show intermediate 'hops'.
Examples:
      www.google.com  OR   www.cox.net  OR  68.10.14.65" \
   --entry-text "www.google.com")

if test "$URLNAME" = ""
then
   exit
fi


#######################################################
## Run 'traceroute' in a terminal window.
#######################################################

xterm -title "traceroute to $URLNAME." \
      -bg black -fg white -hold -geometry 80x40+0+25 \
      -e traceroute $URLNAME

#         -sb -leftbar -sl 1000 \
