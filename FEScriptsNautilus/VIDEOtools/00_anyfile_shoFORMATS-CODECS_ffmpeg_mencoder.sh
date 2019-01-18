#!/bin/sh
##
## Nautilus
## SCRIPT: 00_anyfile_shoFORMATS-CODECS_ffmpeg_mencoder.sh
##
## PURPOSE: Shows the video (container) formats and codecs available
##          for 'ffmpeg' and 'mencoder'.
##
## METHOD:  There is no prompt for a parameter.
##
##          Uses the commands 'ffmpeg -formats' and 'mencoder -ovc help'.
##
##          Puts the text output in a file in the /tmp directory and
##          shows the text output in a text viewer of the user's choice.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
###########################################################################
## Started: 2010oct31
## Changed: 2011may02 Add $USER to temp filename.
## Changed: 2012feb09 Added 'mencoder -of help' output.
## Changed: 2012may14 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
## Changed: 2013apr10 Added checks for the ffmpeg and mencoder executables. 
###########################################################################

## FOR TESTING: (display statements that are executed)
# set -x

#########################################################
## Check if the ffmpeg executable exists.
#########################################################

EXE_FULLNAME="/usr/bin/ffmpeg"

if test ! -f "$EXE_FULLNAME"
then
   zenity  --info --title "Executable NOT FOUND." \
   --no-wrap \
   --text  "\
The ffmpeg executable
   $EXE_FULLNAME
was not found. Exiting.

If the executable is in another location,
you can edit this script to change the filename.
OR, install the 'ffmpeg' package."
   exit
fi


##################################
## Prepare the output filename.
##################################

FILEOUT="/tmp/${USER}_video_codecs_ffmpeg_mencoder.txt"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


##############################################
## Put the codecs info in the output file.
##############################################

echo "\
############################
Output of 'ffmpeg -formats' :
############################

'-formats' shows 
  1) 'File formats' = available 'container' format names/abbreviations as well as
                      'video-only' and 'audio-only' format names/abbreviations,
  2) 'Codecs' = available video and audio codecs (coder-decoders),
then
  3a) bitstream filters,
  3b) protocols, and
  3c) frame-size-and-frame-rate abbreviations.

[It would be nice if the 'ffmpeg -formats' were reformatted someday to
 distinguish, in the 'File formats' section, the 'container', 'video-only',
 and 'audio-only' formats.

 Note that 'avi', 'asf', 'flv', 'Matroska', 'mov', 'mp4', 'mpeg', and 'ogg'
 are common container formats.  Matroska files often have the suffix 'mkv'.
 'mpeg' files often have the suffix 'mpg'.  'asf' files often have the suffix
 'wmv'.

 Also, it would be nice if 'ffmpeg -formats' were reformatted someday to
 separate, in the 'Codecs' section, the video and the audio codecs.]

There are 1-character codes preceding the 'format names' (the 'container' and
'video-only' and 'audio-only' format names) and preceding the 'codec names'
(for audio and video). They have the following meanings:

For 'Format names':

	   D   Decoding available

	   E   Encoding available

For audio and video CODEC names only:

	   V/A/S
	       Video/audio/subtitle codec

	   S   Codec supports slices

	   D   Codec supports direct rendering

	   T   Codec can handle input truncated at random locations instead of
	       only at frame boundaries

" > "$FILEOUT"

# ffmpeg -formats >> "$FILEOUT"

$EXE_FULLNAME -formats >> "$FILEOUT"


#########################################################
## Check if the mencoder executable exists.
#########################################################

EXE_FULLNAME="/usr/bin/mencoder"

if test ! -f "$EXE_FULLNAME"
then
   zenity  --info --title "Executable NOT FOUND." \
   --no-wrap \
   --text  "\
The mencoder executable
   $EXE_FULLNAME
was not found.

If the executable is in another location,
you can edit this script to change the filename.
OR, install the 'mencoder' package."

fi


#########################################################
## If the mencoder exists, add its help to the text file.
#########################################################

if test -f "$EXE_FULLNAME"
then

   echo "
#############################################################
'mencoder' INFO:

###############################
Output of 'mencoder -ovc help' (mencoder VIDEO CODEC names) :
###############################
" >> "$FILEOUT"

   # mencoder -ovc help >> "$FILEOUT"

   $EXE_FULLNAME -ovc help >> "$FILEOUT"

   echo "

###############################
Output of 'mencoder -oac help' (mencoder AUDIO CODEC names) :
###############################
" >> "$FILEOUT"

   # mencoder -oac help >> "$FILEOUT"

   $EXE_FULLNAME -oac help >> "$FILEOUT"

   echo "

###############################
Output of 'mencoder -of help' (mencoder CONTAINER FORMAT names) :
###############################
" >> "$FILEOUT"

   # mencoder -of help >> "$FILEOUT"

   $EXE_FULLNAME -of help >> "$FILEOUT"

fi
## END OF test for mencoder existence


###########################
## Show the output file.
###########################

# . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$FILEOUT" &
