#!/bin/sh
##
## Nautilus
## SCRIPT: cap09_anyfile_DEVvideo-pulseAUDIO_CAPTUREto_FLV-H264-PCM_ffmpeg_Qquit_PRELIM.sh
##
## PURPOSE: Using 'ffmpeg', this script captures /dev/videoN activity in
##          a video stream recorded in a libx264 (H.264) movie format.
##
##          (NOTE: Need to add a zenity prompt for /dev/videoN where
##                 N is usually 0 [webcam] or 1 [another video device,
##                 such as a digital microscope]. Currently defaulted to /dev/video0)
##
##          Currently, the 'ffmpeg' command captures audio from a pulseaudio
##          sound server encoding the audio stream into 'LOSSLESS' raw PCM.
##
##          In this script, 'ffmpeg' puts the video and audio streams in an
##          FLV container --- in a '.flv' file.
##
## METHOD:  Uses 'zenity --entry' to prompt for number of threads to use in
##          doing the recording (to take advantage of multi-core machines) ---
##          assuming the libx264 encoder is threaded.
##
##          Uses 'zenity --info' to show info on how this utility works.
##
##          Uses 'zenity --entry' to prompt for a 'delay time' to allow time
##          to setup for recording video.
##
##          Runs 'ffmpeg' with '-f video4linux2 -i /dev/video0' and '-vcodec libx264'
##          and 'lossless' audio parms '-f alsa -ac 2 -i pulse -acodec pcm_s16le'
##          --- along with various other parms.
##               Puts the media streams in a '.flv' suffix file.
##
##          NOTE on some ffmpeg hard-coded parms:
##             Change the MOVIESIZE and OFFSET parameters near the top of this
##             code, to set the recording area (which can be the screen size).
##
##          Runs 'ffmpeg' in an 'xterm' so that messages can be seen and
##          so that the recording can be stopped.
##
##          The user ends the recording by entering 'q' in
##          the terminal in which 'ffmpeg' is running.
##
##          Shows the captured '.flv' file in a movie player.
##
###############  NOTES and REFERENCES on ffmpeg for movie capture  ###############
##
## REFERENCES: http://ffmpeg.org/trac/ffmpeg/ticket/445
##             which showed the video capture command:
##
##            ffmpeg -f video4linux2 -i /dev/video0 -vcodec libx264 -crf 20 \
##            -threads 0 out.flv
##
##            For additional video capture info and info on audio capture, see
##            http://ubuntuforums.org/archive/index.php/t-1392026.html
##                 "HOWTO: Proper Screencasting on Linux"
##            Some quotes from that page follow.
##
## "...we capture audio from pulse (pulseaudio sound server) and encode it
## to *'lossless'* raw PCM with 2 audio channels (stereo). Then, we grab a
## video stream from x11 at a frame rate of 30 and a size of 1024x768
## from the display :0.0 and encode it to *'lossless'* h264 using libx264.
## ... The resulting streams will be muxed in a Matroska container (.mkv)."
##    
## "Using '-threads 0' means automatic thread detection."
##
##
## NOTE: You might want to record one audio channel, with '-ac 1'.
##       AND
##       You might want use a frame rate less than 30, say 25 or even less.
##       These changes may reduce size of the output file significantly.
##
## Audio parms - pulse/alsa/oss:
##
##    "Most recent Linux distributions have PulseAudio installed by default,
##     but if your distribution does not use the pulseaudio sound system,
##     try replacing '-f alsa -ac 2 -i pulse' with something like
##     '-f alsa -ac 2 -i hw:0,0'. Many users of this guide reported
##     success with the above options. You might have to change the
##     0,0 to match that of your sound device. You could also try
##     '-f alsa -ac 2 -i /dev/dsp'.  Other users reported success with
##     '-f oss -ac 2 -i /dev/dsp'.
##     Basically there are many ways to do it, and it depends on your
##     system's sound configurations and hardware."
##
## Controlling Pulse audio input:
##
## "To control PulseAudio input (e.g. capture application audio instead of mic)
##  install 'pavucontrol'. Start recording with 'ffmpeg'. Start 'pavucontrol'.
##  Go to the 'Recording' tab and you'll find 'ffmpeg' listed there.
##  Change audio capture from 'Internal Audio Analog Stereo' to
##  'Monitor of Internal Audio Analog Stereo'.
##  Now it should record system and application audio instead of microphone.
##
##  This setting will be remembered. The next time you want to capture with
##  'ffmpeg', it will automatically start recording system audio.
##  If you want to revert this, use 'pavucontrol' again to change back to
##  microphone input."
##
##  Message you may get if 'pavucontrol' is not installed:
##
## $ pavucontrol
## The program 'pavucontrol' is currently not installed.
## You can install it by typing: 
##     sudo apt-get install pavucontrol
## pavucontrol: command not found
##
## On pause/resume:
##
## "Pause/resume screencasting isn't possible with ffmpeg yet, but you can
##  use 'mkvmerge' to achieve the same result. You can install this program
##  from your distribution's package management system under the package
##  name 'mkvtoolnix', or download it from the official website
##  http://www.bunkus.org/videotools/mkvtoolnix/. 'mkvmerge' allows you to
##  concatenate mkv files with identically-encoded streams to a single file.
##  Meaning that if you want to make a pause from screencasting, you'll
##  just stop recording part 1, then start recording part 2 as another file,
##  and finally concatenate (i.e. add) these 2 parts into a single screencast
##  ready for final compression. You can do this for as many parts as
##  you like. Example:
##      mkvmerge -o complete.mkv part1.mkv +part2.mkv +part3.mkv +part4.mkv
##  This command pruduces a video file named 'complete.mkv' that has all
##  the parts put together in the order they were specified into on the
##  command line.
##  However, note that all the parts you want to concatenate must have
##  exactly the same size/framerate/encoding parameters, otherwise it
##  won't work. You can't add files with different encoding options to
##  each other."
##
## Selecting an area of the screen with the mouse:
##
## "To select an area of the screen with the mouse and get ffmpeg to record,
##  it, There is a simple tool called 'xrectsel' that you can use to select
##  an area of the screen by drawing with your mouse, and it will print
##  your selection coordinates which you can then use in 'ffmpeg'.
##  This tool comes as an auxiliary tool with the 'ffcast' bash script
##  that wraps around ffmpeg's screencasting abilities. ('ffcast' does not
##  support audio yet). You can get ffcast/xrectsel installed by following
##  the instructions at
##  http://ubuntuforums.org/showpost.php?p=9902784&postcount=79"
##                                          (thanks to FakeOutdoorsman)
## Hiding the mouse cursor:
##
##  "To hide the mouse cursor, add '+nomouse' after ':0.0' to look like this:
##   :0.0+nomouse "  (thanks to FakeOutdoorsman)
##
#
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
##             The delay-time that the user supplied will determine when
##             the 'ffmpeg' command will start in the 'xterm' window.
##
##             The user ends the recording by entering 'q' in the terminal
##             in which 'ffmpeg' is running.
##
############# MAINTENANCE HISTORY ###########################################
## Started: 2011nov11 Based on http://ffmpeg.org/trac/ffmpeg/ticket/445 and
##                    feNautilusScript
##      '..._XscreenANDpulseAUDIO_CAPTURElosslessTO_MKV-H264-PCM_ffmpeg...'.
## Changed: 2012may24 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
##############################################################################

## FOR TESTING: (display statements that execute)
# set -x

MOVIESIZE="1024x768"
OFFSET="+0,0"

## We could also set an offset, like "+200,100", to set parameters
##    -s 800x600 -i :0.0+200,100
## This tells 'ffmpeg' to capture a rectangle of 800x600 with an
## X offset of 200 pixels and a Y offset of 100 pixels
## (the offset starting point is the top-left corner of the screen).
## Note that if you offset the capture area out of the screen, 'ffmpeg'
## will give you an error.


###############################
## Prepare the output filename.
###############################

FILEOUT="/tmp/${USER}_screencap_dev-video_libx264.flv"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


############################################################
## Set the NUMBER of THREADS before video capture starts.
############################################################

NTHREADS=""

NTHREADS=$(zenity --entry \
   --title "Enter NUMBER of THREADS to use." \
   --text "\
Enter NUMBER of THREADS to use.
  If you have only one processor available, use 1.
  If more processors are available, it is probably better
  to specify 1 or 2 less than the number available, so that
  1 or 2 processors are available for non-video-capture
  processes --- otherwise, other processes will be slow." \
   --entry-text "2")

if test "$NTHREADS" = ""
then
   exit
fi


##########################################
## Show info on how this utility works.
##########################################

# CURDIR="`pwd`"
# CURDIRFOLDED=`echo "$CURDIR" | fold -55`

SCRIPT_BASENAME=`basename $0`

zenity --info \
   --title "INFO on this RECORD-VIDEO+AUDIO utility." \
   --no-wrap \
   --text "\
This utility, $SCRIPT_BASENAME,
will use 'ffmpeg' to record video from /dev/video0
     Video Size   = $MOVIESIZE
     Video Offset = $OFFSET
into an h.264 VIDEO stream ( vcodec = 'libx264' )
and  a 'lossless' AUDIO stream ( acodec = 'pcm_s16le' )
put into an 'flv' container in output file
  $FILEOUT

After a user-specified delay,
'ffmpeg' will be started in a terminal window so that
startup and coding messages can be viewed. You can
minimize the window to get it out of the way of
what is being recorded.

STOP THE RECORDING BY re-opening the 'ffmpeg' terminal
window and typing 'q' (quit).  The terminal
does not close after 'ffmpeg' stops, so that you can
examine msgs. THEN CLOSE the terminal window. The
output file, if good, will be shown in a video player.

CLOSE this window to get the DELAY secs PROMPT."


############################################################
## Set the delay time (in secs) before video capture starts.
############################################################

DELAYSECS=""

DELAYSECS=$(zenity --entry \
   --title "Delay Time (secs) before ffmpeg-capture starts." \
   --text "\
Enter delay-time in seconds.
This allows some setup time before the 'ffmpeg'-window pops up
and ffmpeg starts capturing /dev/video0 output ( Video Size =
$MOVIESIZE and Video Offset = $OFFSET ) into file
  $FILEOUT

After 'ffmpeg' starts, you can minimize the terminal in which
'ffmpeg' is running. Re-open it to enter 'q' to stop recording." \
   --entry-text "6")

if test "$DELAYSECS" = ""
then
   exit
fi

sleep $DELAYSECS


#####################################################
## Capture the X11 screen activities with 'ffmpeg'.
#####################################################
## User should use 'q' in the xterm to quit recording.
#####################################################
## Based on command:
## ffmpeg -f video4linux2 -i /dev/video0 -vcodec libx264 \
##        -crf 20 -threads 0 out.flv
## FROM: http://ffmpeg.org/trac/ffmpeg/ticket/445
#####################################################

xterm -bg black -fg white -hold -geometry 90x48+100+100 -e \
  ffmpeg -f alsa -ac 2 -i pulse -acodec pcm_s16le \
         -f video4linux2 -i /dev/video0 -r 30 \
         -vcodec libx264 -vpre lossless_ultrafast \
         -threads $NTHREADS "$FILEOUT"

## Use the size and offset parms??
# -s $MOVIESIZE -i :0.0$OFFSET 

## Could use the long form of '-vpre' :
#        -vpre /usr/share/ffmpeg/libx264-lossless_ultrafast.ffpreset \

## Should we use '-b'??
## Others have used '-b 200k' or '-b 459k' or '-b 750k' or '-b 1000k'
## in various ffmpeg commands. '-b 750k' has been suggested as a good
## compromise between file size and quality of video.

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
## -acode codec = force the audio codec. Example: -acodec libmp3lame
## -ab val = audio bitrate in bits/sec (default = 64k)
## -ar val = audio sampling frequency in Hz (default = 44100 Hz)
## -ac channels - default = 1
##
## -vcodec codec = force the video codec. Example: -vcodec mpeg4 
##                   Try  "ffmpeg -formats"
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
##   -an - disable audio recording
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
##   -ss position - seek to given position, in secs or hh:mm:ss[.xxx]
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


###########################
## Show the movie file.
###########################

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

xterm -fg white -bg black -hold -geometry 90x48+100+100 \
      -e $MOVIEPLAYER "$FILEOUT"


#########################################################
## Use a user-specified MOVIEPLAYER.  Someday?
#########################################################

# . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
# . $DIR_NautilusScripts/.set_VIEWERvars.shi

# $MOVIEPLAYER "$FILEOUT" &
