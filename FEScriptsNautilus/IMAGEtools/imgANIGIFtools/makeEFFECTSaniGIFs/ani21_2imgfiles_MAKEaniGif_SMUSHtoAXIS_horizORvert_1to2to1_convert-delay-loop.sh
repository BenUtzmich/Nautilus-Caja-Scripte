#!/bin/sh
##
## Nautilus
## SCRIPT: ani21_2imgfiles_MAKEaniGif_front-backROTATE_inpDELAY.sh
##
## PURPOSE: For a pair of user selected image files (.jpg' or '.png' or '.gif'
##          or whatever), this script makes it appear as if one image is
##          on the back of the other --- and rotates one image from 'face-on'
##          to 'edge-on', and then rotates the 2nd image from 'edge-on'
##          to 'face-on'. I.e. it appears that each image is rotated through
##          a 90 degree angle.
##
##          The effect is meant to look like a page, with a photograph
##          on each side of the page, and the page is being rotated about
##          an axis --- vertical or horizontal.
##
##          NOTE: No perspective transformation is applied at this time,
##          so the 'rotation' looks more like a 'smushing' in and out,
##          to the axis of rotation and back out to full view of each image.
##
##          Uses 'zenity' 3 times:
##
##          1. To prompt the user for 3 items: number of 'frames' to make
##             through each 90 degree rotation --- and how many rotations to
##             make (0 means keep rotating) --- and prompts for an
##             inter-image delay (in hundredths of seconds).
##
##          2. Also uses 'zenity' to prompt the user whether to rotate about
##             1 - a horizontal axis, or
##             2 - a vertical axis.
##
##          3. Also uses 'zenity' to prompt the user for the background
##             color to use around the rotated images.
## 
##          To make the sequence of 'rotated' files,
##          this script uses the ImageMagick 'convert' program with the
##          '-distort Perspective' option.
##
##          To make the animated GIF file, this script uses the
##          ImageMagick 'convert' program with '-delay' and '-loop' options.
## 
##          Shows the animated '.gif' file in an image viewer of the
##          user's choice (which could be a web browser).
##
## Reference: http://www.imagemagick.org
##
## Created: 2012feb10
## Changed: 2012feb12 Add prompt for #frames to 'hold onto' the 2 selectd images.

## FOR TESTING: (show statements as they execute)
#  set -x


####################################################################
## Get the 2 user-selected IMAGE filename.
####################################################################

FILENAME1="$1"
FILENAME2="$2"
FILENAME3="$3"


####################################################################
## Check that at least two filenames were selected.
####################################################################

if test "$FILENAME2" = ""
then
   zenity --info --title "NEED TO SELECT ANOTHER FILE. EXITING ..." \
      -text "\
This 2-image-ROTATE utility requires TWO filenames to be selected.

Exiting ..."
   exit
fi


####################################################################
## Check if more than two filenames were selected.
####################################################################

if test ! "$FILENAME3" = ""
then
   zenity --info --title "TOO MANY FILES SELECTED. EXITING ..." \
      -text "\
This 2-image-ROTATE utility requires exactly TWO filenames to be selected.

Exiting ..."
   exit
fi


####################################################################
## Check that the two selected files are the same size ---
## in X and Y pixels.
####################################################################

FILESIZE1=`identify "$FILENAME1" | head -1 | awk '{print $3}'` 
FILESIZE2=`identify "$FILENAME2" | head -1 | awk '{print $3}'` 

if test ! "$FILESIZE1" = "$FILESIZE2"
then
   zenity --info \
      --title "THE 2 FILES ARE DIFFERENT PIXEL SIZES. EXITING ..." \
      -text "\
This 2-image-ROTATE utility requires that both files have the same
size --- in X and Y pixels.

FILE1:
NAME: $FILENAME1
SIZE: $FILESIZE1

FILE2:
NAME: $FILENAME2
SIZE: $FILESIZE2

You can make the two files the SAME size with some of the other
'feNautilusScripts' 'IMAGEtools' utilities --- such as a 'GENtool'
to make a SOLID BACKGROUND file big enough to contain either of the 2 image
files and an OVERLAY tool to overlay each image on the solid background file.

Exiting ..."
   exit
fi


#######################################################################
## Get the suffix (extension) of the 2 input files.
##    (Assumes one period in the filenames, at the extension.)
#######################################################################

FILEEXT1=`echo "$FILENAME1" | cut -d\. -f2`
FILEEXT2=`echo "$FILENAME2" | cut -d\. -f2`

#######################################################################
## Get a 'stub' to use to name the output files.
##    (Assumes one period in the filenames, at the extension.)
#######################################################################

# FILEMIDNAME1=`echo "$FILENAME1" | sed 's|\..*$||'`
# FILEMIDNAME2=`echo "$FILENAME2" | sed 's|\..*$||'`

FILEMIDNAME1=`echo "$FILENAME1" | cut -d\. -f1`
FILEMIDNAME2=`echo "$FILENAME2" | cut -d\. -f1`


#######################################################################
## Set the viewer to be used to show the output animated GIF file.
######################################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi


##########################################################################
## From the user, get
## - the number of frames to make to 'rotate' an image through 90 degrees
## - the number of complete rotations to make (0 = keep rotating)
## - the 'delay' time - time to display each frame of the animation ---
##   in 100ths of a second. Example: 250 = 2.5 seconds.
##########################################################################

FRAMES_LOOPS_TIME=""

FRAMES_LOOPS_TIME=$(zenity --entry \
   --title "NUM-of-FRAMESin90degreeROTATE, NUM-LOOPS, DISPLAY-TIME" \
   --text "\
Enter the NUMBER-of-FRAMES to make, in rotating each image thru 90 degrees
      and
enter the NUMBER-of-completeROTATION-LOOPS to make (0 = keep rotating)
      and
enter the FRAME-DISPLAY-TIME, in 100ths of seconds.
Examples:
  250 gives 2.5 seconds for the display time of each frame.
  100 gives 1.0 seconds for the display time of each frame.
   10 gives 0.1 second for the display time of each frame.

The resulting animated GIF file will be shown using
$ANIGIFVIEWER .
   (If the viewer is a web browser, it may take more than
     10 seconds to start up.)

This utility may take 30 SECONDS OR MORE to run to completion.
" \
   --entry-text "10 0 10")

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
## Prompt for type of 'rotation' in the animated GIF --- about
## a horizontal-axis or a vertical-axis.
##############################################################

AXISTYPE=""

AXISTYPE=$(zenity --list --radiolist \
   --title "ROTATE AROUND: HORIZONTAL-axis OR VERTICAL?" \
   --text "\
Choose one of the following types of rotation to use ---
around a horizontal or a vertical axis?" \
   --column "" --column "Type" \
   FALSE horizontal-axis TRUE vertical-axis)

if test "$AXISTYPE" = ""
then
   exit
fi


############################################################
## From the user,
## get the number of frames to make to 'hold' on the orignal
## 2images before continuing to 'rotate'.
##
##    (Gives the user a chance to see the 2 selected images,
##     in full, for a second or more.)
############################################################

FRAMES_HOLD=""

FRAMES_HOLD=$(zenity --entry \
   --title "NUMBER-of-'HOLD'-FRAMES" \
   --text "\
Enter the NUMBER-of-FRAMES to 'hold onto' the original 2 selected
images, after each complete rotation, before continuing to rotate.

This gives you a chance to see the 2 full images for as much as
a second or more at a time, after each full rotation.
" \
   --entry-text "5")

if test "$FRAMES_HOLD" = ""
then
   exit
fi



#######################################################
## Prompt for the BACKGROUND COLOR parameter.
#######################################################

BKGND_COLOR=""

PERIMETERMSG="top and bottom"
if test "$AXISTYPE" = "horizontal-axis"
then
   PERIMETERMSG="left and right sides"
fi

BKGND_COLOR=$(zenity --entry \
   --title "Enter BACKGROUND COLOR." \
   --text "\
Enter a BACKGROUND COLOR --- to fill in the background at the
$PERIMETERSMSG of the rotated images.

Examples:
black   OR   #000000
white   OR   #ffffff
red     OR   #ff0000
green   OR   #00ff00
blue    OR   #0000ff
midgray   OR  #808080
transparent 
" \
   --entry-text "white")

if test "$BKGND_COLOR" = ""
then
   exit
fi

##################################################################
## Make full filename for the output ani-gif file --- using the
## midnames of the 2 selected image files.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

# OUTFILE="${FILEMIDNAME1}_${FILEMIDNAME2}_ROTATED_${FRAMES}frames_${NUMLOOPS}loops_delay${DISPLAYTIME}_${AXISTYPE}_ani.gif"
OUTFILE="${FILEMIDNAME1}_${FILEMIDNAME2}_ROTATED_${FRAMES}frames_${NUMLOOPS}loops_delay${DISPLAYTIME}_hold${FRAMES_HOLD}_${AXISTYPE}_ani.gif"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi

#################################################################
## We divide 90 degrees --- pi/2 = 2 x arctan(1) --- by $FRAMES
## to get DELTA_RADS, the 'delta-angle' in radians.
##  (This should give us proper angular speed of the rotation.
##   The plane should be going through a constant angular amount
##   per time to display each frame.)
#################################################################

DELTA_RADS=`echo "scale = 3; 2.0 * a(1) / $FRAMES" | bc -l`


######################################################################
## Use 'convert' with '-distort Perspective' to make the requested
## number ($FRAMES) of rotated files from file ** $FILENAME1 **
## --- for horizontal-axis or vertical-axis rotation.
######################################################################
## In the 4 'convert -distort Perspective' commands below, we use a
## 4-point mapping of the corners of the 2 images
## --- top-left, top-right, bottom-right, bottom-left --- i.e. we go
## clockwise around the corners of each image, starting from top-left.
######################################################################

FILE1XSIZE=`echo $FILESIZE1 | cut -dx -f1`
FILE1YSIZE=`echo $FILESIZE1 | cut -dx -f2` 

if test "$AXISTYPE" = "horizontal-axis"
then

   FILE1YHALF=`echo "scale = 3; $FILE1YSIZE / 2.0" | bc`

   CNT=1

   while test $CNT -lt $FRAMES
   do
      ROTATEDFILENAME="/tmp/${FILEMIDNAME1}_ROTATED${AXISTYPE}${CNT}.png"
      if test -f "$ROTATEDFILENAME"
      then
        rm -f "$ROTATEDFILENAME"
      fi

      #######################################################################
      ## We get the y-coordinates of the corners of the rotated image
      ## --- rotated thru $CNT * $DELTA_RADS radians --- by getting the
      ## DELTAY to apply to each original corner y-coordinate. We get NDELTAY
      ## by multiplying $FILE1YHALF by the cosine of ($CNT * $DELTA_RADS).
      ######################################################################
      ## NOTE: There seems to be a bug in GNU bc version  1.06.94. The
      ## scale=0 does not yield integers. It seems to perform as if scale=1.
      ## Example:
      ##   $ echo "scale = 0 ; 2 * 5.1"  | bc
      ##   10.2
      ## Hence I use 'cut' to assure that I get an integer.
      ##
      ## Several people have reported this weird behavior --- at
      ## http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=388487
      ## and one reports workarounds with 'sed' instead of 'cut'.
      ## A 'bc' author claims it is a bug in documentation, not in the
      ## behavior of 'scale'. He says 'scale' behaves according to the
      ## POSIX spec.
      ##
      ## Also see http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=610988
      ## The POSIX spec for 'bc' can be seen here:
      ## http://manpages.ubuntu.com/manpages/dapper/man1/bc.1posix.html
      ## I personally think this is an error or oversight in the POSIX spec
      ## for the way scale is to behave for 'expression * expression'. The
      ## spec should be the same as the spec for 'expression / expression'.
      ######################################################################

      ## FOR TESTING:
      #   set -x

      NDELTAY=`echo "scale = 3; $FILE1YHALF * s($CNT * $DELTA_RADS)" | bc -l | cut -d'.' -f1`
      YTOPLEFT=$NDELTAY
      YTOPRIGHT=$NDELTAY
      YBOTRIGHT=`expr $FILE1YSIZE - $NDELTAY`
      YBOTLEFT=`expr $FILE1YSIZE - $NDELTAY`

      TRANSFORM_4POINT="0,0 0,$YTOPLEFT \
                        ${FILE1XSIZE},0 ${FILE1XSIZE},$YTOPRIGHT \
                        ${FILE1XSIZE},$FILE1YSIZE ${FILE1XSIZE},$YBOTRIGHT \
                        0,$FILE1YSIZE 0,$YBOTLEFT"

      convert "$FILENAME1" -matte  -virtual-pixel $BKGND_COLOR  \
              -distort Perspective  "$TRANSFORM_4POINT" \
              "$ROTATEDFILENAME"

      ## FOR TESTING:
      #   set -

      CNT=`expr $CNT + 1`

   done
fi
## END OF if test "$AXISTYPE" = "horizontal-axis"


if test "$AXISTYPE" = "vertical-axis"
then

   FILE1XHALF=`echo "scale = 3; $FILE1XSIZE / 2.0" | bc`

   CNT=1

   while test $CNT -lt $FRAMES
   do
      ROTATEDFILENAME="/tmp/${FILEMIDNAME1}_ROTATED${AXISTYPE}${CNT}.png"
      if test -f "$ROTATEDFILENAME"
      then
        rm -f "$ROTATEDFILENAME"
      fi

      #######################################################################
      ## We get the x-coordinates of the corners of the rotated image
      ## --- rotated thru $CNT * $DELTA_RADS radians --- by getting the
      ## NDELTAX to apply to each original corner x-coordinate. We get NDELTAX
      ## by multiplying $FILE1XHALF by the cosine of ($CNT * $DELTA_RADS).
      ##
      ## NOTE: See note on 'scale' bug, and workarounds, above.
      #####################################################################

      ## FOR TESTING:
      #   set -x

      NDELTAX=`echo "scale = 3; $FILE1XHALF * s($CNT * $DELTA_RADS)" | bc -l | cut -d'.' -f1`
      XTOPLEFT=$NDELTAX
      XTOPRIGHT=`expr $FILE1XSIZE - $NDELTAX`
      XBOTRIGHT=`expr $FILE1XSIZE - $NDELTAX`
      XBOTLEFT=$NDELTAX

      TRANSFORM_4POINT="0,0 $XTOPLEFT,0 \
                        ${FILE1XSIZE},0 ${XTOPRIGHT},0 \
                        ${FILE1XSIZE},$FILE1YSIZE ${XBOTRIGHT},$FILE1YSIZE \
                        0,$FILE1YSIZE $XBOTLEFT,$FILE1YSIZE"

      convert "$FILENAME1" -matte  -virtual-pixel $BKGND_COLOR  \
              -distort Perspective  "$TRANSFORM_4POINT" \
              "$ROTATEDFILENAME"

      ## FOR TESTING:
      #   set -

      CNT=`expr $CNT + 1`

   done
fi
## END OF if test "$AXISTYPE" = "vertical-axis"


######################################################################
## Use 'convert' with '-distort Perspective' to make the requested
## number ($FRAMES) of rotated files from file ** $FILENAME2 **
## --- for horizontal-axis or vertical-axis rotation.
######################################################################

FILE2XSIZE=`echo $FILESIZE2 | cut -dx -f1`
FILE2YSIZE=`echo $FILESIZE2 | cut -dx -f2` 

if test "$AXISTYPE" = "horizontal-axis"
then

   FILE2YHALF=`echo "scale = 3; $FILE2YSIZE / 2.0" | bc`

   CNT=1

   while test $CNT -lt $FRAMES
   do
      ROTATEDFILENAME="/tmp/${FILEMIDNAME2}_ROTATED${AXISTYPE}${CNT}.png"
      if test -f "$ROTATEDFILENAME"
      then
        rm -f "$ROTATEDFILENAME"
      fi

      ######################################################################
      ## We get the y-coordinates of the corners of the rotated image
      ## --- rotated thru $CNT * $DELTA_RADS radians --- by getting the
      ## DELTAY to apply to each original corner y-coordinate. We get NDELTAY
      ## by multiplying $FILE2YHALF by the cosine of ($CNT * $DELTA_RADS).
      ##
      ## NOTE: See note on 'scale' bug, and workarounds, above.
      #######################################################################
      NDELTAY=`echo "scale = 3; $FILE2YHALF * s($CNT * $DELTA_RADS)" | bc -l | cut -d'.' -f1`
      YTOPLEFT=$NDELTAY
      YTOPRIGHT=$NDELTAY
      YBOTRIGHT=`expr $FILE2YSIZE - $NDELTAY`
      YBOTLEFT=`expr $FILE2YSIZE - $NDELTAY`

      TRANSFORM_4POINT="0,0 0,$YTOPLEFT \
                        ${FILE2XSIZE},0 ${FILE2XSIZE},$YTOPRIGHT \
                        ${FILE2XSIZE},$FILE2YSIZE ${FILE2XSIZE},$YBOTRIGHT \
                        0,$FILE2YSIZE 0,$YBOTLEFT"

      convert "$FILENAME2" -matte  -virtual-pixel $BKGND_COLOR  \
              -distort Perspective  "$TRANSFORM_4POINT" \
              "$ROTATEDFILENAME"
      CNT=`expr $CNT + 1`
   done
fi
## END OF if test "$AXISTYPE" = "horizontal-axis"


if test "$AXISTYPE" = "vertical-axis"
then

   FILE2XHALF=`echo "scale = 3; $FILE2XSIZE / 2.0" | bc`

   CNT=1

   while test $CNT -lt $FRAMES
   do
      ROTATEDFILENAME="/tmp/${FILEMIDNAME2}_ROTATED${AXISTYPE}${CNT}.png"
      if test -f "$ROTATEDFILENAME"
      then
        rm -f "$ROTATEDFILENAME"
      fi

      ########################################################################
      ## We get the x-coordinates of the corners of the rotated image
      ## --- rotated thru $CNT * $DELTA_RADS radians --- by getting the
      ## NDELTAX to apply to each original corner x-coordinate. We get NDELTAX
      ## by multiplying $FILE2XHALF by the cosine of ($CNT * $DELTA_RADS).
      ##
      ## NOTE: See note on 'scale' bug, and workarounds, above.
      ########################################################################
      NDELTAX=`echo "scale = 3; $FILE2XHALF * s($CNT * $DELTA_RADS)" | bc -l | cut -d'.' -f1`
      XTOPLEFT=$NDELTAX
      XTOPRIGHT=`expr $FILE2XSIZE - $NDELTAX`
      XBOTRIGHT=`expr $FILE2XSIZE - $NDELTAX`
      XBOTLEFT=$NDELTAX

      TRANSFORM_4POINT="0,0 $XTOPLEFT,0 \
                        ${FILE2XSIZE},0 ${XTOPRIGHT},0 \
                        ${FILE2XSIZE},$FILE2YSIZE ${XBOTRIGHT},$FILE2YSIZE \
                        0,$FILE2YSIZE $XBOTLEFT,$FILE2YSIZE"

      convert "$FILENAME2" -matte  -virtual-pixel $BKGND_COLOR  \
              -distort Perspective  "$TRANSFORM_4POINT" \
              "$ROTATEDFILENAME"
      CNT=`expr $CNT + 1`
   done
fi
## END OF if test "$AXISTYPE" = "vertical-axis"


##################################################################
## Make the list of filenames to use in making the animated GIF file.
##################################################################

FILENAMES="$FILENAME1"

## Add the 'hold' frames for the 1st selected image.

CNT=1

while test $CNT -lt $FRAMES_HOLD
do
   FILENAMES="$FILENAMES $FILENAME1"
   CNT=`expr $CNT + 1`
done

## Rotate the 1st selected image, 90 degrees - from face-on to edge-on.

CNT=1

while test $CNT -lt $FRAMES
do
   ROTATEDFILENAME="/tmp/${FILEMIDNAME1}_ROTATED${AXISTYPE}${CNT}.png"
   FILENAMES="$FILENAMES $ROTATEDFILENAME"
   CNT=`expr $CNT + 1`
done

## Rotate the 2nd selected image, 90 degrees - from edge-on to face-on.

CNT=$FRAMES

while test $CNT -gt 0
do
   ROTATEDFILENAME="/tmp/${FILEMIDNAME2}_ROTATED${AXISTYPE}${CNT}.png"
   FILENAMES="$FILENAMES $ROTATEDFILENAME"
   CNT=`expr $CNT - 1`
done

FILENAMES="$FILENAMES $FILENAME2"

## Add the 'hold' frames for the 2nd selected image.

CNT=1

while test $CNT -lt $FRAMES_HOLD
do
   FILENAMES="$FILENAMES $FILENAME2"
   CNT=`expr $CNT + 1`
done


## Rotate the 2nd selected image, 90 degrees - from face-on to edge-on.

CNT=1

while test $CNT -lt $FRAMES
do
   ROTATEDFILENAME="/tmp/${FILEMIDNAME2}_ROTATED${AXISTYPE}${CNT}.png"
   FILENAMES="$FILENAMES $ROTATEDFILENAME"
   CNT=`expr $CNT + 1`
done

## Rotate the 1st selected image, 90 degrees - from edge-on to face-on.

CNT=$FRAMES

while test $CNT -gt 0
do
   ROTATEDFILENAME="/tmp/${FILEMIDNAME1}_ROTATED${AXISTYPE}${CNT}.png"
   FILENAMES="$FILENAMES $ROTATEDFILENAME"
   CNT=`expr $CNT - 1`
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

## FOR TESTING:
#   set -x

convert -delay $DISPLAYTIME -loop $NUMLOOPS $FILENAMES  "$OUTFILE"

## FOR TESTING:
#   set -

##################################
## Show the new animated gif file.
##################################

$ANIGIFVIEWER "$OUTFILE" &



