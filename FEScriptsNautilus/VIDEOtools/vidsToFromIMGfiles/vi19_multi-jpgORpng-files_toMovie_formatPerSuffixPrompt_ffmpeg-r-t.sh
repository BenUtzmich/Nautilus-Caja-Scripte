#!/bin/sh
##
## Nautilus
## SCRIPT: vi19_multi-jpgORpng-files_toMovie_formatPerSuffixPrompt_ffmpeg-r-t.sh
##
## PURPOSE: Combines selected '.jpg' (or '.png') files into a movie file.
##          Uses 'ffmpeg'.
##
## METHOD: In a 'for' loop, copies the user-selected files to the /tmp directory,
##         with filenames of the form ${TEMPIMGMIDNAME}N.jpg where N=1,2,3,...
##
##         Uses 'zenity --entry' to prompt for a frame rate for the movie.
##
##         Uses 'zenity --list --radiolist' to prompt for a movie container type
##         --- choices: mp4, mpeg, flv, avi, asf, ogg.
##
##         Builds the output filename of the movie using the selected type as 
##         the output file suffix.
##
##         Runs 'ffmpeg' with parms including '-r' to specify the frame rate and
##         -i /tmp/${TEMPIMGMIDNAME}%d.$FILEEXT1 to specify the input filenames.
##
##         Shows the new movie in a MOVIEPLAYER.
##
## REFERENCES:
##    http://www.miscdebris.net/blog/2008/04/28/create-a-movie-file-from-single-image-files-png-jpegs/
##    which gives an example to make an mp4 quicktime movie:
##       ffmpeg -qscale 5 -r 20 -b 9600 -i img%04d.png movie.mp4
##   OR
##    http://www.catswhocode.com/blog/19-ffmpeg-commands-for-all-needs
##    which gives an example:
##       ffmpeg -f image2 -i image%d.jpg video.mpg   (works??)
##
##   OR Google a set of keywords like
##             ffmpeg (jpeg|jpg|png) files "make a movie"
##
##
## HOW TO USE: In Nautilus, select one or more '.jpg' or '.png' image files.
##             Then right-click and choose this VIDEOtools script to run
##             (name above).
##
###############################################################################################
## Created: 2010oct31
## Changed: 2011jun13 Changed the MOVIEPLAYER. Added '-geometry' parm to xterm.
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and we use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012may24 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
##############################################################################

## FOR TESTING: (display statements that are executed)
# set -x

############################################################
## LOOP thru the selected files making a copy of each in
## /tmp --- with a names like $USER_temp_image1.jpg,
## $USER_temp_image2.jpg, $USER_temp_image3.jpg, ....
##
## Make sure they all have a common extension --- '.jpg'.
############################################################

CNT=0
TEMPIMGMIDNAME="$USER_temp_image"
FILEEXT1=""

for FILENAME
do
   ###############################################################
   ## Get the file extension of the file.
   ##
   ##  (Assumes one dot (.) in the filename, at the extension.)
   ###############################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "png"
   then
      zenity --info \
      --title "INPUT NOT '.jpg' or '.png'.  EXITING ..." \
      --text "\
File $FILENAME
is not a '.jpg' or '.png' suffix file.  Exiting ..."
      exit
   fi

   if test "$FILEEXT1" = ""
   then
      FILEEXT1="$FILEEXT"
   fi

   if test "$FILEEXT" != "$FILEEXT1" 
   then
      zenity --info \
      --title "INPUT NOT SAME TYPE (suffix).  EXITING ..." \
      --text "\
File $FILENAME
is not a '$FILEEXT1' suffix file, like one of the other input files.

 Exiting ..."
      exit
   fi

   CNT=`expr $CNT + 1`
   TEMPOUT="/tmp/${TEMPIMGMIDNAME}${CNT}.$FILEEXT1"
   cp "$FILENAME" "$TEMPOUT"

done
## END OF 'for FILENAME' loop --- to check file extensions and copy
## image files to /tmp with sequence numbers in the filenames.


#############################################################################
## We copy the last image file one extra time to /tmp, because 'ffmpeg'
## seems to cut short the display of the last image.
#############################################################################

CNT=`expr $CNT + 1`
TEMPOUT="/tmp/${TEMPIMGMIDNAME}${CNT}.$FILEEXT1"
cp "$FILENAME" "$TEMPOUT"


#############################################################################
## Prompt for the frame rate for showing the images ---
## say every 1 second, every 5 seconds, or whatever.
#############################################################################

RATE=""

RATE=$(zenity --entry \
   --title "RATE for showing the images?" \
   --text "\
Enter RATE, for display of the images. Examples:
               1     for showing each image for 1 second.
               0.5   for showing each image for 2 seconds (1/2).
               0.25  for showing each image for 4 seconds (1/4).
               0.1   for showing each image for 10 seconds (1/10).
               0.05  for showing each image for 20 seconds (1/20).
               0.025 for showing each image for 40 seconds (1/40).
               0.01  for showing each image for 100 seconds (1/100).
               0.005 for showing each image for 200 seconds (about every 3.3 mins)." \
   --entry-text "0.25")

if test "$RATE" = ""
then
   exit
fi


#######################################################
## Prompt for Output Video (container) type.
## Offer a 'radiolist' of options.
#######################################################

MOVIEMIDNAME="temp_imgs2movie"

VIDTYPE=""

VIDTYPE=$(zenity --list --radiolist \
   --title "VIDEO OUTPUT (container) TYPE?" \
   --text "\
The movie will be put in the current directory using a name like
'$MOVIEMIDNAME'.

Choose one of the following container types:" \
   --column "" --column "Type" \
   TRUE mp4 FALSE mpeg FALSE flv FALSE avi FALSE asf FALSE ogg)

if test "$VIDTYPE" = ""
then
   exit
fi

####################################################################
## Make the output movie filename, using the VIDTYPE obtained
## from the zenity radiolist prompt above.
#####################################################################

FILEOUT="${MOVIEMIDNAME}.$VIDTYPE"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


################################################################
## Use 'ffmpeg' to combine the '.jpg' files into the movie file.
################################################################
## FROM http://www.miscdebris.net/blog/2008/04/28/create-a-movie-file-from-single-image-files-png-jpegs/
## an example to make an mp4 quicktime movie:
##
##   ffmpeg -qscale 5 -r 20 -b 9600 -i img%04d.png movie.mp4
##
## Feedback from users indicates this worked well.
########################################################################
## FROM http://www.catswhocode.com/blog/19-ffmpeg-commands-for-all-needs
## an example:
##  
##   ffmpeg -f image2 -i image%d.jpg video.mpg
##                                               ('-f image2' is WRONG??)
##
## "This command will transform all the images from the current directory
## (named image1.jpg, image2.jpg, etc.) to a video file named video.mpg."
########################################################################
## The -t $DURATION' attempt in the 'ffmpeg' call below --- with
##         DURATION=`echo "scale = 0; $CNT / $RATE" | bc`
## --- does not work to force the appropriate duration of the movie file
## so that the last image is shown more than briefly.
##      But we leave that code there, in case it ever works.
## Instead we add an extra copy of the last image to the end of the movie.
##
## Even adding '-ss 0' and putting the '-t' (and '-ss') parm before the
## input file specification instead of before the output filename does NOT
## work. 
#############################################################################

DURATION=`echo "scale = 0; $CNT / $RATE" | bc`

xterm -hold -fg white -bg black -geometry 90x48+100+100 -e \
      ffmpeg  -qscale 5 -r $RATE -b 9600 \
      -i /tmp/${TEMPIMGMIDNAME}%d.$FILEEXT1 -ss 0 -t $DURATION "$FILEOUT"

## We could add the '-f' (container type) parameter if need be.
#        ... -f $VIDTYPE "$FILEOUT"

#########################################################
## Cleanup the /tmp image files after the call to ffmpeg.
#########################################################

rm "/tmp/${TEMPIMGMIDNAME}*.$FILEEXT1"

###########################################################
## Show the movie file (when user closes the xterm window).
###########################################################

if test ! -f "$FILEOUT"
then
   exit
fi

# MOVIEPLAYER="/usr/bin/vlc"
# MOVIEPLAYER="/usr/bin/mplayer"
# MOVIEPLAYER="/usr/bin/gnome-mplayer"
# MOVIEPLAYER="/usr/bin/vlc"

MOVIEPLAYER="/usr/bin/ffplay -stats"

xterm -fg white -bg black -hold -geometry 90x24+100+100 -e \
      $MOVIEPLAYER "$FILEOUT"

######################################################
## Use a user-specified MOVIEPLAYER.  Someday?
######################################################

# . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
# . $DIR_NautilusScripts/.set_VIEWERvars.shi

# $MOVIEPLAYER "$FILEOUT" &
