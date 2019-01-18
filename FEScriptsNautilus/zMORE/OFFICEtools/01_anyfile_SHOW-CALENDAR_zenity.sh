#!/bin/sh
##
## Nautilus
## SCRIPT: 01_anyfile_SHOW_CALENDAR_zenity.sh
##
## PURPOSE: This script starts up the zenity calendar.
##
## METHOD: Simply issues the 'zenity --calendar' command.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
##########################################################################
## Created: 2012feb10
## Changed: may11 Changed script name in comments above and touched up
##                    the comments.
#######################################################################

zenity --calendar
