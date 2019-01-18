#!/bin/sh
##
## Nautilus
## SCRIPT: 02_anyfile_START-ETHERAPE_onIFACE_gksudo-etherape.sh
##
## PURPOSE: Runs an 'etherape -i' command, as root using gksudo,
##          to show network interface traffic to remote destinations,
##          dynamically.
##
## METHOD: Uses 'zenity' to prompt for an ethernet interface id, such as
##         eth0 or eth1.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this Nautilus script to run
##             (name above).
##
################################################################################
## REFERENCES:
##
## FROM 'man etherape':
##
## NAME
##       etherape - graphical network traffic browser
##
## SYNOPSIS
##       etherape  [  -m	operating  mode  ] [ -i interface ] [ -f filter ] [ -r
##       inputfile ] [ -n ] [ -d ] [ -F ] [ -N color ] [ -L color ] [ -T color ]
##       -z ]
##
## DESCRIPTION
##       etherape  is  a	network  traffic browser. It displays network activity
##       graphically. It uses GNOME libraries as its user interface,  and  libp-
##       cap, a packet capture and filtering library.
##
## OPTIONS
##       These options can be supplied to the command:
##
##       -m, --mode <ethernet|fddi|ip|tcp>
##	      set  mode  of  operation	(default  is  lowest level for current
##	      device)
##
##       -i, --interface <interface name>
##	      set interface to listen to
##
##       -f, --filter <capture filter>
##	      set capture filter
##
##       -r, --infile <file name>
##	      set input file
##
##       -n, --numeric
##	      don't convert addresses to names
##
##       -d, --diagram-only
##	      don't display any node text identification
##
##       -F, --no-fade
##	      do not fade old links
##
##       -N, --node-color <color>
##	      set the node color
##
##       -L, --link-color <color>
##	      set the link color
##
##       -T, --text-color <color>
##	      set the text color
##
##       -z, --zero-delay
##	      ignores timestamps when replaying a capture file.
##
##       -?, --help
##	      show a brief help message
## 
## FILES
##        Etherape will use /etc/ethers if there is one. If not, it will  try  to
##        reverse lookup the ip address.
## 
##        IMPORTANT!   It is particularly important when running in ethernet mode
##        to have the ethernet address of your router in  /etc/ethers.   If  not,
##        your  router  will  have  as name whatever IP address it was forwarding
##        traffic from when it was first heard.
## 
## SEE ALSO
##        The etherape webpage is at http://etherape.sourceforge.net/
##
#############################################################################
## Created: 2011may23
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
##                    Added zenity prompt for the interface id.
############################################################################

## FOR TESTING: (show statements as they execute)
# set -x

##################################################
## Prompt for an Interface ID, like eth0 or eth1.
##################################################

IFACE=""

IFACE=$(zenity --entry \
   --title "Enter an INTERFACE ID, such as 'eth0' or 'eth1'." \
   --text "\
Enter an INTERFACE ID, such as 'eth0' or 'eth1'.

NOTE: This script uses 'mode' 'ip' --- but you can edit the script
to use mode 'ethernet' or 'tcp' or 'fddi'. See 'man etherape'.

NOTE: The 'man' help says:
   'It is particularly important when running in ethernet mode
   to have the ethernet address of your router in /etc/ethers.   If not,
   your router will have as name whatever IP address it was forwarding
   traffic from when it was first heard.'" \
   --entry-text "eth0")

if test "$IFACE" = ""
then
   exit
fi


##########################################################
## Run 'etherape'.
## Could one of the 4 modes indicated in the 'man' help:
##       -m ethernet
##       -m ip
##       -m tcp
##       -m fddi
#########################################################

gksudo etherape -n -m ip -i $IFACE


## NOTE: One or more zenity prompts may be added someday --- to prompt
##       for mode, for whether-to-use-the-numeric-option, for a filter.
