#!/bin/sh
##
## Nautilus
## SCRIPT: 00_anyfile_RUN_SCREEN-SECTION-MAGNIFIER_xmag.sh
##
## PURPOSE: Run 'xmag' --- typically to examine the color of pixels
##          in a section of the screen.
##
## METHOD: Simply runs 'xmag', but we could add a 'zenity --info' popup
##         to explain to the user some functions available with
##         the 'xmag' program --- like examining colors of pixels.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
########################################################################
## Created: 2010may30
## Changed: 2012may12 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################

## FOR TESTING: (show statements as they execute)
#  set -x

xmag
