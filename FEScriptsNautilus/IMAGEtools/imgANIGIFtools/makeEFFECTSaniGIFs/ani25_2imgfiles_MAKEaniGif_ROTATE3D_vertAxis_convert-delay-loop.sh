#!/bin/sh
##
## NAUTILUS
## SCRIPT: ani25_2imgfiles_ROTATE3D_vertAxis_convert-delay-loop.sh
##
## PURPOSE: Given 2 images (of same x,y pixel size), this script makes an
##          animated GIF that looks like the 2 images are on each side of a
##          sheet of paper and the paper is rotating about a vertical axis down
##          the middle of the 2 images --- with a 'perpective' 3D effect added.
##
## METHOD:  Makes 4 sequences of images that emulate the rotation of
##            a. image1 thru 90 degrees, from 'face-on' to 'edge-on'
##            b. image2 thru 90 degrees, from 'edge-on' to 'face-on'
##            c. image2 thru 90 degrees, from 'face-on' to 'edge-on'
##            d. image1 thru 90 degrees, from 'edge-on' to 'face-on' 
##          and the images are done with a 'perspective' effect. That is,
##          as the left and right 4 corners of the images rotate, it looks
##          like a pair of right corners 'vanish' TOWARD a horizon (across
##          the middle of the images), as the pair of corners rotate
##          AWAY FROM the eye and the image goes 'edge-on' ---
##          AND, as a left pair of corners rotate TOWARD the eye, it looks
##          like those corners 'enlarge' toward the user as the corners move
##          toward the eye and AWAY from a horizon across the middle of the
##          images.
##
##          These 4 sequences of images are put in an animated GIF file.
##
##          Sine/cosine formulas are used to calculate the intersection points
##          of 4 view lines into a plane.
##
##             The 4 lines are the lines of sight from the user's eye (assumed
##             to be at the midpoint of the image about 1200 pixels from the
##             vertical axis of rotation, which is in the middle of the images)
##             to the 4 corners of the images.
##
##             The plane is the plane containing the vertical axis of rotation
##             of the image(s) --- the plane which is perpendicular
##             to the user's line of sight to the middle of the
##             images. We will call this plane 'the screen'.
##
##          Uses 4 'zenity' prompts:
##
##          1. Uses 'zenity' to prompt the user for
##              a. number of images to make for each 90 degree rotation
##                 of either image
##              b. number of 360 degree rotations (loops) --- 0 = never ending
##              c. an inter-image 'delay' (in hundredths of seconds).
##
##          2. Uses 'zenity' to prompt the user for a number of 'hold frames'
##             for the two images --- to hold them in the 'face-on' position.
##
##          3. Uses 'zenity' to prompt the user for a background color
##             to use to fill in the background around the perimeter of the
##             image.
##
##          4. Uses 'zenity' to prompt for the distance from eye to center
##             of the images --- in pixels.
##
##          NOTE: The image 'canvas' MAY need to be enlarged from the
##                size of the selected 2 images, so that the corners that
##                rotate toward the eye, and away from the face-on position,
##                do not go off-canvas as those corners rotate TOWARD THE EYE.
##
##          Uses ImageMagick 'convert' with the '-distort Perspective' option
##          to make each of the 4 sequences of 'perspective' images.
##
##          To make the animated GIF file, this script uses the
##          ImageMagick 'convert' program with '-delay' and '-loop' options.
##
##          Shows the animated '.gif' file in an image viewer of the
##          user's choice (which could be a web browser).
##
## REFERENCES: http://www.imagemagick.org/Usage/distorts/#bilinear
##             http://www.wizards-toolkit.org/discourse-server/viewtopic.php?f=1&t=11056
##
## HOW TO USE: Click on the names of 2 image files in a Nautilus
##             directory list.
##             Then right-click and choose this script to run (name above).
##
## Created: 2012feb24 Based on a 'ROTATE360inPlane' script and a
##                    'LAY-BACKtoFlat' and a 'SMUSHtoAXIS' script in the
##                    'imgANIGIF' group.
## Changed: 2012feb29 Add a zenity prompt for the eye-to-images distance.

## FOR TESTING: (show statements as they execute)
#  set -x

####################################################################
## Get the 2 user-selected IMAGE filenames --- and a 3rd name, if any.
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
This 2-images-ROTATE3D-vertAxis utility requires TWO filenames
to be selected.

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
This 2-images-ROTATE3D-vertAxis utility requires exactly TWO
filenames to be selected.

Exiting ..."
   exit
fi


####################################################################
## Check that the two selected files are the same size ---
## in X and Y pixels.
####################################################################

XbyY_PIXELS1=`identify "$FILENAME1" | head -1 | awk '{print $3}'` 
XbyY_PIXELS2=`identify "$FILENAME2" | head -1 | awk '{print $3}'` 

if test ! "$XbyY_PIXELS1" = "$XbyY_PIXELS2"
then
   zenity --info \
      --title "THE 2 FILES ARE DIFFERENT PIXEL SIZES. EXITING ..." \
      -text "\
This 2-images-ROTATE3D-vertAxis utility requires that
both files have the same size --- in X and Y pixels.

FILE1:
NAME: $FILENAME1
SIZE: $XbyY_PIXELS1

FILE2:
NAME: $FILENAME2
SIZE: $XbyY_PIXELS2

If you don't want to crop either image,
you can make the two images the SAME pixel-size with some of the other
'feNautilusScripts' 'IMAGEtools' utilities --- such as a 'GENtool'
to make a SOLID BACKGROUND file big enough to contain either of the 2 image
files and an OVERLAY tool to overlay each image on the solid background file.

Exiting ..."
   exit
fi


#######################################################################
## Get the suffix (extension) of the 2 input files.
##    (Assumes one period in the filenames, at the extension.)
## COMMENTED, for now.
#######################################################################

# FILEEXT1=`echo "$FILENAME1" | cut -d\. -f2`
# FILEEXT2=`echo "$FILENAME2" | cut -d\. -f2`


####################################################################
## Check that the file extension is 'jpg' or 'png' or 'gif'.
##     Assumes one period (.) in filename, at the extension.
## COMMENTED, for now.
####################################################################
 
# if test "$FILEEXT1" != "jpg" -a "$FILEEXT1" != "png" -a "$FILEEXT1" != "gif"
# then
#    exit
# fi
 
# if test "$FILEEXT2" != "jpg" -a "$FILEEXT2" != "png" -a "$FILEEXT2" != "gif"
# then
#    exit
# fi


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
## zenity-PROMPT-1:
## From the user, get
## - the number of frames to make to 'lay-down' an image to the horizon/flat
## - the number of complete cycles to make (0 = keep cycling)
## - the 'delay' time - time to display each frame of the animation ---
##   in 100ths of a second. Example: 250 = 2.5 seconds.
##########################################################################

FRAMES_LOOPS_TIME=""

FRAMES_LOOPS_TIME=$(zenity --entry \
   --title "NUMBER-of-FRAMES, NUM-LOOPS, DISPLAY-TIME" \
   --text "\
Enter the NUMBER-of-FRAMES to make, in 'ROTATING' each image THROUGH
90 DEGREES (each of the 2 images will be rotated through 180 degrees
for a total of a 360 degree rotation of the simulated 'sheet' that
has one image on one side and the other image on the other side)
      and
enter the NUMBER-of-complete-CYCLES (loops) to make (0 = keep rotating)
      and
enter the FRAME-DISPLAY-TIME, in 100ths of seconds.
Examples:
  250 gives 2.5 seconds for the display time of each frame.
  100 gives 1.0 seconds for the display time of each frame.
   10 gives 0.1 second for the display time of each frame.
    5 gives 20 frames/sec for an almost smooth animation, if
      the adjacent images do not differ much.

The resulting animated GIF file will be shown using
$ANIGIFVIEWER .
   (If the viewer is a web browser, it may take more than
     10 seconds to start up.)

This utility may take 20 SECONDS OR MORE to run to completion.
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


############################################################
## zenity-PROMPT-2:
## From the user,
## get the number of frames to make to 'hold' on the orignal
## 2images in their 'face-on' position before continuing to 'loop'.
##
##    (Gives the user a chance to see the 2 selected images,
##     in full, for a second or more.)
############################################################

FRAMES_HOLD=""

FRAMES_HOLD=$(zenity --entry \
   --title "NUMBER-of-'HOLD'-FRAMES" \
   --text "\
Enter the NUMBER-of-FRAMES to 'hold onto' the original 2 selected
images, in their 'face-on' position, before continuing the loop.

This gives you a chance to see the 2 full images for as much as
a second or more at a time, in their 'full-face' position.
" \
   --entry-text "5")

if test "$FRAMES_HOLD" = ""
then
   exit
fi


#######################################################
## zenity-PROMPT-3:
## Prompt for the BACKGROUND COLOR parameter.
#######################################################

BKGND_COLOR=""

BKGND_COLOR=$(zenity --entry \
   --title "Enter BACKGROUND COLOR." \
   --text "\
Enter a BACKGROUND COLOR --- to fill in the background around
the perimeter of each image. (The image 'canvas' is enlarged to
accomodate the corners of the images which expand vertically as
the corners appear to approach the eye of the beholder.)

Examples:
black   OR   #000000
white   OR   #ffffff
red     OR   #ff0000
green   OR   #00ff00
blue    OR   #0000ff
midgray   OR  #808080
transparent 
" \
   --entry-text "black")

if test "$BKGND_COLOR" = ""
then
   exit
fi


############################################################
## zenity-PROMPT-4:
## From the user,
## get the distance from the eye to the center of the images
## --- in pixels.
############################################################

EYEPX=""

EYEPX=$(zenity --entry \
   --title "Distance from EYE TO the center of the 2 images?" \
   --text "\
Enter the simulated DISTANCE from the observer's EYE TO the
center of the 2 images --- in pixels.

This will typically be in the range of 600 pixels to 1600 pixels.
" \
   --entry-text "1200")

if test "$EYEPX" = ""
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

# OUTFILE="${FILEMIDNAME1}_${FILEMIDNAME2}_ROTATE3D_${FRAMES}frames_${NUMLOOPS}loops_delay${DISPLAYTIME}_ani.gif"
OUTFILE="${FILEMIDNAME1}_${FILEMIDNAME2}_ROTATE3D_${FRAMES}frames_${NUMLOOPS}loops_delay${DISPLAYTIME}_hold${FRAMES_HOLD}_ani.gif"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


####################################################################
## Get the input image size, x and y, in pixels.
##   (Recall that we require the 2 files to have the same img size.)
####################################################################

XPIXELS=`echo "$XbyY_PIXELS1" | cut -dx -f1`
YPIXELS=`echo "$XbyY_PIXELS1" | cut -dx -f2`



####################################################################
## Calculate the half-width and half-height of the 2 images.
####################################################################
## NOTE: For multiplication with the '*' operator with 'bc', in calcs below,
## scale=0 does not yield integers. It seems to perform as if scale=1.
## Example:
##   $ echo "scale = 0 ; 2 * 5.1"  | bc
##   10.2
## Hence I use 'cut' to assure that I get an integer from the
## multiplication operation when using 'bc'.
####################################################################

# XHALFPX=`echo "scale = 3; $XPIXELS / 2" | bc | cut -d'.' -f1`
# YHALFPX=`echo "scale = 3; $YPIXELS / 2" | bc | cut -d'.' -f1`

XHALFPX=`expr $XPIXELS / 2`
YHALFPX=`expr $YPIXELS / 2`


#################################################################
## We divide 90 degrees --- pi/2 = 2 x arctan(1) --- by $FRAMES
## to get DELTA_RADS, the 'delta-angle' in radians.
##  (This should give us proper angular speed of the rotation.
##   The plane should be going through a constant angular amount
##   per time to display each frame.)
#################################################################

DELTA_RADS=`echo "scale = 3; 2.0 * a(1) / $FRAMES" | bc -l`


######################################################################
## SEQUENCE-1:
## IMAGE1 --- RIGHTEDGE: inSCREEN-to-inBACK:
## Use 'convert' with '-distort Perspective' to make the requested
## number of frames ($FRAMES) for a 90 degree rotation from 'face-on'
## to 'edge-on' of the image in file ** $FILENAME1 ** --- emulate the
## right corners going away from the screen.
##
## We make the frames as $CNT goes from 1 to $FRAMES - 1,
## and the angle goes from 0 to 90 degrees.
######################################################################
## In the 'convert -distort Perspective' commands below, we use a
## 4-point mapping of the 'corners' of the image
## --- top-mid, bottom-mid, top-right, bottom-right.
## Note that the 2 'mid' 'corners' are on the axis of rotation.
######################################################################

## FOR TESTING:
#   set -x

CNT=1

while test $CNT -lt $FRAMES
do
   SEQUENCE_FILENAME="/tmp/${FILEMIDNAME1}_RIGHTedge_SCREENtoBACK_${CNT}.png"
   if test -f "$SEQUENCE_FILENAME"
   then
      rm -f "$SEQUENCE_FILENAME"
   fi

   ANGLE=`echo "scale = 3; $CNT * $DELTA_RADS" | bc`

   ######################################################################### 
   ## Calculate the values of the top-right and bottom-right corners
   ## based on $XHALFPX, $YHALFPX, ANGLE=$CNT*$DELTA_RADS, $EYEPX.
   #########################################################################
   ## NOTE: The origin is the top-left of the image, and Y is increasing from
   ## the top of the image down. X is increasing from left to right.
   #########################################################################
   ## We use 'bc' to perform fractional, non-integer math operations.
   ## We use 'expr' to perform integer math operations.
   #########################################################################

   #########################################################################
   ## YTOPRIGHT= YHALFPX * ( 1 - EYEPX / (EYEPX + XHALFPX * SIN(ANGLE) )
   ## YBOTRIGHT= YHALFPX * ( 1 + EYEPX / (EYEPX + XHALFPX * SIN(ANGLE) )
   ## Note: When ANGLE=0, YTOPRIGHT=0 and YBOTRIGHT=2*YHALFPX.
   #########################################################################

   YDELT=`echo "scale = 3; $EYEPX / ( $EYEPX + $XHALFPX * s($ANGLE) )" | bc -l`

   YTOPRIGHTPX=`echo "scale = 3; $YHALFPX * ( 1 - $YDELT )" | bc | cut -d'.' -f1`
   YBOTRIGHTPX=`echo "scale = 3; $YHALFPX * ( 1 + $YDELT )" | bc | cut -d'.' -f1`

   ##################################################################################
   ## XTOPRIGHT= XHALFPX * ( 1 + EYEPX * COS(ANGLE) / (EYEPX + XHALFPX * SIN(ANGLE) )
   ## XBOTRIGHT= XTOPRIGHT
   ## Note: When ANGLE=0, XTOPRIGHT=XBOTRIGHT=2*XHALFPX.
   ##       When ANGLE=90deg, XTOPRIGHT=XBOTRIGHT=XHALFPX.
   ##################################################################################

   XDELT=`echo "scale = 3; $EYEPX * c($ANGLE) / ( $EYEPX + $XHALFPX * s($ANGLE) )" | bc -l`

   XTOPRIGHTPX=`echo "scale = 3; $XHALFPX * ( 1 + $XDELT)" | bc | cut -d'.' -f1`
   XBOTRIGHTPX=$XTOPRIGHTPX


   #####################################################################
   ## Use 'convert' to make the new image file from imgfile1 ---
   ## with a 4-point mapping of corners in the image
   ## --- top-mid, bottom-mid, top-right, bottom-right.
   #####################################################################
   ## Note that the 2 'mid' corners, on the axis of rotation, stay fixed.
   #####################################################################

   ## FOR TESTING:
   #      set -x

   TRANSFORM_4POINT="${XHALFPX},0 ${XHALFPX},0  \
   ${XHALFPX},$YPIXELS ${XHALFPX},$YPIXELS \
   $XPIXELS,0 ${XTOPRIGHTPX},$YTOPRIGHTPX  \
   ${XPIXELS},$YPIXELS ${XBOTRIGHTPX},$YBOTRIGHTPX"

   convert "$FILENAME1"  -matte  -virtual-pixel $BKGND_COLOR -mattecolor none \
        -distort Perspective "$TRANSFORM_4POINT" \
        "$SEQUENCE_FILENAME"

   ## FOR TESTING:
   #      set -

   CNT=`expr $CNT + 1`

done
## END OF LOOP: while test $CNT -lt $FRAMES  (for $FILENAME1, sequence1)


##########################################################################
## SEQUENCE-2:
## IMAGE2 --- LEFTEDGE: inBACK-to-inSCREEN:
## Use 'convert' with '-distort Perspective' to make the requested
## number of frames ($FRAMES) for a 90 degree rotation from 'edge-on'
## to 'face-on' of the image in file ** $FILENAME2 ** --- emulate the
## left corners coming from behind the screen, toward the screen.
##
## We make the frames as $CNT goes from $FRAMES - 1 to 1,
## and the angle goes from 90 degrees to 0.
##########################################################################
## In the 'convert -distort Perspective' commands below, we use a
## 4-point mapping of 'corners' of the image
## --- top-left, bottom-left, top-mid, bottom-mid.
## Note that the 2 'mid' 'corners' are on the axis of rotation.
##########################################################################

CNT=`expr $FRAMES - 1`

while test $CNT -gt 0
do
   SEQUENCE_FILENAME="/tmp/${FILEMIDNAME2}_LEFTedge_BACKtoSCREEN_${CNT}.png"
   if test -f "$SEQUENCE_FILENAME"
   then
      rm -f "$SEQUENCE_FILENAME"
   fi

   ANGLE=`echo "scale = 3; $CNT * $DELTA_RADS" | bc`

   ######################################################################### 
   ## Calculate the values of the top-left and bottom-left corners
   ## based on $XHALFPX, $YHALFPX, ANGLE=$CNT*$DELTA_RADS, $EYEPX.
   #########################################################################
   ## NOTE: The origin is the top-left of the image, and Y is increasing from
   ## the top of the image down. X is increasing from left to right.
   #########################################################################
   ## We use 'bc' to perform fractional, non-integer math operations.
   ## We use 'expr' to perform integer math operations.
   #########################################################################

   #########################################################################
   ## YTOPLEFT= YHALFPX * ( 1 - EYEPX / (EYEPX + XHALFPX * SIN(ANGLE) )
   ## YBOTLEFT= YHALFPX * ( 1 + EYEPX / (EYEPX + XHALFPX * SIN(ANGLE) )
   ## Note: When ANGLE=0, YTOPLEFT=0 and YBOTLEFT=2*YHALFPX.
   #########################################################################

   YDELT=`echo "scale = 3; $EYEPX / ( $EYEPX + $XHALFPX * s($ANGLE) )" | bc -l`

   YTOPLEFTPX=`echo "scale = 3; $YHALFPX * ( 1 - $YDELT )" | bc | cut -d'.' -f1`
   YBOTLEFTPX=`echo "scale = 3; $YHALFPX * ( 1 + $YDELT )" | bc | cut -d'.' -f1`

   ##################################################################################
   ## XTOPLEFT= XHALFPX * ( 1 - EYEPX * COS(ANGLE) / (EYEPX + XHALFPX * SIN(ANGLE) )
   ## XBOTLEFT= XTOPLEFT
   ## Note: When ANGLE=90deg, XTOPLEFT=XBOTLEFT=XHALFPX.
   ##       When ANGLE=0,     XTOPLEFT=XBOTLEFT=0.
   ##################################################################################

   XDELT=`echo "scale = 3; $EYEPX * c($ANGLE) / ( $EYEPX + $XHALFPX * s($ANGLE) )" | bc -l`

   XTOPLEFTPX=`echo "scale = 3; $XHALFPX * ( 1 - $XDELT)" | bc | cut -d'.' -f1`
   XBOTLEFTPX=$XTOPLEFTPX


   #####################################################################
   ## Use 'convert' to make the new image file from imgfile2 ---
   ## with a 4-point mapping of corners in the image
   ## --- top-left, bottom-left, top-mid, bottom-mid.
   #####################################################################
   ## Note that the 2 'mid' corners, on the axis of rotation, stay fixed.
   #####################################################################

   ## FOR TESTING:
   #      set -x

   TRANSFORM_4POINT="0,0 ${XTOPLEFTPX},$YTOPLEFTPX  \
   0,$YPIXELS ${XBOTLEFTPX},$YBOTLEFTPX \
   ${XHALFPX},0 ${XHALFPX},0  \
   ${XHALFPX},$YPIXELS ${XHALFPX},$YPIXELS"

   convert "$FILENAME2"  -matte  -virtual-pixel $BKGND_COLOR -mattecolor none \
        -distort Perspective "$TRANSFORM_4POINT" \
        "$SEQUENCE_FILENAME"

   ## FOR TESTING:
   #      set -

   CNT=`expr $CNT - 1`

done
## END OF LOOP: while test $CNT -gt 0  (for $FILENAME2, sequence 2)


######################################################################
## SEQUENCE-3:
## IMAGE2 --- RIGHTEDGE: inSCREEN-to-inBACK:
## Use 'convert' with '-distort Perspective' to make the requested
## number of frames ($FRAMES) for a 90 degree rotation from 'face-on'
## to 'edge-on' of the image in file ** $FILENAME2 ** --- emulate the
## right corners going away from the screen.
##
## We make the frames as $CNT goes from 1 to $FRAMES - 1,
## and the angle goes from 0 to 90 degrees.
######################################################################
## In the 'convert -distort Perspective' commands below, we use a
## 4-point mapping of the corners of the image
## --- top-mid, bottom-mid, top-right, bottom-right.
## Note that the 2 'mid' 'corners' are on the axis of rotation.
######################################################################

## FOR TESTING:
#   set -x

CNT=1

while test $CNT -lt $FRAMES
do
   SEQUENCE_FILENAME="/tmp/${FILEMIDNAME2}_RIGHTedge_SCREENtoBACK_${CNT}.png"
   if test -f "$SEQUENCE_FILENAME"
   then
      rm -f "$SEQUENCE_FILENAME"
   fi

   ANGLE=`echo "scale = 3; $CNT * $DELTA_RADS" | bc`

   ######################################################################### 
   ## Calculate the values of the top-right and bottom-right corners
   ## based on $XHALFPX, $YHALFPX, ANGLE=$CNT*$DELTA_RADS, $EYEPX.
   #########################################################################
   ## NOTE: The origin is the top-left of the image, and Y is increasing from
   ## the top of the image down. X is increasing from left to right.
   #########################################################################
   ## We use 'bc' to perform fractional, non-integer math operations.
   ## We use 'expr' to perform integer math operations.
   #########################################################################

   #########################################################################
   ## YTOPRIGHT= YHALFPX * ( 1 - EYEPX / (EYEPX + XHALFPX * SIN(ANGLE) )
   ## YBOTRIGHT= YHALFPX * ( 1 + EYEPX / (EYEPX + XHALFPX * SIN(ANGLE) )
   ## Note: When ANGLE=0, YTOPRIGHT=0 and YBOTRIGHT=2*YHALFPX.
   #########################################################################

   YDELT=`echo "scale = 3; $EYEPX / ( $EYEPX + $XHALFPX * s($ANGLE) )" | bc -l`

   YTOPRIGHTPX=`echo "scale = 3; $YHALFPX * ( 1 - $YDELT )" | bc | cut -d'.' -f1`
   YBOTRIGHTPX=`echo "scale = 3; $YHALFPX * ( 1 + $YDELT )" | bc | cut -d'.' -f1`

   ##################################################################################
   ## XTOPRIGHT= XHALFPX * ( 1 + EYEPX * COS(ANGLE) / (EYEPX + XHALFPX * SIN(ANGLE) )
   ## XBOTRIGHT= XTOPRIGHT
   ## Note: When ANGLE=0, XTOPRIGHT=XBOTRIGHT=2*XHALFPX.
   ##       When ANGLE=90deg, XTOPRIGHT=XBOTRIGHT=XHALFPX.
   ##################################################################################

   XDELT=`echo "scale = 3; $EYEPX * c($ANGLE) / ( $EYEPX + $XHALFPX * s($ANGLE) )" | bc -l`

   XTOPRIGHTPX=`echo "scale = 3; $XHALFPX * ( 1 + $XDELT)" | bc | cut -d'.' -f1`
   XBOTRIGHTPX=$XTOPRIGHTPX


   #####################################################################
   ## Use 'convert' to make the new image file from imgfile2 ---
   ## with a 4-point mapping of corners in the image
   ## --- top-mid, bottom-mid, top-right, bottom-right.
   #####################################################################
   ## Note that the 2 'mid' corners, on the axis of rotation, stay fixed.
   #####################################################################

   ## FOR TESTING:
   #      set -x

   TRANSFORM_4POINT="${XHALFPX},0 ${XHALFPX},0  \
   ${XHALFPX},$YPIXELS ${XHALFPX},$YPIXELS \
   $XPIXELS,0 ${XTOPRIGHTPX},$YTOPRIGHTPX  \
   ${XPIXELS},$YPIXELS ${XBOTRIGHTPX},$YBOTRIGHTPX"

   convert "$FILENAME2"  -matte  -virtual-pixel $BKGND_COLOR -mattecolor none \
        -distort Perspective "$TRANSFORM_4POINT" \
        "$SEQUENCE_FILENAME"

   ## FOR TESTING:
   #      set -

   CNT=`expr $CNT + 1`

done
## END OF LOOP: while test $CNT -lt $FRAMES  (for $FILENAME2, sequence3)


##########################################################################
## SEQUENCE-4:
## IMAGE1 --- LEFTEDGE: inBACK-to-inSCREEN:
## Use 'convert' with '-distort Perspective' to make the requested
## number of frames ($FRAMES) for a 90 degree rotation from 'edge-on'
## to 'face-on' of the image in file ** $FILENAME1 ** --- emulate the
## left corners coming from behind the screen, toward the screen.
##
## We make the frames as $CNT goes from $FRAMES - 1 to 1,
## and the angle goes from 90 degrees to 0.
##########################################################################
## In the 'convert -distort Perspective' commands below, we use a
## 4-point mapping of 'corners' of the image
## --- top-left, bottom-left, top-mid, bottom-mid.
## Note that the 2 'mid' 'corners' are on the axis of rotation.
##########################################################################

CNT=`expr $FRAMES - 1`

while test $CNT -gt 0
do
   SEQUENCE_FILENAME="/tmp/${FILEMIDNAME1}_LEFTedge_BACKtoSCREEN_${CNT}.png"
   if test -f "$SEQUENCE_FILENAME"
   then
      rm -f "$SEQUENCE_FILENAME"
   fi

   ANGLE=`echo "scale = 3; $CNT * $DELTA_RADS" | bc`

   ######################################################################### 
   ## Calculate the values of the top-left and bottom-left corners
   ## based on $XHALFPX, $YHALFPX, ANGLE=$CNT*$DELTA_RADS, $EYEPX.
   #########################################################################
   ## NOTE: The origin is the top-left of the image, and Y is increasing from
   ## the top of the image down. X is increasing from left to right.
   #########################################################################
   ## We use 'bc' to perform fractional, non-integer math operations.
   ## We use 'expr' to perform integer math operations.
   #########################################################################

   #########################################################################
   ## YTOPLEFT= YHALFPX * ( 1 - EYEPX / (EYEPX + XHALFPX * SIN(ANGLE) )
   ## YBOTLEFT= YHALFPX * ( 1 + EYEPX / (EYEPX + XHALFPX * SIN(ANGLE) )
   ## Note: When ANGLE=0, YTOPLEFT=0 and YBOTLEFT=2*YHALFPX.
   #########################################################################

   YDELT=`echo "scale = 3; $EYEPX / ( $EYEPX + $XHALFPX * s($ANGLE) )" | bc -l`

   YTOPLEFTPX=`echo "scale = 3; $YHALFPX * ( 1 - $YDELT )" | bc | cut -d'.' -f1`
   YBOTLEFTPX=`echo "scale = 3; $YHALFPX * ( 1 + $YDELT )" | bc | cut -d'.' -f1`

   ##################################################################################
   ## XTOPLEFT= XHALFPX * ( 1 - EYEPX * COS(ANGLE) / (EYEPX + XHALFPX * SIN(ANGLE) )
   ## XBOTLEFT= XTOPLEFT
   ## Note: When ANGLE=90deg, XTOPLEFT=XBOTLEFT=XHALFPX.
   ##       When ANGLE=0,     XTOPLEFT=XBOTLEFT=0.
   ##################################################################################

   XDELT=`echo "scale = 3; $EYEPX * c($ANGLE) / ( $EYEPX + $XHALFPX * s($ANGLE) )" | bc -l`

   XTOPLEFTPX=`echo "scale = 3; $XHALFPX * ( 1 - $XDELT)" | bc | cut -d'.' -f1`
   XBOTLEFTPX=$XTOPLEFTPX


   #####################################################################
   ## Use 'convert' to make the new image file from imgfile2 ---
   ## with a 4-point mapping of corners in the image
   ## --- top-left, bottom-left, top-mid, bottom-mid.
   #####################################################################
   ## Note that the 2 'mid' corners, on the axis of rotation, stay fixed.
   #####################################################################

   ## FOR TESTING:
   #      set -x

   TRANSFORM_4POINT="0,0 ${XTOPLEFTPX},$YTOPLEFTPX  \
   0,$YPIXELS ${XBOTLEFTPX},$YBOTLEFTPX \
   ${XHALFPX},0 ${XHALFPX},0  \
   ${XHALFPX},$YPIXELS ${XHALFPX},$YPIXELS"

   convert "$FILENAME1"  -matte  -virtual-pixel $BKGND_COLOR -mattecolor none \
        -distort Perspective "$TRANSFORM_4POINT" \
        "$SEQUENCE_FILENAME"

   ## FOR TESTING:
   #      set -

   CNT=`expr $CNT - 1`

done
## END OF LOOP: while test $CNT -gt 0  (for $FILENAME1, sequence 4)



##############################################################
## Call 'convert' to make a SOLID-COLOR image file (using the
## background color). This is for the edge-on view.
##############################################################

BKGND_FILENAME="/tmp/solid${BKGND_COLOR}_${XbyY_PIXELS1}.png"

if test -f "$BKGND_FILENAME"
then
   rm -f "$BKGND_FILENAME"
fi

convert  -size $XbyY_PIXELS1  xc:$BKGND_COLOR  "$BKGND_FILENAME"


##################################################################
## Make the list of filenames to use in making the animated GIF file.
##################################################################

FILENAMES="$FILENAME1"

## Add the frames of SEQUENCE-1 --- image1's right edge rotating
## from the screen (face-on) to the back (edge-on).

CNT=1

while test $CNT -lt $FRAMES
do
   SEQUENCE_FILENAME="/tmp/${FILEMIDNAME1}_RIGHTedge_SCREENtoBACK_${CNT}.png"
   FILENAMES="$FILENAMES $SEQUENCE_FILENAME"
   CNT=`expr $CNT + 1`
done


## Add the background-file, to emulate an edge-on view (image is flat).

FILENAMES="$FILENAMES $BKGND_FILENAME"


## Add the frames of SEQUENCE-2 --- image2's left edge rotating
## the back (edge-on) to the screen (face-on).


CNT=`expr $FRAMES - 1`

while test $CNT -gt 0
do
   SEQUENCE_FILENAME="/tmp/${FILEMIDNAME2}_LEFTedge_BACKtoSCREEN_${CNT}.png"
   FILENAMES="$FILENAMES $SEQUENCE_FILENAME"
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


## Add the frames of SEQUENCE-3 --- image2's right edge rotating
## from the screen (face-on) to the back (edge-on).

CNT=1

while test $CNT -lt $FRAMES
do
   SEQUENCE_FILENAME="/tmp/${FILEMIDNAME2}_RIGHTedge_SCREENtoBACK_${CNT}.png"
   FILENAMES="$FILENAMES $SEQUENCE_FILENAME"
   CNT=`expr $CNT + 1`
done


## Add the background-file, to emulate an edge-on view (image is flat).

FILENAMES="$FILENAMES $BKGND_FILENAME"


## Add the frames of SEQUENCE-3 --- image1's left edge rotating
## the back (edge-on) to the screen (face-on).

CNT=`expr $FRAMES - 1`

while test $CNT -gt 0
do
   SEQUENCE_FILENAME="/tmp/${FILEMIDNAME1}_LEFTedge_BACKtoSCREEN_${CNT}.png"
   FILENAMES="$FILENAMES $SEQUENCE_FILENAME"
   CNT=`expr $CNT - 1`
done

## Add the 'hold' frames for the 1st selected image.

CNT=1

while test $CNT -lt $FRAMES_HOLD
do
   FILENAMES="$FILENAMES $FILENAME1"
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

## FOR TESTING:
#   set -x

convert -delay $DISPLAYTIME -loop $NUMLOOPS $FILENAMES  "$OUTFILE"

## FOR TESTING:
#   set -


##################################
## Show the new animated gif file.
##################################

$ANIGIFVIEWER "$OUTFILE" &


