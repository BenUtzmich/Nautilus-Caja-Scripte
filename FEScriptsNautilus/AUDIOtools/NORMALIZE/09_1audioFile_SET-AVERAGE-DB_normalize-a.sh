#!/bin/sh
##
## Nautilus
## SCRIPT: 09_1audioFile_SET-AVERAGE-DB_normalize-a.sh
##
## PURPOSE: For a user-selected audio file ('.wav', '.ogg', whatever),
##          this script sets the RMS (root mean square) amplitude of the
##          audio file  to a user-specified amplitude, in decibels.
##          Typical value: -15 decibels.
##
## METHOD:  Uses 'zenity --entry' to prompt for the decibel level.
##
##          Uses the 'normalize -a' = 'normalize --amplitude' command
##          to make the new file.
##
##          Since normalize uses the input file for its output,
##          we use 'cp' to copy the user-selected file to a file
##          with the same name but '_NORMALIZED' added into the name.
##          Then we apply 'normalize' to that file.
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
## Check if the player executable exists.
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

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`


#######################################
## Check that the file is an audio file
## supported by 'normalize'.
## If not, skip it.
#########
##    COMMENTED, for now.
#######################################

# if test "$FILEEXT" != "wav" -a "$FILEEXT" != "ogg"
# then 
#    # continue
#    exit
# fi


#######################################
## Get the midname of the audio file.
#######################################

FILEMIDNAME=`echo "$FILENAME" | cut -d\. -f1`


#############################################
## Set the filename of the OUTPUT audio file
## and make a copy of the input audio file
## using the new filename.
#############################################

FILEOUT="${FILEMIDNAME}_NORMALIZED.$FILEEXT"

cp "$FILENAME" "$FILEOUT"


############################################
## Prompt for the decibel level. 
############################################

DB_LEVEL=""

DB_LEVEL=$(zenity --entry \
   --title "Enter DECIBELS." \
   --text "\
Enter a DECIBEL LEVEL for the average amplitude ---
the RMS (root mean square) amplitude --- of the output
audio file:
   $FILEOUT

Typical values:  -12 or -15" \
   --entry-text "-15")

if test "$DB_LEVEL" = ""
then
   exit
fi


##################################################
## Use 'normalize' to alter the amplitude of
## the output audio file.
#########################
## We run 'normalize' in an 'xterm' window so
## that we can see output messages.
##################################################

# xterm -fg white -bg black -hold -geometry 90x24+100+100 -e \
#   normalize --amplitude ${DB_LEVEL}dB "$FILEOUT"

xterm -fg white -bg black -hold -geometry 90x24+100+100 -e \
   $EXE_FULLNAME --amplitude ${DB_LEVEL}dB "$FILEOUT"
