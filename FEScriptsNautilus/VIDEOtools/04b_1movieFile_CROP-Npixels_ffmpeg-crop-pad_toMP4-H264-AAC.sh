#!/bin/sh
##
## Nautilus
## SCRIPT: 04b_1movieFile_CROP_Npixels_ffmpeg-crop-pad_toMP4-H264-AAC.sh
##
## PURPOSE: Crop a user-specified number of pixels from the
##          bottom/top/left/right of a movie file --- and make the
##          output movie file an MP4-H264-AAC container-video-audio format.
##
## METHOD:  Uses 'zenity --list --radiolist' to prompt for the type of
##          crop --- bottom/top/left/right.
##
##          Uses 'zenity --entry' to prompt for the number of pixels.
##
##          Uses 'ffmpeg' with '-crop...' and '-pad...' and '-f mp4'
##          and parms for H264 video and AAC audio.
##
##          Shows the new, cropped movie file in a movie player.
##
##   NOTE on TESTING:
##       This script has not been tested on a wide variety of movie types ---
##       such as '.mpg', '.mp4', '.mkv', '.wmv', '.asf', '.avi', '.mov',
##       '.ogg' suffix files.
##
##       I may need to add 'if' statements for various suffixes, and specify
##       special conversion parms for files of certain suffix/format.
##
## HOW TO USE: In Nautilus, select a movie file.
##             Then right-click and choose this script to run (name above).
##
###############################################################################
## Started: 2012jun18 Based on FE Nautilus Scripts
##                    04b_1movieFile_CROP_Npixels_ffmpeg-crop-pad-Acopy-Vdefault_PRELIM.sh
##                 and
##                    30a_1mkvCapFile_CONVERTto_MP4-H264-AAC_4youtube_ffmpeg.sh
## Changed: 2013apr10 Added check for the ffmpeg executable.
###############################################################################

## FOR TESTING: (display the executed statements)
# set -x

#########################################################
## Check if the ffmpeg executable exists.
#########################################################

EXE_FULLNAME="/usr/bin/ffmpeg"

if test ! -f "$EXE_FULLNAME"
then
   zenity --info --title "Executable NOT FOUND." \
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
## Check that the selected file is a 'flv' or 'wmv' or 'avi' file
## --- or some other movie file, suffix to be added.
##  (Assumes just one dot [.] in the filename, at the extension.)
##################################################################

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
#  if test "$FILEEXT" != "flv" -a "$FILEEXT" != "wmv" -a \
#          "$FILEEXT" != "avi" -a "$FILEEXT" != "mov"
#  then
#     exit
#  fi


#######################################################
## Prompt for Crop-type --- top/bottom/left/right.
#######################################################

CROPTYPE=""

CROPTYPE=$(zenity --list --radiolist \
   --title "CROP top/bottom/left/right?" \
   --text "Choose one of the following crop types:" \
   --column "" --column "Type" \
   FALSE top TRUE bottom FALSE left FALSE right)

if test "$CROPTYPE" = ""
then
   exit
fi


#############################################################################
## Prompt for the number of pixels to crop from the $CROPTYPE of the movie file.
##
## Example: 18 for 18 pixels.
#############################################################################

CROPPIXELS=""

CROPPIXELS=$(zenity --entry \
   --title "Number of PIXELS to CROP." \
   --text "\
Enter number of PIXELS to CROP from the $CROPTYPE of the movie file.
(Must be a multiple of 2, for top/bottom.)" \
   --entry-text "18")

if test "$CROPPIXELS" = ""
then
   exit
fi


##########################################
## Set the ffmpeg 'crop' and 'pad' parms.
##
## !NOTE!: We try to avoid video artifacts
## introduced by re-sizing the video ---
## by padding out the area cropped --- using
## the same number of pixels for the padding
## as for the cropping.
##
## We could make padding an option, via
## another zenity prompt.
##
## We use the default black padding color,
## but we could add a '-padcolor' parm
## to the ffmpeg command below --- and add
## a zenity prompt for the color.
## (Too many zenity prompts?)
##########################################

if test "$CROPTYPE" = "top"
then
   CROPPARM="-croptop $CROPPIXELS"
   PADPARM="-padtop $CROPPIXELS"
fi

if test "$CROPTYPE" = "bottom"
then
   CROPPARM="-cropbottom $CROPPIXELS"
   PADPARM="-padbottom $CROPPIXELS"
fi

if test "$CROPTYPE" = "left"
then
   CROPPARM="-cropleft $CROPPIXELS"
   PADPARM="-padleft $CROPPIXELS"
fi

if test "$CROPTYPE" = "right"
then
   CROPPARM="-cropright $CROPPIXELS"
   PADPARM="-padright $CROPPIXELS"
fi


###############################
## Prepare the output filename.
###############################

FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`

FILEOUT="${FILENAMECROP}_CROPPED_h264-aac.mp4"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi

###################################################################
## Use 'ffmpeg' to make the cropped 'mp4-h264-aac' file.
###################################################################

## FOR TEST:
#   set -x

xterm -hold -fg white -bg black -geometry 90x48+100+100 -e \
      $EXE_FULLNAME -i "$FILENAME" -f mp4 \
         -vcodec libx264 \
         -vpre /usr/share/ffmpeg/libx264-lossless_slow.ffpreset \
         -crf 22 \
         -acodec libfaac -ab 128k  -ar 22050 -ac 1 \
         $CROPPARM $PADPARM -threads 0 "$FILEOUT"

## FOR TEST:
#    set -

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


###################################################################
## Meaning of some 'popular' ffmpeg parms:
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

##################################
## Show the (cropped) movie file.
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


##############################################
## Use a user-specified MOVIEPLAYER. Someday?
##############################################

#  . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
#  . $DIR_NautilusScripts/.set_VIEWERvars.shi

#   $MOVIEPLAYER "$FILEOUT" &
