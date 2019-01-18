#!/bin/sh
##
## Nautilus
## SCRIPT: 01_1-wav-file_TRIM_start_length_sox.sh
##
## PURPOSE: Trims a user-selected audio file (.wav) according to a
##          user-specified start-secs and duration-secs.
##
## METHOD: Uses 'soxi -D' to get the duration of the wav file.
##
##         Uses zenity to prompt for the two secs values --- start-secs and
##         duration-secs.
##
##         Uses 'sox', with the 'trim' parameter, to make the new wav file.
##
##         Plays the output (trimmed) file in an audio player of the
##         user's choice.
##
## HOW TO USE: In the Nautilus file manager, navigate to a '.wav' file
##             and select it.
##             Then right-click and choose this nautilus script to run
##             (name above).
##
## REFERENCE: http://www.thegeekstuff.com/2009/05/sound-exchange-sox-15-examples-to-manipulate-audio-files/
##
###########################################################################
## Created: 2010oct04
## Changed:2012feb29 Changed the script name in the comment above.
##                    Added the METHOD comments section above.
## Changed: 2013apr10 Added check for the soxi and sox executables. 
###########################################################################

## FOR TESTING:  (turn ON display of executed-statements)
#  set -x

#########################################################
## Check if the soxi executable exists.
#########################################################

EXE_FULLNAME="/usr/bin/soxi"

if test ! -f "$EXE_FULLNAME"
then
   zenity  --info --title "Executable NOT FOUND." \
   --no-wrap \
   --text  "\
The soxi executable
   $EXE_FULLNAME
was not found. Exiting."
   exit
fi

#########################################################
## Check if the sox executable exists.
#########################################################

EXE_FULLNAME="/usr/bin/sox"

if test ! -f "$EXE_FULLNAME"
then
   zenity  --info --title "Executable NOT FOUND." \
   --no-wrap \
   --text  "\
The sox executable
   $EXE_FULLNAME
was not found. Exiting."
   exit
fi

###########################################
## Get the filename of the selected file.
###########################################

# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
# FILENAMES="$@"
  FILENAME="$1"


#####################################################
## Get the 'midname' of the selected file,
## and make the output filename.
##   Assumes one period in the name, at the extension.
#####################################################

MIDNAME=`echo "$FILENAME" | cut -d\. -f1`

OUTFILE="${MIDNAME}_TRIMMED.wav"

###########################################
## Get the 'duration' of the selected file,
## in seconds.
###########################################

# SECS=`soxi -D "$FILENAME"`

SECS=`$EXE_FULLNAME -D "$FILENAME"`


###########################################
## Prompt for the start-secs & duration-secs.
###########################################

SECS1and2=""

SECS1and2=$(zenity --entry \
   --title "Enter START-SECS and DURATION-SECS." \
   --text "\
Enter START-SECS and DURATION-SECS separated by a space
--- to specify the 'audio clip' to be created.
Example: 0.35 0.25

This utility will trim the selected file

   $FILENAME

(which has a total duration of $SECS seconds)

giving file    $OUTFILE" \
   --entry-text "0.35 0.25")

if test "$SECS1and2" = ""
then
   exit
fi


## FOR TESTING:  (turn ON display of executed-statements)
# set -x

SECS1=`echo "$SECS1and2" | cut -d' ' -f1`
SECS2=`echo "$SECS1and2" | cut -d' ' -f2`


###########################################
## Trim the selected file.
###########################################

# sox "$FILENAME" "$OUTFILE" trim $SECS1 $SECS2

$EXE_FULLNAME  "$FILENAME" "$OUTFILE" trim $SECS1 $SECS2


###########################################
## Play the trimmed file.
###########################################

# gmplayer "$OUTFILE"

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$AUDIOPLAYER "$OUTFILE" &
