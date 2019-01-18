#!/bin/sh
##
## Nautilus
## SCRIPT: 01_whois4url.sh
##
## PURPOSE: Prompts the user for a URL and runs 'whois' in a terminal
##          window to get responses from the URL.
##
## HOW TO USE: Right-click on the name of ANY file (or directory) in ANY Nautilus 
##             directory list. Then choose this Nautilus script (name above).
##
##
## Created: 2011may23
## Changed: 


## FOR TESTING: (show statements as they execute)
#  set -x


##################################################
## Prompt for a URL (or IP address), using zenity.
##################################################

    URLNAME=""
    URLNAME=$(zenity --entry --title "Enter a URL, for 'whois'." \
           --text "\
Enter a URL name (or IP address), for 'whois' to check for identity.
Examples:
      www.google.com  OR   www.cox.net  OR  68.10.14.65" \
           --entry-text "www.google.com")

    if test "$URLNAME" = ""
    then
       exit
    fi


#######################################################
## Run 'whois' in a terminal window.
#######################################################
## Alternatively, we could put the output in a /tmp
## file and show it with $TXTVIEWER.
#######################################################

   xterm -title "whois $URLNAME." \
         -bg white -fg black -hold -geometry 85x45+10+25 \
         -e whois $URLNAME

#         -sb -leftbar -sl 1000 \

   
