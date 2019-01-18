#!/bin/sh
##
## Nautilus
## SCRIPT: ani15_1imgfile_MAKEaniGif_ROLLhoriz-vert_inpDELAY.sh
##
## PURPOSE: From a user selected image file (.jpg' or '.png' or '.gif'
##          or whatever), this script makes a sequence of 'rolled'
##          images (horizontal or vertical) and makes an animated '.gif'
##          file from that sequence of images.
##
##          Uses 'zenity' to prompt the user for number of pixels to advance
##          for each frame of the animated GIF and for an inter-image delay
##          (in hundredths of seconds).
##
##          Also uses 'zenity' to prompt the user whether to roll
##             1 - horizontal, or
##             2 - vertical
##
##          To make the sequence of 'rolled' files,
##          this script uses the ImageMagick 'convert' program with the
##          '-roll +{xpixels}+{ypixels}' option.
##
##          To make the animated GIF file, this script uses the
##          ImageMagick 'convert' program with '-delay' and '-loop' options.
## 
##          Shows the animated '.gif' file in an image viewer of the
##          user's choice (which could be a web browser).
##
## Reference: http://www.imagemagick.org/Usage/warping/#roll
##
## Created: 2012feb09
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
## - the number of frames to make to 'roll' completely across the image
## - the number of complete roll-loops to make (0 = keep rolling)
## - the 'delay' time - time to display each frame of the animation ---
##   in 100ths of a second. Example: 250 = 2.5 seconds.
##########################################################

FRAMES_LOOPS_TIME=""

FRAMES_LOOPS_TIME=$(zenity --entry \
   --title "NUMBER-of-ROLL-FRAMES, NUM-LOOPS, DISPLAY-TIME" \
   --text "\
Enter the NUMBER-of-FRAMES to make, in a complete 'roll' across the image
      and
enter the NUMBER-of-ROLL-LOOPS to make (0 = keep rolling)
      and
enter the FRAME-DISPLAY-TIME (the 'delay'), in 100ths of seconds.
Examples:
  250 gives 2.5 seconds for the display time of each frame.
  100 gives 1.0 seconds for the display time of each frame.
   10 gives 0.1 second for the display time of each frame.

The resulting animated GIF file will be shown using
$ANIGIFVIEWER .
   (If the viewer is a web browser, it may take more than
     10 seconds to start up.)" \
   --entry-text "20 0 50")

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
## Prompt for 'direction' of the 'rolling' animated GIF ---
## horizontal or vertical.
##############################################################

ANITYPE=""

ANITYPE=$(zenity --list --radiolist \
   --title "ANI-GIF type: rolled HORIZONTALLY OR VERTICALLY?" \
   --text "Choose one of the following types of rolled animated GIF files to make." \
   --column "" --column "Type" \
   TRUE horizontal FALSE vertical)

if test "$ANITYPE" = ""
then
   exit
fi


##########################################################
## From the user, get
## the number of frames to make to 'hold' on the orignal
## image before continuing to 'roll'. (Gives the user a
## chance to see the full image for a second or more.)
##########################################################

FRAMES_HOLD=""

FRAMES_HOLD=$(zenity --entry \
   --title "NUMBER-of-'HOLD'-FRAMES" \
   --text "\
Enter the NUMBER-of-FRAMES to 'hold onto' the original selected
image, after each roll, before continuing to 'roll'.

This gives you a chance to see the full image for as much as
a second or more at a time, after each full roll.
" \
   --entry-text "5")

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

# OUTFILE="${FILENAMECROP}_ROLLED_${FRAMES}frames_${NUMLOOPS}loops_delay${DISPLAYTIME}_${ANITYPE}_ani.gif"
OUTFILE="${FILENAMECROP}_ROLLED_${FRAMES}frames_${NUMLOOPS}loops_delay${DISPLAYTIME}_hold${FRAMES_HOLD}_${ANITYPE}_ani.gif"


if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi



######################################################################
## Use 'convert' with '-roll  +{xpixels}+0' or '-roll +0+{ypixels}' to
## make the $FRAMES rolled files from file $FILENAME.
######################################################################

FILESIZE=`identify "$FILENAME" | head -1 | awk '{print $3}'` 


if test "$ANITYPE" = "horizontal"
then

   PIXELSX=`echo $FILESIZE | cut -dx -f1` 
   DELTAX=`echo "scale = 3; $PIXELSX / $FRAMES" | bc`

   CNT=1

   while test $CNT -lt $FRAMES
   do
      ROLLEDFILENAME="/tmp/${FILENAMECROP}_ROLLED${ANITYPE}${CNT}.$FILEEXT"
      if test -f "$ROLLEDFILENAME"
      then
        rm -f "$ROLLEDFILENAME"
      fi

      MOVEPIXELSX=`echo "scale = 3; $CNT * $DELTAX" | bc`

      convert "$FILENAME"  -roll +${MOVEPIXELSX}+0  "$ROLLEDFILENAME"
      CNT=`expr $CNT + 1`
   done
fi
## END OF if test "$ANITYPE" = "horizontal"


if test "$ANITYPE" = "vertical"
then

   PIXELSY=`echo $FILESIZE | cut -dx -f2`
   DELTAY=`echo "scale = 3; $PIXELSY / $FRAMES" | bc`

   CNT=1

   while test $CNT -lt $FRAMES
   do
      ROLLEDFILENAME="/tmp/${FILENAMECROP}_ROLLED${ANITYPE}${CNT}.$FILEEXT"
      if test -f "$ROLLEDFILENAME"
      then
        rm -f "$ROLLEDFILENAME"
      fi

      MOVEPIXELSY=`echo "scale = 3; $CNT * $DELTAY" | bc`

      convert "$FILENAME"  -roll +0+$MOVEPIXELSY  "$ROLLEDFILENAME"

      CNT=`expr $CNT + 1`
   done
fi
## END OF if test "$ANITYPE" = "vertical"


##################################################################
## Make the list of filenames to use in making the animated GIF file.
##################################################################

FILENAMES="$FILENAME"

CNT=1

while test $CNT -lt $FRAMES
do
   ROLLEDFILENAME="/tmp/${FILENAMECROP}_ROLLED${ANITYPE}${CNT}.$FILEEXT"
   FILENAMES="$FILENAMES $ROLLEDFILENAME"
   CNT=`expr $CNT + 1`
done


## Add the 'hold' frames of the original (selected) image.

CNT=1

while test $CNT -lt $FRAMES_HOLD
do
   FILENAMES="$FILENAMES $FILENAME"
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
##       In other words, you can't get 2 loops, because '-loop 2'
##       gives 3 loops --- and there seems to be no other way to
##       get 2 loops using 'convert'.
##################################################################

convert -delay $DISPLAYTIME -loop $NUMLOOPS $FILENAMES "$OUTFILE"


##################################
## Show the new animated gif file.
##################################

$ANIGIFVIEWER "$OUTFILE" &



