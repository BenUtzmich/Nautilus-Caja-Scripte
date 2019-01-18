#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_anyfile_SHOW_selected_SYSTEM-MAIL-CONFIG-FILES_txtviewer.sh
##
## PURPOSE: Show selected MAIL configuration files.
##          Usually these are files ending in '.conf' or 'cap'.
##          Examples: /etc/mailcap
##
## METHOD:  Uses a 'zenity --radiolist' prompt to present a list
##          of mail config files to show.
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
## Created: 2011amy23 Based on 00_show_PRINT_CONFIGfiles.sh
## Changed: 2011may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
##########################################################################


## FOR TESTING: (show statements as they execute, in a terminal window)
#   set -x

########################################
## zenity prompt for a config file
## --- in a while loop.
########################################

while :
do

   SHOWFILE=""

   SHOWFILE=$(zenity --list --radiolist \
   --title "Which MAIL config file to show?" \
   --height 400 \
   --text "\
Choose a configuration file to show.
  (You can edit this script to change or add files.
   There are about 400 '.conf' files under /etc.)" \
   --column "Pick1" --column "Filename" \
   /etc/mail.rc         /etc/mail.rc \
   /etc/mailcap         /etc/mailcap \
   /etc/mailcap.order   /etc/mailcap.order \
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
