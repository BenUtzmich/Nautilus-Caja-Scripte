#!/bin/sh
##
## NAUTILUS
## SCRIPT: 08_anyfile_show_DISTRO_WIKI_WEB-PAGES.sh
##
## PURPOSE: Show various Linux DISTRO WIKI web pages
##          in a user-selected web browser.
##
##          These pages/sites may go dead at a fairly high rate
##          (several per year), so this script may need to be
##          updated several times per year to be fairly current.
##
##          Uses a 'zenity --radiolist' prompt to present a list
##          of web pages to show.
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
   --title "Which LINUX DISTRO WIKI web page to show?" \
   --height=400 \
   --text "\
Choose $ANOTHER linux-DISTRO WIKI web page to show. Or Cancel.
  (You can edit this script to change or add site pages.)

Distro wikis are often sources of documentation and how-to's.

Web pages are shown in your default 'feNautilusScripts' web browser,
set in the HTMLVIEWER var of the '.set_VIEWERvars.shi' include script." \
   --column "Pick1" --column "Web page" \
   "wiki.ubuntu.com" "http://wiki.ubuntu.com"  \
   "wiki.archlinux.org" "http://wiki.archlinux.org"  \
   "en.gentoo-wiki.com" "http://en.gentoo-wiki.com"  \
   "www.thinkwiki.org" "http://www.thinkwiki.org"  \
   "wiki.cchtml.com" "http://wiki.cchtml.com"
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
## END OF LOOP:  while :
