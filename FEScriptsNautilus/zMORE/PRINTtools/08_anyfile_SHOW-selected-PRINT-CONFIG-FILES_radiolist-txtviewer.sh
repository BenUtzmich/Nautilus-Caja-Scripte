#!/bin/sh
##
## NAUTILUS
## SCRIPT: 08_anyfile_SHOW-selected_PRINT-CONFIG-FILES_radiolist-txtviewer.sh
##
## PURPOSE: Show selected print configuration files.
##          Usually these are files ending in '.conf' or 'cap'.
##          Examples: /etc/cups/printers.conf  /etc/printcap
##
## METHOD:  Uses a 'zenity --list --radiolist' prompt to present a list
##          of selected config files to show.
##
##          Uses a textfile viewer of the user's choice to display the
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
## Created: 2011amy23 Based on 00_show_BOOT-ETC_CONFIGfiles.sh
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################


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
   --title "Which PRINT config file to show?" \
   --height 400 \
   --text "\
Choose a configuration file to show.
  (You can edit this script to change or add files.
   There are about 400 '.conf' files under /etc.)" \
   --column "Pick1" --column "Filename" \
   /etc/cups/printers.conf /etc/cups/printers.conf \
   /etc/printcap        /etc/printcap \
   /etc/cups/cupsd.conf /etc/cups/cupsd.conf \
   /etc/cups/cupsd.conf.default /etc/cups/cupsd.conf.default \
   /etc/cups/mime.types /etc/cups/mime.types \
   /etc/cups/mime.convs /etc/cups/mime.convs \
   /etc/cups/raw.types  /etc/cups/raw.types \
   /etc/cups/raw.convs  /etc/cups/raw.convs \
   /etc/cups/pdftops    /etc/cups/pdftops \
   /etc/cups/snmp.conf  /etc/cups/snmp.conf \
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
