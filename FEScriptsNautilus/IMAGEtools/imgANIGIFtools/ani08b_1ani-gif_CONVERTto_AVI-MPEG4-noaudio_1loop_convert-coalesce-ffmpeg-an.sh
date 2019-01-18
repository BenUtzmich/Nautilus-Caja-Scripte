#!/bin/sh
##
## Nautilus
## SCRIPT: ani08b_1ani-gif_CONVERTto_AVI-MPEG4-noaudio_1loop_conver-coalesce-ffmpeg-an.sh
##
## PURPOSE: Converts a user-selected animated '.gif' file
##          to a '.avi' movie file, with no audio track.
##
## METHOD:  Uses Imagemagick 'convert -coalesce' to make a set of
##          '.png' files from the selected animated gif file.
##
##          Uses the 'ffmpeg' utility to make the '.avi' movie file, without
##          an audio track, from the set of '.png' files.
##
##          Shows the '.avi' file in a movie player --- 'ffplay' --- or
##          $MOVIEPLAYER, a movie player of the user's choice.
##
## REFERENCE: http://www.linuxquestions.org/questions/linux-software-2/converting-animated-gif-to-avi-ffmpeg-549839/
##
##            'macemoneta' found that the following two commands work:
##                convert test.gif test%05d.jpg
##                ffmpeg -r 5 -i test%05d.jpg -y -an test.avi
##
## HOW TO USE: In Nautilus, select one animated '.gif' file.
##             Then right-click and choose this script to run (name above).
##
###########################################################################
## Started: 2012feb09
## Changed: 2012may12 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (display statements that are executed)
# set -x

########################################################
## Get the filename of the selected (animated GIF) file.
########################################################

  FILENAME="$1"
# FILENAME="$@"
# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"


#####################################################################
## WE COULD
## Check that the selected file is a valid input movie file via its suffix.
##     (Assumes just one dot [.] in the filename, at the extension.)
#####################################################################

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
#  if test "$FILEEXT" != "gif" -a  "$FILEEXT" != "GIF"
#  then
#     exit
#  fi


####################################################################
## Get the 'midname' of the selected filename --- for use in
## making names of output files.
##    (Assumes just one dot [.] in the filename, at the extension.)
####################################################################

FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`


####################################################################
## Prepare the output '.avi' filename.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
####################################################################

CURDIR="`pwd`"

OUTFILE="${FILENAMECROP}_FROManiGIF.avi"

if test ! -w "$CURDIR"
then
   OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


##########################################################
## From the user, get the rate at which to show the frames
## of the selected animated GIF file --- in frames per second.
##########################################################

FRAMERATE=""

FRAMERATE=$(zenity --entry \
   --title "RATE at which to show the animated GIF frames?" \
   --text "\
Enter the NUMBER-of-FRAMES-per-SECOND at which to show the
'frames' of the selected animated GIF file:
  $FILENAME

Examples:
  1 is probably good if the animated GIF contains less than 10 'frames'.
  5 or more is probably good for an animated GIF with 50 frames or more.

The output '.avi' movie file, if good, will be shown using 'ffplay', with 'ffplay'
messages shown in a window --- AFTER the 'ffmpeg' messages window is closed.

   (Edit this script to change the movie viewer used.)" \
   --entry-text "1")

if test "$FRAMERATE" = ""
then
   exit
fi


##########################################################
## Use 'convert' to make PNG files (in the /tmp directory)
## from the 'frames' of the animated GIF file.
##########################################################

convert "$FILENAME" -coalesce "/tmp/${FILENAMECROP}_frame%02d.png"


#############################################################
## Use 'ffmpeg' to make the '.avi' file from the PNG files.
##    VCODEC NOTE:
##    According to 'ffmpeg' conversion messages, the default
##    video codec for the 'avi' container seems to be 'mpeg4'.
#############################################################
##    FILE SIZE NOTE:
##    The first test aniGIF file used was 3 times larger than
##    the output '.avi' file. MPEG4 compession seems to be
##    significant. It's surprising to this script author that
##    the movie file is so much smaller than the input GIF file.
#############################################################

xterm -hold -fg white -bg black -geometry 90x48+100+100 -e \
    ffmpeg -r $FRAMERATE -i "/tmp/${FILENAMECROP}_frame%02d.png" \
           -an "$OUTFILE"

## THIS WORKS. Note: '-an' is used and no '-threads' :
#    ffmpeg -r $FRAMERATE -i "/tmp/${FILENAMECROP}_frame%02d.png" \
#           -an "$OUTFILE"

## ALTERNATIVELY, we could be more specific with:
#      ffmpeg -r $FRAMERATE -i "/tmp/${FILENAMECROP}_frame%02d.png"  \
#        -f avi -vcodec mpeg4 -b 800k -g 300 -bf 2 "$OUTFILE"

## These options came FROM an example on web page:
##    http://manpages.ubuntu.com/manpages/lucid/man1/ffmpeg.1.html
## which had the following additional info:
##
##   This is a typical DVD ripping example; the input is a VOB file, the
##   output an AVI file with MPEG-4 video and MP3 audio.
##
##   Note that in this command we use B-frames so the MPEG-4 
##   stream is DivX5 compatible, and GOP size is 300 which means
##   one intra frame every 10 seconds for 29.97fps input video.


## NOTE: We do not use audio parms on the 'ffmpeg' command, such as
##               -acodec libfaac -ab 128k  -ar 22050 -ac 1



#####################################################################
## Basic ffmpeg syntax is:
##  ffmpeg [input options] -i [input file] [output options] [output file]
##
## Note that, without the '-f' parameter,
## 'ffmpeg' determines the container format of the output file
## based on the extension you specify. For example, if you specify the
## extension as '.mkv', your file will be muxed into an Matroska container.
##
## Meaning of the 'popular' ffmpeg parms:
##
## -i  val = input filename(s)
##
## -f fmt  = force [container] format
##
## -vcodec codec - to force the video codec. Example: -vcodec mpeg4 
##                 Try  "ffmpeg -formats"
##
## -r  val = frame rate in frames/sec
##
## -b  val = video bitrate in kbits/sec (default = 200 kbps)
##
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
## -an = disable audio recording
##
## -acode codec - to force the audio codec. Example: -acodec libmp3lame
## -ab val = audio bitrate in bits/sec (default = 64k)
## -ar val = audio sampling frequency in Hz (default = 44100 Hz)
## -ac channels - default = 1
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
##   -ss position = seek to given position, in secs or hh:mm:ss[.xxx]
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


###########################################################
## Show the movie file (when user closes the xterm window).
###########################################################

if test ! -f "$OUTFILE"
then
   exit
fi

# MOVIEPLAYER="/usr/bin/vlc"
# MOVIEPLAYER="/usr/bin/mplayer"
# MOVIEPLAYER="/usr/bin/gmplayer -vo xv"
# MOVIEPLAYER="/usr/bin/smplayer"
# MOVIEPLAYER="/usr/bin/totem"
  MOVIEPLAYER="/usr/bin/ffplay -stats"

xterm -fg white -bg black -hold -geometry 90x24+100+100 \
      -e $MOVIEPLAYER "$OUTFILE"

## NOTE: 'totem' (based on gstreamer, version ?) tends to play
##        only a second or so of an mpeg1video that I created
##        with ffmpeg.
##        But 'ffplay' does a good job. 'mplayer' does OK.
##        'totem' is suspect. (Or the ffmpeg recording parms?)


#########################################################
## Someday change to use a user-specified MOVIEPLAYER. (?)
#########################################################

# . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
# . $DIR_NautilusScripts/.set_VIEWERvars.shi

# $MOVIEPLAYER "$FILEOUT" &
