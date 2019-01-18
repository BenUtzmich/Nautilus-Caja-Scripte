#!/bin/sh
##
## Nautilus
## SCRIPT: ani23_2imgfiles_MAKEaniGif_WIPE_left-right_1to2to1_inpDELAY.sh
##
## PURPOSE: For a pair of user selected image files (.jpg' or '.png' or '.gif'
##          or whatever), this script makes it appear as if one image is
##          WIPEDed, left-right, into the other image and back to the
##          first image again.
##
## METHOD:  Uses 'zenity' to prompt the user for 3 items:
##          (1) number of 'frames' to make for each wipe from one
##              image to the other --- and
##          (2) how many wipe cycles to request (0 means keep wiping
##              back-and-forth
##          (3) an inter-image 'delay' (in hundredths of seconds), i.e. amount
##             of time to show each frame.
## 
##          Gets the X-Y pixel size of the 2 same-sized image files. Then
##          makes a gradient image-file of 3 sections:
##             black on the left, white on the right, and a gradient of
##             black to white in the middle.
##          Uses 'convert' with the '+append' option.
##
##          Using 'convert' with the '-crop' option, in a for loop, makes
##          a sequence of gradient files by getting an XxY sized
##          section of the 3-panel gradient file.
##
##          Makes the sequence of images to make the ani-GIF by compositing
##          the 2 selected image files with each one of the sequence of
##          gradient files --- using 'composite'.
##
##          To make the animated GIF file, this script uses the
##          ImageMagick 'convert' program with '-delay' and '-loop' options,
##          with the set of composited images as input.
## 
##          Shows the animated '.gif' file in an image viewer of the
##          user's choice (which could be a web browser).
##
## Reference: http://www.imagemagick.org/
##            See pages on 'xc:', 'gradient:', '+append', '-crop', 'composite'
##
## Created: 2012feb15
## Changed: 2012

## FOR TESTING: (show statements as they execute)
#  set -x


####################################################################
## Get the 2 user-selected IMAGE filenames.
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
This 2-image-WIPE utility requires TWO filenames to be selected.

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
This 2-image-WIPE utility requires exactly TWO filenames to be selected.

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
This 2-image-WIPE utility requires that both files have the same
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
## Get the X and Y pixel size of the 2 input files.
#######################################################################

XPIXELS=`echo "$FILESIZE1" | cut -dx -f1`
YPIXELS=`echo "$FILESIZE1" | cut -dx -f2`


#######################################################################
## Get the suffix (extension) of the 2 input files.
##    (Assumes one period in the filenames, at the extension.)
##
## COMMENTED, for now.  (We use PNG files for the intermediate files
## that are used to make the final animated-GIF output file.)
#######################################################################

# FILEEXT1=`echo "$FILENAME1" | cut -d\. -f2`
# FILEEXT2=`echo "$FILENAME2" | cut -d\. -f2`

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
## - the number of frames to make to 'WIPE' one image tto the other
## - the number of wipe cycles to request (0 = keep wiping)
## - the 'delay' time - time to display each frame of the animation ---
##   in 100ths of a second. Example: 250 = 2.5 seconds.
##########################################################################

FRAMES_LOOPS_TIME=""

FRAMES_LOOPS_TIME=$(zenity --entry \
   --title "NUMBER-of-WIPE-FRAMES, NUM-LOOPS, DISPLAY-TIME" \
   --text "\
Enter the NUMBER-of-FRAMES to make, in wiping one image into the other
      and
enter the NUMBER-of-WIPE-CYCLES(loops) to make (0 = keep cycling)
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

This utility may take 30 seconds or more to run to completion." \
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


############################################################
## From the user,
## get the number of frames to make to 'hold' on the orignal
## 2images before continuing to 'wipe'.
##
##    (Gives the user a chance to see the 2 selected images,
##     in full, for a second or more.)
############################################################

FRAMES_HOLD=""

FRAMES_HOLD=$(zenity --entry \
   --title "NUMBER-of-'HOLD'-FRAMES" \
   --text "\
Enter the NUMBER-of-FRAMES to 'hold onto' each of the 2 selected
images, at each 'end' of the wipe cycle, before continuing to wipe
back and forth between the 2 images.

This gives you a chance to see the 2 selected images for as much as
a second (or more) at a time, at each 'end' of the wipe cycle.
" \
   --entry-text "5")

if test "$FRAMES_HOLD" = ""
then
   exit
fi


##################################################################
## Make full filename for the output ani-gif file --- using the
## names of the 2 selected image files.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

# OUTFILE="${FILEMIDNAME1}_${FILEMIDNAME2}_WIPEleft-right_${FRAMES}frames_${NUMLOOPS}loops_delay${DISPLAYTIME}_ani.gif"
OUTFILE="${FILEMIDNAME1}_${FILEMIDNAME2}_WIPEleft-right_${FRAMES}frames_${NUMLOOPS}loops_delay${DISPLAYTIME}_hold${FRAMES_HOLD}_ani.gif"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi

##########################################################################
## First, build-up the 'base gradient file', (3*XPIXELS) x YPIXELS, 
## from which to make the sequence of XPIXELSxYPIXELS gradient files
## by using 'convert -crop'.
##########################################################################

BASEGRADIENTFILE="/tmp/gradientLR_whiteLeftANDblackRight.png"
convert -size ${YPIXELS}x$XPIXELS gradient:  -rotate -90 "$BASEGRADIENTFILE"

WHITEFILE="/tmp/white.png"
convert -size ${XPIXELS}x$YPIXELS xc:white "$WHITEFILE"

BLACKFILE="/tmp/black.png"
convert -size ${XPIXELS}x$YPIXELS xc:black "$BLACKFILE"

APPENDEDFILE="/tmp/appendedLR_white_white2black_black.png"
convert "$WHITEFILE" "$BASEGRADIENTFILE" "$BLACKFILE" +append "$APPENDEDFILE"

## FOR TESTING:
#  exit


###############################################################
## Now make the several XPIXELSxYPIXELS gradient files.
#############################################################################
## First, set the 'deltax' to use in advancing the wipe images back and forth.
##    We base this on using $FRAMES as the number of gradient files to make,
##    between the 2 selected images. We do not make the 2 end frames,
##    corresponding to solid white and solid black
##    --- i.e. corresponding to the 2 selected image files.
#############################################################################

FRAMESplus2=`expr $FRAMES + 2`
DELTAX_PIXELS=`expr 2 \* $XPIXELS / $FRAMESplus2`
CNT=1

while test $CNT -le $FRAMES
do
   TEMPGRADIENTFILE="/tmp/gradientLR_whiteLeftANDblackRight_$CNT.png"

   XPOS=`expr $DELTAX_PIXELS \* $CNT`
   convert  "$APPENDEDFILE" -crop ${XPIXELS}x$YPIXELS+${XPOS}+0 \
     "$TEMPGRADIENTFILE"

   ## AN ATTEMPT WITH THE '-compose ModulusAdd' TECHNIQUE:
   ##
   ##   DELTAX_PCNT=`expr 100 / $FRAMES`  goes above the loop.
   ##
   # PCNT=`expr $CNT \* $DELTA_PCNT`
   # GRAYBKGND="rgb($PCNT,$PCNT,$PCNT)"
   # composite -size $XYPIXELS  "$BASEGRADIENTFILE" \
   #     -background $GRAYBKGND -compose ModulusAdd -flatten \
   #     "$TEMPGRADIENTFILE"
   ##
   ## IM version 6.5.1-0 gives error message:
   ##      "unrecognized compose operator `ModulusAdd'"
   ## It appears this operator is available sometime after version 6.6.8
   ## or thereabouts.

   ## FOR TESTING:
   # eog "$TEMPGRADIENTFILE" &
   # sleep 1

   CNT=`expr $CNT + 1`
done
## END OF LOOP: while test $CNT -le $FRAMES


##################################################################
## COMPOSITE the 2 test image files with the several ($FRAMES)
## gradient files created above.
##################################################################

CNT=1

while test $CNT -le $FRAMES
do
   COMPOSITEFILE="/tmp/${FILENAME1}_${FILENAME2}_composite_$CNT.jpg"
   composite "$FILENAME1"  "$FILENAME2" \
             "/tmp/gradientLR_whiteLeftANDblackRight_$CNT.png" \
             "$COMPOSITEFILE"

   ## FOR TESTING:
   # eog "$COMPOSITEFILE" &
   # sleep 1

   CNT=`expr $CNT + 1`
done


####################################################################
## Make the list of filenames to use in making the animated GIF file.
####################################################################

FILENAMES="$FILENAME1"

## Add the 'hold' frames for the 1st selected image.

CNT=1

while test $CNT -lt $FRAMES_HOLD
do
   FILENAMES="$FILENAMES $FILENAME1"
   CNT=`expr $CNT + 1`
done


## Add the wipe frames, from image1 to image2.

CNT=1

while test $CNT -lt $FRAMES
do
   WIPEDFILENAME="/tmp/${FILENAME1}_${FILENAME2}_composite_$CNT.jpg"
   FILENAMES="$FILENAMES $WIPEDFILENAME"
   CNT=`expr $CNT + 1`
done

FILENAMES="$FILENAMES $FILENAME2"


## Add the 'hold' frames for the 2nd selected image.

CNT=1

while test $CNT -lt $FRAMES_HOLD
do
   FILENAMES="$FILENAMES $FILENAME2"
   CNT=`expr $CNT + 1`
done


## Add the wipe frames, from image2 to image1.

CNT=$FRAMES

while test $CNT -gt 0
do
   CNT=`expr $CNT - 1`
   WIPEDFILENAME="/tmp/${FILENAME1}_${FILENAME2}_composite_$CNT.jpg"
   FILENAMES="$FILENAMES $WIPEDFILENAME"
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



