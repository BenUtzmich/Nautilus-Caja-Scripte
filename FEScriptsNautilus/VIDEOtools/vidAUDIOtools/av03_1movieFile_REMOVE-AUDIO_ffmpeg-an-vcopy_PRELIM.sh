#!/bin/sh
##
## Nautilus
## SCRIPT: av03_1movieFile_REMOVE-AUDIO_ffmpeg-an-vcopy_PRELIM.sh
##
## PURPOSE: REMOVE the audio track from a movie file ('.mp4' or '.mkv' or
##          '.flv' Flash video file or 'avi' or 'mov' ...)
##          --- putting the new movie file 
##          (a video track in a 'container' file) in a file whose name is
##          the same as the input movie file, but with a qualifier like
##          '_NOaudio'.
##
## METHOD:  Uses 'zenity --info' to show how this utility works.
##
##          Uses 'ffmpeg' with '-an -vcodec copy' parms.
##
##          Runs 'ffmpeg' in an 'xterm' so that messages can be seen.
##
##          Starts up the new video file in a movie player of the user's
##          choice.
##
##       NOTE on how ffmpeg SETS CONTAINER FORMAT:
##        Unless the '-f' parameter is used,
##        the 'ffmpeg' utility determines the container format of the output file
##        from the suffix of the input file. So suffixes like mp4, flv, and
##        avi should work. But a suffix like wmv should be changed to asf,
##        if that is the actual format of the container.  And a suffix like
##        ogv should probably be changed to ogg.
##
##       This script may be enhanced in the future to accept suffixes like
##       '.wmv' and '.ogv', and make appropriate choices for the '-f'
##       (container format) parameter of the 'ffmpeg' command --- and make
##       an appropriate choice of a suffix for the output movie file.
##
##       See the beginnings of such coding in the scripts
##           ..._1movieFile_CHGaudioVOLUME_ffmpeg_PRELIM.sh
##           ..._1movieFile_CLIP_......_ffmpeg_PRELIM.sh
##           ..._1movieFile_AUD-VID-OFFSET_....._ffpmeg_PRELIM.sh
##
##      NOTE on ffmpeg parms:
##        Check the '-threads' parm on ffmpeg, to see if it is set how you want.
##        '0' means use all the processors available. You may want to set it
##        to 1 or 2, for various reasons.
##
## HOW TO USE: In Nautilus, select a movie file.
##             Then right-click and choose this script to run (name above).
##
##      NOTE on usage of this script:
##        This utility was designed to work with the feNautilusScript
##            '..._1movieFile_ADD-AUDIO_..._ffmpeg-....sh'
##        which adds an audio track to a movie file --- putting the
##        video and audio streams into an appropriate 'container' file.
##        This script is meant to be run before that script is used.
##        Typically the video-only output from this script is used to
##        contain the audio after it is edited.
##
##############################################################################
## Started: 2011jun08
## Changed: 2012may22 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (display statements that execute)
# set -x

###############################################
## Get the filename of the selected movie file.
###############################################

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


##################################################
## Prepare the output 'no-audio' movie filename.
##################################################
## FILEEXT was extracted above, and like there, we
## assume there is just one period (.) in the
## input filename, at the file-type suffix of the file.
######################################################

FILENAMECROP=`echo "$FILENAME" |  cut -d\. -f1`

FILEOUT="${FILENAMECROP}_NOaudio.$FILEEXT"

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

zenity --info --title "INFO on this REMOVE-AUDIO utility." \
         --no-wrap \
         --text "\
This utility, $SCRIPT_BASENAME,
will use 'ffmpeg' to remove the audio track(s) from
the input (movie) file
    $FILENAME.

A new output (a movie file) will be put in filename
  $FILEOUT

in the same directory as the input file, namely,
  $CURDIRFOLDED

'ffmpeg' will be started in a terminal window so that
startup and coding messages can be viewed.  The terminal
does not close after 'ffmpeg' stops, so that you can
examine msgs. THEN CLOSE that 'ffmpeg' terminal window.

The output 'no-audio' movie file, if good, will be shown
in a movie player.

CLOSE this window to startup the 'ffmpeg' extraction."


###################################################
## Use 'ffmpeg' to make the 'no-audio' movie file.
#################################################################################
## Remove-audio-from-video examples 
## FROM: http://ubuntuforums.org/archive/index.php/t-1057416.html
##
## ffmpeg -i input.flv -an -vcodec copy output.flv
## ffmpeg -i input.avi -an -vcodec copy output.avi
## 
## If this does not work for some video-audio-container format, we may
## need to specify some video and container parameters to make sure
## that ffmpeg works.
################################################################################

xterm -bg black -fg white -hold -geometry 90x42+100+100 -e \
   ffmpeg -i "$FILENAME" -an -vcodec copy \
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


##################################
## Play the 'no-audio' movie file.
##################################

if test ! -f "$FILEOUT"
then
   exit
fi

# MOVIEPLAYER="/usr/bin/vlc"
# MOVIEPLAYER="/usr/bin/gmplayer"
# MOVIEPLAYER="/usr/bin/gnome-mplayer"
# MOVIEPLAYER="/usr/bin/totem"

# MOVIEPLAYER="/usr/bin/ffplay -stats"

# xterm -bg black -fg white -hold -geometry 90x24+100+100 \
#       -e $MOVIEPLAYER "$FILEOUT"

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$MOVIEPLAYER "$FILEOUT" &
