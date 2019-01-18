#!/bin/sh
##
## Nautilus
## SCRIPT: 13vf1_1vobFile_CONVERTto_AVI-MPEG4-MP3_ffmpeg.sh
##
## PURPOSE: Converts a '.vob' video file (typically from a DVD)
##          to a '.avi' movie file --- actually
##          AVI-MPEG4-MP3 container-video-audio. Uses 'ffmpeg'.
##
## METHOD:  There are no prompts to the user --- any parms such as bitrates
##          are hard-coded.
##
##          Uses 'ffmpeg' with parms including '-f avi' for the container
##          format and '-vcodec mpeg4' for the video encoding
##          and '-acodec libmp3lame' for the audio encoding.
##
##          Shows the '.avi' file in a movie player.
##
## REFERENCES:
##          These 'ffmpeg' parms are based on a vob-to-avi example at
##          http://manpages.ubuntu.com/manpages/lucid/man1/ffmpeg.1.html
##          See some quotes from this web page below, near the call
##          to 'ffmpeg'.
##      OR
##          do a web search on keywords such as 'ffmpeg avi vcodec mpeg4'.
##
##
## HOW TO USE: In Nautilus, select a '.vob' movie file.
##             Then right-click and choose this VIDEOtools script to run
##             (name above).
##
#########################################################################
## Started: 2011dec12
## Changed: 2012may24 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
##########################################################################

## FOR TESTING: (display statements that are executed)
# set -x

###########################################
## Get the filename of the selected file.
###########################################

# FILENAME="$@"
# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

FILENAME="$1"


#####################################################################
## Check that the selected file is a 'vob' movie file via its suffix.
##     (Assumes just one dot [.] in the filename, at the extension.)
## COMMENTED.
#####################################################################

#  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
#  if test "$FILEEXT" != "vob"
#  then
#     exit
#  fi


####################################################################
## Prepare the output '.avi' filename --- in /tmp.
##    (Assumes just one dot [.] in the filename, at the extension.)
####################################################################

FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`

FILEOUT="/tmp/${FILENAMECROP}_new.avi"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


##########################################################
## Use 'mencoder' to make the '.avi' file.
##########################################################

xterm -hold -fg white -bg black -geometry 90x24+100+100 -e \
      ffmpeg -i "$FILENAME" -f avi \
      -vcodec mpeg4 -b 800k -g 300 -bf 2 \
      -acodec libmp3lame -ab 128k "$FILEOUT"


## These options came FROM an example on web page:
##    http://manpages.ubuntu.com/manpages/lucid/man1/ffmpeg.1.html
## which had the following additional info:
##
##   This is a typical DVD ripping example; the input is a VOB file, the
##   output an AVI file with MPEG-4 video and MP3 audio.
##
##   Note that in this command we use B-frames so the MPEG-4 
##   stream is DivX5 compatible, and GOP size is 300 which means
##   one intra frame every 10 seconds for 29.97fps input video.
##
##   Furthermore, the audio stream is MP3-encoded so
##   you need to enable LAME support by passing "--enable-libmp3lame" to
##   configure [if you build ffmpeg].
##   The mapping is particularly useful for DVD transcoding to
##   get the desired audio language.


###########################################################
## Show the movie file (when user closes the xterm window).
###########################################################

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

xterm -hold -fg white -bg black -geometry 90x24+100+100 \
      -e $MOVIEPLAYER "$FILEOUT"

#########################################################
## Use a user-specified MOVIEPLAYER.  Someday?
#########################################################

# . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
# . $DIR_NautilusScripts/.set_VIEWERvars.shi

# $MOVIEPLAYER "$FILEOUT" &
