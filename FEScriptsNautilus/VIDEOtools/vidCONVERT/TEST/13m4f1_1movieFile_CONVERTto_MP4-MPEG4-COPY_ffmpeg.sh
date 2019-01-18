#!/bin/sh
##
## Nautilus
## SCRIPT: 13m4f1_1movieFile_CONVERTto_MP4-MPEG4-COPY_ffmpeg.sh
##
## PURPOSE: Convert a  movie file to a '.mp4' container movie file
##          with 'mpeg4' video encoding.  Uses 'ffmpeg'.
##
## METHOD:  There are no prompts to the user --- any parms such as bitrates
##          are hard-coded.
##
##          Uses 'ffmpeg' with parms including '-vcodec mpeg4' for the video
##          codec and '-acodec copy' for the audio codec --- with output
##          directed into a file with '.mp4' suffix.
##
##          Shows the '.mp4' file in a movie player.
##
## REFERENCES: See
##             http://www.catswhocode.com/blog/19-ffmpeg-commands-for-all-needs
##             posted circa 2008,
##         OR
##             see http://rolandmai.com/node/23 posted circa 2008,
##         OR
##             do a web search with keywords such as 'ffmpeg vcodec mpeg4 mp4'.
##
## HOW TO USE: In Nautilus, select a movie file.
##             Then right-click and choose this VIDEOtools script to run
##             (name above).
##
##    NOTE on TESTING:
##       This script needs to be tested on a wide variety of input movie
##       file types, such as '.flv', '.avi', '.wmv', and '.mov'
##       May need to use different ffmpeg parms for some of these input
##       formats, depending on ffmpeg error msgs that are seen in the xterm.
##
###########################################################################
## Started: 2010oct31
## Changed: 2011jan06 Added '-vcode mpeg4video' to the ffmpeg command.
## Changed: 2012may24 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

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
##    (Assumes just one dot [.] in the filename, at the extension.)
#####################################################################
 
#  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

#  if test "$FILEEXT" != "flv" -a "$FILEEXT" != "wmv" -a \
#          "$FILEEXT" != "avi" -a "$FILEEXT" != "mov"
#  then
#     exit
#  fi


####################################################################
## Prepare the output '.mp4' filename --- in /tmp.
##    (Assumes just one dot [.] in the filename, at the extension.)
####################################################################

FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`

FILEOUT="/tmp/${FILENAMECROP}_new.mp4"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


###################################################################
## Use 'ffmpeg' to make the 'mp4' file --- high-quality,
## by taking defaults, if possible (which usually means
## same size, same bit rates, etc.).
###################################################################
## For some input file types:
##
## - May also have to set rate (e.g. -r 29.97) --- using a prompt
##   or extracting from input file info, if necessary.
##
## - May have to add a zenity prompt for output size
##   --- or try to extract the input size to use for output size,
##   for example, by using 'ffmpeg -i'.
#####################################################################

xterm -hold -fg white -bg black -geometry 90x48+100+100 -e \
      ffmpeg -i "$FILENAME" \
            -vcodec mpeg4 -b 459k \
            -acodec copy "$FILEOUT"


## ALTERNATIVES to try, if problems:
##     We could supply frame rate or an image size, if error msgs
##     indicate either of these parms are needed --- like examples below.
##     Also might need to specify an appropriate audio codec.
##
##   ffmpeg -i "$FILENAME" \
##                 -vcodec mpeg4 -b 459k -r 30 -s 480x360 \
##                 -acodec copy "$FILEOUT"
##
##   ffmpeg -i "$FILENAME" \
##                -vcodec mpeg4 -b 200k -r 29.92 -s 640x480 \
##                -acodec libmp3lame -ab 128k -ar 44100 "$FILEOUT"


## ALTERNATIVE avi2mp4 (for iPod or iPhone):
##
##  ffmpeg -i "$FILENAME" \
##    -vcodec mpeg4 -b 1200kb -mbd 2 -flags +4mv+trell -s 320x180 \
##    -acodec aac  -ab 128kb  -aic 2 -cmp 2 -subcmp 2  -title X "$FILEOUT"
##
## FROM (2008): http://www.catswhocode.com/blog/19-ffmpeg-commands-for-all-needs
##
## In the thread on that page, Jaime Gomez points out that
## '-flags +4mv+aic -trellis 1' may be needed in place of '-flags +4mv+trell'.

## ALTERNATIVE flv2mp4 (for iPod or iPhone):
##
## ffmpeg -v 0 -i "$FILENAME" -f mp4 \
##        -vcodec mpeg4 -r 25 -vb 384000 \
##        -acodec libfaac -ar 22050 -ab 64k "$FILEOUT"
##
## FROM (2008?): http://rolandmai.com/node/23



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
