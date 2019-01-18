#!/bin/sh
##
## Nautilus
## SCRIPT: av08_1vidFile-1audFile_AUD-VID-OFFSET_ffmpeg-itsoffset-f-vcopy-acopy_PRELIM.sh
##
## PURPOSE: Change the 'offset' between an audio and a video stream of
##          a movie file. Takes an audio-only and a video-only file as
##          input and combines them into a new movie file.
##
##          Note: This requires the audio to be separated from the video
##          in a movie file --- putting each in a separate file.
##          
## METHOD:  Uses 'zenity --info' to show info on how this utility works.
##
##          Uses 'zenity --info' multiple times in checking the selected files
##          to make sure there are two and to try to determine which is the
##          audio and which is the video.
##
##          Uses 'zenity --entry' to prompt for the time offset.
##
##          Uses 'ffmpeg' with '-itsoffset' and '-vcodec copy -acodec copy'
##          parms.
##
##          Shows the new movie file in a movie player.
##
##          We attempt to make the output movie file in a format
##          (video-audio-container) as suggested by the input video file.
##          We use the '-vcodec copy -acodec copy -f' ffmpeg parms.
##
##          The value of the '-f' container format may be set according
##          to the suffix of the input file.
##
##     REFERENCE: Google 'ffmpeg audio video offset sync' or
##                       'ffmpeg itsoffset'.
##
##     NOTE on how ffmpeg SETS CONTAINER FORMAT:
##       ffmpeg ordinarily chooses the output container format based on
##       the file extension of the output file --- unless the '-f'
##       (container format) option is specified --- which is necessary
##       in some cases.
##
##       The intial design intent of this script was/is to determine
##       a value for the '-f' parm (and the suffix of the output movie file)
##       based on the suffix of the video input file.
##
##       Sometimes making the value of the -f' parm the same as the extension of
##       the input video file will be appropriate --- 'flv' may be appropriate
##       for '-f' value if 'flv' was the suffix of the input video file,
##       for example.
##
##       Some video input file extensions may not be directly appropriate ---
##       --- such as 'wmv' or 'ogv' or 'mpg'. However, they will probably
##       work if '-f' is used with specifications such as 'asf' or 'ogg' or
##       'mpeg', respectively.
##
##       This script works by trying to figure out an appropriate value
##       for '-f' from the video input file suffix --- and the suffix on the
##       output file may be set to indicate the container format, rather
##       than using the suffix of the input video file.
##
## NOTE on TESTING:
##       The script needs to be tested on a wide variety of source movie files ---
##       with suffixes such as 'mp4', 'mpg', 'mpeg', 'flv', 'avi', 'wmv',
##       'mov', etc.
##
##       I may add comments near the container-setting 'if' statements
##       --- like 'if test "$FILEEXT" = "wmv"' --- that indicate whether
##       they actually worked on a test file(s).
##
## HOW TO USE: In Nautilus, select the two input files --- a video-only
##             movie file and an audio file. Then right-click
##             and, in the Nautilus 'Scripts >' submenus, choose to run
##             this script (name above).
##
#######################################################################
## Started: 2010jun16
## Changed: 2011jul07 Made changes to (hopefully) handle filenames with
##                    embedded spaces. (Removed use of FILENAMES="$@".
##                    We use "$1" "$2" and "$3" instead.)
## Changed: 2012may22 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (display the executed statements)
# set -x

##########################################
## Show info on how this utility works.
##########################################

CURDIR="`pwd`"
CURDIRFOLDED=`echo "$CURDIR" | fold -55`

SCRIPT_BASENAME=`basename $0`

zenity --info \
   --title "   INFO on this AUDIO-VIDEO-OFFSET make-MOVIE utility.   " \
   --no-wrap \
   --text "\
This utility, $SCRIPT_BASENAME,
requires TWO files as input --- an audio-only file and a video-only file.
Put them in the same directory and select them for this utility.

This utility will (try to) figure out which is the audio and
which the video.

'ffmpeg' will be used to add the audio track(s) from the audio
file to the video track in the movie file --- with a time offset
that you will specify, at a prompt.

The new movie file will be put in a filename like the video input
filename, except that a '_AUD-VID-OFFSET' qualifier will
be added to the filename.  The new output file will be put in
the same directory as the input files, namely,
  $CURDIRFOLDED

'ffmpeg' will be started in a terminal window so that
startup and coding messages can be viewed.  The terminal
does not close after 'ffmpeg' stops encoding, so that you can
examine msgs. THEN CLOSE that 'ffmpeg' terminal window.

The new movie file, if good, will be played in a movie player.

CLOSE this window to startup the input-file-checking,
output-filename-building, prompting, and 'ffmpeg' processing."


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
the AUDIO file. The 'file' info for the two files follows:

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
the VIDEO file. The 'file' info for the two files follows:

  $FILEINFO1

  $FILEINFO2

Exiting this script, when you click OK."
   exit
fi

if test "$VIDEOFILE" = "$AUDIOFILE"
then
   zenity --info \
   --title "COULD NOT DETERMINE WHICH IS AUDIO and WHICH IS VIDEO. Exiting." \
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


##################################################################
## Check that the selected video file has an extension that we think
## we can support --- like 'flv' or 'mpg' or 'mpeg' or 'avi' or 'wmv'
## 'mov' or 'mp4' or ...
##
## Some other suffixes may be added as we encounter new
## file formats to clip.
##
##  (Assumes just one dot [.] in the filename, at the extension.)
##################################################################

FILEEXT=`echo "$VIDEOFILE" | cut -d\. -f2`
 
if test "$FILEEXT" != "flv" -a \
        "$FILEEXT" != "mpg" -a "$FILEEXT" != "mpeg" -a \
        "$FILEEXT" != "wmv" -a "$FILEEXT" != "avi"  -a \
        "$FILEEXT" != "mov" -a \
        "$FILEEXT" != "mp4" 
then
   zenity --info \
   --title "UNSUPPORTED SUFFIX.  EXITING..." \
   --no-wrap \
   --text "\
The suffix ( $FILEEXT ) of the input video file does not look like one
that is currently 'supported' by this script:
$BASENAME.

'Supported' suffixes:
flv, mpg, mpeg, avi, wmv, mov, mp4

If you think this file should be supported, you can edit
this script and add/change the appropriate 'if' statements.

EXITING ..."

   exit
fi


############################################################
## Set the container format (CONFMT) and output suffix
## (FILEEXTOUT) according to the input suffix.
############################################################

OTHER_PARMS=""

if test "$FILEEXT" = "flv"
then
   CONFMT="flv"
   FILEEXTOUT="flv"
   # OTHER_PARMS="yada yada yada"
fi

if test "$FILEEXT" = "mpg"
then
   CONFMT="mpeg"
   FILEEXTOUT="mpg"
   # OTHER_PARMS="yada yada yada"
fi

if test "$FILEEXT" = "mpeg"
then
   CONFMT="mpeg"
   FILEEXTOUT="mpg"
   # OTHER_PARMS="yada yada yada"
fi

if test "$FILEEXT" = "avi"
then
   CONFMT="avi"
   FILEEXTOUT="avi"
   # OTHER_PARMS="yada yada yada"
fi

if test "$FILEEXT" = "wmv" 
then
   CONFMT="asf"
   FILEEXTOUT="wmv"
   # OTHER_PARMS="yada yada yada"
fi

if test "$FILEEXT" = "mp4"
then
   CONFMT="mp4"
   FILEEXTOUT="mp4"
   # OTHER_PARMS="yada yada yada"
fi

if test "$FILEEXT" = "mov"
then
   CONFMT="mov"
   FILEEXTOUT="mov"
   # OTHER_PARMS="yada yada yada"
fi

if test "$FILEEXT" = "mkv"
then
   CONFMT="mkv"
   FILEEXTOUT="mkv"
   # OTHER_PARMS="yada yada yada"
fi

if test "$FILEEXT" = "ogg"
then
   CONFMT="ogg"
   FILEEXTOUT="ogg"
   # OTHER_PARMS="yada yada yada"
fi

if test "$FILEEXT" = "ogv"
then
   CONFMT="ogg"
   FILEEXTOUT="ogv"
   # OTHER_PARMS="yada yada yada"
fi

if test "$FILEEXT" = "3gp" 
then
   CONFMT="3gp"
   FILEEXTOUT="3gp"
   # OTHER_PARMS="yada yada yada"
fi


#############################################################################
## Prompt for the offset time for the audio & video portions
## of the movie file.
##
## Examples: 13 or 00:00:13
#############################################################################

OFFSET_TIME=""

OFFSET_TIME=$(zenity --entry \
   --title "OFFSET BETWEEN the AUDIO and VIDEO." \
   --text "\
Enter a time in seconds --- or in hh:mm:ss[.xxx] format.
Examples: 3.5 or 00:00:03.5

The time may be negative or positive." \
   --entry-text "3.5")

if test "$OFFSET_TIME" = ""
then
   exit
fi


###############################
## Prepare the output filename.
###############################

FILENAMECROP=`echo "$VIDEOFILE" | cut -d\. -f1`

FILEOUT="${FILENAMECROP}_AUD-VID-OFFSET${OFFSET_TIME}.$FILEEXTOUT"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi

###################################################################
## Use 'ffmpeg' to make the 'audio-video offset' movie file.
## Defaulting as many parameters as possible from the input file ---
## output file having same frame-size, bit rates, etc. as input file.
###################################################################
## REFERENCE:
## http://
##################################################################

## FOR TEST: (show statements as they execute)
#   set -x

xterm -hold -fg white -bg black -geometry 90x48+100+100 -e \
      ffmpeg -i "$AUDIOFILE" -itsoffset $OFFSET_TIME -i "$VIDEOFILE" \
      -f $CONFMT -vcodec copy -acodec copy \
      $OTHER_PARMS "$FILEOUT"

#       -acodec libmp3lame -ar 22050 -ab 56k -ac 1 \

## In the similar 'ADD-AUDIO' script,
## '-acodec copy' did not work on an flv file with audio type 'adpcm_swf'.
## Err msg:
##     -acodec copy and -vol are incompatible (frames are not decoded)
##
## So I tried specifying an audio codec. (ac3 did not work. mp3 and mp2
## did not work either.) So ...
## We may not be able to use ffmpeg to offset audio and video for all movies.
## We may add audio/video-type-check-and-exit logic statements above.

## FOR TEST: (turn off 'set -x')
#    set -

###################################################################
## Meaning of the 'popular' ffmpeg parms:
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

xterm -fg white -bg black -hold -geometry 90x24+100+100 -e \
        $MOVIEPLAYER "$FILEOUT"


###############################################
## Use a user-specified MOVIEPLAYER. Someday?
###############################################

#  . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
#  . $DIR_NautilusScripts/.set_VIEWERvars.shi

#   $MOVIEPLAYER "$FILEOUT" &
