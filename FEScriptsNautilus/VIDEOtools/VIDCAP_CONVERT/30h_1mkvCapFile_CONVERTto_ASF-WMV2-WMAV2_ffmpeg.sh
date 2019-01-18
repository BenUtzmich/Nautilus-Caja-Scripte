#!/bin/sh
##
## Nautilus
## SCRIPT: 30h_1mkvCapFile_CONVERTto_ASF-WMV2-WMAV2_ffmpeg.sh
##
## PURPOSE: Using 'ffmpeg', this script converts an input movie file
##          to a '.asf' container movie file.
##
##          This script is intended to use as input '.mkv' (Matroska container)
##          movie files that are 'lossless' H264-and-PCM
##          screen-and-audio-captures from a 'XscreenANDpulseAUDIO_CAPTURE'
##          script --- but it may work with other movie file inputs, that is,
##          different container formats, such as '.flv' or '.avi' or '.mpg'.
##
##          The input video stream (possibly near LOSS-LESS) is converted to
##          a *LOSSY* 'wmv2' video stream and the input audio stream (possibly
##          near LOSS-LESS) is converted to a *LOSSY* 'wmav2' audio stream.
##
##               (We could probably use suffix '.wmv' for the container file,
##                which seems to be commonly done.)
##
## METHOD: Uses 'zenity --info' to show info on how this utility works.
##
##         Uses 'zenity --entry' to prompt for an image size (x,y-pixels)
##         for the output movie file.
##
##         Runs 'ffmpeg' with '-f mp4' and '-vcodec libx264' and
##         '-acodec libfaac' parms.
##
##         Runs 'ffmpeg' in an 'xterm' so that messages can be seen.
##
##         When the conversion is done, this script
##         shows the '.asf'/'.wmv' file in a movie player.
##
##
##    REFERENCE: http://ubuntuforums.org/archive/index.php/t-1392026.html
##            "HOWTO: Proper Screencasting on Linux" by verb3k
##            Shows how a good-quality LOSS-LESS '.mkv' file can be created.
##
##            That HOWTO does not mention converting to wmv formats.
##            The ffmpeg parms that we try in this script are based on
##            a 2009 web page: 
##               http://ubuntuforums.org/archive/index.php/t-1074152.html
##            in particular, the command which worked for Nixie Pixel:
##
##    ffmpeg -i infile.flv -vcodec wmv2 -sameq -acodec wmav2 -f asf outfile.asf
##
##
## HOW TO USE: In Nautilus, select a (.mkv) movie file.
##             Then right-click and choose this script to run (name above).
##
#############################################################################
## Started: 2011may12
## Changed: 2011dec11 Removed '--no-wrap' from the 'zenity --entry' prompt for
##                    image size. '--no-wrap' is not implemented for '--entry'.
## Changed: 2012may24 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (display statements that execute)
# set -x

###########################################
## Get the INPUT movie filename.
########################################################################
## We can create a LOSSLESS H264-PCM-MKV file from the script
## '30_VIDpulseAUD_screenCAPTURElossless_toH264-PCM-MKV_ffmpeg_Qquit.sh'
## (according to 'verb3k')
#######################################################################

FILENAME="$1"


###############################################
## Prepare the OUTPUT '.asf' filename.
## (The suffix usually determines the container
## type that 'ffmpeg' creates. If that does not
## work, try using '-f'.)
###############################################

FILEOUT="/tmp/${USER}_MOVIEfileCONVERTEDto_LOSSY-WMV2-WMAV2.asf"

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
will use 'ffmpeg' to [try to] convert the INPUT file

  $FILENAME

in directory

  $CURDIRFOLDED

into lossy 'WMV2' video and lossy 'WMAV2' audio in
a 'ASF' container in OUTPUT file

  $FILEOUT

'ffmpeg' will be started in a terminal window so that startup
and coding messages can be watched.  When 'ffmpeg' is done
(that is, when encoding messages stop), CLOSE the terminal window.

  The output file, if good, will be shown in a video player.

Now, CLOSE this window to get a PROMPT for image size of the
output --- and to, after that, START the ffmeg-window."


############################################################
## Ask for the image SIZE for the NEW LOSSY file that we
## are about to make from the INPUT video file.
############################################################

NEWSIZE=""

NEWSIZE=$(zenity --entry \
   --title "ENTER image SIZE for the new WMV2-WMAV2-ASF file to be made." \
   --text "\
Enter an image size for the ASF (.asf) file

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
 1600x1200 = UXGA   (4:3 = 1.33...)
        0  = same size as input file

'ffmpeg' CONVERSION will be started in a terminal window
so that startup and encoding messages can be watched.

When the 'ffmpeg' run is done, CLOSE the terminal window.
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

###########################################################
## Convert the input movie file into a lossy WMV2 video
## stream and lossy WMAV2 audio stream in an ASF container.
###################################################################
## The parameters for this 'ffmpeg' command came FROM
##  http://ubuntuforums.org/archive/index.php/t-1074152.html
###################################################################
## We do the ffmpeg run in a terminal window to watch progress,
## via messages from 'ffmpeg'.
###########################################################

xterm -bg black -fg white -hold -geometry 90x48+100+100 -e \
    ffmpeg -i "$FILENAME" -f asf \
           -vcodec wmv2 $SPARM -b 750k \
           -acodec wmav2 -ab 128k -ar 22050 -ac 1 \
           -threads 1 "$FILEOUT"


## To minimize the size of the audio data we may use parms like
##    '-ab 96k  -ar 22050 -ac 1'   OR   '-ab 64k  -ar 22050 -ac 1'
## instead of parms like
##    '-ab 128k -ar 44100 -ac 2'


## '-threads 0' (multi-core) can cause some codecs
## to hang without posting any msgs. That happened with wmv2,wmav2,
## so we use '-threads 1'.

## Others have used '-b 459k' or '-b 200k' or '-b 1000k' or '-b 1150'.
## Removing '-b' seems to result, in some conversions of other types,
## in a very high bit rate, like 100,000k.

## Instead of '-b', we could try '-sameq' as in the example below.

## Could add '-r' --- like '-r 24' or '-r29.92' or '-r 29.97' or '-r 30'.
## But that might result in lower quality output if the value does not match
## (is not very near or a sub-multiple of) the frame rate of the input file.

## Could use '-ab 64k' or '-ab 96k' instead of '-ab 128k' or higher,
## if hi-fidelity sound not needed.

## Could try 'ac 1' for mono sound, rather than stereo.

## REFERENCE 2009 web page: 
##               http://ubuntuforums.org/archive/index.php/t-1074152.html
##            in particular, the command which worked for Nixie Pixel,
##            to convert a '.flv' Flash video file:
##
##    ffmpeg -i infile.flv -vcodec wmv2 -sameq -acodec wmav2 -f asf outfile.asf

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
