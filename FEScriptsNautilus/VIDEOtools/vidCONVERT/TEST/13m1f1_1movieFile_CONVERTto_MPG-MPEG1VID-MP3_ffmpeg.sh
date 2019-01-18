#!/bin/sh
##
## Nautilus
## SCRIPT: 13m1f1_1movieFile_CONVERTto_MPG-MPEG1VID-MP3_ffmpeg.sh
##
## PURPOSE: Convert a  movie file to a '.mpg' container movie file
##          with 'mpeg1' for the video codec.  Uses 'ffmpeg'.
##
## METHOD:  There are no prompts to the user --- any parms such as bitrates
##          are hard-coded.
##
##          Uses 'ffmpeg' with parms including '-vcodec mpeg1video' for the
##          video '-acodec libmp3lame' for the audio codec --- with output
##          directed into a file with '.mpg' suffix. (The '-f mpeg' parm
##          could be added if needed.)
##
##          Shows the '.mpg' in a movie player.
##
## REFERENCES: 
##          Do a web search on keywords such as 'ffmpeg mpeg1video mpg'.
##
## HOW TO USE: In Nautilus, select a movie file.
##             Then right-click and choose this VIDEOtools script to run
##             (name above).
##
##     NOTE on TESTING:
##       This script still needs to be tested on a wide variety of input
##       movie files including '.flv', 'avi', 'wmv', and 'mov' files.
##       May need different ffmpeg parms for some of these input formats,
##       depending on ffmpeg error msgs that are seen in the xterm.
##
## TESTING NOTES:
##  2012jun10  Worked on an AVI file with xvid(mpeg4) video and mp3 audio.
##
############################################################################
## Started: 2010mar08
## Changed: 2010oct27 Added '-vcodec mpeg1video' to ffmpeg cmd.
## Changed: 2011jan06 Commented out checks on input file suffix.
## Changed: 2012may24 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
## Changed: 2012jun10 Added '-f mpeg' to the ffmpeg command. Removed a space
##                    after back-slash in the ffmpeg command.
##############################################################################

## FOR TESTING: (display statements that are executed)
# set -x

###########################################
## Get the filename of the selected file.
###########################################

# FILENAME="$@"
# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

FILENAME="$1"

 
#####################################################################
## Check that the selected file is a 'supported' movie file,
## via its suffix.
##      (Assumes just one dot [.] in the filename, at the extension.)
#####################################################################

#  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

#  if test "$FILEEXT" != "flv" -a "$FILEEXT" != "wmv" -a \
#          "$FILEEXT" != "avi" -a "$FILEEXT" != "mov"
#  then
#     exit
#  fi


####################################################################
## Prepare the output '.mpg' filename --- in /tmp.
##    (Assumes just one dot [.] in the filename, at the extension.)
####################################################################

FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`

FILEOUT="/tmp/${FILENAMECROP}_new.mpg"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


#####################################################################
## Use 'ffmpeg' to make the 'mpg' file --- high-quality,
## by taking defaults, if possible (which usually means
## same size, same bit rates, etc.).
#####################################################################
## For some input file types:
##
##  - May have to set rate (e.g. -r 29.97) --- using a prompt
##    or extracting from input file info, if necessary.
##
##  - May have to add a zenity prompt for output image size (pixels)
##    like an even-number of pixels --- or try to extract the input
##    size to use for output size, for example, by using 'ffmpeg -i'.
#####################################################################

## SIMPLEST ATTEMPT:
##               ffmpeg -i "$FILENAME" "$FILEOUT"

xterm -hold -fg white -bg black -geometry 90x48+100+100 -e \
      ffmpeg -i "$FILENAME"  -f mpeg -vcodec mpeg1video  -sameq \
            -acodec libmp3lame -ab 128k -ar 44100 "$FILEOUT"

#      ffmpeg -i "$FILENAME"  -f mpeg -vcodec mpeg1video  -b 200k \

## ALTERNATIVES to try, if problems:
##   We could try specifying a frame rate or an image size, if needed
##   --- like in following examples:
##
##   ffmpeg -i "$FILENAME" \
##          -vcodec mpeg1video -b 200k -r 24 -s 640x480 \
##          -acodec libmp3lame -ab 128k -ar 44100 "$FILEOUT"
##
##   ffmpeg  -i "$FILENAME" \
##          -vcodec mpeg1video -b 459k -r 29.92 -s 480x360 \
##          -acodec libmp3lame -ab 64k -ar 22050 "$FILEOUT"
##

## Another ALTERNATIVE (using '-target'):
##
##   ffmpeg -i"$FILENAME"  -target ntsc-dvd "$FILEOUT"
##
## Then you can use your favorite burning software to burn the converted file
## to DVD for playable in any DVD player.
##
## Note that the default NTSC screen size is 720 x 480, which will degrade
## resolution if you are upsizing from a smaller sized flv video (which is
## often 416 x 324 (or even 360x240).
##
## FROM (2009): http://worldtv.com/blog/guides_tutorials/flv_converter.php


########################
## Show the movie file.
########################

if test ! -f "$FILEOUT"
then
   exit
fi

# MOVIEPLAYER="/usr/bin/vlc"
# MOVIEPLAYER="/usr/bin/mplayer"
# MOVIEPLAYER="/usr/bin/gmplayer -vo xv"
# MOVIEPLAYER="/usr/bin/smplayer"
# MOVIEPLAYER="/usr/bin/totem"

MOVIEPLAYER="/usr/bin/ffplay -stats"

xterm -fg white -bg black -hold -geometry 90x24+100+100 \
      -e $MOVIEPLAYER "$FILEOUT"

#########################################################
## Use a user-specified MOVIEPLAYER.  Someday?
#########################################################

# . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
# . $DIR_NautilusScripts/.set_VIEWERvars.shi

# $MOVIEPLAYER "$FILEOUT" &
