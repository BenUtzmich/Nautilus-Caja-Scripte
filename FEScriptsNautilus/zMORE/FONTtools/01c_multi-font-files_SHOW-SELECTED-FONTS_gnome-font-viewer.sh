#!/bin/sh
##
## Nautilus
## SCRIPT: 01c_multi-font-files_SHOW-SELECTED-FONTS_gnome-font-viewer.sh
##
## PURPOSE: For each of the user-selected (font) files in a
##          directory, uses the 'gnome-font-viewer' program
##          to view the font file.
##
##             For example, the user can navigate to the $HOME/.fonts
##             directory a view selected fonts there --- typically '.ttf' files.
##             Alternatively, the user can view fonts in /usr/share/fonts.
##
## WARNING: We startup each instance of 'gnome-font-viewer' in the 'background'.
##          So if you select 8 files, 8 viewer windows will open up ---
##          almost at the same time. This is to help compare fonts.
##
##          It is probably best to not choose more than 8 files at a time.
##          We could keep a count and exit when the count exceeded 8.
##
## HOW TO USE: In Nautilus, navigate to a directory containing font files
##             and select one or more font files (using Ctl or Shift keys
##             to select multiple files).
##             Then right-click and choose this script to run (name above).
##
##########################################################################
## Script
## Created: 2010aug25
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012apr18 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################

## FOR TESTING: (show statements as they execute)
#  set -x

## FOR TESTING:
# ERRFILE="/tmp/${USER}_stderr_fontviewer_test.txt"


####################################
## START THE LOOP on the filenames.
####################################

for FILENAME
do

   #################################################
   ## Use gnome-font-viewer to view the (font) file.
   #################################################

   gnome-font-viewer "$FILENAME" &
#  gnome-font-viewer "$FILENAME" 2> "$ERRFILE"

   ## Pause before showing next font, so that the
   ## user is aware that multiple windows are opening.
   sleep 1

done

## FOR TESTING:
# gedit "$ERRFILE" &
