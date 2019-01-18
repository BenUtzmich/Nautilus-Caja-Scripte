#!/bin/sh
##
## Nautilus
## SCRIPT: 14_1movieFile_FLIPvertically_ffmpeg-vflip_toMP4-H264-AAC.sh
##
## PURPOSE: Vertically-flip a movie file.
##
## METHOD:  There is no prompt for parameters.
##
##          Uses 'ffmpeg' with '-vf vflip' --- and container, video codec,
##          and audio codec specified with '-f', '-vcodec', and '-acodec
##          respectively.
##
##          Shows the new, 'v-flipped' movie file in a movie player.
##
##     Although this seems like a totally useless function, in the past,
##     some webcams have recorded video upside down. For a case like that,
##     this function might be useful. Another example: to 'right' the
##     movie taken by a sky-diver who was filming someone as he was head-down.
##
##  NOTE on TESTING:
##       This script has not been tested on a wide variety of movie types ---
##       such as '.asf', '.avi', '.flv', '.mkv', '.mov', '.mpg', '.mp4',
##       '.ogg', '.wmv' suffix files.
##
##       I may add comments here on which input formats (container,video,audio)
##       have been tested and the outcome.
##
## HOW TO USE: In Nautilus, select a movie file.
##             Then right-click and choose this script to run (name above).
##
#############################################################################
## Started: 2012jun25 Based on FE Nautilus Script
##            14_1movieFile_FLIPhorizontally_ffmpeg-hflip_toMP4-H264-AAC.sh
## Changed: 2013apr10 Added check for the ffmpeg executable. 
###########################################################################

## FOR TESTING: (display the executed statements)
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


##############################################
## Get the filename of the selected file.
##############################################

  FILENAME="$1"
# FILENAMES="$@"
# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

##################################################################
## Check that the selected file is a 'supported' movie file type,
## according to the suffix.   ## SKIP THE CHECK, for now. ##
##
##     Types (suffixes) that MAY be 'supportable' are
##         'avi', 'asf', 'flv', 'mkv', 'mp4', 'mpeg', 'mpg', 'wmv',
##     and others.
##
##  (Assumes just one dot [.] in the filename, at the extension.)
##################################################################

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
#  if test "$FILEEXT" != "avi"  -a "$FILEEXT" != "asf" -a \
#          "$FILEEXT" != "flv"  -a \
#          "$FILEEXT" != "mkv"  -a "$FILEEXT" != "mp4"  -a \
#          "$FILEEXT" != "mpg"  -a "$FILEEXT" != "mpeg" -a \
#          "$FILEEXT" != "wmv"        
#  then
#     exit
#  fi


#################################################################
## Prepare the output filename.
##
##  (Assumes just one dot [.] in the filename, at the extension.)
#################################################################

FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`

FILEOUT="${FILENAMECROP}_V-FLIPPED_h264-aac.mp4"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


###################################################################
## Use 'ffmpeg' to make the 'v-flipped' movie file.
###################################################################

## FOR TEST:
#   set -x

xterm -hold -fg white -bg black -geometry 90x48+100+100 -e \
   $EXE_FULLNAME -i "$FILENAME"  -f mp4 \
      -vcodec libx264 \
      -vpre /usr/share/ffmpeg/libx264-lossless_slow.ffpreset \
      -crf 22 \
      -acodec libfaac -ab 128k  -ar 22050 -ac 1 \
      -vf "vflip"  -threads 0  "$FILEOUT"


## These options come FROM the FE 'VIDCAP_CONVERT' Nautilus Script 
## 30a_1mkvCapFile_CONVERTto_MP4-H264-AAC_4youtube_ffmpeg.sh

## To reduce the size of the audio data we may use parms like
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


## FOR TEST:
#    set -

###################################################################
## Meaning of some 'popular' ffmpeg parms:
##
##  -i  val = input filename
##
## Video:
##   -f val = specifies container format (for video plus audio)
##   -vcodec codec - to force the video codec.
##                   Example: -vcodec mpeg4 
##                   Try  "ffmpeg -formats"
##   -r  val = frame rate in frames/sec
##   -b  val = video bitrate in kbits/sec (default = 200 kbps)
##   -s  val = frame size, wxh where w and h are pixels or abbrevs:
##          qqvga =  160x120
##           qvga =  320x240
##            vga =  640x480
##           svga =  800x600
##            xga = 1024x768
##           sxga = 1280x1024
##           uxga = 1600x1200
##
## Audio:
##   -acode codec - to force the audio codec. Example:
##                                      -acodec libmp3lame
##   -ab val = audio bitrate in bits/sec (default = 64k)
##   -ar val = audio sampling frequency in Hz (default = 44100 Hz)
##   -ac channels - for stereo or monaural - default = 1
##   -an - disable audio recording
##
##               
## Some other useful params:
## 
## Other Video [ for cropping, etc. ] :
##   -aspect (4:3, 16:9 or 1.3333, 1.7777)
##   -croptop pixels
##   -cropbottom pixels
##   -cropleft pixels
##   -cropright pixels
##   -padtop (bottom, left, right)
##   -padcolor <6 digit hex number>
##   -vn - disable video recording         [for audio extract]
##   -target type - where type is vcd or svcd or dvd or ..., then
##                  bitrate, codecs, buffersizes are set automatically.
##   -pass n, where n is 1 or 2
##
## Other:
##   -t duration - format is hh:mm:ss[.xxx]
##   -ss position - seek to given position, in secs or hh:mm:ss[.xxx]
##   -y  = overwrite output file(s)
##   -fs file-size-limit
##   -debug
##   -threads count
#######################################################################

##################################
## Show the v-flipped movie file.
##################################

if test ! -f "$FILEOUT"
then
   exit
fi

#  MOVIEPLAYER="/usr/bin/vlc"
#  MOVIEPLAYER="/usr/bin/mplayer"
#  MOVIEPLAYER="/usr/bin/gnome-mplayer"
#  MOVIEPLAYER="/usr/bin/totem"

MOVIEPLAYER="/usr/bin/ffplay -stats"

xterm -fg white -bg black -hold -geometry 90x24+100+100 -e \
      $MOVIEPLAYER "$FILEOUT"


################################################
## Use a user-specified MOVIEPLAYER. Someday?
################################################

#  . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
#  . $DIR_NautilusScripts/.set_VIEWERvars.shi

#   $MOVIEPLAYER "$FILEOUT" &
