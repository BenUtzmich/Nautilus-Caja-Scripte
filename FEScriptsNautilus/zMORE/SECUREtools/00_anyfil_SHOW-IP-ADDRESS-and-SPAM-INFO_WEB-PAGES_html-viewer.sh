#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_anyfil_SHO_IP-ADDRESS-and_SPAM-INFO_WEB-PAGES_html-viewer.sh
##
## PURPOSE: Show IP-address-info, spam-info, and various web-security
##          web pages --- pages such as the IP-address-assigners home pages
##          and pages that contain email/web-browsing security info.
##
## METHOD:  Uses a 'zenity --radiolist' prompt to present a list
##          of web pages to show.
##
##          Shows each user-selected web page in an HTML (web) browser
##          of the user's choice.
##
## HOW TO USE: 
##         1) In Nautilus, select ANY file in ANY directory.
##            (Note that the selected file and the Nautilus current
##            directory are not used by this script.
##            This is simply a way to get to the Nautilus 'Scripts' menu.)
##         2) Then right-click and choose this script to run (name above).
##            It is in the 'SECUREtools' group of 'zMORE'.
##
##########################################################################
## Created: 2011jun27
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
##########################################################################

## FOR TESTING: (show statements as they execute, in a terminal window)
#   set -x


########################################
## zenity prompt for a webpage
## -- in a while loop.
########################################

## Set the a-or-ANOTHER word in the prompt.
ANOTHER="a"

while :
do

   SHOWPAGE=""

   SHOWPAGE=$(zenity --list --radiolist \
   --title "Which WEB-SECURITY/IP-address web page to show?" \
   --height=400 \
   --text "\
Choose $ANOTHER web-security web page to show. Or Cancel.
  (You can edit this script to change or add site pages.)

Web pages are shown in your default 'feNautilusScripts' web browser,
set in the HTMLVIEWER var of the '.set_VIEWERvars.shi' include script." \
   --column "Pick1" --column "Web page" \
   "ICANN.org" "http://www.icann.org"  \
   "IANA.org" "http://www.iana.org"  \
   "APNIC.net" "http://www.apnic.net"  \
   "RIPE.net" "http://www.ripe.net"  \
   "ARIN.net" "http://ws.arin.net"  \
   "SamSpade.org" "http://samspade.org" \
   "spamcop.net" "http://www.spamcop.net"  \
   "ipaddressguide.com" "http://www.ipaddressguide.com"  \
   "spamlinks.net" "http://spamlinks.net"
   )
 
   if test "$SHOWPAGE" = ""
   then
      exit
   fi

   #################################
   ## Show the selected file.
   #################################

   ## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

   . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
   . $DIR_NautilusScripts/.set_VIEWERvars.shi

   $HTMLVIEWER "$SHOWPAGE"

   ANOTHER="ANOTHER"

done
## END of while prompting loop.
