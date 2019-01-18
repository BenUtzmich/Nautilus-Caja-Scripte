#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_anyfile_SHOW_selected_SYSTEM-MAIL-LOG-FILES_txtviewer.sh
##
## PURPOSE: Show selected MAIL log files under /var.
##          Usually these are files ending in '.log'.
##          Examples: /var/log/mail.log  /var/log/mail.err
##
## METHOD:  Uses a 'zenity --radiolist' prompt to present a list
##          of selected config files to show.
##
##          Uses a text-viewer of the user's choice to display the
##          user-selected text file.
##
## HOW TO USE: 
##         1) In Nautilus, select ANY file in ANY directory.
##            (Note that the selected file and the Nautilus current
##            directory are not used by this script.
##            This is simply a way to get to the Nautilus 'Scripts' menu.)
##         2) Then right-click and choose this script to run (name above).
##
##########################################################################
## Created: 2011may23
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################


## FOR TESTING: (show statements as they execute, in a terminal window)
#   set -x


########################################
## zenity prompt for a log file
## --- in a while loop.
########################################

while :
do

   SHOWFILE=""

   SHOWFILE=$(zenity --list --radiolist \
   --title "Which mail log file to show?" \
   --height=500 \
   --text "\
Choose a log file to show.
  (You can edit this script to change or add files.)" \
   --column "Pick1" --column "Filename" \
   /var/log/mail.err    /var/log/mail.err \
   /var/log/mail.info   /var/log/mail.info \
   /var/log/mail.log    /var/log/mail.log \
   /var/log/mail.warn   /var/log/mail.warn \
   )
 
   if test "$SHOWFILE" = ""
   then
      exit
   fi


   #################################
   ## Show the selected file.
   #################################

   ## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

   . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
   . $DIR_NautilusScripts/.set_VIEWERvars.shi

   $TXTVIEWER "$SHOWFILE"

done
## END of while prompting loop.
