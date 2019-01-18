#!/bin/sh
##
## Nautilus
## SCRIPT: 09_1audioFile_SHOW-LEVEL-PEAK-GAIN_normalize-n.sh
##
## PURPOSE: For a user-selected audio file ('.wav', '.ogg', whatever),
##          this script shows the level, peak, and gain of the file.
##
##          'Gain' is the safe amount of gain you could apply to the file
##          without clipping sound waves.
##
## METHOD:  Uses the 'normalize -n' = 'normalize --no-adjust' command
##          to get the audio file properties.
##
##          Uses 'zenity --info' to show the output from the
##          'normalize -n' command.
##
## HOW TO USE: In Nautilus, select one audio file in a directory.
##             Right click and, from the 'Scripts >' submenus,
##             choose to run this script (name above) --- in the
##             'AUDIOtools' group.
##
## REFERENCE: Linux Format Magazine article, Jan 2010, LXF issue #127
##            'Normalize - Engineer raw aduio like a pro' by Seth Kenlon
##
###########################################################################
## Created: 2012jun04
## Changed: 2013apr10 Added check for the normalize executable.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x

#########################################################
## Check if the normalize executable exists.
#########################################################

EXE_FULLNAME="/usr/bin/normalize"

if test ! -f "$EXE_FULLNAME"
then
   zenity  --info --title "Executable NOT FOUND." \
   --no-wrap \
   --text  "\
The normalize executable
   $EXE_FULLNAME
was not found. Exiting.

If the executable is in another location,
you can edit this script to change the filename."
   exit
fi


#######################################
## Get the user-selected filename.
#######################################

FILENAME="$1"


#######################################
## Get the extension of the audio file.
#######################################

# TEXTOUT=`normalize -n "$FILENAME"`

TEXTOUT=`$EXE_FULLNAME -n "$FILENAME"`


############################################
## Show the output from 'normalize -n'. 
############################################

zenity --info \
   --title "LEVEL, PEAK, and GAIN." \
   --text "\
Audio levels for audio file:
   $FILENAME

$TEXTOUT"
