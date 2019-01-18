#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_anyfile_SHOW_selected_BOOT-or-ETC_CONFIG-FILES_radiolist-txtviewer.sh
##
## PURPOSE: Show selected configuration files under /etc and /boot.
##
##          Usually these are files ending in '.conf' or '.cfg'.
##          Examples: /etc/X11/xorg.conf  /boot/grub/grub.cfg
##
## METHOD:  Uses a 'zenity --radiolist' prompt to present a list
##          of selected config files to show.
##
##          Uses a text-viewer of the user's choice to display the
##          user-selected text file.
##
## HOW TO USE: 
##         1) In Nautilus, select ANY file in ANY directory.
##            (Note that the selected file and the
##            Nautilus current directory are not used by this script.
##            This is simply a way to get to the Nautilus 'Scripts' menu.)
##         2) Then right-click and choose this script to run (name above).
##
##########################################################################
## Script
## Created: 2011apr28
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012apr18 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
##########################################################################

## FOR TESTING: (show statements as they execute, in a terminal window)
#   set -x


########################################
## zenity prompt for a config file
## -- in a while loop.
########################################

while :
do

   SHOWFILE=""

   SHOWFILE=$(zenity --list --radiolist \
      --title "Which config file to show?" \
      --height=500 \
      --text "\
Choose a configuration file to show.
  (You can edit this script to change or add files.
   There are about 400 '.conf' files under /etc.)" \
      --column "Pick1" --column "Filename" \
      /boot/grub/grub.cfg /boot/grub/grub.cfg \
      /etc/NetworkManager/nm-system-settings.conf /etc/NetworkManager/nm-system-settings.conf \
      /etc/X11/xorg.conf /etc/X11/xorg.conf \
      /etc/X11/Xsession.d/55gnome-session_gnomerc /etc/X11/Xsession.d/55gnome-session_gnomerc \
      /etc/X11/xinit/xinitrc /etc/X11/xinit/xinitrc \
      /etc/aliases /etc/aliases \
      /etc/apt/sources.list /etc/apt/sources.list \
      /etc/bash.bashrc /etc/bash.bashrc \
      /etc/crontab /etc/crontab \
      /etc/debconf.conf /etc/debconf.conf \
      /etc/dpkg/dpkg.cfg /etc/dpkg/dpkg.cfg \
      /etc/fonts/fonts.conf   /etc/fonts/fonts.conf \
      /etc/fstab /etc/fstab \
      /etc/host.conf /etc/host.conf \
      /etc/hostname /etc/hostname \
      /etc/hosts /etc/hosts \
      /etc/hp/hplip.conf /etc/hp/hplip.conf \
      /etc/inetd.conf /etc/inetd.conf \
      /etc/mailcap /etc/mailcap \
      /etc/mplayer/mplayer.conf /etc/mplayer/mplayer.conf \
      /etc/modules /etc/modules \
      /etc/netscsid.conf /etc/netscsid.conf \
      /etc/networks /etc/networks \
      /etc/nsswitch.conf /etc/nsswitch.conf \
      /etc/openoffice/psprint.conf /etc/openoffice/psprint.conf \
      /etc/passwd /etc/passwd \
      /etc/printcap /etc/printcap \
      /etc/profile /etc/profile \
      /etc/pulse/client.conf /etc/pulse/client.conf \
      /etc/pulse/daemon.conf /etc/pulse/daemon.conf \
      /etc/resolv.conf /etc/resolv.conf \
      /etc/rsyslog.conf /etc/rsyslog.conf \
      /etc/samba/smb.conf /etc/samba/smb.conf \
      /etc/sensors.conf /etc/sensors.conf \
      /etc/services /etc/services \
      /etc/sysctl.conf /etc/sysctl.conf \
      /etc/udev/udev.conf /etc/udev/udev.conf \
      /etc/ufw/ufw.conf /etc/ufw/ufw.conf \
      /etc/wgetrc /etc/wgetrc \
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
