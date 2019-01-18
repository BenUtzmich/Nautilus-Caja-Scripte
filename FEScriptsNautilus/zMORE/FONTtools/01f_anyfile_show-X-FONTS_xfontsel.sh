#!/bin/sh
##
## Nautilus
## SCRIPT: 01f_anyfile_show_X-FONTS_xfontsel.sh
##
## PURPOSE: Starts up the 'xfontsel' program, to show the
##          fonts known to the X server.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
##########################################################################
## Script
## Created: 2010may30
## Changed: 2012apr18 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
##########################################################################

## FOR TESTING: (show statements as they execute)
#  set -x


EXECHECK=`which xfontsel`

if test -f "$EXECHECK"
then
#  xfontsel &
   xfontsel
fi
