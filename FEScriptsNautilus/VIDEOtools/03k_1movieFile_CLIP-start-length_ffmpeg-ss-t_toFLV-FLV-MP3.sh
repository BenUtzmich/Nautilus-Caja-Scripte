#!/bin/sh
##
## Nautilus
## SCRIPT: 03k_1movieFile_CLIP-start-length_ffmpeg-ss-t_toFLV-FLV-MP3.sh
##
## PURPOSE: Clip a section out of a movie file --- based on a user-specified
##          start time and a user-specified duration of the clip.
##
##          Make the output movie file format flv-flv-mp3
##          (container-video-audio).
##
## METHOD:  Uses 'zenity --entry' to prompt for start time and duration.
##
##          Uses 'ffmpeg' with '-ss', '-t', '-f flv', and various other parms.
##
##          Shows the new clip file in a movie player.
##
##       NOTE on CONTAINER FORMAT of the OUTPUT FILE:
##          We attempt to make the output clip file in a specified format
##          (video-audio-container): video in 'flv' format and audio in
##          'mp3' format --- in an 'flv' container.
##             
##          We specify the 3 formats because, for many types of input movies,
##          use of '-vcodec copy -acodec copy' does not yield good movie files
##          (playable in a wide range of players).
##
##     NOTE on how 'ffmpeg' SETS CONTAINER FORMAT of the OUTPUT FILE: 
##       ffmpeg ordinarily chooses the output container format based on
##       the file extension of the output file --- unless the '-f'
##       (container format) option is specified.
##
##       Sometimes making the output file have the same extension as
##       the input file will work --- for '.flv' and '.mp4' and '.avi' files.
##       On the other hand,
##       some input file extensions on the output file may not work --- such as
##       '.wmv' or '.ogv' or '.mpg'. However, they may work if '-f' is used with
##       specifications such as 'asf' or 'ogg' or 'mpeg', respectively.
##
##       Rather than try to figure out an output 'container' format,
##       this script specifies the 'flv' container format.
##
##     NOTE on TESTING:
##       This script needs to be tested on a wide variety of 'flv', 'mp4',
##       'avi', 'wmv', 'mov', and some other movie file formats.
##
##       I may add comments that indicate whether this script 
##       actually worked on certain test files.
##
## REFERENCE: Google 'ffmpeg ss'    or  'ffmpeg start duration'  or
##            'ffmpeg clip'   or  'ffmpeg ss flv mp3'  or ...
##
## REFERENCE: AUDIO '-ss' and '-t' EXAMPLE FROM:
##            http://activearchives.org/wiki/Cookbook
##            ffmpeg -i xabier.wav -ss 180 -t 60 \
##                   -acodec libvorbis -ab 192000 xabier_sample.ogg
##            This suggests that '-ss' and '-t' should be AFTER '-i'.
##            But other examples show '-ss' BEFORE '-i'.
##
## HOW TO USE: In Nautilus, select a movie file.
##             Then right-click and choose this script to run (name above).
##
###########################################################################
## Started: 2011dec12 Based on the script
##           '03b_oneMovie_CLIP_vidout-h264_audout-aac_inFLV_ffmpeg.sh'.
## Changed: 2011dec13 Added '-async 1' to the 'ffmpeg' cmd.
## Changed: 2012may22 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
## Changed: 2012jun18 Put '-ss' parm after '-i'. Added 'flv-mp3' to FILEOUT.
## Changed: 2012jun25 Use 'awk' instead of 'cut' to separate the 2 time inputs.
## Changed: 2012jul20 Touch up comments in zenity prompt for start-duration.
##                    Add 'vob' to allowed input suffixes.
##########################################################################

## FOR TESTING: (display statements that are executed)
#  set -x

THIS_SCRIPT=`basename $0`

##########################################
## Get the filename of the selected file.
##########################################

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
## file formats to clip --- like 'webm'.
##
##  (Assumes just one dot [.] in the filename, at the extension.)
##################################################################

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
if test "$FILEEXT" != "mp4" -a "$FILEEXT" != "mkv" -a \
        "$FILEEXT" != "flv" -a "$FILEEXT" != "avi" -a \
        "$FILEEXT" != "wmv" -a "$FILEEXT" != "asf" -a \
        "$FILEEXT" != "mov" -a \
        "$FILEEXT" != "mpg" -a "$FILEEXT" != "mpeg" -a \
        "$FILEEXT" != "ogg" -a "$FILEEXT" != "ogv" -a \
        "$FILEEXT" != "3gp" -a "$FILEEXT" != "vob"
then
   zenity --info \
          --title "UNSUPPORTED SUFFIX.  EXITING..." \
          --text "\
The suffix of the input file ( $FILEEXT ) does not look like one
that is currently allowed by this script:
$THIS_SCRIPT.

Allowed suffixes:
mp4, mkv, flv, avi, wmv, asf, mov, mpg, mpeg, ogg, ogv, 3gp

If you think this file should be supported, you can edit
this script and add/change the appropriate 'if' statements.

EXITING ..."

    exit
fi


############################################################
## Prompt for the start and duration times for the clip.
############################################################

STARTDUR=""

STARTDUR=$(zenity --entry \
   --title "Start-time (hrs:min:sec) & Duration (min:sec) of movie clip." \
   --text "\
Enter Start-time & Duration of the clip to keep --- in either hrs:min:sec[.xxx] format
OR in seconds.

Equivalent examples:
    00:01:23 00:00:22
    83 22

------------------------------------------------------------------------
When it appears that 'ffmpeg' is through doing the conversion, CLOSE
the 'ffmpeg' messages window to see the new clip played by 'ffplay'.
-----------------------------------------------------------------------
NOTE: The output video format will be FLV (probably Sorenson). The output
audio format will be MP3. The container format will be FLV.
------------------------------------------------------------------------
NOTE: In some cases 'totem' and 'vlc' may NOT play the new movie, BUT
'mplayer', 'gnome-mplayer', and 'ffplay' probably will.
" \
   --entry-text "00:01:23 00:00:22")

## Obsolete/no-longer-accurate Note - commented.
# NOTE:
# You may find that you get the entire movie instead of a clip.
# IF you see a 'frame rate differs' message like the following
# in the 'ffmpeg' messages (just below the 'built on' message line):
# 
#   Seems stream 0 codec frame rate differs from container frame rate:
#   1000.00 (1000/1) -> 15.00 (15/1)
# 
# THEN the '-t' (DURATION) parameter needs to be adjusted.
# 
# In this case, 15/1000 = 0.015.  It turns out if you want a 45 sec clip,
# say, then let 't' be 0.015 x 45 = 0.675, instead of 45.
# 
# So specify 0 0.675 instead of 0 45, to get the first 45sec of the movie.

## Obsolete/no-longer-accurate Note - commented.
# NOTE: The VIDEO stream may be clipped but NOT the AUDIO. If there is audio in the
# file, it may no longer be in sync with the video. If you need sync, you will probably
# need to use the EXTRACT-AUDIO and REMOVE-AUDIO scripts to separate the audio and video
# streams. You could use this script to clip the video-only file. According to that video,
# clip the audio file, in 'audacity', say. Then use the ADD-AUDIO script to paste the clipped
# video and audio files back together. (This may be automated in a script, someday.)
# (Hopefully, ffmpeg will be enhanced someday to apply the '-ss' and '-t' parms to
# both the audio and the video streams.)(The '-ss' option does not seem to be starting the
# clip where one would expect. A bug in ffmpeg? Experimentation with ss values may be needed.)


if test "$STARTDUR" = ""
then
   exit
fi

# STARTTIME=`echo "$STARTDUR" | cut -d' ' -f1`
# DURATION=`echo "$STARTDUR" | cut -d' ' -f2`

STARTTIME=`echo "$STARTDUR" | awk '{print $1}'`
DURATION=`echo "$STARTDUR" | awk '{print $2}'`


##########################################
## Prepare the output filename.
##########################################

FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`

FILEOUT="${FILENAMECROP}_START${STARTTIME}_DURATION${DURATION}_flv-mp3.flv"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


#################################################################
## Use 'ffmpeg' to make the new movie clip file.
#################################################################
## REFERENCE:
## ffmpeg -i xabier.wav -ss 180 -t 60 -acodec libvorbis -ab 192000 xabier_sample.ogg
## AUDIO '-ss' and '-t' EXAMPLE FROM: http://activearchives.org/wiki/Cookbook
##      This suggests that '-ss' and '-t' should be AFTER '-i'.
#################################################################

## FOR TEST: (show statements as they execute)
#   set -x

xterm -hold -fg white -bg black -geometry 90x48+100+100 -e \
      ffmpeg -i "$FILENAME" \
            -ss $STARTTIME \
            -t $DURATION -f flv \
            -copyts -async 1 \
            -vcodec flv -sameq \
            -acodec libmp3lame -ab 128k -ar 44100 -ac 2 \
            -threads 1  "$FILEOUT"

## NOTE: Seems to be a problem with audio being behind the video
## by about 3-5 secs. Tried with/wo '-copyts', and with '-ar 22050/44100',
## and with '-b 800k'/'-sameq'. 
## **** '-async 1' fixes the audio sync problem. (Close enough, anyway.)

## FOR TEST:
#    set -

## ON AUDIO:
##
## Could try '-ab 96k' if audio quality is not an issue.
## To minimize the size of the audio data we may use parms like
##    '-ab 96k  -ar 22050 -ac 1'   OR   '-ab 64k  -ar 22050 -ac 1'
## instead of parms like
##    '-ab 128k -ar 44100 -ac 2'
##
## Can use  '-an' to remove the audio.

## ON VIDEO:
##
## Add '-b 200k'? Or use a larger value, like '-b 750k'?
##
## OR '-sameq' or '-qscale 5' needed to improve output quality?
##
## Remove '-copyts'?  Is '-copyts' (copy time-stamps) needed?
##
## '-async 1' IS needed.



## ON START-TIME and DURATION:
##
## Although some put the '-ss' and '-t' parms before the '-i' input,
## at least one forum thread indicates they should be put AFTER '-i'.
## But many postings disagree with that.
##     Perhaps '-ss' before '-i' and '-t' after '-i' ???

## NOTE:
## If you get the entire movie instead of a clip:
## THE '-t' (DURATION) parameter may need to be adjusted if you see a
## 'frame rate differs' message like the following.
##
##   Seems stream 0 codec frame rate differs from container frame rate:
##   1000.00 (1000/1) -> 15.00 (15/1)
##
## In this case, 15/1000 = 0.015.  It turns out if you want a 45 sec clip,
## say, then let 't' be 0.015 x 45 = 0.675, instead of 45.
##
## So specify 0 0.675 instead of 0 45, to get the first 45sec of the movie.

## ON THREADS:
##  '-threads 1' needed?  At least one forum posting on clipping with ffmpeg
##                        for a certain output format indicates Yes ---
##                        rather than a higher number of threads.
##  '-threads 0' would allow ffmpeg to choose the number of threads
##    according to the number of processors that ffmpeg thinks are available.



###########################################
## Show the clipped (shortened) movie file.
###########################################

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


###############################################
## Use a user-specified MOVIEPLAYER.  Someday?
###############################################

#  . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
#  . $DIR_NautilusScripts/.set_VIEWERvars.shi

#   $MOVIEPLAYER "$FILEOUT" &
