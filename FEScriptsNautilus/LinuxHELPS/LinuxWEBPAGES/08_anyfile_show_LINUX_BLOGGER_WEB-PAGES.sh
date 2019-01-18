#!/bin/sh
##
## NAUTILUS
## SCRIPT: 08_anyfile_show_LINUX_BLOGGER_WEB-PAGES.sh
##
## PURPOSE: Show various Linux blogger web pages
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
##            It is in the 'LinuxHELPS' group.
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
   --title "Which LINUX BLOGGER web page to show?" \
   --height=400 \
   --text "\
Choose $ANOTHER linux-blogger web page to show. Or Cancel.
  (You can edit this script to change or add site pages.)

Web pages are shown in your default 'feNautilusScripts' web browser,
set in the HTMLVIEWER var of the '.set_VIEWERvars.shi' include script." \
   --column "Pick1" --column "Web page" \
   "markthecarp.net" "http://www.markthecarp.net" \
   "movingtofreedom.org" "http://movingtofreedom.org" \
   "www.omgubuntu.co.uk" "http://www.omgubuntu.co.uk" \
   "ubuntugeek.com" "http://www.ubuntugeek.com" \
   "blog.linuxmint.com" "http://blog.linuxmint.com" \
   "ubuntuvibes.com" "http://ubuntuvibes.com" \
   "blogs.gnome.org" "http://blogs.gnome.org" \
   "productivelinux.com" "http://productivelinux.com" \
   "techdrivein.com" "http://www.techdrivein.com" \
   "blog.twinapex.fi" "http://blog.twinapex.fi" \
   "newton.freehostia.com" "http://newton.freehostia.com" \
   "n0t3s.wordpress.com" "http://n0t3s.wordpress.com" \
   "linux-update.blogspot.com" "http://linux-update.blogspot.com" \
   "mygeekopinions.blogspot.com" "http://mygeekopinions.blogspot.com"
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
