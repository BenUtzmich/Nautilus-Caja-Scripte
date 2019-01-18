#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_anyfile_SHOW_selected_THUNDERBIRD-MAIL-FILES_txtviewer.sh
##
## PURPOSE: Show selected Thunderbird MAIL files ---
##          under $HOME/.mozilla-thunderbird/[8-scrambled-chars].default
##          Examples:   mimeTypes.rdf    abook.mab
##
## METHOD:  Uses a 'zenity --radiolist' prompt to present a list
##          of Thunderbird files to show.
##
##          Uses a text- of the user's choice to display the
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
## Created: 2011amy23 Based on 00_show_sysMAIL_CONFIGfiles.sh
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################


## FOR TESTING: (show statements as they execute, in a terminal window)
#   set -x

########################################
## zenity prompt for a Thunderbird file
## --- in a while loop.
########################################

DIR_TBIRD_DEFAULT=`ls $HOME/.mozilla-thunderbird/ | grep '.default$' | head -1`
DIR_TBIRD_DEFAULT="$HOME/.mozilla-thunderbird/$DIR_TBIRD_DEFAULT"

while :
do

   SHOWFILE=""

   SHOWFILE=$(zenity --list --radiolist \
   --title "Which Thunderbird MAIL config file to show?" \
   --width=550 \
   --height=400 \
   --text "\
Choose a configuration file to show.
  (You can edit this script to change or add files.)" \
   --column "Pick1" --column "Filename" \
   $DIR_TBIRD_DEFAULT/abook.mab       $DIR_TBIRD_DEFAULT/abook.mab \
   $DIR_TBIRD_DEFAULT/mimeTypes.rdf   $DIR_TBIRD_DEFAULT/mimeTypes.rdf \
   $DIR_TBIRD_DEFAULT/prefs.js        $DIR_TBIRD_DEFAULT/prefs.js \
   $DIR_TBIRD_DEFAULT/blocklist.xml   $DIR_TBIRD_DEFAULT/blocklist.xml \
   $DIR_TBIRD_DEFAULT/localstore.rdf  $DIR_TBIRD_DEFAULT/localstore.rdf \
   $DIR_TBIRD_DEFAULT/panacea.dat     $DIR_TBIRD_DEFAULT/panacea.dat \
   $DIR_TBIRD_DEFAULT/persdict.dat    $DIR_TBIRD_DEFAULT/persdict.dat \
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
