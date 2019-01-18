#!/bin/sh
##
## Nautilus
## SCRIPT: 01_1-wav-file_SPLIT_intoThirds_sox.sh
##
## PURPOSE: Trims an audio file (.wav) into 3 equal sized '.wav' files.
##
## METHOD: Uses 'soxi -D' to get the duration of the wav file.
##
##         Uses 'bc' to calculate one-third of the duration.
##
##         Uses 'sox' three times, with the 'trim' parameter, to
##         make the 3 output files.
##
##         Plays the 1st of the 3 files in an audio player of the
##         user's choice.
##
## HOW TO USE: In the Nautilus file manager, navigate to a '.wav' file
##             and select it.
##             Then right-click and choose this nautilus script to run
##             (name above).
##
## Reference: http://www.thegeekstuff.com/2009/05/sound-exchange-sox-15-examples-to-manipulate-audio-files/
##
#########################################################################
## Created: 2010oct04
## Changed: 2012feb29 Changed the script name in the comment above.
##                    Added the METHOD comments section above.
## Changed: 2013apr10 Added check for the soxi and sox executables. 
#########################################################################

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
was not found. Exiting.

If the executable is in another location,
you can edit this script to change the filename."
   exit
fi

#########################################################
## Check if the sox executable exists.
#########################################################

EXE_FULLNAME2="/usr/bin/sox"

if test ! -f "$EXE_FULLNAME2"
then
   zenity  --info --title "Executable NOT FOUND." \
   --no-wrap \
   --text  "\
The sox executable
   $EXE_FULLNAME2
was not found. Exiting.

If the executable is in another location,
you can edit this script to change the filename."
   exit
fi


###########################################
## Get the filename of the selected file.
###########################################

# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
# FILENAMES="$@"
  FILENAME="$1"


###########################################
## Get the 'midname' of the selected file.
###########################################

MIDNAME=`echo "$FILENAME" | cut -d\. -f1`

###########################################
## Get the 'duration' of the selected file,
## in seconds.
###########################################

# SECS=`soxi -D "$FILENAME"`

SECS=`$EXE_FULLNAME -D "$FILENAME"`


###########################################
## Calculate the 1/3 and 2/3 time points.
###########################################

SECS_1THIRD=`echo "scale = 5; $SECS/3" | bc`

SECS_2THIRDS=`echo "scale = 5; $SECS_1THIRD + $SECS_1THIRD" | bc`


###########################################
## Split the selected file into 3.
###########################################

$EXE_FULLNAME2 "$FILENAME" ${MIDNAME}_1stThird.wav trim 0 $SECS_1THIRD

$EXE_FULLNAME2 "$FILENAME" ${MIDNAME}_2ndThird.wav trim $SECS_1THIRD $SECS_2THIRDS

$EXE_FULLNAME2 "$FILENAME" ${MIDNAME}_3rdThird.wav trim $SECS_2THIRDS $SECS


###########################################
## Play the first of the 3 output files.
###########################################

OUTFILE="${MIDNAME}_1stThird.wav"

# gmplayer "$OUTFILE"

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$AUDIOPLAYER "$OUTFILE" &


