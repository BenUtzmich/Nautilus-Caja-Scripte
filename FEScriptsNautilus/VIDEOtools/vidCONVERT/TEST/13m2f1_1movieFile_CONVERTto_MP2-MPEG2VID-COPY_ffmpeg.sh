#!/bin/sh
##
## Nautilus
## SCRIPT: 13m2f1_1movieFile_CONVERTto_MP2-MPEG2VID-COPY_ffmpeg.sh
##
## PURPOSE: Convert a  movie file to an '.mp2' container movie file
##          with 'mpeg2' video encoding. Uses 'ffmpeg'.
##
## METHOD:  There are no prompts to the user --- any parms such as bitrates
##          are hard-coded.
##
##          Uses 'ffmpeg' with parms including '-vcodec mpeg2video' for
##          video codec and '-acodec copy' for audio codec --- with
##          output directed into a file with '.mp2' suffix.
##
##          Shows the '.mp2' file in a movie player.
##
## REFERENCES:
##          http://ubuntuforums.org/archive/index.php/t-1074152.html
##          (circa 2009) provided a minimalist example like:
##             ffmpeg -i "$FILENAME" -f mpeg2video -sameq "$FILEOUT"
##     OR
##          do a web search on keywords such as 'ffmpeg mpeg2video mp2'.
##
##
## HOW TO USE: In Nautilus, select a movie file.
##             Then right-click and choose this VIDEOtools script to run
##             (name above).
##
##    NOTE on TESTING:
##       This script needs to be tested on a wide variety of input movie
##       file types  such as '.flv', '.avi', '.wmv', and '.mov' files.
##       May need to use different ffmpeg parms for some of these
##       input formats, according to error msgs from ffmpeg.
##
##########################################################################
## Started: 2010oct31
## Changed: 2011jan06 Add '-vcodec mpeg2video' to ffmpeg command.
## Changed: 2012may24 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
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
##     (Assumes just one dot [.] in the filename, at the extension.)
#####################################################################
 
#  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

#  if test "$FILEEXT" != "flv" -a "$FILEEXT" != "wmv" -a \
#          "$FILEEXT" != "avi" -a "$FILEEXT" != "mov"
#  then
#     exit
#  fi


####################################################################
## Prepare the output '.mp2' filename --- in /tmp.
##    (Assumes just one dot [.] in the filename, at the extension.)
####################################################################

FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`

FILEOUT="/tmp/${FILENAMECROP}_new.mp2"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


##########################################################
## Use 'ffmpeg' to make the 'mp2' file --- high-quality,
## by taking defaults, if possible (which usually means
## same size, same bit rates, etc.).
##########################################################
## For some input file types:
##
## - May also have to set rate (e.g. -r 29.97) --- using a prompt
##   or extracting from input file info, if necessary.
##
## - May have to add a zenity prompt for output image size (pixels)
##   such as an even number of pixels
##   --- or try to extract the input size to use for output size,
##   for example, by using 'ffmpeg -i'.
#####################################################################
## '-acodec copy' may fail if an input audio encoding is not
## supported by the output 'mp2' container format.
#####################################################################

xterm -hold -fg white -bg black -geometry 90x48+100+100 -e \
      ffmpeg -i "$FILENAME" \
            -vcodec mpeg2video -b 459k \
            -acodec copy "$FILEOUT"


## ALTERNATIVES to try, if problems:
##    We could try adding a frame rate or an image size, if error msgs
##    indicate that either of those parms are needed --- per these examples.
##
##   ffmpeg -i "$FILENAME" \
##               -vcodec mpeg2video -b 459k -r 30 -s 480x360 \
##               -acodec copy "$FILEOUT"
##
##   ffmpeg -i "$FILENAME" \
##              -vcodec mpeg2video -b 200k -r 29.92 -s 640x480 \
##              -acodec libmp3lame -ab 128k -ar 44100  "$FILEOUT"

## ALTERNATIVE:
##
# ffmpeg -i "$FILENAME" -f mpeg2video -sameq "$FILEOUT"
##
## FROM (2009): http://ubuntuforums.org/archive/index.php/t-1074152.html


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
