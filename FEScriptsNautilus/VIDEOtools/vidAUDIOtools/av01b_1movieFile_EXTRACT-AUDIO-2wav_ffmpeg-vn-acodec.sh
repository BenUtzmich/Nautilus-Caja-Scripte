#!/bin/sh
##
## Nautilus
## SCRIPT: av01b_1movieFile_EXTRACT-AUDIO_2wav_ffmpeg-vn-acodec.sh
##
## PURPOSE: Extract the audio from a movie file ('.mp4' or '.mkv' or
##          '.flv' Flash video file or '.avi' or '.mov' or '.wmv' ...) 
##          --- into a '.wav' audio file.
##
## METHOD:  Uses 'zenity --info' to show how this utility works.
##
##          Runs 'ffmpeg' with parms '-vn' and '-acodec pcm_s16le
##          -ab 128k -ar 44100 -ac 2'.
##
##          Runs 'ffmpeg' in an 'xterm' so that messages can be seen.
##
##          Starts up the new audio file in an audio player of the user's
##          choice.
##
##          The user could use an audio editor, like audacity, to adjust
##          volume of the output file.
##
##      NOTE on ffmpeg parms:
##        Check the '-threads' parm on ffmpeg, to see if it is set how you want.
##        '0' means use all the processors available. You may want to set it
##        to 1 or 2, for various reasons.
##
##      REFERENCE:  An flv-video-to-wave-file example 
##                  FROM: http://howto-pages.org/ffmpeg/#strip
##
##                  ffmpeg -i mandelbrot.flv -vn -acodec pcm_s16le \
##                         -ar 44100 -ac 2 mandelbrot.wav
##
##                  which makes sure that the audio comes out uncompressed
##                  at a sample rate of 44100 Hz in 16-bit samples and
##                  2 channels (stereo).
##
## HOW TO USE: In Nautilus, select a movie file.
##             Then right-click and choose this script to run (name above).
##
##       NOTE on usage of this script:
##            This utility was designed to work with a pair of feNautilusScripts
##            '..._1movieFile_REMOVE-AUDIO_ffmpeg....sh'
##            '..._1movieFile_ADD-AUDIO_............._ffmpeg.....sh'
##
##        The first removes an audio track from a movie --- for example,
##        after extracting the audio with a script like this. That 1st script
##        makes a movie 'container file' with only a video stream ---
##        for insertion of an audio track back into the movie.
##
##        The 2nd script adds an audio track back into a 'container file'
##        that contains an video stream but no audio stream.
##
#############################################################################
## Started: 2010mar22
## Changed: 2011jun08 Added AUDIOPLAYER, AUDIOEDITOR vars. Added zenity info popup.
## Changed: 2012may22 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (display statements that execute)
# set -x

##########################################
## Get the filename of the selected file.
##########################################

  FILENAME="$1"
# FILENAMES="$@"
# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

##################################################################
## Check that the selected file is a 'flv' or 'wmv' or 'avi' file
## --- or some other movie file, suffix to be added.
##
##     (Assumes one '.' in the filename, at the extension.)
##################################################################

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
#  if test "$FILEEXT" != "flv" -a "$FILEEXT" != "wmv" -a \
#          "$FILEEXT" != "avi" -a "$FILEEXT" != "mov"
#  then
#     exit
#  fi


#######################################
## Prepare the output '.wav' filename.
#######################################

FILENAMECROP=`echo "$FILENAME" |  cut -d\. -f1`

FILEOUT="${FILENAMECROP}.wav"

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
   --title "INFO on this EXTRACT-AUDIO-to-WAV utility." \
   --no-wrap \
   --text "\
This utility, $SCRIPT_BASENAME,
will use 'ffmpeg' to convert the audio track(s) from
the input (movie) file
    $FILENAME
to a WAV audio file.

The wav-formatted output will be put in filename
  $FILEOUT

in the same directory as the input file, namely,
  $CURDIRFOLDED

'ffmpeg' will be started in a terminal window so that
startup and coding messages can be viewed.  The terminal
does not close after 'ffmpeg' stops, so that you can
examine msgs. THEN CLOSE that 'ffmpeg' terminal window.

The audio file, if good, will be brought up
in an audio player.

CLOSE this window to startup the 'ffmpeg' extraction."


#######################################
## Use 'ffmpeg' to make the 'wav' file.
#################################################################################
## An flv-video-to-wave-file example 
## FROM: http://howto-pages.org/ffmpeg/#strip
##
## ffmpeg -i mandelbrot.flv -vn -acodec pcm_s16le -ar 44100 -ac 2 mandelbrot.wav
##
## making sure that the audio comes out uncompressed at a sample rate of
## 44100 Hz in 16-bit samples and 2 channels (stereo).
################################################################################

xterm -bg black -fg white -hold -geometry 90x42+100+100 -e \
   ffmpeg -i "$FILENAME" -vn -acodec pcm_s16le -ab 128k -ar 44100 -ac 2 \
          -threads 1 "$FILEOUT"

######################################################################
## Meaning of some common ffmpeg parms:
##
## -i  val = input filename
## -ab val = audio bitrate in bits/sec (default = 64k)
## -ar val = audio sampling frequency in Hz (default = 44100 Hz)
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
##               
## Some other useful params:
##
## Audio:
##   -ac channels - default = 1
##   -acode codec - to force the audio codec. Example:
##                                      -acodec libmp3lame
##   -an - disable audio recording
##   -vn - disable video recording
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
## Other:
##   -debug
##   -threads count
#########################################################################


######################################
## Play/edit the new audio (wav) file.
######################################

if test ! -f "$FILEOUT"
then
   exit
fi

#  AUDIOPLAYER="/usr/bin/vlc"
#  AUDIOPLAYER="/usr/bin/gmplayer"
#  AUDIOPLAYER="/usr/bin/gnome-mplayer"
#  AUDIOPLAYER="/usr/bin/totem"

#  AUDIOPLAYER="/usr/bin/ffplay -stats"

#  AUDIOPLAYER="/usr/bin/audacity"

#  xterm -hold -fg white -bg black -geometry 90x24+100+100 -e \
#        $AUDIOPLAYER "$FILEOUT"

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

# $AUDIOEDITOR "$FILEOUT" &

$AUDIOPLAYER "$FILEOUT" &
