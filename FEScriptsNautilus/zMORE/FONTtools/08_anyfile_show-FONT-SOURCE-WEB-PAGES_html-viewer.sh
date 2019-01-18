#!/bin/sh
##
## NAUTILUS
## SCRIPT: 08_anyfile_show_FONT-ARCHIVE_WEB-PAGES_html-viewer.sh
##
## PURPOSE: Show various web pages that are sources of fonts ---
##          esp. scalable fonts such as TrueType fonts.
##
## METHOD:  Uses a 'zenity --radiolist' prompt to present a list
##          of web pages to show.
##
##          The 'zenity' prompt is in a 'while' loop, so that the
##          user can quickly try more than one web site.
##
##          Shows each selected web page in an html-viewer of the
##          user's choice.
##
## HOW TO USE: 
##         1) In Nautilus, select ANY file in ANY directory.
##            (Note that the selected file and the
##            Nautilus current directory are not used by this script.
##            This is simply a way to get to the Nautilus 'Scripts' menu.)
##         2) Then right-click and choose this script to run (name above).
##            It is in the 'FONTtools' group of the 'zMORE' group.
##
###########################################################################
## Script
## Created: 2011jun27
## Changed: 2012apr18 Changed script name in comments above and touched up
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
      --title "Which FONT web page to show?" \
      --height=400 \
      --text "\
Choose $ANOTHER FONT web page to show. Or Cancel.
  (You can edit this script to change or add site pages.)

Web pages are shown in your preferred 'feNautilusScripts' web browser,
set in the HTMLVIEWER var of the '.set_VIEWERvars.shi' include script." \
      --column "Pick1" --column "Web page" \
      "www.webpublicity.com" "http://www.webpublicity.com" \
      "dafont.com" "http://dafont.com" \
      "www.1001freefonts.com" "http://www.1001freefonts.com" \
      "fontconfig.org" "http://fontconfig.org" \
      "www.wadfonts.com" "http://www.wadfonts.com"
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
