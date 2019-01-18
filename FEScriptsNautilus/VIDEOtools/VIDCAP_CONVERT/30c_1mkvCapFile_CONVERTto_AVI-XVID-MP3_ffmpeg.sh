#!/bin/sh
##
## Nautilus
## SCRIPT: 30c_1mkvCapFile_CONVERTto_AVI-XVID-MP3_ffmpeg.sh
##
## PURPOSE: Using 'ffmpeg', this script converts an input movie file
##          to an '.avi' container movie file.
##
##          This script is intended to use as input '.mkv' (Matroska container)
##          movie files that are 'lossless' H264-and-PCM
##          screen-and-audio-captures from an FE 'XscreenANDpulseAUDIO_CAPTURE'
##          script --- but it may work with other movie file inputs, that is,
##          different container formats, such as '.flv' or '.avi' or '.mpg'.
##
##          The input video stream (possibly near LOSS-LESS) is converted to
##          a *LOSSY* XVID video stream and the input audio stream (possibly
##          near LOSS-LESS) is converted to a *LOSSY* MP3 audio stream.
##
## METHOD: Uses 'zenity --info' to show info on how this utility works.
##
##         Uses 'zenity --entry' to prompt for an image size (x,y-pixels)
##         for the output movie file.
##
##         Runs 'ffmpeg' with '-f avi' and '-vcodec libxvid' and
##         '-acodec libmp3lame' parms.
##
##         REFERENCE: http://ubuntuforums.org/archive/index.php/t-1392026.html
##                    "HOWTO: Proper Screencasting on Linux" by verb3k
##
##         Runs 'ffmpeg' in an 'xterm' so that messages can be seen.
##
##         When the conversion is done, this script
##         shows the '.avi' file in a movie player.
##
## HOW TO USE: In Nautilus, select a (.mkv) movie file.
##             Then right-click and choose this script to run (name above).
##
##     NOTE on usage of this script:
##        This script was designed to be run after the feNautilusScript
##          'XscreenANDpulseAUDIO_CAPTURE'
##       which captures an X11 desktop and Pulse audio session into
##       a 'lossless' H.264 video stream and a 'lossless' PCM audio stream
##       in a '.mkv' (Matroska container) movie file.
##
## REFERENCE: http://ubuntuforums.org/archive/index.php/t-1392026.html
##            "HOWTO: Proper Screencasting on Linux" by verb3k
##
##############################################################################
## Started: 2011may09
## Changed: 2011dec11 Removed '--no-wrap' from the 'zenity --entry' prompt for
##                    image size. '--no-wrap' is not implemented for '--entry'.
## Changed: 2012may22 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (display statements that execute)
# set -x

###########################################
## Get the INPUT ('.mkv') filename.
########################################################################
## We know that a LOSSLESS H264-PCM-MKV file from the script
## '...XscreenANDpulseAUDIO_CAPTURE...'
## is successfully convertible to an XVID-MP3-AVI video file,
## via the following 'ffmpeg' command. (according to 'verb3k')
#######################################################################

FILENAME="$1"


######################################
## Prepare the output '.avi' filename.
## (The suffix determines the container
## type that 'ffmpeg' creates.)
######################################

FILEOUT="/tmp/${USER}_MOVIEfileCONVERTEDto_LOSSY-xvid-mp3.avi"

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

into lossy XVID (MPEG-4 part 2) video and lossy MP3 audio
in an AVI container in OUTPUT file

  $FILEOUT

'ffmpeg' will be started in a terminal window so that startup
and encoding messages can be watched.  When 'ffmpeg' is done
(that is, when coding messages stop), CLOSE the terminal window.

The output file, if good, will be shown in a video player.

Now, CLOSE this window to get a PROMPT for image size of the
output --- and to, after that, START the ffmeg-window."


############################################################
## Ask for the image SIZE for the NEW LOSSY file that we
## are about to make from the INPUT video file.
############################################################

NEWSIZE=""

NEWSIZE=$(zenity --entry \
   --title "ENTER image SIZE for the new XVID-MP3-AVI file to be made." \
   --text "\
Enter an image size for the AVI file
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

'ffmpeg' CONVERSION is started in a terminal window
so that startup and coding messages can be watched.

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

################################################################
## Convert the input movie file into a lossy XVID (MPEG-4 part 2)
## video stream and lossy MP3 audio stream in an AVI container.
########
## Do the conversion in a terminal window to watch progress,
## via messages from 'ffmpeg'.
################################################################

xterm -bg black -fg white -hold -geometry 90x48+100+100 -e \
      ffmpeg -i "$FILENAME" -f avi \
         -vcodec libxvid $SPARM -qscale 8 -me_method full -mbd rd \
         -flags +gmc+qpel+mv4 -trellis 1 \
         -acodec libmp3lame -ab 128k -ar 22050 -ac 1 \
         -threads 0 "$FILEOUT"

## To minimize the size of the audio data we may use parms like
##    '-ab 96k  -ar 22050 -ac 1'   OR   '-ab 64k  -ar 22050 -ac 1'
## instead of parms like
##    '-ab 128k -ar 44100 -ac 2'

## The parameters for this 'ffmpeg' command came
## FROM "HOWTO: Proper Screencasting on Linux" by verb3k :
##
## The options from '-me_method full' to '-trellis 1' are
## encoding parameters for 'libxvid'.
##
## For video, tweaking the value of '-qscale' will give different results.
## Smaller value means higher video quality but increased file size
## and encoding time --- similar to libx264’s '-crf'.


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
