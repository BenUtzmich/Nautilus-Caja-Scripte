#!/bin/sh
##
## NAUTILUS
## SCRIPT: 06_anyfile_SHOW_GNUPLOT-INFO_WEB-PAGES_html-viewer.sh
##
## PURPOSE: Show various 'gnuplot' web pages --- pages such as
##          the 'gnuplot' home page and pages that contain gnuplot
##          command examples.
##
## METHOD:  Uses a 'zenity --radiolist' prompt to present a list
##          of web pages to show.
##
##          Shows the selected web page(s) in an html-viewer of the
##          user's choice.
##
## HOW TO USE: 
##         1) In Nautilus, select ANY file in ANY directory.
##            (Note that the selected file and the Nautilus current
##            directory are not used by this script.
##            This is simply a way to get to the Nautilus 'Scripts' menu.)
##         2) Then right-click and choose this script to run (name above).
##            This script is in the 'PLOTtools' group.
##
##########################################################################
## Created: 2011jun20
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################


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
   --title "Which GNUPLOT web page to show?" \
   --height=400 \
   --text "\
Choose $ANOTHER GNUPLOT web page to show. Or Cancel.
  (You can edit this script to change or add site pages.)

Web pages are shown in your default 'feNautilusScripts' web browser,
set in the HTMLVIEWER var of the '.set_VIEWERvars.shi' include script." \
   --column "Pick1" --column "Web page" \
   "gnuplot Home page at gnuplot.info" "http://www.gnuplot.info" \
   "gnuplot examples at sourceforge.net" "http://gnuplot.sourceforge.net/demo/"  \
   "gnuplot FAQ page at lanl.gov" "http://t16web.lanl.gov/Kawano/gnuplot/index-e.html" \
   "gnuplot examples at lanl.gov" "http://t16web.lanl.gov/Kawano/gnuplot/gallery/index-e.html" \
   "gnuplot 4.4 manual, PDF file @ home page" "http://www.gnuplot.info/docs_4.4/gnuplot.pdf" \
   "gnuplot 4.2 manual, HTML pages @ home page" "http://www.gnuplot.info/docs_4.2/gnuplot.html" \
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
## END of while prompting loop.
