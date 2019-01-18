#!/bin/sh
##
## Nautilus
## SCRIPT: 08b_1movieFile_ROTATE_mencoder-vf-rotate_toMP4.sh
##
## PURPOSE: Rotate a movie file 90-degrees, clockwise or counter-clockwise.
##
## METHOD:  Uses 'zenity --entry' to prompt for a rotation option.
##
##          Uses 'mencoder' with option '-vf' (vfilters) to specify
##          the type of rotation.
##
##          The video codec is specified by the '-ovc' option.
##          The audio codec is specified by the '-oac' option.
##          The container format is specified by the output file suffix
##          --- or by '-f' (?).
##
##          Shows the new, rotated movie file in a movie player.
##
##     NOTE on TESTING:
##       This script has not been tested on a wide variety of movie types ---
##       such as '.mpg', '.mp4', '.mkv', '.wmv', '.asf', '.avi', '.mov',
##       '.ogg' suffix files.
##
##       I may add comments here on which input formats (container,video,audio)
##       have been tested and the outcome.
##
## HOW TO USE: In the Nautilus file manager, select a movie file.
##             Then right-click and choose this script to run.
##             (Script name is above.)
##
## REFERENCES:
## http://www.thelinuxblog.com/rotating-videos-in-linux/
## http://www.mplayerhq.hu/DOCS/HTML/en/menc-feat-selecting-codec.html
##  http://stackoverflow.com/questions/3937387/rotating-videos-with-ffmpeg
##
#############################################################################
## Started: 2016oct21 Based on FE Nautilus Script
##                    08a_1movieFile_ROTATE_ffmpeg-vf-transpose_toMP4-H264-AAC.sh
## Changed: 2016oct21 Added '-vf harddup -mc 0 -noskip' options to the 'mencoder'
##                    command, to try to solve too-fast-playback of output file
##                    by Windows Media Player (skipping frames?).
#############################################################################

## FOR TESTING: (display the executed statements)
# set -x

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
##        'mkv', 'mp4', 'flv', 'mpg', 'mpeg', 'wmv', 'avi', 'asf',
##     and others.
##
##  (Assumes just one dot [.] in the filename, at the extension.)
##################################################################

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
#  if test "$FILEEXT" != "mkv" -a "$FILEEXT" != "mp4"  -a \
#          "$FILEEXT" != "flv" -a "$FILEEXT" != "mov"  -a \
#          "$FILEEXT" != "mpg" -a "$FILEEXT" != "mpeg" -a \
#          "$FILEEXT" != "wmv" -a "$FILEEXT" != "avi"  -a \
#          "$FILEEXT" != "asf"
#  then
#     exit
#  fi


###########################################################
## Prompt for Rotate option number --- for -vf rotate=?.
## For the transpose parameter you can pass:
## 
## 0 = 90 CounterCLockwise and Vertical Flip (default)
## 1 = 90 Clockwise
## 2 = 90 CounterClockwise
## 3 = 90 Clockwise and Vertical Flip
##
###########################################################

ROTATE_NUM=""

ROTATE_NUM=$(zenity --entry \
   --title "Supply a ROTATE option number." \
   --text "\
Enter the number 0, 1, 2, or 3.

 0 = 90 CounterCLockwise and Vertical Flip
 1 = 90 Clockwise
 2 = 90 CounterClockwise
 3 = 90 Clockwise and Vertical Flip

The new file will have the string '__ROTATED__opt' in the filename." \
   --entry-text "1")

if test "$ROTATE_NUM" = ""
then
   exit
fi


###############################
## Prepare the output filename.
###############################

FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`

FILEOUT="${FILENAMECROP}_ROTATED_opt${ROTATE_NUM}_mencoder-lavc-faac.mp4"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


###################################################################
## Use 'ffmpeg' to make the rotated movie file.
###################################################################

## FOR TEST:
#   set -x

xterm -hold -fg white -bg black -geometry 90x48+100+100 -e \
   mencoder -of lavf \
      -ovc lavc -vf rotate=1,harddup \
      -mc 0 -noskip \
      -of lavf \
      -oac faac \
      "$FILENAME" -o  "$FILEOUT"

## The following simple form seems to work OK (but some speedup/sync problems?)
## on my Ubuntu 9.10 Karmic Koala (2009oct) distro.
##   mencoder -ovc lavc -vf rotate=1 -oac copy \
##      "$FILENAME" -o  "$FILEOUT"

## BNOTE that I am getting the following message from test runs:
## with the '-oavc lavc' option:
##
## ** MUXER_LAVF *****************************************************************
## REMEMBER: MEncoder's libavformat muxing is presently broken and can generate
## INCORRECT files in the presence of B-frames. Moreover, due to bugs MPlayer
## will play these INCORRECT files as if nothing were wrong!
## *******************************************************************************
##
## I may look into alternative options to remove this message,
## but probably in post-2016 releases of mplayer/mencoder.
##
## When I tried '-ovc x264', I go the following error:
##
##    x264 [error]: no ratecontrol method specified
##    x264_encoder_open failed.
##    FATAL: Cannot initialize video driver.
##
## An attempt to provide a ratecontrol failed.

## For container info, the 'mencoder -of help' command on my computer showed:
##
## $ mencoder -of help
## MEncoder SVN-r29237-4.4.1 (C) 2000-2009 MPlayer Team
## 
## Available output formats:
##    avi      - Microsoft Audio/Video Interleaved
##    mpeg     - MPEG-1/2 system stream format
##    lavf     - FFmpeg libavformat muxers
##    rawvideo - (video only, one stream only) raw stream, no muxing
##    rawaudio - (audio only, one stream only) raw stream, no muxing
##
## NOTE: 'man mencoder' says '-of' is BETA CODE!

## For video codec info, the 'mencoder -ovc help' command on my computer showed:
##
## $ mencoder -ovc help
## MEncoder SVN-r29237-4.4.1 (C) 2000-2009 MPlayer Team
## 
## Available codecs:
##   copy     - frame copy, without re-encoding. Doesn't work with filters.
##   frameno  - special audio-only file for 3-pass encoding, see DOCS.
##   raw      - uncompressed video. Use fourcc option to set format explicitly.
##   nuv      - nuppel video
##   lavc     - libavcodec codecs - best quality!
##   vfw      - VfW DLLs, read DOCS/HTML/en/encoding-guide.html.
##   qtvideo  - QuickTime DLLs, currently only SVQ1/3 are supported.
##   xvid     - XviD encoding
##   x264     - H.264 encoding

## For audio codec info, the 'mencoder -oac help' command on my computer showed:
##
## $ mencoder -oac help
## MEncoder SVN-r29237-4.4.1 (C) 2000-2
## 
## Available codecs:
##   copy     - frame copy, without re
##   pcm      - uncompressed PCM audio
##   mp3lame  - cbr/abr/vbr MP3 using 
##   lavc     - FFmpeg audio encoder (MP2, AC3, ...)
##   faac     - FAAC AAC audio encoder


## For video filters info, the 'mencoder -vf help' command on my computer showed:
##
## $ mencoder -vf help
## Available video filters:
##   rectangle      : draw rectangle
##   bmovl          : Read bitmaps from a FIFO and display them in window
##   crop           : cropping
##   expand         : expanding & osd
##   pp             : postprocessing
##   scale          : software scaling
##   vo             : libvo wrapper
##   format         : force output format
##   noformat       : disallow one output format
##   yuy2           : fast YV12/Y422p -> YUY2 conversion
##   flip           : flip image upside-down
##   rgb2bgr        : fast 24/32bpp RGB<->BGR conversion
##   rotate         : rotate
##   mirror         : horizontal mirror
##   palette        : 8bpp indexed (using palette) -> BGR 15/16/24/32 conversion
##   pp7            : postprocess 7
##   lavc           : realtime mpeg1 encoding with libavcodec
##   lavcdeint      : libavcodec's deinterlacing filter
##   screenshot     : screenshot to file
##   dvbscale       : calc Y scaling for DVB card
##   cropdetect     : autodetect crop size
##   test           : test pattern generator
##   noise          : noise generator
##   yvu9           : fast YVU9->YV12 conversion
##   eq             : soft video equalizer
##   eq2            : Software equalizer
##   halfpack       : yuv planar 4:2:0 -> packed 4:2:2, half height
##   dint           : drop interlaced frames
##   1bpp           : 1bpp bitmap -> YUV/BGR 8/15/16/32 conversion
##   2xsai          : 2xSai BGR bitmap 2x scaler
##   unsharp        : unsharp mask & gaussian blur
##   swapuv         : UV swapper
##   il             : (de)interleave
##   fil            : fast (de)interleaver
##   boxblur        : box blur
##   sab            : shape adaptive blur
##   smartblur      : smart blur
##   perspective    : perspective correcture
##   down3dright    : convert stereo movie from top-bottom to left-right field
##   field          : extract single field
##   denoise3d      : 3D Denoiser (variable lowpass filter)
##   hqdn3d         : High Quality 3D Denoiser
##   detc           : de-telecine filter
##   telecine       : telecine filter
##   tinterlace     : temporal field interlacing
##   tfields        : temporal field separation
##   ivtc           : inverse telecine, take 2
##   ilpack         : 4:2:0 planar -> 4:2:2 packed reinterlacer
##   dsize          : reset displaysize/aspect
##   decimate       : near-duplicate frame remover
##   softpulldown   : mpeg2 soft 3:2 pulldown
##   pullup         : pullup (from field sequence to frames)
##   filmdint       : Advanced inverse telecine filer
##   framestep      : Dump one every n / key frames
##   tile           : Make a single image tiling x/y images
##   delogo         : simple logo remover
##   remove-logo    : Removes a tv logo based on a mask image.
##   hue            : hue changer
##   yuvcsp         : yuv colorspace converter
##   kerndeint      : Kernel Deinterlacer
##   rgbtest        : rgbtest
##   phase          : phase shift fields
##   divtc          : inverse telecine for deinterlaced video
##   harddup        : resubmit duplicate frames for encoding
##   softskip       : soft (post-filter) frame skipping for encoding
##   ass            : Render ASS/SSA subtitles
##   yadif          : Yet Another DeInterlacing Filter
##   blackframe     : detects black frames
##   ow             : overcom

## For audio filters info, the 'mencoder -af help' command on my computer failed:
##
## $ mencoder -af help
## MEncoder SVN-r29237-4.4.1 (C) 2000-2009 MPlayer Team
## No file given
## 
## Exiting... (error parsing command line)
##
## I had to use 'man mencoder' for help on audio filters.

## The 'ffmpeg' command was:
##
##   ffmpeg -i "$FILENAME" -f mp4 \
##      -vcodec libx264 \
##      -vpre /usr/share/ffmpeg/libx264-lossless_slow.ffpreset \
##      -crf 22 \
##      -acodec libfaac -ab 128k  -ar 22050 -ac 1 \
##      -vf \"transpose=$ROTATE_NUM\"  -threads 0  "$FILEOUT"
##
## These options come FROM the FE 'VIDCAP_CONVERT' Nautilus Script 
## 30a_1mkvCapFile_CONVERTto_MP4-H264-AAC_4youtube_ffmpeg.sh
##
## To reduce the size of the audio data we may use parms like
##    '-ab 96k  -ar 22050 -ac 1'   OR   '-ab 64k  -ar 22050 -ac 1'
## instead of parms like
##    '-ab 128k -ar 44100 -ac 2'
##
## Change '-ac 1' to '-ac 2' if you want to preserve stereo.
##
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
##
## Originally tried
##               -vcodec libx264 -vpre slow -crf 22 \
## BUT vpre 'slow' was not found.
## Fixed that by using the fully-qualified name above. (2011may06)
## This documents exactly which vpre file we are using.
##
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

#######################################################################
## The 'man' help for mencoder is combined with the 'man' help for
## 'mplayer'. That 'man' help says:
##
##    mencoder (MPlayer's Movie Encoder) is a simple movie encoder, designed
##    to encode MPlayer-playable movies (see above) to other MPlayer-playable
##    formats (see  below).	It encodes to MPEG-4 (DivX/Xvid), one of the
##    libavcodec codecs and PCM/MP3/VBRMP3 audio in 1, 2 or 3	passes.
##
##    Furthermore  it  has  stream  copying  abilities, a powerful
##    filter system (crop, expand, flip, postprocess, rotate, scale,
##    noise, RGB/YUV conversion) and more.
##
##
#######################################################################


##################################
## Show the (scaled) movie file.
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


###############################################
## Use a user-specified MOVIEPLAYER. Someday?
###############################################

#  . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
#  . $DIR_NautilusScripts/.set_VIEWERvars.shi

#   $MOVIEPLAYER "$FILEOUT" &
