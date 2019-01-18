#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_anyfile_SHOW_SYSTEM-MOUNT-TABLES_txtviewer.sh
##
## PURPOSE: Show selected 'mount' files having to do with
##          storage partition mounts --- like files '/etc/fstab'
##          and '/etc/mtab'.
##
## METHOD:  Uses a 'zenity --radiolist' prompt to present a list
##          of selected 'mount' files to show.
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
#########################################################################
## Created: 2012apr07
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
## Changed: 2012jun25 Changed script name from FILES to TABLES.
#######################################################################


## FOR TESTING: (show statements as they execute, in a terminal window)
#   set -x

########################################
## zenity prompt for a 'mount' file
## -- in a while loop.
########################################

while :
do

   SHOWFILE=""

   SHOWFILE=$(zenity --list --radiolist \
   --title "Which 'mount' file to show?" \
   --height=500 \
   --text "\
Choose a 'mount' file to show.
  (You can edit this script to change or add files.)" \
   --column "Pick1" --column "Filename" \
   NO /etc/fstab \
   NO /etc/mtab \
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
