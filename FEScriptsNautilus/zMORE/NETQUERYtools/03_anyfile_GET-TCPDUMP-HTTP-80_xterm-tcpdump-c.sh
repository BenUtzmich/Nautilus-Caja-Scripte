#!/bin/sh
##
## Nautilus
## SCRIPT: 03_anyfile_GET-TCPDUMP-HTTP-80_xterm-tcpdump-c.sh
##
## PURPOSE: Runs the 'tcpdump' command to get host source-destination
##          info for HTTP (port 80/http) packets thru a user-specified
##          network interface of 'this' host.
##
## METHOD: Uses 'zenity' to prompt for a network interface and 'zenity'
##         again to prompt for how much info (N packets) to collect.
##
##         Runs 'sudo tcpdmp' with appropriate parameters in an
##         'xterm' terminal.
##
##         Shows the 'tcpdump' output in the 'xterm' terminal.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this Nautilus script to run
##             (name above).
##
######################################################################
## Created: 2015jan26
## Changed: 2015
#######################################################################

## FOR TESTING: (show statements as they execute)
# set -x

##############################################
## Prompt for the network interface.
##############################################

IFACE=""

IFACE=$(zenity --entry \
   --title "Enter Network Interface (eth0, wlan0, ...)." \
   --text "\
Enter a network interface ID.
Examples:  eth0    OR    eth1    OR    wlan0" \
   --entry-text "eth0")

if test "$IFACE" = ""
then
   exit
fi


##############################################
## Prompt for the number of packets to collect.
##############################################

COUNT=""

COUNT=$(zenity --entry \
   --title "Maximum NUMBER of PACKETS to collect." \
   --text "\
Enter MAXIMUM NUMBER of PACKETS to collect.
Examples:  50  -OR-  200

In the following 'xterm' window, enter Ctl-c to stop the
collection of packets at any time." \
   --entry-text "150")

if test "$COUNT" = ""
then
   exit
fi



#####################################################
## Prepare the (binary) 'capture' output file.
##
## Since the user may not have write-permission on the
## current directory (and to avoid accumulation of large
## files in directories that are not auto-cleaned),
## put the file in /tmp.
#####################################################

# CAPFILE="${USER}_temp_tcpdump_HTTP-80.cap"

# CAPFILE="/tmp/$CAPFILE"


# if test -f "$CAPFILE"
# then
#   rm -f "$CAPFILE"
# fi


#######################################################
## Get the 'tcpdump' output.
#######################################################
## Some possible 'expressions' to use:
##
## To print traffic neither sourced from nor destined for local hosts  (if
## you gateway to one other net, this stuff should never make it onto your
## local net).
##
##	   tcpdump ip and not net localnet
##
## To print the start and end packets (the SYN and FIN  packets)  of  each
## TCP conversation that involves a non-local host.
##
##	   tcpdump 'tcp[tcpflags] & (tcp-syn|tcp-fin) != 0 and not src and dst net localnet'
##
## To  print  all  IPv4  HTTP packets to and from port 80, i.e. print only
## packets that contain data, not, for example, SYN and  FIN  packets  and
## ACK-only packets.  (IPv6 is left as an exercise for the reader.)
##
##	   tcpdump 'tcp port 80 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)'
##
##-----
## FROM: http://ftp3.usa.openbsd.org/pub/OpenBSD/src/usr.sbin/tcpdump/tcpdump.8
##
## To print only the SYN packets of HTTP connections:
##
##     tcpdump 'tcp[tcpflags] = tcp-syn and port http'
##
############################################################

xterm -fg white -bg black -geometry 100x80+350+30 -hold \
      -title "sudo tcpdump -i $IFACE  -c $COUNT ... ; Enter passwd." \
      -e sudo tcpdump -i $IFACE  -c $COUNT  -l -A -q \
         'tcp[tcpflags] = tcp-syn and port http'
