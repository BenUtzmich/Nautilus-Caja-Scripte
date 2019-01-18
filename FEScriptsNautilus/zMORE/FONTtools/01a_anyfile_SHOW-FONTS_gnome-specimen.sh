#!/bin/sh
##
## Nautilus
## SCRIPT: 01a_anyfile_SHOW-FONTS_gnome-specimen.sh
##
## PURPOSE: Starts up the 'gnome-specimen' program --- to show fonts
##          available on the host.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
##########################################################################
## Script
## Created: 2010may12
## Changed: 2012apr18 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
##########################################################################

## FOR TESTING: (show statements as they execute)
#  set -x


EXECHECK=`which gnome-specimen`

if test -f "$EXECHECK"
then
#  gnome-specimen &
   gnome-specimen
fi
