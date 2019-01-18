#!/bin/sh
##
## Nautilus
## SCRIPT: 13m4f2_1movieFile_CONVERTto_MP4-H264-AAC_ffmpeg.sh
##
## PURPOSE: Convert a movie file to a '.mp4' movie file, copying
##          the video stream to H.264 format and the audio stream to
##          AAC format --- using 'ffmpeg'.
##
## METHOD:  There are no prompts to the user --- any parms such as bitrates
##          are hard-coded.
##
##          Uses 'ffmpeg' with parms including '-f mp4' and a couple of
##          audio rate parms.
##
##          Shows the '.mp4' file in a movie player.
##
## REFERENCES:  http://ubuntuforums.org/archive/index.php/t-1392026.html
##            "HOWTO: Proper Screencasting on Linux" by verb3k
##            which shows how to put H264 video and AAC audio into
##            an MP4 container.
##
## HOW TO USE: In Nautilus, select a movie file.
##             Then right-click and choose this VIDEOtools script to run
##             (name above).
##
#########################################################################
## Started: 2012jun19 Based on FE Nautilus Scripts
##                    13ff2_1movieFile_CONVERTto_FLV-H264-AAC_ffmpeg.sh
##                    and
##               30a_1mkvCapFile_CONVERTto_MP4-H264-AAC_4youtube_ffmpeg.sh
## Changed: 2013oct20 Add the ability to put the output file in /tmp if
##                    the user does not have permission to write a file
##                    to the current directory.
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
## Check that the selected file is a 'supported' movie file
## via its suffix.
##     (Assumes just one dot [.] in the filename, at the extension.)
## COMMENTED.
#####################################################################

#  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
#  if test "$FILEEXT" != "mov" -a "$FILEEXT" != "mp4" -a "$FILEEXT" != "mpg"
#  then
#     exit
#  fi


####################################################################
## Prepare the output '.mp4' filename --- in /tmp --- or in the
## current directory, if the user has permission to write to it.
##    (Assumes just one dot [.] in the filename, at the extension.)
####################################################################

FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`

CURDIR=`pwd`

if test -w "$CURDIR"
then
   FILEOUT="${FILENAMECROP}_NEW_h264-aac.mp4"
else
   FILEOUT="/tmp/${FILENAMECROP}_NEW_h264-aac.mp4"
fi


if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


##########################################################
## Use 'ffmpeg' to make the '.mp4' file.
##########################################################

xterm -hold -fg white -bg black -geometry 90x40+100+100 -e \
      ffmpeg -i "$FILENAME" -f mp4 \
         -vcodec libx264 \
         -vpre /usr/share/ffmpeg/libx264-lossless_slow.ffpreset \
         -crf 22 \
         -acodec libfaac -ab 128k  -ar 22050 -ac 1 \
         -threads 0 "$FILEOUT" 

## These options come FROM the FE 'VIDCAP_CONVERT' Nautilus Script 
## 30a_1mkvCapFile_CONVERTto_MP4-H264-AAC_4youtube_ffmpeg.sh

## To minimize the size of the audio data we may use parms like
##    '-ab 96k  -ar 22050 -ac 1'   OR   '-ab 64k  -ar 22050 -ac 1'
## instead of parms like
##    '-ab 128k -ar 44100 -ac 2'

## Change '-ac 1' to '-ac 2' if you want to preserve stereo.

## Most of the parameters for this 'ffmpeg' command came
## FROM "HOWTO: Proper Screencasting on Linux" by verb3k :
##
## "We use the preset 'slow' and a CRF value of 22 for rate control.
## The lower you set the CRF value, the better your video's quality
## will be, and consequently the file size and encoding time will
## increase, and vice-versa.
##
## For a good guide on encoding with FFmpeg+x264, see 
## http://rob.opendot.cl/index.php/useful-stuff/ffmpeg-x264-encoding-guide/"


## Originally tried
##               -vcodec libx264 -vpre slow -crf 22 \
## BUT vpre 'slow' was not found.
## Fixed that by using the fully-qualified name above. (2011may06)
## This documents exactly which vpre file we are using.


## 'libfaac' was not found in
##            ... -acodec libfaac -ab 128k -ac 2 \
## Got 'Unknown encoder' msg.
## 'ffmpeg -formats' shows 'libfaad' and 'aac'.
## Tried 'libfaad'. Another 'Unknown encoder' msg.
## Trying 'aac'.    Another 'Unknown encoder' msg.
## Googling found
## http://ubuntuforums.org/showthread.php?t=1117283 which points out cmds:
##
##  sudo wget http://www.medibuntu.org/sources.list.d/`lsb_release -cs`.list --output-document=/etc/apt/sources.list.d/medibuntu.list 
##  sudo apt-get -q update
##  sudo apt-get --yes -q --allow-unauthenticated install medibuntu-keyring
##  sudo apt-get -q update
##  sudo apt-get install ffmpeg libavcodec-extra-52
##
## to install 'libfaac'. That worked. (2011may06)


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

xterm -fg white -bg black -hold -geometry 90x24+100+100 \
      -e $MOVIEPLAYER "$FILEOUT"

#########################################################
## Use a user-specified MOVIEPLAYER.  Someday?
#########################################################

# . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
# . $DIR_NautilusScripts/.set_VIEWERvars.shi

# $MOVIEPLAYER "$FILEOUT" &
