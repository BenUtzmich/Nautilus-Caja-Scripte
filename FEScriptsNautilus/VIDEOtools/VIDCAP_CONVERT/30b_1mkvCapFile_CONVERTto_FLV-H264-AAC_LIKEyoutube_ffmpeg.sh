#!/bin/sh
##
## Nautilus
## SCRIPT: 30b_1mkvCapFile_CONVERTto_FLV-H264-AAC_LIKEyoutube_ffmpeg.sh
##
## PURPOSE: Using 'ffmpeg', this script converts an input movie file to a
##          '.flv' container movie file.
##
##          This script is intended to use as input '.mkv' (Matroska container)
##          movie files that are 'lossless' H264-and-PCM
##          screen-and-audio-captures from a 'XscreenANDpulseAUDIO_CAPTURE'
##          script --- but it may work with other movie file inputs, that is,
##          different container formats, such as '.flv' or '.avi' or '.mpg'.
##
##          The input video stream (possibly near LOSS-LESS) is converted
##          to a *LOSSY* H264 video stream and the input audio stream 
##          (possibly near LOSS-LESS) is converted to a *LOSSY* AAC audio stream.
##
## METHOD: Uses 'zenity --info' to show info on how this utility works.
##
##         Uses 'zenity --entry' to prompt for an image size (x,y-pixels)
##         for the output movie file.
##
##         Runs 'ffmpeg' with '-f flv' and '-vcodec libx264' and
##         '-acodec libfaac' parms.
##
##         REFERENCE: http://ubuntuforums.org/archive/index.php/t-1392026.html
##                    "HOWTO: Proper Screencasting on Linux" by verb3k
##
##         Runs 'ffmpeg' in an 'xterm' so that messages can be seen.
##
##         When the conversion is done, this script
##         shows the '.flv' file in a movie player.
##
## HOW TO USE: In Nautilus, select a (.mkv) movie file.
##             Then right-click and choose this script to run (name above).
##
##     NOTE on usage of this script:
##       This script was designed to be run after the feNautilusScript
##          '...XscreenANDpulseAUDIO_CAPTURE...'
##       which captures an X11 desktop and Pulse audio session into
##       a 'lossless' H.264 video stream and a 'lossless' PCM audio stream
##       in a '.mkv' (Matroska container) movie file.
##
## REFERENCE: http://ubuntuforums.org/archive/index.php/t-1392026.html
##            "HOWTO: Proper Screencasting on Linux" by verb3k
##            which shows how to put H264 video and AAC audio into
##            an *MP4* (not FLV) container.
##
###############################################################################
## Started: 2011may10
## Changed: 2011dec11 Removed '--no-wrap' from the 'zenity --entry' prompt for
##                    image size. '--no-wrap' is not implemented for '--entry'.
## Changed: 2012may22 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (display statements that execute)
# set -x

###########################################
## Get the INPUT filename.
###########################################

FILENAME="$1"


######################################
## Prepare the output '.flv' filename.
## (The suffix determines the container
## type that 'ffmpeg' creates.)
######################################

FILEOUT="/tmp/${USER}_MOVIEfileCONVERTEDto_LOSSY-h264-aac.flv"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


##########################################
## Show info on how this utility works.
##########################################

CURDIR="`pwd`"
CURDIRFOLDED=`echo "$CURDIR" | fold -55`

SCRIPT_BASENAME=`basename $0`

zenity --info \
   --title "INFO on this CONVERT-a-VIDEO utility." \
   --no-wrap \
   --text "\
This utility, $SCRIPT_BASENAME ,
will use 'ffmpeg' to (try to) convert the INPUT file

  $FILENAME

in directory

  $CURDIRFOLDED

into lossy H.264 video and lossy AAC audio in an FLV container
in OUTPUT file

  $FILEOUT

'ffmpeg' is started in a terminal window so that startup and
coding messages can be watched. When 'ffmpeg' is done
(messages will stop), CLOSE the terminal window.

The output file, if good, will be shown in a video player.

Now, CLOSE this window to get a PROMPT for image size of
the output --- and to, after that, START the ffmeg-window."


############################################################
## Ask for the image SIZE for the NEW LOSSY file that we
## are about to make from the INPUT video file.
############################################################

NEWSIZE=""

NEWSIZE=$(zenity --entry \
   --title "ENTER image SIZE for the new H264-AAC-FLV file to be made." \
   --text "\
Enter an image size for the FLV file
$FILEOUT
that will now be made from the INPUT file
$FILENAME
Examples:
  320x240  = QVGA  (4:3 = 1.33...)
  352x288  = CIF   (1.22...)
  640x480  = VGA   (4:3 = 1.33...)
  720x480  = NTSC screen size (1.5)
  720x576  = PAL screen size (1.25)
  800x600  = SVGA  (4:3 = 1.33...)
 1024x768  = XGA   (4:3 = 1.33...)
 1280x720  = HD720 (16:9 = 1.77...)
 1280x1024 = SXGA  (5:4 = 1.25)
 1920x1080 = HD1080 (16:9 = 1.77...)
 1600x1200 = UXGA  (4:3 = 1.33...)
        0  = same size as input file

'ffmpeg' CONVERSION will be started in a terminal window
so that startup and encoding messages can be watched.

When 'ffmpeg' is done, CLOSE the terminal window.
The output file, if good, will be shown in a video player." \
   --entry-text "640x480")

if test "$NEWSIZE" = ""
then
   exit
fi

if test "$NEWSIZE" = "0"
then
   SPARM=""
else
   SPARM="-s $NEWSIZE"
fi


####################################################################
## Convert the input movie file into a lossy *H.264* video
## stream and lossy *AAC* audio stream in an *FLV* (.flv) container.
########
## Do the conversion in a terminal window to watch progress,
## via messages from 'ffmpeg'.
####################################################################

xterm -bg black -fg white -hold -geometry 90x48+100+100 -e \
      ffmpeg -i "$FILENAME" -f flv \
         -vcodec libx264 \
         -vpre /usr/share/ffmpeg/libx264-lossless_slow.ffpreset \
         -crf 22 $SPARM \
         -acodec libfaac -ab 128k  -ar 22050 -ac 1 \
         -threads 0 "$FILEOUT"

## To minimize the size of the audio data we may use parms like
##    '-ab 96k  -ar 22050 -ac 1'   OR   '-ab 64k  -ar 22050 -ac 1'
## instead of parms like
##    '-ab 128k -ar 44100 -ac 2'

## Most of the parameters for this 'ffmpeg' command came
## FROM "HOWTO: Proper Screencasting on Linux" by verb3k :
##
## "We use the preset 'slow' and a CRF value of 22 for rate control.
## The lower you set the CRF value, the better your video’s quality
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

#####################################################################
## Basic ffmpeg syntax is:
##  ffmpeg [input options] -i [input file] [output options] [output file]
##
## Note that 'ffmpeg' determines the container format of the output file
## based on the extension you specify. For example, if you specify the
## extension as '.mkv', your file will be muxed into an Matroska container.
##
## Meaning of the 'popular' ffmpeg parms:
##
## -i  val = input filename
##
## -acode codec - to force the audio codec. Example: -acodec libmp3lame
## -ab val = audio bitrate in bits/sec (default = 64k)
## -ar val = audio sampling frequency in Hz (default = 44100 Hz)
## -ac channels - default = 1
##
## -vcodec codec - to force the video codec. Example: -vcodec mpeg4 
##                 Try  "ffmpeg -formats"
## -r  val = frame rate in frames/sec
## -b  val = video bitrate in kbits/sec (default = 200 kbps)
## -s  val = frame size, wxh where w and h are pixels or abbrevs:
##          qqvga =  160x120
##           qvga =  320x240
##            cif =  352x288
##            vga =  640x480
##           svga =  800x600
##            xga = 1024x768
##           sxga = 1280x1024
##           uxga = 1600x1200
##               
## Some other useful params:
##
## Audio:
##   -an = disable audio recording
## 
## Video:
##   -vn = disable video recording
##   -y  = overwrite output file(s)
##   -aspect (4:3, 16:9 or 1.3333, 1.7777)
##   -croptop pixels
##   -cropbottom pixels
##   -cropleft pixels
##   -cropright pixels
##   -padtop (bottom, left, right)
##   -padcolor <6 digit hex number>
##   -ss position = seek to given position, in secs or hh:mm:ss[.xxx]
##   -t duration - format is hh:mm:ss[.xxx]
##   -fs file-size-limit
##   -target type - where type is vcd or svcd or dvd or ..., then
##                  bitrate, codecs, buffersizes are set automatically.
##   -pass n, where n is 1 or 2
##
## Other:
##   -debug
##   -threads count
#######################################################################


##############################
## Show the OUTPUT movie file.
##############################

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

xterm -fg white -bg black -hold -geometry 90x32+100+100 \
      -e $MOVIEPLAYER "$FILEOUT"

## NOTE: 'totem' (based on gstreamer, version ?) tends to play
##        only a second or so of an mpeg1video that I created
##        with ffmpeg.
##        But 'ffplay' does a good job. 'mplayer' does OK.
##        'totem' is suspect. (Or the ffmpeg recording parms?)


#########################################################
## Use a user-specified MOVIEPLAYER.  Someday?
#########################################################

# . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
# . $DIR_NautilusScripts/.set_VIEWERvars.shi

# $MOVIEPLAYER "$FILEOUT" &
