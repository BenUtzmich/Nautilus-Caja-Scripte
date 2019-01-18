#!/bin/sh
##
## NAUTILUS
## SCRIPT: 08_anyfile_show_LINUX_HOWTO_WEB-PAGES.sh
##
## PURPOSE: Show various Linux HOWTO web pages
##          in a user-selected web browser.
##
##          These pages/sites may go dead at a fairly high rate
##          (several per year), so this script may need to be
##          updated several times per year to be fairly current.
##
## METHOD:  Uses a 'zenity --radiolist' prompt to present a list
##          of web pages to show.
##
##          Goes to the selected URL using an HTML-viewer of the
##          user's choice.
##
## HOW TO USE: 
##         1) Click on the name of any file (or directory) in a Nautilus
##            directory list. (Note that the selected file and the
##            Nautilus current directory are not used by this script.
##            This is simply a way to get to the Nautilus 'Scripts' menu.)
##         2) Then right-click and choose this script to run (name above).
##            It is in the 'LinuxHOWTOS' group.
##
## Created: 2011jun27
## Changed: 2012feb29 Changed the script name in the comment above.


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
   --title "Which LINUX HOWTO web page to show?" \
   --height=400 \
   --text "\
Choose $ANOTHER linux-HOWTO web page to show. Or Cancel.
  (You can edit this script to change or add site pages.)

Web pages are shown in your default 'feNautilusScripts' web browser,
set in the HTMLVIEWER var of the '.set_VIEWERvars.shi' include script." \
   --column "Pick1" --column "Web page" \
   "www.howtoforge.com" "http://www.howtoforge.com" \
   "ubuntuguide.org" "http://ubuntuguide.org" \
   "www.howtogeek.com" "http://www.howtogeek.com" \
   "tuxtweaks.com" "http://tuxtweaks.com" \
   "www.linux-archive.org" "http://www.linux-archive.org" \
   "www.brighthub.com/hubfolio/" "http://www.brighthub.com/hubfolio/" \
   "www.commandlinefu.com" "http://www.commandlinefu.com" \
   "www.ehow.com (ads, slow)" "http://www.ehow.com"
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
## END OF LOOP:   while :
