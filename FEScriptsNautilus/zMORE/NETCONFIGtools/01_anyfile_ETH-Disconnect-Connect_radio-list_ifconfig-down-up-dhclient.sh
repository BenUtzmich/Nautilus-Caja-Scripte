#!/bin/sh
##
## NAUTILUS
## SCRIPT: 01_anyfile_ETH-Disconnect-Connect_radiolist_ifconfig-down-up-dhclient.sh
##
## PURPOSE: Switches a user-specified ethernet connection (eth0 or eth1 ---
##          or other) between connected and dis-connected.
##
## METHOD:  Uses a 'zenity --radiolist' prompt to present a list
##          of ethernet interface options --- for eth0 or eth1 (or add your own).
##          Example options:
##                  eth0-CONNECT, eth0-DISCONNECT, eth1-CONNECT, eth1-DISCONNECT
##
##          Uses 'sudo ifconfig' to do the disconnect --- and 
##          'sudo ifconfig' and 'sudo dhclient' to do the connect.
##
##          These commands are issued in an 'xterm' so that the user
##          can supply a root password.
##
## HOW TO USE: 
##         1) In Nautilus, select ANY file in ANY directory.
##            (Note that the selected file and the Nautilus current
##            directory are not used by this script.
##            This is simply a way to get to the Nautilus 'Scripts' menu.)
##         2) Then right-click and choose this script to run (name above).
##
## REFERENCES: 'man ifconfig' , 'man dhclient' and ...
##   http://www.linuxforums.org/forum/newbie/62488-how-connect-disconnect-eth0-command-line.html
##   http://www.backtrack-linux.org/forums/showthread.php?t=209
##   http://knoppix.net/forum/threads/29083-Can-we-speed-up-Network-Manager
##   http://ubuntuforums.org/showthread.php?t=684495
##   http://blog.nightworkers.net/
##
##############################################################################
## Created: 2012mar20 Based on an XWINconfig '..._xrandr.sh' script.
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################


## FOR TESTING: (show statements as they execute, in a terminal window)
#   set -x


#########################################################
## Set the variable 'DIR_NautilusScripts' --- for
## use below in calling a script from the '.util_scripts'
## subdirectory under DIR_NautilusScripts.
#########################################################

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi


#############################################
## zenity prompt for a ethernet interface
## and connection option (connect/disconnect)
## --- in a while loop.
#############################################

while :
do

   ETH_OPT=""

   ETH_OPT=$(zenity --list --radiolist \
   --title "Which Ethernet Interface and Connection-option?" \
   --height 425 \
   --text "\
Choose (1) an ethernet interface and (2) connect or disconnect ---
via the options below.

An 'xterm' will popup to ask for a password, and show the command(s)
as they execute.
You can close the 'xterm' window after the network command(s) execute.
Or, you can issue the 'ifconfig' command to query the interface status
--- example: to see if an IP address is assigned --- or use 'ping'.

      This prompt is in a while loop. You can click 'Cancel' or
      close this window to exit this prompting loop.

   (You can edit this script to change/add ethernet interface names or
    commands and command options.)" \
   --column "Pick1" --column "OPTION" \
   NO  eth0-CONNECT \
   NO  eth0-DISCONNECT \
   NO  eth1-CONNECT \
   NO  eth1-DISCONNECT
)
 
   if test "$ETH_OPT" = ""
   then
      exit
   fi

   if test "$ETH_OPT" = "eth0-CONNECT"
   then
      xterm -hold -fg white -bg black \
            -title "eth0 CONNECT -via- ifconfig eth0 up" -e \
            $DIR_NautilusScripts/.util_scripts/passCmds2term_thenStartSh.sh \
            "sudo ifconfig -v eth0 up ; sudo dhclient eth0"
   fi

   if test "$ETH_OPT" = "eth0-DISCONNECT"
   then
      xterm -hold -fg white -bg black \
            -title "eth0 DISCONNECT -via- ifconfig eth0 down" -e \
            $DIR_NautilusScripts/.util_scripts/passCmds2term_thenStartSh.sh \
            sudo ifconfig -v eth0 down
   fi

   if test "$ETH_OPT" = "eth1-CONNECT"
   then
      xterm -hold -fg white -bg black \
            -title "eth1 CONNECT -via- ifconfig eth1 up" -e \
            $DIR_NautilusScripts/.util_scripts/passCmds2term_thenStartSh.sh \
            "sudo ifconfig -v eth1 up ; sudo dhclient eth1"
   fi

   if test "$ETH_OPT" = "eth1-DISCONNECT"
   then
      xterm -hold -fg white -bg black \
            -title "eth1 DISCONNECT -via- ifconfig eth1 down" -e \
            $DIR_NautilusScripts/.util_scripts/passCmds2term_thenStartSh.sh \
            sudo ifconfig -v eth1 down
   fi

done
## END of while prompting loop.
