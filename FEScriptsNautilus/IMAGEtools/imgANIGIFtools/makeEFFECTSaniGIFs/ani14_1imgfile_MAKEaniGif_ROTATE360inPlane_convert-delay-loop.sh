#!/bin/sh
##
## Nautilus
## SCRIPT: ani14_1imgfile_MAKEaniGif_ROTATE360inPlane_inpDELAY.sh
##
## PURPOSE: From a user selected image file (.jpg' or '.png' or '.gif'
##          or whatever), this script makes a sequence of 'rotated'
##          images (through 360 degrees) and makes an animated '.gif'
##          file from that sequence of images.
##
##          Uses 'zenity' to prompt the user for
##             - number of 'frames' to make, for each 360 rotation
##             - number of 360 rotations to make (0 = keep rotating)
##             - a 'delay' time - time to show each frame (in 100ths of seconds).
##
##          Uses 'zenity' to prompt the user whether to rotate
##             1 - clockwise, or
##             2 - counter-clockwise
##
##          Uses 'zenity' to prompt for #frames to 'hold onto' the original
##          selected image in each animation cycle.
##
##          To make the sequence of more and more rotated files,
##          this script uses the ImageMagick 'convert' program with the
##          '-distort SRT {angle}' option.
##
##          To make the animated GIF file, this script uses the
##          ImageMagick 'convert' program with '-delay' and '-loop' options.
## 
##          Shows the animated '.gif' file in an image viewer of the
##          user's choice (which could be a web browser).
##
## Reference: http://www.imagemagick.org/Usage/warping/#animations
##
## NOTE: We could make many of the 'frame' files in memory using various
##       cloning techniques of the 'convert' command ... BUT for large
##       images or lots of frames, this could consume a lot of memory
##       and make the convert command fail.
##
##       To try to avoid this (and to have the intermediate files 
##       available for examination or use), we make the frame files
##       in the /tmp directory.
##
## Created: 2012feb08
## Changed: 2012feb12 Add prompt for #frames to 'hold' on image.

## FOR TESTING: (show statements as they execute)
#  set -x


####################################################################
## Get the user-selected IMAGE filename.
####################################################################

FILENAME="$1"


#######################################################################
## Get the suffix (extension) of the input file.
##    (Assumes one period in the filename, at the extension.)
#######################################################################

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`


#######################################################################
## Get a 'stub' to use to name the output files.
#######################################################################

# FILENAMECROP=`echo "$FILENAMECROP" | sed 's|\..*$||'`

FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`


#######################################################################
## Set the viewer to be used to show the output animated GIF file.
######################################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi


##########################################################
## From the user, get 
##  - the number of frames to make per rotation
##  - the number of 360 loops to make (0 = keep rotating)
##    and 
##  - the 'delay' time for each frame of the animation ---
##    in 100ths of a second. Example: 250 = 2.5 seconds.
##########################################################

FRAMES_LOOPS_TIME=""

FRAMES_LOOPS_TIME=$(zenity --entry \
   --title "NUM-ROTATED-FRAMES, NUM-LOOPS, DISPLAY-TIME" \
   --text "\
Enter the NUMBER-of-FRAMES to make, in a 360 degree rotation
      and
enter the NUMBER-of-360-LOOPS to make (0 = keep rotating)
      and
enter the FRAME-DISPLAY-TIME, in 100ths of seconds.
Examples:
  250 gives 2.5 seconds for the display time of each frame.
  100 gives 1.0 seconds for the display time of each frame.
   10 gives 0.1 second for the display time of each frame.

The resulting animated GIF file will be shown using
$ANIGIFVIEWER .
   (If the viewer is a web browser, it may take more than
     10 seconds to start up.)" \
   --entry-text "20 0 10")

if test "$FRAMES_LOOPS_TIME" = ""
then
   exit
fi

FRAMES=`echo "$FRAMES_LOOPS_TIME" | cut -d' ' -f1`
NUMLOOPS=`echo "$FRAMES_LOOPS_TIME" | cut -d' ' -f2`
DISPLAYTIME=`echo "$FRAMES_LOOPS_TIME" | cut -d' ' -f3`

# FRAMES=`echo "$FRAMES_LOOPS_TIME" | awk '{print $1}'`
# NUMLOOPS=`echo "$FRAMES_LOOPS_TIME" | awk '{print $2}'`
# DISPLAYTIME=`echo "$FRAMES_LOOPS_TIME" | awk '{print $3}'`



##############################################################
## Prompt for 'direction' of the 'rotating' animated GIF ---
## clockwise OR counter-clockwise.
##############################################################

ANITYPE=""

ANITYPE=$(zenity --list --radiolist \
   --title "ANI-GIF type: rotated CLOCKWISE OR ANTI-CLOCKWISE?" \
   --text "Choose one of the following types of rotated animated GIF files to make." \
   --column "" --column "Type" \
   TRUE clockwise FALSE counter-clockwise)

if test "$ANITYPE" = ""
then
   exit
fi


##########################################################
## From the user,
## get the number of frames to make to 'hold' on the orignal
## image before continuing into another rotation cycle.
##     (This gives the user a chance to see the original
##      image 'upright' for as much as a second or more.)
##########################################################

FRAMES_HOLD=""

FRAMES_HOLD=$(zenity --entry \
   --title "NUMBER-of-'HOLD'-FRAMES" \
   --text "\
Enter the NUMBER-of-FRAMES to 'hold onto' the original selected
image before continuing into another rotation cycle.

This gives you a chance to see the selected image for as much as
a second (or more) 'upright', after each full cycle." \
   --entry-text "10")

if test "$FRAMES_HOLD" = ""
then
   exit
fi

##################################################################
## Make full filename for the output ani-gif file --- using the
## name of a selected image file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

# OUTFILE="${FILENAMECROP}_ROTATEinPLANE360_${FRAMES}frames_${NUMLOOPS}loops_delay${DISPLAYTIME}_${ANITYPE}_ani.gif"
OUTFILE="${FILENAMECROP}_ROTATEinPLANE360_${FRAMES}frames_${NUMLOOPS}loops_delay${DISPLAYTIME}_hold${FRAMES_HOLD}_${ANITYPE}_ani.gif"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi

####################################################################
## Generate a solid-colored file on which to composite the
## selected image. Make it about 60% larger than the selected file.
##      (We use white as the solid color, but we could use
##       'zenity' to prompt for the background color to use.)
####################################################################

BKGNDCOLOR="white"

FILESIZE=`identify "$FILENAME" | head -1 | awk '{print $3}'` 
SIZEX=`echo $FILESIZE | cut -dx -f1` 
SIZEY=`echo $FILESIZE | cut -dx -f2`

SIZEX2=`echo "scale = 3; $SIZEX * 1.6" | bc`
SIZEY2=`echo "scale = 3; $SIZEY * 1.6" | bc`

BKGNDFILE="/tmp/${FILENAMECROP}_ENLARGED-BACKGROUND_${BKGNDCOLOR}ONLY.jpg"

if test -f "$BKGNDFILE"
then
  rm -f "BKGNDFILE"
fi

convert  -size ${SIZEX2}x$SIZEY2  xc:$BKGNDCOLOR  "$BKGNDFILE"


####################################################################
## Composite the selected image onto the center of the larger
## background color file.
####################################################################

FILENAME2="/tmp/${FILENAMECROP}_BORDER-ADDED${BKGNDCOLOR}.jpg"

if test -f "$FILENAME2"
then
  rm -f "FILENAME2"
fi

composite -gravity Center  "$FILENAME"  "$BKGNDFILE"  "$FILENAME2"


######################################################################
## Use 'convert' with '-distort SRT' to make the $FRAMES rotated files
## from file $FILENAME2.
######################################################################

DELTA_ANGLE=`echo "scale = 10; 360 / $FRAMES" | bc`

CNT=1

while test $CNT -lt $FRAMES
do
   ROTATEDFILENAME="/tmp/${FILENAMECROP}_ROTATED${CNT}.$FILEEXT"
   if test -f "$ROTATEDFILENAME"
   then
     rm -f "$ROTATEDFILENAME"
   fi

   # ANGLE=`expr $CNT \* $DELTA_ANGLE`
   ANGLE=`echo "scale = 10; $CNT * $DELTA_ANGLE" | bc`

   if test "$ANITYPE" = "clockwise"
   then
      # convert "$FILENAME2"  -rotate $ANGLE "$ROTATEDFILENAME"
      convert "$FILENAME2" -virtual-pixel white -distort SRT $ANGLE \
              "$ROTATEDFILENAME"
   fi

   if test "$ANITYPE" = "counter-clockwise"
   then
      # convert "$FILENAME2"  -rotate -$ANGLE "$ROTATEDFILENAME"
      convert "$FILENAME2" -virtual-pixel white -distort SRT -$ANGLE \
              "$ROTATEDFILENAME"
   fi

   CNT=`expr $CNT + 1`
done
## END OF LOOP while test $CNT -le $FRAMES


##################################################################
## Make the list of filenames to use in making the animated GIF file.
##################################################################

FILENAMES=""

## Add the rotation frames.

CNT=1

while test $CNT -lt $FRAMES
do
   ROTATEDFILENAME="/tmp/${FILENAMECROP}_ROTATED${CNT}.$FILEEXT"
   FILENAMES="$FILENAMES $ROTATEDFILENAME"
   CNT=`expr $CNT + 1`
done

## Add the 'upright' image (with the added border).

FILENAMES="$FILENAMES $FILENAME2"


## Add the 'hold' frames of the selected image (with the added border).

CNT=1

while test $CNT -lt $FRAMES_HOLD
do
   FILENAMES="$FILENAMES $FILENAME2"
   CNT=`expr $CNT + 1`
done



##################################################################
## Use 'convert' to make the animated gif file.
##    -delay 250 pauses 250 hundredths of a second (2.5 sec)
##                                     before showing next image
##    -loop 0 animates 'endlessly'
##################################################################
## NOTE: There seems to be a bug in '-loop' in ImageMagick version
##       6.5.1-0 (circa 2010-12-02). '-loop 1' works OK, but
##       '-loop N' works like '-loop N+1' for N=2,3,...
##################################################################

convert -delay $DISPLAYTIME $FILENAMES -loop $NUMLOOPS "$OUTFILE"


##################################
## Show the new animated gif file.
##################################

$ANIGIFVIEWER "$OUTFILE" &



