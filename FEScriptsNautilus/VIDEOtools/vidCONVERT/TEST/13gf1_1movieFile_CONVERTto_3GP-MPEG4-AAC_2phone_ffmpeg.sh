#!/bin/sh
##
## Nautilus
## SCRIPT: 13gf1_1movieFile_CONVERTto_3GP-MPEG4-AAC_2phone_ffmpeg.sh
##
## PURPOSE: Convert a movie file to a '.3gp' movie file --- say, for
##          smart phones.  Uses 'ffmpeg'.
##
##          These 'ffmpeg' parms were reportedly used to  convert a
##          movie file to a small-format (176x144) '.3gp' movie file for use
##          on a mobile phone.
##
## METHOD:  There are no prompts to the user --- any parms such as bitrates
##          are hard-coded.
##
##          Uses 'ffmpeg' with parms including '-vcodec mpeg4' for the video
##          codec and '-r 25' for frame rate and '-s 176x144' and '-f 3gp'
##          for the container format and audio parms
##               '-acodec aac -ac 1 -ar 22050 -ab 128'
##          as well as the rather unusual '-muxvb 64' and '-muxab 32'
##          ffmpeg parameters.
##
##          Shows the output '.3gp' file in a movie player.
##
## REFERENCES:
##       The ffmpeg parms for 3gp files were based on a forum response at
##       http://www.sprintusers.com/forum/archive/index.php/t-102919.html
##   OR
##       do a web search on keywords such as 'ffmpeg 3gp'.
##
##
## HOW TO USE: In Nautilus, select a movie file.
##             Then right-click and choose this VIDEOtools script to run
##             (name above).
##
##########################################################################
## Started: 2010aug06
## Changed: 2011may11
## Changed: 2012may24 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
##############################################################################

## FOR TESTING: (display statements that are executed)
#  set -x

##########################################
## Get the filename of the selected file.
##########################################

# FILENAME="$@"
# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

FILENAME="$1"


######################################################################
## Check that the selected file is a 'supported' file, via its suffix.
## Other suffixes could be added here.
##     (Assumes just one dot [.] in the filename, at the extension.)
## COMMENTED. We depend on the user to select a proper input file.
######################################################################

#  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
#  if test "$FILEEXT" != "mpg" -a "$FILEEXT" != "wmv" -a \
#          "$FILEEXT" != "flv" -a "$FILEEXT" != "avi" -a \
#          "$FILEEXT" != "ogv" -a "$FILEEXT" != "ogg" -a \
#          "$FILEEXT" != "3gp" -a "$FILEEXT" != "3g2"
#  then
#     exit
#  fi


#####################################################################
## Prepare the output '.3gp' filename --- in /tmp.
##    (Assumes just one dot [.] in the filename, at the extension.)
####################################################################

FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`

FILEOUT="/tmp/${FILENAMECROP}_new.3gp"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


############################################################
## Ask for the image SIZE for the NEW LOSSY file that we
## are about to make from the INPUT video file.
#######################
##   COMMENTED for now. We use '176x144' for now.
#############################################################
## REFERENCE: http://en.wikipedia.org/wiki/Display_resolution
#############################################################

## This 'if test 0' effectively comments the following section.
if test 0
then

NEWSIZE=""

NEWSIZE=$(zenity --entry \
   --title "ENTER image SIZE for the new MPEG4-AAC-3GP file to be made." \
   --text "\
Enter an image size for the 3GP file

 $FILEOUT

that will now be made from the INPUT file

 $FILENAME

Examples:
  176x144  = QCIF  (1.222...)
  320x240  = QVGA  (4:3 = 1.33...)
  352x288  = CIF   (1.22...)
  640x480  = VGA   (4:3 = 1.33...)
  720x480  = NTSC screen size (1.5)
  720x576  = PAL screen size (1.25)
  800x600  = SVGA  (4:3 = 1.33...)
 1024x768  = XGA   (4:3 = 1.33...)
 1280x720  = HD720 (16:9 = 1.77...)
 1280x1024 = SXGA  (5:4 = 1.25)
 1920x1080 = HD1080 (16:9 = 1.77...)
 1600x1200 = UXGA  (4:3 = 1.33...)
        0  = same size as input file

'ffmpeg' CONVERSION will be started in a terminal window
so that startup and encoding messages can be watched.

When 'ffmpeg' is done, CLOSE the terminal window.
The output file, if good, will be shown in a video player." \
   --entry-text "176x144")

if test "$NEWSIZE" = ""
then
   exit
fi

if test "$NEWSIZE" = "0"
then
   SPARM=""
else
   SPARM="-s $NEWSIZE"
fi

fi
## END OF 'if test 0'


############################################################
## Use 'ffmpeg' to make the '3gp' file.
############################################################
## FROM: http://www.sprintusers.com/forum/archive/index.php/t-102919.html
##
## ffmpeg -y -i "<%InputFile%>" -timestamp "<%TimeStamp%>" -bitexact \
##        -vcodec mpeg4 -fixaspect -s 176x144 -r 25 -b 400 -acodec \
##        aac -ac 1 -ar 22050 -ab 64 -f 3gp -muxvb 64 -muxab 32 \
##        "<%TemporaryFile%>.3gp"
##
## Some of these parms (like -fixaspect) or their values were not
## accepted by my ffmpeg on Linux (Ubuntu 9.10), so I backed off and
## started adding parameters as needed, such as '-vcodec', '-r', '-s',
## and 'acodec'.
###########################################################

## FOR TESTING:
#    set -x

xterm -fg white -bg black -hold -geometry 90x48+100+100 -e \
      ffmpeg -i "$FILENAME" \
         -vcodec mpeg4  -r 25 -s 176x144 -b 400 \
         -acodec aac -ac 1 -ar 22050 -ab 128 \
         -f 3gp -muxvb 64 -muxab 32  \
         "$FILEOUT"

## FOR TESTING:
#    set -


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
## -acode codec - to force the audio codec. Example: -acodec libmp3lame
## -ab val = audio bitrate in bits/sec (default = 64k)
## -ar val = audio sampling frequency in Hz (default = 44100 Hz)
## -ac channels - default = 1
##
## -vcodec codec - to force the video codec. Example: -vcodec mpeg4 
##                 Try  "ffmpeg -formats"
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
##   -an = disable audio recording
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


#####################################
## Show the output '.3gp' movie file.
#####################################

if test ! -f "$FILEOUT"
then
   exit
fi

# MOVEIPLAYER="/usr/bin/vlc"
# MOVEIPLAYER="/usr/bin/mplayer"
# MOVEIPLAYER="/usr/bin/gmplayer -vo xv"
# MOVEIPLAYER="/usr/bin/smplayer"
# MOVEIPLAYER="/usr/bin/totem"

MOVEIPLAYER="/usr/bin/ffplay -stats"

xterm -fg white -bg black -hold -geometry 90x24+100+100 \
      -e $MOVEIPLAYER "$FILEOUT"

#########################################################
## Use a user-specified MOVEIPLAYER.  Someday?
#########################################################

# . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
# . $DIR_NautilusScripts/.set_VIEWERvars.shi

# $MOVEIPLAYER "$FILEOUT" &
