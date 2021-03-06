#!/bin/sh
##
## Nautilus
## SCRIPT: av05f_1vidFile-1audFile_ADD-AUDIO_outAVI-XVID-MP3_ffmpeg-f.sh
##
## PURPOSE: Add an audio file to a (video-only) movie file --- and create a new movie file
##          in AVI-XVID-MP3 container-video-audio format.
##
## METHOD:  Uses 'zenity --info' to show info on how this utility works.
##
##          Uses 'zenity --info' multiple times in checking the selected files
##          to make sure there are two and to try to determine which is the
##          audio and which is the video.
##
##          Uses 'ffmpeg' with '-f avi' and '-vcodec libxvid' and '-acodec libmp3lame'
##          parms. I.e., this script uses parms on 'ffmpeg' to output video in 'xvid'
##          format and audio in 'mp3' format --- in an 'avi' container.
##
##          Shows the new movie file in a movie player.
##
##      NOTE on how ffmpeg SETS CONTAINER FORMAT:
##        Unless the '-f' parameter is used,
##        the 'ffmpeg' command determines the container format of the output file
##        from the suffix of the input file. Suffixes like mp4, flv, mkv, and
##        avi should work. But a suffix like wmv should be changed to asf,
##        if that is the actual format of the container of the input movie file.
##        And a suffix like ogv should probably be changed to ogg.
##
##       Rather than using a lot of logic to determine an appropriate
##       output container format and output file suffix, we specify
##       'avi' for the container format and '.avi' for the output file suffix.
##
##       This script was developed by testing on a '.avi' movie file ---
##       its audio was extracted into an mp3 file and the audio removed from
##       the '.avi' file leaving a video-only (xvid) '.avi' file.
##       The audio file was edited with 'audacity' and the
##       two files were put together by this utility into a '.avi' file.
##       So this utility may be most suited for use on '.avi' movie 
##       container format files as the input file.
##
##       If it turns out that these ffmpeg parms work almost exclusively on
##       input files in an 'avi' container format, this script may be
##       renamed from
##           ..._1vidFile-1audFile_ADD-AUDIO_....
##       to something like
##           ..._oneAVIfile-1audFile_ADD-AUDIO_....
##       meaning this script is mainly for AVI input files --- with output
##       in xvid-mp3-avi video-audio-container format.
##
##      NOTE on other ffmpeg parms:
##        Check the '-threads' parm on ffmpeg, to see if its set how you want.
##        '0' means use all the processors available. You may want to set it
##        to 1 or 2, for various reasons.
##
## HOW TO USE: In Nautilus, select a video-only movie file and an audio file.
##             Then right-click and choose this script to run (name above).
##
##     NOTE on preparing input for this script:
##        This utility was designed to work with the feNautilusScript
##            '..._1movieFile_REMOVE-AUDIO_..._ffmpeg-....sh'
##        which removes the audio from a movie file --- and puts the
##        video in a 'container' file (of the same type as the input movie file)
##        without an audio track.
##        That script is one way to prepare the video-only movie file for input
##        into this script.
##
################################################################################
## Started: 2011jun09
## Changed: 2011jul07 Tested to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES="$@". We use "$1" "$2" and
##                     "$3" instead.)
## Changed: 2011oct20 Chgd to use '-f avi' rather than letting container format
##                    be determined by the output file suffix (which was simply
##                    --- TOO simply --- set to the input file suffix).
## Changed: 2012may24 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (display the statements that are executed)
# set -x

##########################################
## Show info on how this utility works.
##########################################

CURDIR="`pwd`"
CURDIRFOLDED=`echo "$CURDIR" | fold -55`

SCRIPT_BASENAME=`basename $0`

zenity --info \
   --title "   INFO on this ADD-AUDIO-to-MOVIE-FILE utility.   " \
   --no-wrap \
   --text "\
This utility, $SCRIPT_BASENAME,
requires TWO files as input --- an audio file and a movie file.
Put them in the same directory and select them for this utility.

This utility will (try to) figure out which is the audio and
which the video.

'ffmpeg' will be used to add the audio track(s) from the audio
file to the movie file --- if possible, from the info available.

The new movie file will be put in a '.avi'-suffixed file named
like the input movie filename, except that a '_ADDEDaudio'
qualifier will be added to the midname.  The new output file
will be put in the same directory as the input files, namely,
  $CURDIRFOLDED

'ffmpeg' will be started in a terminal window so that
startup and coding messages can be viewed.  The terminal
does not close after 'ffmpeg' stops, so that you can
examine msgs. THEN CLOSE that 'ffmpeg' terminal window.

The new movie file, if good, will be played in a movie player.

CLOSE this window to startup the input-file-checking,
output-filename-building, and 'ffmpeg' processing."


###########################################
## Check that "$1" is present.
###########################################

if test "$1" = ""
then
   zenity --info \
   --title "TWO FILES required. Exiting." \
   --no-wrap \
   --text "\
This utility, $BASENAME,
requires TWO files as input --- an audio file and a movie file.
Put them in the same directory and select them for this utility.

NO INPUT FILE WAS SUPPLIED.

Exiting this script, when you click OK."
   exit
fi

###########################################
## Check that "$2" is present.
###########################################

if test "$2" = ""
then
   zenity --info \
   --title "TWO FILES required. Exiting." \
   --no-wrap \
   --text "\
This utility, $BASENAME,
requires TWO files as input --- an audio file and a movie file.
Put them in the same directory and select them for this utility.

A SECOND INPUT FILE WAS NOT SUPPLIED.

Exiting this script, when you click OK."
   exit
fi

###########################################
## Check that "$3" is NOT present.
###########################################

if test ! "$3" = ""
then
   zenity --info \
   --title "EXACTLY TWO FILES required. Exiting." \
   --no-wrap \
   --text "\
This utility, $BASENAME,
requires TWO files as input --- an audio file and a movie file.
Put them in the same directory and select them for this utility.

IT APPEARS THAT A 3rd FILE WAS SUPPLIED.

Exiting this script, when you click OK."
   exit
fi


#################################################################
## WE TRY TO DETERMINE WHICH OF the selected files is
## the audio file and which is the video file ---
## using the 'file' command.
#################################################################

FILEINFO1=`file "$1"`
FILEINFO2=`file "$2"`

FILE1VIDEOCHK=`echo "$FILEINFO1" | egrep  'Media|video|Video'`
FILE1AUDIOCHK=`echo "$FILEINFO1" | egrep  'Audio|layer III'`

FILE2VIDEOCHK=`echo "$FILEINFO2" | egrep  'Media|video|Video'`
FILE2AUDIOCHK=`echo "$FILEINFO2" | egrep  'Audio|layer III'`

VIDEOFILE=""
AUDIOFILE=""

if test "$FILE1VIDEOCHK" != ""
then
   VIDEOFILE="$1"
fi

if test "$FILE1AUDIOCHK" != ""
then
   AUDIOFILE="$1"
fi

if test "$FILE2VIDEOCHK" != ""
then
   VIDEOFILE="$2"
fi

if test "$FILE2AUDIOCHK" != ""
then
   AUDIOFILE="$2"
fi

if test "$AUDIOFILE" = ""
then
   zenity --info \
   --title "DID NOT DETERMINE THE AUDIO FILE. Exiting." \
   --no-wrap \
   --text "\
This utility, $BASENAME,
as currently written, could not determine which file is
the audio file. The 'file' info for the two files follows:

  $FILEINFO1

  $FILEINFO2

Exiting this script, when you click OK."
   exit
fi

if test "$VIDEOFILE" = ""
then
   zenity --info \
   --title "COULD NOT DETERMINE THE VIDEO FILE. Exiting." \
   --no-wrap \
   --text "\
This utility, $BASENAME,
as currently written, could not determine which file is
the audio file. The 'file' info for the two files follows:

  $FILEINFO1

  $FILEINFO2

Exiting this script, when you click OK."
   exit
fi

if test "$VIDEOFILE" = "$AUDIOFILE"
then
   zenity --info \
   --title "COULD NOT DETERMINE WHICH IS AUDIO and WHICH VIDEO. Exiting." \
   --no-wrap \
   --text "\
This utility, $BASENAME,
as currently written, chose the same file as the audio file
AND the video file. The 'file' info for the two files follows:

  $FILEINFO1

  $FILEINFO2


Exiting this script, when you click OK."
   exit
fi


######################################
## Prepare the output filename.
######################################

FILEMIDNAME=`echo "$VIDEOFILE" | cut -d\. -f1`

# FILEEXT=`echo "$VIDEOFILE" | cut -d\. -f2`

# FILEOUT="${FILEMIDNAME}_ADDEDaudio.$FILEEXT"

FILEOUT="${FILEMIDNAME}_ADDEDaudio.avi"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


###########################################################
## Use 'ffmpeg' to make the new movie file.
###########################################################
## A (too simple?) 'Mix a video with a sound file' example 
## FROM (2008): http://www.catswhocode.com/blog/19-ffmpeg-commands-for-all-needs
## ffmpeg -i son.wav -i video_origine.avi video_finale.mpg
###########################################################

xterm -hold -fg white -bg black -geometry 90x42+100+100 -e \
   ffmpeg -i "$AUDIOFILE" -i "$VIDEOFILE" -f avi \
         -vcodec libxvid -qscale 8 -me_method full -mbd rd \
         -flags +gmc+qpel+mv4 -trellis 1 \
         -acodec libmp3lame -ab 128k -ar 22050 -ac 1 \
         -threads 0 "$FILEOUT"

## Could use '-ab 96k' or '-ab 64k' if audio quality is not an issue.

## To minimize the size of the audio data we may use parms like
##    '-ab 96k  -ar 22050 -ac 1'   OR   '-ab 64k  -ar 22050 -ac 1'
## instead of parms like
##    '-ab 128k -ar 44100 -ac 2'

## Should we use '-b'??
## Others have used '-b 200k' or '-b 459k' or '-b 750k' or '-b 1000k'
## in various ffmpeg commands. '-b 750k' has been suggested as a good
## compromise between file size and quality of video.

## The parameters for this 'ffmpeg' command came
## FROM "HOWTO: Proper Screencasting on Linux" by verb3k :
##
## REFERENCE: http://ubuntuforums.org/archive/index.php/t-1392026.html
##            "HOWTO: Proper Screencasting on Linux" by verb3k
##
## The options from '-me_method full' to '-trellis 1' are
## encoding parameters for 'libxvid'.
##
## For video, tweaking the value of '-qscale' will give different results.
## Smaller value means higher video quality but increased file size
## and encoding time --- similar to the parm '-crf' for 'libx264'.


##################################################################
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
#######################################################################


################################
## Play the new movie file.
################################

if test ! -f "$FILEOUT"
then
   exit
fi

# MOVIEPLAYER="/usr/bin/vlc
# MOVIEPLAYER="/usr/bin/gmplayer
# MOVIEPLAYER="/usr/bin/gnome-player"
# MOVIEPLAYER="/usr/bin/totem"

# MOVIEPLAYER="/usr/bin/ffplay -stats"

# xterm -fg white -bg black -hold -geometry 90x24+100+100 -e \
#       $MOVIEPLAYER "$FILEOUT"

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$MOVIEPLAYER "$FILEOUT" &
