#!/bin/sh
##
## Nautilus
## SCRIPT: cap05b_anyfile_Xscreen-NOaudio_CAPTURE_toMPG1_ffmpeg_secsPrompt.sh
##
## PURPOSE: Capture X-window activity to an '.mpg' (mpeg1) movie file ---
##          video only --- no audio --- using 'ffmpeg'.
##
## METHOD:  COULD use 'zenity --info' to show info on how this utility works.
##
##          Uses 'zenity --entry' to prompt for a 'capture-seconds' value,
##          to record for the specified amount of time.
##
##          Uses a hard-coded 'delay-time' to determine when to startup 'ffmpeg'
##          but COULD use 'zenity --entry' to prompt for a 'delay time' to allow time
##          to setup for recording video.
##
##          COULD use 'zenity --entry' to prompt for number of threads to use in
##          doing the recording (to take advantage of multi-core machines) ---
##          if the mpeg1video encoder is threaded.
##
##          Runs 'ffmpeg' with '-an' and '-f x11grab' and  '-vcodec mpeg1video'
##          parms --- along with various other parms, like '-vframes' ---
##          which is calculated from the 'capture-seconds' supplied by the user
##          and a frame-rate which is hard-coded in a RATE var.
##
##          Puts the video stream in a '.mpg' suffix file.
##
##          NOTE on some ffmpeg hard-coded parms:
##             Change the MOVIESIZE and OFFSET parameters near the top of this
##             code, to set the recording area (which can be the screen size).
##
##          COULD run 'ffmpeg' in an 'xterm' so that messages can be seen.
##
##          Shows the captured '.mpg' file in a movie player.
##
## REFERENCES: http://ubuntuforums.org/archive/index.php/t-1392026.html
##             "HOWTO: Proper Screencasting on Linux"
##          and
##            http://mail-index.netbsd.org/pkgsrc-users/2009/12/06/msg011281.html
##             (Example ffmpeg command is in comments below.)
##          and
##            do web searches on keywords such as 'ffmpeg x11grab mpeg1video'
##            or 'ffmpeg x11grab mpeg'.
##
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
##             The (hard-coded) delay-time will determine when
##             the 'ffmpeg' command will start, in the 'xterm' window.
##
##             The capture-time that the user supplied will determine how long
##             the 'ffmpeg' command will record.
##
##############################################################################
## Started: 2010mar08
## Changed: 2011jan06
## Changed: 2011may02 Added $USER to the output filename.
## Changed: 2012may24 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
##############################################################################

## FOR TESTING: (display statements that execute)
# set -x

MOVIESIZE="1024x768"
OFFSET="+0,0"


#########################################################
## Set the capture time (in secs) for the video capture.
#########################################################

CAPTURESECS=""

CAPTURESECS=$(zenity --entry \
   --title "CAPTURE Time (secs) for the X11 video capture." \
   --text "\
Enter capture-time in seconds:
 This is the amount of time that ffmpeg will capture the X11 screen activity.

Capture size: $MOVIESIZE is hardcoded in a variable of this script.
Capture offset: $OFFSET is hardcoded in a variable of this script." \
   --entry-text "10")

if test "$CAPTURESECS" = ""
then
   exit
fi

RATE=25
VFRAMES=`expr $CAPTURESECS \* $RATE`

###############################
## Prepare the output filename.
###############################

FILEOUT="/tmp/${USER}_videocapture_ffmpeg_${MOVIESIZE}_noAudio_MPEG1.mpg"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi

############################################################
## Set the delay time (in secs) before video capture starts.
############################################################

#  DELAYSECS=""
#
#  DELAYSECS=$(zenity --entry \
#     --title "Delay Time (secs) before capture starts." \
#     --text "Enter delay-time in seconds:
#  This allows some setup time before ffmpeg starts capturing the X11 screen." \
#     --entry-text "10")

# if test "$DELAYSECS" = ""
# then
#    exit
# fi

# sleep $DELAYSECS


####################################################
## A zenity OK/Cancel prompt for 'Start recording?'.
####################################################

zenity  --question \
   --title "Start recording? (to $FILEOUT)" \
   --text  "\
Start recording the screen for $CAPTURESECS seconds?
      (after a delay of 3 seconds, to get setup)
Cancel = Exit.

You will know when the recording has stopped --- 
a movie viewer will start showing your movie, which is in
$FILEOUT.

(This prompt could be changed to ask for delay-secs.)"

if test $? != 0
then
   exit
fi

sleep 3



#####################################################
## Capture the X11 screen activities with 'ffmpeg'.
#####################################################
## This example from 'man ffmpeg' does not seem to work.
# ffmpeg -f x11grab -s cif -i :0.0 "$FILEOUT"
## NOR
# ffmpeg -f x11grab -s cif -i ":0.0" /tmp/movie2.mpg
## It gives error msgs:
##  AVParameters don't have video size and/or rate. Use -s and -r.
##  :0.0: I/O error occurred
########################################################################################
## Thanks to
## http://mail-index.netbsd.org/pkgsrc-users/2009/12/06/msg011281.html
## for the following example that works on Ubuntu Karmic.
##
## ffmpeg -an -f x11grab -r 25 -s 1024x768 -i ":0.0" -vcodec mpeg4 -sameq /tmp/test.mp4
##
## A little experimenting indicates that the '-r' is the critical parm.
## It may be that '-sameq' does not have any effect. And '-an' may not be needed.
########################################################################################

## FOR TESTING: (use 'q' in the xterm to quit recording)
# xterm -bg black -fg white -hold -geometry 24x18+1000+750 -e \
#  ffmpeg -f x11grab -r 25 -s $MOVIESIZE -i ":0.0" -an -vcodec mpeg1video \
#         -sameq "$FILEOUT"

## For non-interactive termination of the movie, TRY:
ffmpeg -an -f x11grab -r $RATE -s $MOVIESIZE -i ":0.0$OFFSET" \
       -vcodec mpeg1video -sameq -vframes $VFRAMES "$FILEOUT"

#        -sameq -t $CAPTURESECS "$FILEOUT"

#        -sameq -vframes $VFRAMES "$FILEOUT"

#####################################################################
## Meaning of the 'popular' ffmpeg parms:
##
## -i  val = input filename
## -ab val = audio bitrate in bits/sec (default = 64k)
## -ar val = audio sampling frequency in Hz (default = 44100 Hz)
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
## Video:
##   -aspect (4:3, 16:9 or 1.3333, 1.7777)
##   -croptop pixels
##   -cropbottom pixels
##   -cropleft pixels
##   -cropright pixels
##   -padtop (bottom, left, right)
##   -padcolor <6 digit hex number>
##   -vn - disable video recording
##   -y  = overwrite output file(s)
##   -t duration - format is hh:mm:ss[.xxx]
##   -fs file-size-limit
##   -ss position - seek to given position, in secs or hh:mm:ss[.xxx]
##   -target type - where type is vcd or svcd or dvd or ..., then
##    bitrate, codecs, buffersizes are set automatically.
##   -vcodec codec - to force the video codec.
##                   Example: -vcodec mpeg4 
##                   Try  "ffmpeg -formats"
##   -pass n, where n is 1 or 2
##
## Audio:
##   -ac channels - default = 1
##   -an - disable audio recording
##   -acode codec - to force the audio codec. Example:
##                                      -acodec libmp3lame
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
# MOVIEPLAYER="/usr/bin/totem"

MOVIEPLAYER="/usr/bin/ffplay -stats"

xterm -fg white -bg black -hold -geometry 90x48+100+100 \
      -e $MOVIEPLAYER "$FILEOUT"

## NOTE: 'totem' (based on gstreamer, version ?) tends to play
##        only a second or so of an mpeg1video.
##        But 'ffplay' does a good job. 'mplayer' does OK.
##       ('totem'/gstreamer is suspect. OR ... mpeg1 parms need improvement?)

###############################################################
## Use a user-specified MOVIEPLAYER.  someday?
################################################################

#  . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
#  . $DIR_NautilusScripts/.set_VIEWERvars.shi

#  $MOVIEPLAYER "$FILEOUT" &
