#!/bin/sh
##
## Nautilus
## SCRIPT: 05_anyfile_SHOW-CUPS-DEVICES_lpinfo-v.sh
##
## PURPOSE: Runs the 'lpinfo -v' and 'lpinfo -l -v' commands to list the
##          available devices known to the CUPS server.
##
## METHOD:  Runs the 'lpinfo' commands in an 'xterm' window
##          so that the user can see that it is running --- it
##          many take quite a few seconds for some of the output to show.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
###########################################################################
## Created: 2011may23
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################

## FOR TESTING: (show statements as they execute)
# set -x

############################################################
## We may put a zenity prompt here someday to ask whether a
## long listing is wanted.  That is, we could set
##    LPINFO_CMD='lpinfo -l -v'
## OR
##    LPINFO_CMD='lpinfo -v'
############################################################

#######################################################
## Run 'lpinfo -v' in a terminal window.
#######################################################

xterm -title "Devices known to the CUPS server, via 'lpinfo -v'." \
      -bg black -fg white -hold -geometry 55x20+0+25 \
      -sb -leftbar -sl 1000 \
      -e lpinfo -v &

xterm -title "Devices known to the CUPS server, via 'lpinfo -l -v'." \
      -bg black -fg white -hold -geometry 80x50+375+25 \
      -sb -leftbar -sl 1000 \
      -e lpinfo -l -v &
