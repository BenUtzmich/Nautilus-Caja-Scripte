#!/bin/sh
##
## Nautilus
## SCRIPT: 01_anyfile_MOUSE-G4andG5toPASTE-G300_xinput_set-button-map.sh
##
## PURPOSE: Set buttons G4 and G5 (on a Logitech G300 mouse) to
##          do paste (like button 2).
##
##          Note that a test with the 'xinput test <device-id>' command
##          shows that the buttons labelled 'G4' and 'G5' on the G300 mouse
##          actually are button numbers 8 and 9.
##
## METHOD: Uses the command 'xinput set-button-map' with suitable
##         mouse name or ID-number.
##
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
## Created by: Blaise Montandon 2014feb04
## Changed by: Blaise Montandon 2014

## FOR TESTING: (show statements as they execute)
#  set -x

############################################
## Prompt for the mouse name or ID-number.
############################################
## Example mouse names:
##   "Logitech Gaming Mouse G300"
##   "USB Optical Mouse"
##   "ImPS/2 Generic Wheel Mouse"
############################################

MOUSE_ID=$(zenity --entry \
   --title "Enter mouse ID-number - to set 2 buttons to PASTE." \
   --text "\
Enter an ID-number for the mouse.

To get the mouse ID-number, you can run the command 'xinput list'
and check the output for strings like 'Mouse' or 'Logitech
--- in particular, look for 'Logitech Gaming Mouse G300'.

You can edit this script to change the default ID-number for your mouse." \
   --entry-text "8")

if test "$MOUSE_ID" = ""
then
   exit
fi


################################################
## Map the mouse buttons.
################################################

BUTTONnums="1 2 3 4 5 6 7 2 2 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25"

xinput set-button-map  "$MOUSE_ID" $BUTTONnums


################################################
## Display the command that was issued (and,
## someday, error msgs, if any).
################################################

zenity --info --title "'xinput' command was issued - buttons G4,G5 (8,9) to PASTE." \
   --no-wrap \
   --text  "\
The command

xinput set-button-map  \"$MOUSE_ID\" $BUTTONnums

was issued to map buttons 'G4' and 'G5' (of a Logitech G300 mouse),
--- which are actually button numbers 8 and 9 ---
to have the PASTE capability of button 2 --- and retain
the PASTE capability of button 2."
