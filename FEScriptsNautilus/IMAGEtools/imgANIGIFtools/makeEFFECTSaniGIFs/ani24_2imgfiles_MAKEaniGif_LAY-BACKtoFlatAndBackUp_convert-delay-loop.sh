#!/bin/sh
##
## NAUTILUS
## SCRIPT: ani24_2imgfiles_LAY-BACKtoFlatAndBackUp_convert-delay-loop.sh
##
## PURPOSE: Makes a 'laid-back' or 'lying down' sequence of images (with a
##          'perspective' effect, that is, the image top vanishing
##          toward the horizon effect --- i.e. the image is going
##          from vertical to flat, with a perspective effect) --- using
##          the first selected image file.
##
##          Then uses the 2nd image file to 'rise up' from the horizon to a
##          'full on' view (i.e. from flat to vertical, with perspective effects).
## 
##          Puts these images in an animated GIF file.
##
## METHOD:  Uses 4 'zenity' prompts:
##
##          1. Uses 'zenity' to prompt the user for
##              a. number of images to make for each half of the animated GIF cycle
##              b. number of loops (0 = never ending)
##              c. an inter-image 'delay' (in hundredths of seconds).
##
##          2. Uses 'zenity' to prompt the user for a number of 'hold frames'
##             for the two images --- to hold them in the 'vertical' position.
##
##          3. Uses 'zenity' to prompt the user for a maximum x-indent (in percent,
##             0 to 50 percent, 50% meaning make the top of the image go to a
##             point as the image is 'laid-back-to' or 'rises-from' the horizon/flat).
##             This x-indent is applied to the top left and right of the sequence of
##             images.
##
##          4. Uses 'zenity' to prompt the user for a background color
##             to use to fill in the background on the top, left, and right sides
##             of the 'perspective' images.
##
##          Uses ImageMagick 'convert' with the '-distort Perspective' option to make the
##          sequence of 'perspective' images.
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
## Created: 2012feb24 Based on a 'perspective' script in the 'imgEFFECTS' group
##                    and an 'animated GIF' script in the 'imgANIGIF' group.
## Changed: 2012

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
This 2-images-LAY-BACK-To-From-FLAT utility requires TWO filenames
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
This 2-images-LAY-BACK-To-From-FLAT utility requires exactly TWO
filenames to be selected.

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
This 2-images-LAY-BACK-To-From-FLAT utility requires that
both files have the same size --- in X and Y pixels.

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
Enter the NUMBER-of-FRAMES to make, in 'laying down' the 1st image TO the
horizon/flat (and 'raising up' the 2nd image FROM the horizon/flat)
      and
enter the NUMBER-of-complete-CYCLES (loops) to make (0 = keep looping)
      and
enter the FRAME-DISPLAY-TIME, in 100ths of seconds.
Examples:
  250 gives 2.5 seconds for the display time of each frame.
  100 gives 1.0 seconds for the display time of each frame.
   10 gives 0.1 second for the display time of each frame.
    5 gives 20 frames/sec for an almost smooth animation

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
## 2images in their vertical position before continuing to 'loop'.
##
##    (Gives the user a chance to see the 2 selected images,
##     in full, for a second or more.)
############################################################

FRAMES_HOLD=""

FRAMES_HOLD=$(zenity --entry \
   --title "NUMBER-of-'HOLD'-FRAMES" \
   --text "\
Enter the NUMBER-of-FRAMES to 'hold onto' the original 2 selected
images, in their vertical position, before continuing the loop.

This gives you a chance to see the 2 full images for as much as
a second or more at a time, in their 'vertical' position.
" \
   --entry-text "5")

if test "$FRAMES_HOLD" = ""
then
   exit
fi


#######################################################
## zenity-PROMPT-3:
## Prompt for the maximum TOP-X-INDENT-PERCENT.
#######################################################

MAXTOPXINDENT_PERCENT=""

MAXTOPXINDENT_PERCENT=$(zenity --entry \
   --title "Enter MAX-TOP-X-INDENT-PERCENT." \
   --text "\
Enter the MAXIMUM PERCENT X-INDENT as each of the 2 selected images
recedes-to or rises-from the horizon/flat.

This should be a number between 0 and 50.

Note that 50% indent emulates the images receding to a POINT in the
distance, when the images appear to be near lying flat." \
   --entry-text "25")

if test "$MAXTOPXINDENT_PERCENT" = ""
then
   exit
fi


#######################################################
## zenity-PROMPT-4:
## Prompt for the BACKGROUND COLOR parameter.
#######################################################

BKGND_COLOR=""

BKGND_COLOR=$(zenity --entry \
   --title "Enter BACKGROUND COLOR." \
   --text "\
Enter a BACKGROUND COLOR --- to fill in the background at the
top, left and right sides of the images, as they are 'laid-back'
to the horizon, and as they 'rise up' from the horizon.

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


##################################################################
## Make full filename for the output ani-gif file --- using the
## midnames of the 2 selected image files.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

# OUTFILE="${FILEMIDNAME1}_${FILEMIDNAME2}_ToFromFLAT_${FRAMES}frames_${NUMLOOPS}loops_delay${DISPLAYTIME}_ani.gif"
OUTFILE="${FILEMIDNAME1}_${FILEMIDNAME2}_ToFromFLAT_${FRAMES}frames_${NUMLOOPS}loops_delay${DISPLAYTIME}_hold${FRAMES_HOLD}_ani.gif"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


####################################################################
## Get the input filesize, x and y, in pixels.
##   (Recall that we require the 2 files to have the same img size.)
####################################################################

XYPIXELS=`identify "$FILENAME1" | head -1 | awk '{print $3}'`
XPIXELS=`echo "$XYPIXELS" | cut -dx -f1`
YPIXELS=`echo "$XYPIXELS" | cut -dx -f2`

####################################################################
## Use $MAXTOPXINDENT_PERCENT and $XPIXELS to calculate the maximum
## x-indent from each side, in pixels (an integer).
####################################################################
## NOTE: For multiplication with the '*' operator with 'bc',
## scale=0 does not yield integers. It seems to perform as if scale=1.
## Example:
##   $ echo "scale = 0 ; 2 * 5.1"  | bc
##   10.2
## Hence I use 'cut' to assure that I get an integer from the
## multiplication operation when using 'bc'.
####################################################################

MAXTOPXINDENT_PX=`echo "scale = 3;  $MAXTOPXINDENT_PERCENT * $XPIXELS / 100" | bc | cut -d'.' -f1`


######################################################################
## Use 'convert' with '-distort Perspective' to make the requested
## number ($FRAMES) of 'LYING-DOWN' files from file ** $FILENAME1 **.
##
## We make the frames 'lie down' as $CNT goes from 1 to $FRAMES - 1.
######################################################################
## In the 'convert -distort Perspective' commands below, we use a
## 4-point mapping of the corners of the image
## --- top-left, top-right, bottom-left, bottom-right --- i.e. we go
## left-to-right --- first on top, then on the bottom.
######################################################################

## FOR TESTING:
#   set -x

CNT=1

while test $CNT -lt $FRAMES
do
   LYINGDOWN_FILENAME="/tmp/${FILEMIDNAME1}_LYINGDOWN${CNT}.png"
   if test -f "$LYINGDOWN_FILENAME"
   then
      rm -f "$LYINGDOWN_FILENAME"
   fi

   ######################################################################### 
   ## Calculate the values of the top-left and top-right corners
   ## based on $XPIXELS, $YPIXELS, $CNT, $FRAMES and $MAXTOPXINDENT_PX.
   #########################################################################
   ## We use 'bc' to perform fractional, non-integer math operations.
   ## We use 'expr' to perform integer math operations.
   #########################################################################

   XTOPLEFTPX=`echo "scale = 3;  $MAXTOPXINDENT_PX * $CNT / $FRAMES" | bc | cut -d'.' -f1`
   XTOPRIGHTPX=`expr $XPIXELS - $XTOPLEFTPX`

   YTOPLEFTPX=`echo "scale = 3;  $YPIXELS * $CNT / $FRAMES" | bc | cut -d'.' -f1`
   YTOPRIGHTPX=$YTOPLEFTPX


   #################################################################
   ## Use 'convert' to make the new image file from imgfile1 ---
   ## with a 4-point mapping of the corners of a square in the image
   ## --- top-left, top-right, bottom-left, bottom-right.
   #############################################
   ## Note that the 2 bottom corners stay fixed.
   #################################################################

   ## FOR TESTING:
   #      set -x

   TRANSFORM_4POINT="0,0 ${XTOPLEFTPX},$YTOPLEFTPX  \
   $XPIXELS,0 ${XTOPRIGHTPX},$YTOPRIGHTPX  \
   ${XPIXELS},$YPIXELS ${XPIXELS},$YPIXELS \
   0,$YPIXELS 0,$YPIXELS"

   convert "$FILENAME1"  -matte  -virtual-pixel $BKGND_COLOR -mattecolor none \
        -distort Perspective "$TRANSFORM_4POINT" \
        "$LYINGDOWN_FILENAME"

   ## FOR TESTING:
   #      set -

   CNT=`expr $CNT + 1`

done
## END OF LOOP: while test $CNT -lt $FRAMES  (for $FILENAME1)


##########################################################################
## Use 'convert' with '-distort Perspective' to make the requested
## number ($FRAMES) of 'RISING-UP' files from file ** $FILENAME2 **.
##########################################################################
## We make the 'lying-down' frames from $FILENAME2, going 1 to $FRAMES - 1.
## Then we use them in the opposite order ($FRAMES-1 to 1) to get the
## appearance of them 'rising-up'.
##########################################################################
## In the 'convert -distort Perspective' commands below, we use a
## 4-point mapping of the corners of the image
## --- top-left, top-right, bottom-left, bottom-right --- i.e. we go
## left-to-right --- first on top, then on the bottom.
##########################################################################

CNT=1

while test $CNT -lt $FRAMES
do
   LYINGDOWN_FILENAME="/tmp/${FILEMIDNAME2}_LYINGDOWN${CNT}.png"
   if test -f "$LYINGDOWN_FILENAME"
   then
      rm -f "$LYINGDOWN_FILENAME"
   fi

   ######################################################################### 
   ## Calculate the values of the top-left and top-right corners
   ## based on $XPIXELS, $YPIXELS, $CNT, $FRAMES and $MAXTOPXINDENT_PX.
   #########################################################################
   ## We use 'bc' to perform fractional, non-integer math operations.
   #########################################################################

   XTOPLEFTPX=`echo "scale = 3;  $MAXTOPXINDENT_PX * $CNT / $FRAMES" | bc | cut -d'.' -f1`
   XTOPRIGHTPX=`expr $XPIXELS - $XTOPLEFTPX`

   YTOPLEFTPX=`echo "scale = 3;  $YPIXELS * $CNT / $FRAMES" | bc | cut -d'.' -f1`
   YTOPRIGHTPX=$YTOPLEFTPX


   #################################################################
   ## Use 'convert' to make the new image file from imgfile1 ---
   ## with a 4-point mapping of the corners of a square in the image
   ## --- top-left, top-right, bottom-left, bottom-right.
   #############################################
   ## Note that the 2 bottom corners stay fixed.
   #################################################################

   ## FOR TESTING:
   #      set -x

   TRANSFORM_4POINT="0,0 ${XTOPLEFTPX},$YTOPLEFTPX  \
   $XPIXELS,0 ${XTOPRIGHTPX},$YTOPRIGHTPX  \
   ${XPIXELS},$YPIXELS ${XPIXELS},$YPIXELS \
   0,$YPIXELS 0,$YPIXELS"

   convert "$FILENAME2"  -matte  -virtual-pixel $BKGND_COLOR -mattecolor none \
        -distort Perspective "$TRANSFORM_4POINT" \
        "$LYINGDOWN_FILENAME"

   ## FOR TESTING:
   #      set -

   CNT=`expr $CNT + 1`

done
## END OF LOOP: while test $CNT -lt $FRAMES  (for $FILENAME2)


##############################################################
## Call 'convert' to make a SOLID-COLOR image file (using the
## background color). This is for the edge-on view.
##############################################################

BKGND_FILENAME="/tmp/${BKGND_COLOR}_${XYPIXELS}.png"

if test -f "$BKGND_FILENAME"
then
   rm -f "$BKGND_FILENAME"
fi

convert  -size $XYPIXELS  xc:$BKGND_COLOR  "$BKGND_FILENAME"


##################################################################
## Make the list of filenames to use in making the animated GIF file.
##################################################################

FILENAMES="$FILENAME1"

## 'Lay-down' the 1st selected image, from 'vertical' down to
## the horizon (i.e. flat).

CNT=1

while test $CNT -lt $FRAMES
do
   LYINGDOWN_FILENAME="/tmp/${FILEMIDNAME1}_LYINGDOWN${CNT}.png"
   FILENAMES="$FILENAMES $LYINGDOWN_FILENAME"
   CNT=`expr $CNT + 1`
done


## Add the background-file, to emulate an edge-on view (image is flat).

FILENAMES="$FILENAMES $BKGND_FILENAME"


## 'Raise-up' the 2nd selected image, from the horizon (i.e. from being flat,
## that is, from edge-on) up to 'vertical'.

CNT=`expr $FRAMES - 1`

while test $CNT -gt 0
do
   LYINGDOWN_FILENAME="/tmp/${FILEMIDNAME2}_LYINGDOWN${CNT}.png"
   FILENAMES="$FILENAMES $LYINGDOWN_FILENAME"
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


## 'Lay down' the 2nd selected image.

CNT=1

while test $CNT -lt $FRAMES
do
   LYINGDOWN_FILENAME="/tmp/${FILEMIDNAME2}_LYINGDOWN${CNT}.png"
   FILENAMES="$FILENAMES $LYINGDOWN_FILENAME"
   CNT=`expr $CNT + 1`
done


## Add the background-file, to emulate an edge-on view (image is flat).

FILENAMES="$FILENAMES $BKGND_FILENAME"


## 'Raise up' the 1st selected image.

CNT=`expr $FRAMES - 1`

while test $CNT -gt 0
do
   LYINGDOWN_FILENAME="/tmp/${FILEMIDNAME1}_LYINGDOWN${CNT}.png"
   FILENAMES="$FILENAMES $LYINGDOWN_FILENAME"
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


