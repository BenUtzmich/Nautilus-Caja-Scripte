#!/bin/sh
##
## Nautilus
## SCRIPT:02_anyfile_MOUSE-MIDbtn-SCROLLonly_xinput_set-button-map.sh
##
## PURPOSE: Sets mid-mouse-button to scroll only (not paste).
##
## METHOD: Uses the command 'xinput set-button-map' with suitable
##         mouse name or ID-number.
##
## NOTE:
## Can use a command like:
##    lshal|grep -i mouse
## or
##    xinput list
## to find the name or ID-number for the mouse.
##
## REFERENCES:
## - http://quandtum.weebly.com/2/post/2012/03/how-to-change-mouse-button-functions-in-linux.html
## - man xinput
##
## HOW TO USE: In the Nautilus file manager, right-click on the name of
##             ANY file (or directory) in a Nautilus directory list.
##             Then choose this Nautilus script to run (see name above).
##
## Created by: Blaise Montandon 2009nov
## Changed by: Blaise Montandon 2012nov15 Changed name of mouse.
## Changed by: Blaise Montandon 2013mar15 Converted this script to an
##                                        'feNautilusScript'.

## FOR TESTING: (show statements as they execute)
#  set -x

############################################
## Prompt for the mouse name or ID-number.
############################################
## Example mouse names:
##   "USB Optical Mouse"
##   "ImPS/2 Generic Wheel Mouse"
############################################

MOUSE_ID=$(zenity --entry \
   --title "Enter mouse name or ID-number - to set SCROLL-only." \
   --text "\
Enter a name or ID-number for the mouse.

To get the mouse name or ID-number, you can run the command 'xinput list'
and check the output for strings like 'Mouse' or 'Optical' or 'Logitech'.

You can edit this script to change the default identifier for your mouse." \
   --entry-text "USB Optical Mouse")

if test "$MOUSE_ID" = ""
then
   exit
fi


################################################
## Map the mouse buttons.
################################################

xinput set-button-map "$MOUSE_ID" 1 0 3 4 5 6 7


################################################
## Display the command that was issued (and,
## someday, error msgs, if any).
################################################

zenity --info --title "'xinput' command was issued - for SCROLL-only." \
   --no-wrap \
   --text  "\
The command

xinput set-button-map  \"$MOUSE_ID\" 1 0 3 4 5 6 7

was issued to de-activate the PASTE capability of
button 2 --- the middle button --- and keep the
SCROLL capability (provided by 'virtual' button positions
4 5 6 and 7)."
