#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_anyfile_show_VIDEO_WEB-PAGES_html-viewer.sh
##
## PURPOSE: Show various VIDEO web pages in a user-selected web browser.
##
## METHOD:  Uses a 'zenity --list --radiolist' prompt to present a list
##          of web pages to show.
##
##          Shows the selected URL using a web browser of the user's choice.
##
## HOW TO USE: 
##         1) In Nautilus, select ANY file in ANY directory.
##             (Note that the selected file and the Nautilus current 
##             directory are not used by this script.
##             This is simply a way to get to the Nautilus 'Scripts' menu.)
##         2) Then right-click and choose this script to run (name above).
##            It is in the 'VIDEOtools' group.
##
##########################################################################
## Created: 2011jun27
## Changed: 2012may14 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################


## FOR TESTING: (show statements as they execute, in a terminal window)
#   set -x


########################################
## zenity prompt for a webpage URL
## -- in a while loop.
########################################

## Set the a-or-ANOTHER word in the prompt.
ANOTHER="a"

# while true
while :
do

   SHOWPAGE=""

   SHOWPAGE=$(zenity --list --radiolist \
   --title "Which VIDEO web page to show?" \
   --height=400 \
   --text "\
Choose $ANOTHER VIDEO web page to show. Or Cancel.
  (You can edit this script to change or add site pages.)

Web pages are shown in your default 'feNautilusScripts' web browser,
set in the HTMLVIEWER var of the '.set_VIEWERvars.shi' include script." \
   --column "Pick1" --column "Web page" \
   "forum.videohelp.com" "http://forum.videohelp.com" \
   "www.videohelp.com" "http://www.videohelp.com" \
   "wiki.videolan.org" "http://wiki.videolan.org" \
   "ffmpeg.org" "http://ffmpeg.org"
)
 
   if test "$SHOWPAGE" = ""
   then
      exit
   fi

   #################################
   ## Show the selected URL.
   #################################

   ## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

   . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
   . $DIR_NautilusScripts/.set_VIEWERvars.shi

   $HTMLVIEWER "$SHOWPAGE"

   ANOTHER="ANOTHER"

done
## END OF 'while' loop.
