#!/bin/sh
##
## Nautilus
## SCRIPT: 13m4m1_1movieFile_CONVERTto_MP4-X264-FAAC_mencoder.sh
##
## PURPOSE: Convert a  movie file to a '.mp4' container movie file ---
##          with an H.264 video stream and an FAAC audio stream.
##          (There are some MP3 audio alternatives in the comments.)
##          Uses 'mencoder'.
##
## METHOD:  There are no prompts to the user --- any parms such as bitrates
##          are hard-coded.
##
##          Uses 'mencoder' with parms including:
##          1.   '-of lavf -lavfopts format=mp4' for the container format
##          2.   '-ovc x264 -x264encopts nocabac:level_idc=30:bframes=0'
##               for the video encoding
##          3.   '-oac faac -faacopts mpeg=4:object=2:raw:br=128'
##               for the audio encoding.
##
##          Shows the '.mp4' file in a movie player.
##
## REFERENCES:
##         The mencoder options come FROM (2008) web page:
##         http://blog.jharding.org/2008/05/encoding-video-for-iphone-with-mencoder.html
##         See the comments below (near the 'mencoder' call) for
##         quotes from that web page.
##    OR
##         For info on converting movie files (like .mov) to mp4 (for iPod),
##         see
##         http://www.listware.net/201007/mplayer-mencoder-users/1873-mencoder-users-cannot-encode-mp4movflv-with-global-headers.html
##    OR
##         For a 2-pass method with mencoder (movie->avi->mp4), to avoid
##         audio sync issues, see
##         http://www.ioncannon.net/meta/210/converting-videos-flvwmvavietc-into-a-format-that-will-work-with-the-iphoneitunes/
##    OR
##         For some circa-2008 mencoder examples that use 'mp3' for audio
##         instead of 'faac', see
##         http://www.linuxquestions.org/questions/linux-software-2/converting-flv-to-mpg-with-audio-and-ffmpeg-646876/
##    OR
##         do a web search on keywords such as 'mencoder mp4 x264 faac'.
##
##
## HOW TO USE: In Nautilus, select a movie file.
##             Then right-click and choose this VIDEOtools script to run
##             (name above).
##
##     NOTE on TESTING:
##       This script needs to be tested on a wide variety of input movie
##       file container types, such as 'flv', 'avi', 'wmv', and 'mov' files
##       --- with various video and audio encodings in the input movie.
##       May need to use different/added mencoder parms for some of these
##       input formats.
##
#############################################################################
## Started: 2010oct31
## Changed: 2012may24 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#############################################################################

## FOR TESTING: (display statements that are executed)
# set -x

###########################################
## Get the filename of the selected file.
###########################################

# FILENAME="$@"
# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

FILENAME="$1"


#####################################################################
## Check that the selected file is a 'supported' movie input file,
## via its suffix.
##     (Assumes just one dot [.] in the filename, at the extension.)
## COMMENTED.
#####################################################################

#  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
#  if test "$FILEEXT" != "flv" -a "$FILEEXT" != "wmv" -a \
#          "$FILEEXT" != "avi" -a "$FILEEXT" != "mov"
#  then
#     exit
#  fi


####################################################################
## Prepare the output '.mp4' filename --- in /tmp.
##    (Assumes just one dot [.] in the filename, at the extension.)
####################################################################

FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`

FILEOUT="/tmp/${FILENAMECROP}_new.mp4"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


##########################################################
## Use 'mencoder' to make the 'mp4' file.
##########################################################

xterm -hold -fg white -bg black -geometry 90x48+100+100 -e \
      mencoder "$FILENAME" -o "$FILEOUT" \
         -vf scale=480:-10,harddup \
         -of lavf -lavfopts format=mp4 \
         -ovc x264 -x264encopts nocabac:level_idc=30:bframes=0 \
         -oac faac -faacopts mpeg=4:object=2:raw:br=128

## The mencoder options come FROM (2008) web page:
## http://blog.jharding.org/2008/05/encoding-video-for-iphone-with-mencoder.html
## See that page for slight variations on these options. Some notes there:
##
## Breaking it down:
##
##    * -vf scale=480:-10 - Scale width to 480, set height appropriately, but
##                          keep a multiple of 16.
##    * -vf harddup       - Insert duplicate frames to maintain frame rate
##       (Note: not sure if this is really needed - can the iPhone handle
##              variable framerate?)
##    * -x264encopts nocabac - iPhone only supports baseline profile, which
##                             does not allow CABAC.
##    * -x264encopts level_idc=30 - iPhone only supports up to level 3.0
##    * -x264encopts bframes=0 - Baseline profile does not allow B-frames
##
## His more detailed Alternative to try (more x264encopts, and -sws):
##
## mencoder.exe input.avi -o output.mp4 -vf scale=480:-10,harddup \
## -oac faac -faacopts mpeg=4:object=2:raw:br=128 \
## -of lavf -lavfopts format=mp4 -sws 9 \
## -ovc x264 \
## -x264encopts nocabac:level_idc=30:bframes=0:global_header:threads=auto:subq=5:frameref=6:partitions=all:trellis=1:chroma_me:me=umh:bitrate=500
##
## The extra options:
##
##    * -sws 9 - I think I just grabbed this from somewhere - wtf? (see below)
##    * global_header - Uses single global header instead of repeating every IDR - saves space
##    * threads=auto - Enables multi-threaded encoding (faster, gives up a touch of quality)
##    * subq=5 - Quarterpixel motion estimation
##    * framref=6 - Use up to 6 reference frames
##    * partitions=all - Consider all macroblock partition sizes
##
##--------------------------------------------------------------
##  Another neat trick is that if you change this:
##  -vf scale=480:-10,harddup
##  to this:
##  -vf dsize=480:320:2,scale=-8:-8,harddup
##  the video will be scaled down however far is necessary to fit in 480x320.
##
##  This is especially interesting for encoding 4:3 content. Otherwise mencoder
##  will scale to 480x360, and you'll cut off the top/bottom of the video,
##  or else need to rescale at runtime.
##
##--------------------------------------------------------------
##
##  If you want to constrain the final size to be within 480x320, then I think
##  you actually want -vf dsize=480:320:0, which tells it to keep display size
##  within those bounds, rather than video size.
##  4:3 DVDs are authored at 720x480 and scaled at display time, so using
##  dsize=480:320:2 will result in either a distored image (if display aspect
##  ratio is not applied) or runtime rescaling (if it is).
##
##  In my testing w/ a 720x480 DVD source, 480:320:2 ended up with a 480x320
##  video, and it appears the display aspect ratio got lost in the process,
##  such that mplayer and quicktime at least displayed it horizontally stretched.
##
##--------------------------------------------------------------
## 'sws' is the type of resize to use.
## The most common are 1,2, or 9.
## Bilinear (-sws 1) is fast but smooths the image.
## Bicubic (-sws 2) is the default.
## Lanczos (-sws 9) actually sharpens the image during resize.
##
## 0 fast bilinear
## 1 bilinear
## 2 bicubic (good quality) (default)
## 3 experimental
## 4 nearest neighbor (bad quality)
## 5 area
## 6 luma bicubic / chroma bilinear
## 7 gauss
## 8 sincR
## 9 lanczos
## 10 natural bicubic spline

## For more on converting movie files (like .mov) to mp4 (for iPod), see
## http://www.listware.net/201007/mplayer-mencoder-users/1873-mencoder-users-cannot-encode-mp4movflv-with-global-headers.html

## For a 2-pass method with mencoder (movie->avi->mp4), to avoid audio sync issues, see
## http://www.ioncannon.net/meta/210/converting-videos-flvwmvavietc-into-a-format-that-will-work-with-the-iphoneitunes/


## ALTERNATIVE flv2mp4:  (Note: Uses mp3 instead of faac for audio.)
##
## mencoder "$FILENAME" -mc 0 -noskip -vf harddup \
##      -oac lavc -lavcopts acodec=libmp3lame:abitrate=64 \
##      -ovc lavc -o "$FILEOUT" 
## OR
## mencoder "$FILENAME" -mc 0 -noskip -vf harddup \
##      -oac mp3lame -lameopts preset=64:mode=0:vol=10:cbr \
##      -ovc lavc -lavcopts vcodec=msmpeg4v2:vpass=1 -o "$FILEOUT"
## OR
## mencoder "$FILENAME" -mc 0 -noskip -vf harddup \
##      -oac mp3lame -lameopts preset=64:mode=0:vol=10:cbr \
##      -ovc lavc -lavcopts vcodec=msmpeg4:vpass=1 -o "$FILEOUT"
##
## FROM (2008): http://www.linuxquestions.org/questions/linux-software-2/converting-flv-to-mpg-with-audio-and-ffmpeg-646876/



########################
## Show the movie file.
########################

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

xterm -fg white -bg black -hold -geometry 90x24+100+100 \
      -e $MOVIEPLAYER "$FILEOUT"

#########################################################
## Use a user-specified MOVIEPLAYER.  Someday?
#########################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

# . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
# . $DIR_NautilusScripts/.set_VIEWERvars.shi

# $MOVIEPLAYER "$FILEOUT" &
