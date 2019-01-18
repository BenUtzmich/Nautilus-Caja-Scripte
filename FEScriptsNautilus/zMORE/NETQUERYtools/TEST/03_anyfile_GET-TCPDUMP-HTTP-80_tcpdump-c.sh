#!/bin/sh
##
## Nautilus
## SCRIPT: 05_anyfile_GET-TCPDUMP-HTTP-80_tcpdump-c.sh
##
## PURPOSE: Runs the 'tcpdump' command to get host source-destination
##          info for HTTP (port 80) packets thru a user-specified
##          network interface of 'this' host.
##
## METHOD: Uses 'zenity' to prompt for a network interface and 'zenity'
##         again to prompt for how much info to collect.
##
##         Runs 'tcpdmp' with appropriate parameters.
##
##         Shows the 'tcpdump' output in a text-viewer of the user's
##         choice.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this Nautilus script to run
##             (name above).
##
######################################################################
## Created: 2014nov30
## Changed: 2014
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
   --entry-text "wlan0")

if test "$IFACE" = ""
then
   exit
fi


##############################################
## Prompt for the number of packets to collect.
##############################################

COUNT=""

COUNT=$(zenity --entry \
   --title "Enter NUMBER of PACKETS to collect." \
   --text "\
Enter NUMBER of PACKETS to collect.
Examples:  200  -OR-  1000" \
   --entry-text "200")

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

CAPFILE="${USER}_temp_tcpdump_HTTP-80.cap"

CAPFILE="/tmp/$CAPFILE"


if test -f "$CAPFILE"
then
  rm -f "$CAPFILE"
fi


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
##
############################################################

xterm -fg white -bg black -hold \
      -title "sudo tcpdump -i $IFACE  -c $COUNT ... ; Enter passwd." \
      -e sudo tcpdump -i $IFACE  -c $COUNT  -w "$CAPFILE" \
         'ip and not net localnet'

## 'tcp port 80'


#####################################################
## Prepare the text output file, for output from
## 'tcpdump -r'.
##
## Since the user may not have write-permission on the
## current directory (and to avoid accumulation of large
## files in directories that are not auto-cleaned),
## put the file in /tmp.
#####################################################

OUTFILE="${USER}_temp_tcpdump_HTTP-80.txt"

OUTFILE="/tmp/$OUTFILE"


if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi



#####################################################
## Run 'tcpdump -r'.
#####################################################

xterm -fg white -bg black -hold \
      -title "sudo tcpdump -r ..." \
      -e sudo tcpdump -r "$CAPFILE" > "$OUTFILE"


###################
## Show the OUTFILE.
###################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE"
