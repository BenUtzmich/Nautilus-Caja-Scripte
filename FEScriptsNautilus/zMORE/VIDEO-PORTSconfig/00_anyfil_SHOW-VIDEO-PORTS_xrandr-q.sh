#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_anyfil_SHOW_VIDEO_PORTS_xrandr-q.sh
##
## PURPOSE: Shows 'xrandr -q' output.
##
## METHOD:  Puts the output in a text file and shows the text file with
##          a textfile-viewer of the user's choice.
##
## HOW TO USE: 
##         1) In Nautilus, select ANY file in ANY directory.
##            (Note that the selected file and the Nautilus current
##            directory are not used by this script.
##            This is simply a way to get to the Nautilus 'Scripts' menu.)
##         2) Then right-click and choose this script to run (name above).
##
#########################################################################
## Created: 2012mar18 Based on a PRINTtools '_radio-list.sh' script.
## Changed: 2012may12 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
## Changed: 2013apr11 Added notes on '*' and '+' indicators. 
#######################################################################


## FOR TESTING: (show statements as they execute, in a terminal window)
#   set -x


###############################################
## Make a temp filename for the query output.
##############################################

OUTFILE="/tmp/${USER}_xrandr-q_query_OUTPUT.txt"

if test -f "$OUTIFLE"
then
   rm  "$OUTIFLE"
fi


###############################################
## Put the 'xrandr -q' output into the temp file.
##############################################

echo "\
'xrandr -q' OUTPUT:
##################
" > "$OUTFILE"

xrandr -q >> "$OUTFILE"


###############################################
## Add trailer info to the output.
##############################################

echo "
An '*' indicates the current mode.
A  '+' indicates preferred modes.

*******
WARNING:
******* 
If you are going to connect a TV or Overhead-Projector to
your computer, it is best to connect the TV to the VGA/HDMI
port on the computer **BEFORE** booting up the computer.

Otherwise, when you connect the TV or Overhead-Projector to
the computer, your computer screen may be suddenly reset to
an inappropriate resolution. Some (older) Linux distros may
not return to the original resolution after powering down
and rebooting the computer. You may need to do web searches
to find a way to reset to the proper desktop resolution.
" >> "$OUTFILE"


#################################
## Show the selected file.
#################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE"
