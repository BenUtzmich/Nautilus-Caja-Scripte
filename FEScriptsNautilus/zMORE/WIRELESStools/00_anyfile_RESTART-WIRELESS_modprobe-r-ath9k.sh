#!/bin/sh
##
## Nautilus
## Script: 00_anyfile_RESTART-WIRELESS_modprobe-r-ath9k.sh
##
## PURPOSE: Stops and restarts the 'ath9k' wireless driver.
##
## METHOD: Uses
##              sudo /sbin/modprobe -r ath9k
##         and
##              sudo /sbin/modprobe ath9k
##         to remove and restart the 'ath9k' kernel module.
##
##         NOTE: If your wireless is using a different driver, this
##               script will not work for you. 
##
## The 'lspci' command on an Acer netbook computer with an Intel N450
## processor shows
##     Network controller: Atheros Communications Inc. AR9285
##                         Wireless Network Adapter (PCI-Express)
##
## So this utility script will probably work for laptops with that
## wireless card.
##
## I find that my netbook loses the wireless connection in my house sometimes
## and the gnome network applet 'hangs' when I try to reconnect.
##
## This restart utility allows me to use the gnome network applet
## successfully, after a restart of this type.
##
##
## HOW TO USE: 
##         1) In Nautilus, select ANY file in ANY directory.
##             (Note that the selected file and the Nautilus current
##              directory are not used by this script.
##              This is simply a way to get to the Nautilus 'Scripts' menu.)
##         2) Then right-click and choose this script to run (name above).
##
##------------------------------------------------------------------------
## REFERENCES:
##    http://askubuntu.com/questions/67280/wireless-doesnt-connect-after-suspend-on-an-asus-k52f
##    http://ubuntuforums.org/archive/index.php/t-1840637.html
## and
##    http://ubuntuforums.org/archive/index.php/t-1813808.html
## A possible alternative:
##   The latter reference mentions doing:
##     sudo gedit /etc/modprobe.d/ath9k.conf
##     Add one line: options ath9k nohwcrypt=1
##
##   It also says:
##     Is your network set to WPA and WPA2 mixed mode?
##     That is often troublesome. If you can, try WPA2 only.
##
#######################################################################
## Created: 2011nov14 as a non-Nautilus script
## Changed: 2012mar18 Converted to a Nautilus script.
## Changed: 2012may12 Touched up some comments above and below.
## Changed: 2012jun23 Added 'zenity --info' popup to let the user know
##                    that it is OK to restart the wireless connection.
#######################################################################

gksu /sbin/modprobe -r ath9k

gksu /sbin/modprobe ath9k


########################################
## Indicate to the user what to do next.
########################################

HOST_ID=`hostname`

zenity --info \
   --title "Ready to restart Atheros wireless connection." \
   --text "\
The commands
     /sbin/modprobe -r ath9k
and
     /sbin/modprobe ath9k
have been performed.

The wireless driver was removed from memory and re-inserted.
This should have taken the wireless connection down.

You can now try restarting the wireless connection via
your Network Management app.
"

exit

#####################################################################
## One could use an 'xterm' technique like the following, to indicate
## the commands being executed and to show messages, if any,
## in the 'xterm'.
##    I could use a utility script to pass both commands to
##    a single xterm.
## This is an option if 'gksu' is not on the system.
####################################################################

xterm -fg white -bg black -hold -title "sudo /sbin/modprobe -r ath9k" \
      -e sudo /sbin/modprobe -r ath9k

## Some alternatives to the command above (?):
# xterm -fg white -bg black -hold -e sudo rmmod -f ath9k
# xterm -fg white -bg black -hold -e sudo /sbin/rmmod ath9k


xterm -fg white -bg black -hold -title "sudo /sbin/modprobe ath9k" \
      -e sudo /sbin/modprobe ath9k

## An alternative to the command above (?):
# xterm -fg white -bg black -hold -e sudo modprobe ath9k nohwcrypt=1
