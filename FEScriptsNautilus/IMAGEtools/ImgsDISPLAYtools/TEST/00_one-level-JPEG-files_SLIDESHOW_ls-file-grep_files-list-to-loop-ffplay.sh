#!/bin/sh
##
## Nautilus
## SCRIPT: 00_one-level-JPEG-files_SLIDESHOW_ls-file-grep_files-list-to-loop-ffplay.sh
##
## PURPOSE: Finds ALL the files in the current directory
##          whose file-type contains the string
##          'JPEG image data' --- using 'ls', 'file', and 'grep'.
##
##          Example outputs from 'file' on JPEG files:
##
##            JPEG image data, EXIF standard 
##            JPEG image data, JFIF standard 1.01 
##            JPEG image data, JFIF standard 1.02
##
##          Shows the files with an image viewer --- 'ffplay' that comes with
##          an installation of 'ffmpeg'.
##
## METHOD:  Builds a list of JPEG filenames --- found by the 'ls-file-grep'
##          combo --- and each file is shown with a separate instance of
##          'ffplay', in a 'for' loop.
##
##          Note that this technique works even if the JPEG files
##          have no suffix, such as '.jpg' --- or a wrong suffix.
##
## HOW TO USE: Right-click on the name of any file (or directory) in
##             a Nautilus list, after navigating to a 'base' directory.
##             Then choose this Nautilus script (name above).
#########################################################################
## MAINTENANCE HISTORY:
## Created: 2013apr10
## Changed: 2013
#########################################################################

## FOR TESTING: (show statements as they execute)
#   set -x

#########################################################
## Check if the ffplay executable exists.
#########################################################

EXE_FULLNAME="/usr/bin/ffplay"

if test ! -f "$EXE_FULLNAME"
then
   zenity  --info --title "Executable NOT FOUND." \
   --no-wrap \
   --text  "\
The ffplay executable
   $EXE_FULLNAME
was not found. Exiting.

If the executable is in another location,
you can edit this script to change the filename.
OR, install the 'ffmpeg' package. It includes 'ffplay'."
   exit
fi


#########################################################
## Prompt for X and Y size of the display area.
#########################################################

XYPIXELS=""

XYPIXELS=$(zenity --entry --title "Enter X and Y pixels, size of display area." \
   --text "\
Enter the X and Y sizes for the display area of the slide show.
Examples: 1024 720   OR   800 600" \
   --entry-text "1024 720")

if test "$XYPIXELS" = ""
then
   exit
fi

XPIXELS=`echo "$XYPIXELS" | cut -d' ' -f1`
YPIXELS=`echo "$XYPIXELS" | cut -d' ' -f2`


########################################################################
## Use 'ls-file-grep' to get the JPEG filenames.
########################################################################
## REFERENCE for this technique - FE Nautilus script:
## 07t_anyfile4Dir_PLAYall-mp3sOfDir-in-Totem_ls-grep-make-filenames-string.sh
## in the 'AUDIOtools' group.
########################################################################

## This does not work for filenames with embedded spaces.
#  JPGNAMES=`ls  | grep '\.jpg$' | sed 's|$| |'`

FILENAMES=`ls`
 
HOLD_IFS="$IFS"
## We put a single line-feed in IFS.
IFS='
'

## It would be nice to avoid changing IFS, but I have not
## found a way, yet, to make the 'in' reader
## of the 'for' loop recognize the separate filenames
## when filenames contain spaces.
##   (Perhaps we could use 'sed' to put a quote at the
##    beginning and end of each line in $FILENAMES.)

JPGNAMES=""

for FILENAME in $FILENAMES
do
   FILECHK=`file "$FILENAME" | grep 'JPEG image'`
   if test ! "$FILECHK" = ""
   then
      JPGNAMES="$JPGNAMES \"$FILENAME\""
   fi
done

IFS="$HOLD_IFS"

if test "$JPGNAMES" = ""
then
   zenity  --info --title "NO MATCHES." \
      --text  "No JPEG files found. EXITING."
   exit
fi

## FOR TESTING:
#  xterm -fg white -bg black -hold -geometry 90x24+100+100 -e \
#  echo "JPGNAMES: $JPGNAMES"


########################################################################
## Pass the string of filenames to the 'ffplay' image viewer command.
## (Simply using $FILENAMES as input to the viewer will encounter failures
##  when there are spaces embedded in filenames.)
########################################################################

for JPGNAME in $JPGNAMES
do
   eval $EXE_FULLNAME -x $XPIXELS -y $YPIXELS -an "$JPGNAME"
done

exit
## This 'exit' is needed to avoid the following text
## being fed to the script interpreter.

#########################################################################
## INFO ON 'ffplay'.
#########################################################################

NOTE: 'man ffplay' shows:

NAME
       ffplay - FFplay media player

SYNOPSIS
       ffplay [options] input_file

DESCRIPTION
       FFplay is a very simple and portable media player using the FFmpeg
       libraries and the SDL library. It is mostly used as a testbed for the
       various FFmpeg APIs.

OPTIONS
   Main options
       -h  Show help.

       -version
	   Show version.

       -L  Show license.

       -formats
	   Show available formats, codecs, protocols, ...

       -x width
	   Force displayed width.

       -y height
	   Force displayed height.

       -s size
	   Set frame size (WxH or abbreviation), needed for videos which do not
	   contain a header with the frame size like raw YUV.

       -an Disable audio.

       -vn Disable video.

       -ss pos
	   Seek to a given position in seconds.

       -bytes
	   Seek by bytes.

       -nodisp
	   Disable graphical display.

       -f fmt
	   Force format.

   Advanced options
       -pix_fmt format
	   Set pixel format.

       -stats
	   Show the stream duration, the codec parameters, the current
	   position in the stream and the audio/video synchronisation drift.

       -debug
	   Print specific debug info.

       -bug
	   Work around bugs.

       -vismv
	   Visualize motion vectors.

       -fast
	   Non-spec-compliant optimizations.

       -genpts
	   Generate pts.

       -rtp_tcp
	   Force RTP/TCP protocol usage instead of RTP/UDP. It is only
	   meaningful if you are streaming with the RTSP protocol.

       -sync type
	   Set the master clock to audio ("type=audio"), video ("type=video")
	   or external ("type=ext"). Default is audio. The master clock is
	   used to control audio-video synchronization. Most media players use
	   audio as master clock, but in some cases (streaming or high quality
	   broadcast) it is necessary to change that. This option is mainly
	   used for debugging purposes.

       -threads count
	   Set the thread count.

       -ast audio_stream_number
	   Select the desired audio stream number, counting from 0. The number
	   refers to the list of all the input audio streams. If it is greater
	   than the number of audio streams minus one, then the last one is
	   selected, if it is negative the audio playback is disabled.

       -vst video_stream_number
	   Select the desired video stream number, counting from 0. The number
	   refers to the list of all the input video streams. If it is greater
	   than the number of video streams minus one, then the last one is
	   selected, if it is negative the video playback is disabled.

       -sst subtitle_stream_number
	   Select the desired subtitle stream number, counting from 0. The
	   number refers to the list of all the input subtitle streams. If it
	   is greater than the number of subtitle streams minus one, then the
	   last one is selected, if it is negative the subtitle rendering is
	   disabled.

   While playing
       q, ESC
	   Quit.

       f   Toggle full screen.

       p, SPC
	   Pause.

       a   Cycle audio channel.

       v   Cycle video channel.

       t   Cycle subtitle channel.

       w   Show audio waves.

       left/right
	   Seek backward/forward 10 seconds.

       down/up
	   Seek backward/forward 1 minute.

       mouse click
	   Seek to percentage in file corresponding to fraction of width.
