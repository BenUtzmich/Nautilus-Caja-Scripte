#!/bin/sh
##
## Nautilus
## SCRIPT: 05_anyfile_SHOW-CUPS-DRIVERS_lpinfo-m.sh
##
## PURPOSE: Runs the 'lpinfo -m' and 'lpinfo -l -m' commands to list the
##          available devices known to the CUPS server --- both a
##          short list and a long list.
##
## METHOD:  Runs the 'lpinfo' commands in an 'xterm' window
##          so that the user can see that it is running --- it
##          many take quite a few seconds for some of the output to show.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
###########################################################################
## Created: 2012jun20 Based on the FE Nautilus Script
##                    05_anyfile_SHOW-CUPS-DEVICES_lpinfo-v.sh
## Changed: 2012
#######################################################################

## FOR TESTING: (show statements as they execute)
# set -x

############################################################
## We may put a zenity prompt here someday to ask whether a
## long listing is wanted.  That is, we could set
##    LPINFO_CMD='lpinfo -l -m'
## OR
##    LPINFO_CMD='lpinfo -m'
############################################################

#######################################################
## Run 'lpinfo -m' in a terminal window.
#######################################################

xterm -title "Devices known to the CUPS server, via 'lpinfo -m'." \
      -bg black -fg white -hold -geometry 55x20+0+25 \
      -sb -leftbar -sl 1000 \
      -e lpinfo -m &

xterm -title "Devices known to the CUPS server, via 'lpinfo -l -m'." \
      -bg black -fg white -hold -geometry 80x50+375+25 \
      -sb -leftbar -sl 1000 \
      -e lpinfo -l -m &
