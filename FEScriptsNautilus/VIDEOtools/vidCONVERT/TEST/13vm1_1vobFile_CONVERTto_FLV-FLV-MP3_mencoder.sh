#!/bin/sh
##
## Nautilus
## SCRIPT: 13vm1_1vobFile_CONVERTto_FLV-FLV-MP3_mencoder.sh
##
## PURPOSE: Converts a '.vob' video file (typically from a DVD)
##          to a '.flv' movie file --- actually
##          FLV-FLV-MP3 container-video-audio. Uses 'mencoder'.
##
## METHOD:  There are no prompts to the user --- any parms such as bitrates
##          are hard-coded.
##
##          Uses 'mencoder' with parms including:
##          1.  '-of lavf' for the container format,
##          2.  '-ovc lavc -lavcopts vcodec=flv:vbitrate=700'
##              for the video encoding,
##          2.  '-oac mp3lame -lameopts abr:br=128 -srate 44100'
##              for the audio encoding.
##
##          Shows the '.flv' file in a movie player.
##
## REFERENCES: 
##          The 'mencoder' parms are based on a vob-to-flv example at
##          http://linux-issues.blogspot.com/2009/05/converting-vob-to-flv-format.html
##      OR
##          do a web search on keywords such as 'mencoder ovc flv oac'
##
## HOW TO USE: In Nautilus, select a movie file.
##             Then right-click and choose this VIDEOtools script to run
##             (name above).
##
###########################################################################
## Started: 2011dec12
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
## Prepare the output '.flv' filename --- in /tmp.
##    (Assumes just one dot [.] in the filename, at the extension.)
####################################################################

FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`

FILEOUT="/tmp/${FILENAMECROP}_new.flv"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


##########################################################
## Use 'mencoder' to make the 'flv' file.
##########################################################

xterm -hold -fg white -bg black -geometry 90x24+100+100 -e \
      mencoder "$FILENAME" -of lavf \
         -ovc lavc -lavcopts vcodec=flv:vbitrate=700 \
         -oac mp3lame -lameopts abr:br=128 -srate 44100 \
         -o "$FILEOUT"

## WORKED on an input Theora-Vorbis-ogv (ogg container) file.

## WAS    vbitrate=150
## WAS    abr:br=32
## WAS    -ofps 25
## WAS    -vf scale=720

## These options came FROM an example on web page:
## http://linux-issues.blogspot.com/2009/05/converting-vob-to-flv-format.html

## SOME OTHER 'mencoder' COMMANDS using 'mpeg4' video codecs, not 'flv':
##
# mencoder "$FILENAME" -forceidx -mc 0 -noskip -skiplimit 0 \
#          -ovc lavc -lavcopts vcodec=msmpeg4v2:vhq -o "$FILEOUT"
##
## OR
##
# mencoder "$FILENAME" -forceidx -mc 0 -noskip -skiplimit 0 \
#          -ovc lavc -lavcopts vcodec=mpeg4:vhq:mbd=2:trell:v4mv:vbitrate=9800 \
#          -o "$FILEOUT"
##
## FROM (2009): http://ubuntuforums.org/archive/index.php/t-1074152.html


## MORE:
##
#  mencoder "$FILENAME" -mc 0 -noskip -vf harddup \
#           -oac twolame -twolameopts br=56 -ovc lavc -o "$FILEOUT"
##
## FROM:
## http://www.linuxquestions.org/questions/linux-software-2/converting-flv-to-mpg-with-audio-and-ffmpeg-646876/


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
