#!/bin/sh
##
## Nautilus
## SCRIPT: 01b_anyfile_SHOW-FONTS_fontmatrix.sh
##
## PURPOSE: Starts up the 'fontmatrix' program --- to show the fonts
##          available on the host.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
###########################################################################
## Script
## Created: 2010may12
## Changed: 2012apr18 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################

## FOR TESTING: (show statements as they execute)
#  set -x


EXECHECK=`which fontmatrix`

if test -f "$EXECHECK"
then
#  fontmatrix &
   fontmatrix
fi
