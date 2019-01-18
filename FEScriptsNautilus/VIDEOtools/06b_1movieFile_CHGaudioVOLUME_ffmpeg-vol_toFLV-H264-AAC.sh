#!/bin/sh
##
## Nautilus
## SCRIPT: 06b_1movieFile_CHGaudioVOLUME_ffmpeg-vol_toFLV-H264-AAC.sh
##
## PURPOSE: Change the audio volume of a movie file --- and make the
##          format of the output file FLV-H264-AAC (container-video-audio).
##
## METHOD:  Uses 'zenity --entry' to prompt for the volume adjustment
##          --- a percentage.
##
##          Uses 'ffmpeg' with the '-vol' parameter to make a new movie file.
##
##          This script shows the new movie file in a movie player.
##
##          We make the output movie file in the flv-h264-aac format
##          (container-video-audio).
##          We use the '-f' and '-vcodec' and '-acodec' ffmpeg parms.
##
##   NOTE on suffixes and container format:
##       ffmpeg ordinarily chooses the output container format based on
##       the file extension of the output file --- unless the '-f'
##       (container format) option is specified.
##
##       Sometimes making the output file have the same extension as
##       the input file will work --- for '.flv' and '.mp4' and '.avi' files.
##       Some input file extensions on the output file may not work --- such as
##       '.wmv' or '.ogv' or '.mpg'. However, they may work if '-f' is used with
##       specifications such as 'asf' or 'ogg' or 'mpeg', respectively.
##
##       This script works by specifying the output container-video-audio formats
##       by using the '-f' '-vcodec' '-acodec' parms of ffmpeg.
##
##   NOTE on testing:
##       The script needs to be tested on a wide variety of input movie files ---
##       with suffixes such as 'mp4', 'mkv', 'flv', 'avi', 'wmv', 'mov', etc.
##
## TEST RESULTS:
##       I may add comments here to indicate which formats have been tested.
##
##
## REFERENCES:
##       Google 'ffmpeg audio volume' or 'ffmpeg vol' or 'ffmpeg loud movie'
##           or 'ffmpeg audio volume flv h.264 aac' or ...
##
## REFERENCES:
##       http://blog.adtools.co.uk/easily-reduce-or-increase-flv-video-audio-levels-easily-using-ffmpeg/693/
##
## HOW TO USE: In Nautilus, select a movie file.
##             Then right-click and choose this script to run (name above).
##
##############################################################################
## Started: 2012jun12 Based on FE Nautilus Scripts
##               01_1movieFile_CHGaudioVOLUME_ffmpeg-vol-Vcopy-Amp3_PRELIM.sh
##                    and
##               04c_1movieFile_CROP_Npixels_ffmpeg-crop-pad_toFLV-H264-AAC.sh
## Changed: 2012jul20 Add 'vob' to allowed input suffixes.
###########################################################################

## FOR TESTING: (display the executed statements)
# set -x

##############################################
## Get the filename of the selected file.
##############################################

  FILENAME="$1"
# FILENAMES="$@"
# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"


##################################################################
## Check that the selected file has an extension that we think
## we can support --- like 'mp4' or 'mkv' or 'flv' or 'avi' or
## 'wmv' or 'asf' or 'mov' or 'mpg' or 'mpeg' or 'ogg' or 'ogv'
## or '3gp'.
##
## Some other suffixes may be added as we encounter new
## file formats to which we do an audio volume change.
##
##  (Assumes just one dot [.] in the filename, at the extension.)
##################################################################

THIS_SCRIPT=`basename $0`

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
if test "$FILEEXT" != "mp4"  -a "$FILEEXT" != "mkv"  -a \
        "$FILEEXT" != "avi"  -a "$FILEEXT" != "flv"  -a \
        "$FILEEXT" != "asf"  -a "$FILEEXT" != "wmv"  -a \
        "$FILEEXT" != "mov"  -a \
        "$FILEEXT" != "mpeg" -a "$FILEEXT" != "mpg" -a \
        "$FILEEXT" != "ogg"  -a "$FILEEXT" != "ogv" -a \
        "$FILEEXT" != "3gp"  -a "$FILEEXT" != "vob"
then
   zenity --info \
          --title "UNSUPPORTED SUFFIX.  EXITING..." \
          --text "\
The suffix of the input file ( $FILEEXT ) does not look like one
that may be supported by this script:
$THIS_SCRIPT.

'Supported' suffixes may be:
mp4, mkv, avi, flv, asf, wmv, mov, mpeg, mpg, ogg, ogv, 3gp, vob

If you think this file should be supported, you can edit
this script and add/change the appropriate 'if' statements.

EXITING ..."

    exit
fi


#############################################################################
## Prompt for the audio volume adjustment of the movie file.
##
## Example: 50 for 50% of original volume.
#############################################################################

AUDIOPCNT=""

AUDIOPCNT=$(zenity --entry \
   --title "AUDIO VOLUME adjustment (percent)." \
   --text "\
Enter a number for percent adjustment of the volume.
Example: 25 for 25% of original volume." \
   --entry-text "25")

if test "$AUDIOPCNT" = ""
then
   exit
fi

AUDIOFACTOR=`expr $AUDIOPCNT \* 256 / 100`


###############################
## Prepare the output filename.
###############################

FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`

FILEOUT="${FILENAMECROP}_audiopct${AUDIOPCNT}_h264-aac.flv"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


###################################################################
## Use 'ffmpeg' to make the audio-changed movie file in
## flv-h264-aac format (container-video-audio).
###################################################################
## REFERENCE:
## http://blog.adtools.co.uk/easily-reduce-or-increase-flv-video-audio-levels-easily-using-ffmpeg/693/
##################################################################

## FOR TEST: (show statements as they execute)
#   set -x

xterm -hold -fg white -bg black -geometry 90x48+100+100 -e \
      ffmpeg -i "$FILENAME" -f flv \
         -vcodec libx264 \
         -vpre /usr/share/ffmpeg/libx264-lossless_slow.ffpreset \
         -crf 22 \
         -acodec libfaac -ab 128k  -ar 22050 -ac 1 \
         -vol $AUDIOFACTOR -threads 1 "$FILEOUT"

## FOR TEST:
#    set -

## These options come FROM the FE 'VIDCAP_CONVERT' Nautilus Script 
## 30b_1mkvCapFile_CONVERTto_FLV-H264-AAC_LIKEyoutube_ffmpeg.sh

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
## This documents which vpre file we are using.


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


###################################################################
## Meaning of 'popular' ffmpeg parms:
##
## -i  val = input filename
## Video:
## -r  val = frame rate in frames/sec
## -b  val = video bitrate in kbits/sec (default = 200 kbps)
## -s  val = frame size, wxh where w and h are pixels or abbrevs:
##          qqvga =  160x120
##           qvga =  320x240
##            vga =  640x480
##           svga =  800x600
##            xga = 1024x768
##           sxga = 1280x1024
##           uxga = 1600x1200
##   -vcodec codec - to force the video codec.
##                   Example: -vcodec mpeg4 
##                   Try  "ffmpeg -formats"
## Audio:
## -ab val = audio bitrate in bits/sec (default = 64k)
## -ar val = audio sampling frequency in Hz (default = 44100 Hz)
##   -ac channels - default = 1
##   -an - disable audio recording
##   -acode codec - to force the audio codec. Example:
##                                      -acodec libmp3lame
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
##   -t duration - format is hh:mm:ss[.xxx]
##   -ss position - seek to given position, in secs or hh:mm:ss[.xxx]
##   -target type - where type is vcd or svcd or dvd or ..., then
##                  bitrate, codecs, buffersizes are set automatically.
##   -pass n, where n is 1 or 2
##
## Other:
##   -y  = overwrite output file(s)
##   -fs file-size-limit
##   -debug
##   -threads count
#######################################################################

#####################################
## Show the audio-changed movie file.
#####################################

if test ! -f "$FILEOUT"
then
   exit
fi

# MOVIEPLAYER="/usr/bin/vlc"
# MOVIEPLAYER="/usr/bin/mplayer"
# MOVIEPLAYER="/usr/bin/gnome-mplayer"
# MOVIEPLAYER="/usr/bin/totem"

MOVIEPLAYER="/usr/bin/ffplay -stats"

xterm -fg white -bg black -hold -geometry 90x24+100+100 \
      -e $MOVIEPLAYER "$FILEOUT"

## Use a user-specified MOVIEPLAYER. Someday?

#  . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
#  . $DIR_NautilusScripts/.set_VIEWERvars.shi

#   $MOVIEPLAYER "$FILEOUT" &
