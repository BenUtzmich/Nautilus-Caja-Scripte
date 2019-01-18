#!/bin/sh
##    
## Nautilus                        
## SCRIPT: 03_anyfile_COLLECT-N-PACKETS_fromIFACE_gksudo-tcpdump.sh
##                            
## PURPOSE: Use 'tcpdump' to collect all types of packets through
##          an interface --- such as 'eth0' or 'eth1' ---
##          up to a user-specified packet count.
##
## METHOD: Uses 'zenity' to prompt for an ethernet interface id, such as
##         eth0 or eth1. Also uses 'zenity' to prompt for N, the number
##         of packets to capture.
##
##         Uses the 'tail -f' command on the capture file to 'follow'
##         the output --- in a 'xterm' --- as it is captured.
##
##         Shows the 'tcpdump' output in both a text-viewer of the user's
##         choice and in a binary file editor, such as 'bless'.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this Nautilus script to run
##             (name above).
##
############################################################################
## Created: 2010may17
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
##                    Added zenity prompt for the interface id.
#######################################################################

## FOR TESTING: (show statements as they execute)
#  set -x

##################################################
## Prompt for an Interface ID, like eth0 or eth1.
##################################################

IFACE=""

IFACE=$(zenity --entry \
   --title "Enter an INTERFACE ID, such as 'eth0' or 'eth1'." \
   --text "\
Enter an INTERFACE ID, such as 'eth0' or 'eth1'.
" \
   --entry-text "eth0")

if test "$IFACE" = ""
then
   exit
fi



######################################################################
## Enter a number for the limit on number of packets to be
## reported by 'tcpdump'.
######################################################################

COUNT=""

COUNT=$(zenity --entry \
   --title "Enter a COUNT - limit on the number of packets." \
   --text "\
Enter a number to specify the number of packets that 'tcpdump'
should capture-and-report before ending." \
   --entry-text "200")

if test "$COUNT" = ""
then
   exit
fi



######################################################################
## Prep a temporary filename, to hold the 'tcpdump' output.
## Since the user may not have write-permission to the current directory,
## and since the 'tcpdump' info may not pertain to the current directory,
## put the list in the /tmp directory.
######################################################################

CURDIR="`pwd`"

OUTFILE="/tmp/${USER}_collectedPACKETS_tcpdump_of_$IFACE_${COUNT}packets.lis"

if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


############################################
## Put a HEADING in the listing.
############################################

echo "\
.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................

'tcpdump' output for interface '$IFACE' --- $COUNT packets captured.

.................... START OF 'tcpdump' OUTPUT ......................


" > "$OUTFILE"


#######################################################
## Issue the 'tail -f' command to 'follow' the output
## to the capture file --- in an 'xterm'.
#######################################################

## FOR TESTING: (show statements as they execute)
#  set -x

xterm -hold -fg white -bg black \
      -geometry 80x50+25+25 \
      -e tail -f "$OUTFILE"


#######################################################################
## Start 'tcpdump'.
#######################################################################

gksudo "tcpdump -i eth0 -c $COUNT -w $OUTFILE"



## FOR TESTING:
#  set -

###########################
## Add report 'TRAILER'.
###########################

SCRIPT_BASENAME=`basename $0`
SCRIPT_DIRNAME=`dirname $0`

HOST_ID="`hostname`"

echo "
.........................  END OF 'tcpdump' OUTPUT  ........................

   The output above is from script

$SCRIPT_BASENAME

   in directory

$SCRIPT_DIRNAME

   It ran the 'tcpdump' command on host  $HOST_ID .

.............................................................................

The actual command used was

tcpdump -i $IFACE -c $COUNT -w $OUTFILE

......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................
" >> "$OUTFILE"


###########################
## Show the listing.
###########################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &

bless "$OUTFILE" &
