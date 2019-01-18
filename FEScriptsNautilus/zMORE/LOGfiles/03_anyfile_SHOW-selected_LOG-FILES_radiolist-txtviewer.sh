#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_anyfile_SHOW_selected_LOG-FILES_radiolist-txviewer.sh
##
## PURPOSE: Show selected log files under /var.
##          Usually these are files ending in '.log'.
##          Examples:  /var/log/Xorg.0.log   /var/log/user.log
##
## METHOD:  Uses a 'zenity --radiolist' prompt to present a list
##          of selected config files to show.
##
##          Uses a text-viewer of the user's choice to display the
##          user-selected text file.
##
## HOW TO USE: 
##         1)  In Nautilus, select ANY file in ANY directory.
##             (Note that the selected file and the Nautilus current
##              directory are not used by this script.
##              This is simply a way to get to the Nautilus 'Scripts' menu.)
##         2) Then right-click and choose this script to run (name above).
##
#########################################################################
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
   --title "Which log file to show?" \
   --height=500 \
   --text "\
Choose a log file to show.
  (You can edit this script to change or add files.
   There are more than 50 '.log' files under /var,
   but many are compressed older ones.)" \
                --column "Pick1" --column "Filename" \
                /var/log/Xorg.0.log      /var/log/Xorg.0.log \
                /var/log/Xorg.0.log.old  /var/log/Xorg.0.log.old \
                /var/log/auth.log        /var/log/auth.log \
                /var/log/auth.log.1      /var/log/auth.log.1 \
                /var/log/daemon.log      /var/log/daemon.log \
                /var/log/daemon.log.1    /var/log/daemon.log.1 \
                /var/log/kern.log        /var/log/kern.log \
                /var/log/kern.log.1      /var/log/kern.log.1 \
                /var/log/lpr.log         /var/log/lpr.log \
                /var/log/lpr.log.1       /var/log/lpr.log.1 \
                /var/log/pm-powersave.log  /var/log/pm-powersave.log \
                /var/log/user.log          /var/log/user.log \
                /var/log/user.log.1        /var/log/user.log.1 \
                /var/log/cups/access_log   /var/log/cups/access_log \
                /var/log/cups/error_log    /var/log/cups/error_log \
                /var/log/cups/page_log     /var/log/cups/page_log \
                /var/log/debug             /var/log/debug \
                /var/log/debug.1           /var/log/debug.1 \
                /var/log/dkms_autoinstaller /var/log/dkms_autoinstaller \
                /var/log/dmesg             /var/log/dmesg \
                /var/log/dmesg.0           /var/log/dmesg.0 \
                /var/log/messages          /var/log/messages \
                /var/log/messages.1        /var/log/messages.1 \
                /var/log/syslog            /var/log/syslog \
                /var/log/syslog.1          /var/log/syslog.1 \
                /var/log/udev              /var/log/udev \
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
