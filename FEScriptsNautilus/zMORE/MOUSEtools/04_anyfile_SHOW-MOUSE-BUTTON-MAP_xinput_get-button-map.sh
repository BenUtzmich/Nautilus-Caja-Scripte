#!/bin/sh
##
## Nautilus
## SCRIPT: 04_anyfile_SHOW-MOUSE-BUTTON-MAP_xinput_get-button-map.sh
##
## PURPOSE: Show the mapping of a mouse's buttons.
##
## METHOD: Uses the command 'xinput get-button-map' with suitable
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
## Created by: Blaise Montandon 2013mar21
## Changed by: Blaise Montandon 2013t to an


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
   --title "Enter mouse name or ID-number - to get button mapping." \
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


####################################################
## Show the moust button mapping in a zenity window.
####################################################

zenity --info --title "'xinput get-button-map' command was issued." \
   --no-wrap \
   --text  "\
Output from ' xinput get-button-map \"$MOUSE_ID\" ' :

`xinput get-button-map  \"$MOUSE_ID\"`
"
