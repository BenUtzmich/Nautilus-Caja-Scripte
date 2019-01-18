#!/bin/sh
##
## Nautilus
## SCRIPT: ani13_1imgfile_MAKEaniGif_to-fromSWIRLED_inpDELAY.sh
##
## PURPOSE: From a user selected image file (.jpg' or '.png' or '.gif'
##          or whatever), this script makes a sequence of 'swirled'
##          images (more and more 'swirly') and makes an animated '.gif'
##          file from that sequence of images.
##
##          Uses 'zenity' 4 times:
##
##          1. Uses 'zenity' to prompt the user for
##             a) the number of image frames to make for each 'swirl'
##             b) the number of cycles of swirls - 0 = keep swirling
##             c) an inter-image 'delay' (in hundredths of seconds).
##
##          2. Uses 'zenity' to prompt the user whether to
##             1 - start from an extreme swirl image and go
##                 to the original image file --- and back (in a loop)
##             2 - start from the original image file and go to the extreme
##                 swirl image --- and back (in a loop).
##
##          3. Uses 'zenity' to prompt for #frames to 'hold onto' the original
##             selected image in each animation cycle.
##
##          4. Maximum angle for the swirl (typically between 45 and 135).
##
##          To make the swirled image 'frames', from 0 to the specified
##          max-angle, this script uses the ImageMagick 'convert' program
##          with the '-swirl' option.
##
##          To make the animated GIF file from the 'frames', this script uses
##          the ImageMagick 'convert' program with '-delay' and '-loop' options.
## 
##          This script shows the animated '.gif' file in an image viewer of the
##          user's choice (which could be a web browser).
##
## Created: 2012feb08
## Changed: 2012feb09 Make swirl go both counter-clockwise and clockwise.
## Changed: 2012feb12 Add prompt for #frames to 'hold onto' the original image.
## Changed: 2012feb28 Add a prompt for the max-angle of the swirl.

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
## Set the number of frames to make and the
## delay time between frames of the animation ---
## in 100ths of a second. Example: 250 = 2.5 seconds.
##########################################################

FRAMES_TIME=""

FRAMES_TIME=$(zenity --entry \
   --title "NUMBR of SWIRLED-FRAMES & frame-DISPLAY TIME" \
   --text "\
Enter the NUMBER-of-SWIRLED-FRAMES to make in each direction
--- counter-clockwise and clockwise (max 10)
    and
enter DISPLAY-TIME for each frame, in 100ths of seconds.
Examples:
 250 gives 2.5 seconds for the display time of each frame
 100 gives 1.0 seconds for the display time of each frame
    10 gives 0.1 seconds for the display time of each frame

The resulting animated GIF file will be shown using
$ANIGIFVIEWER .
   (If the viewer is a web browser, it may take more than
     10 seconds to start up.)

NOTE: It may take 20 seconds or more for this utility to complete." \
   --entry-text "5 20")

if test "$FRAMES_TIME" = ""
then
   exit
fi

FRAMES=`echo "$FRAMES_TIME" | cut -d' ' -f1`
DISPLAYTIME=`echo "$FRAMES_TIME" | cut -d' ' -f2`

# FRAMES=`echo "$FRAMES_TIME" | awk '{print $1}'`
# DISPLAYTIME=`echo "$FRAMES_TIME" | awk '{print $2}'`

if test $FRAMES -gt 10
then
   FRAMES=10
fi


##############################################################
## Prompt for 'direction' of the animated GIF ---
## image-to-SWIRLED-and-back OR SWIRLED-to-image-and-back.
##############################################################

ANITYPE=""

ANITYPE=$(zenity --list --radiolist \
   --title "ANI-GIF type: swirled-to-image OR image-to-swirled?" \
   --text "\
Choose one of the following types of swirled animated GIF files to make.

Choose to START with the image SWIRLED
     -OR-
START with the image UN-SWIRLED.

NOTE: After the first cycle, these two animations look the same." \
   --column "" --column "Type" \
   FALSE SWIRLED-to-image-and-back TRUE image-to-SWIRLED-and-back)

if test "$ANITYPE" = ""
then
   exit
fi


##########################################################
## From the user,
## get the number of frames to make to 'hold' on the orignal
## image before continuing into another swirl cycle.
##     (This gives the user a chance to see the original
##      non-swirled image for as much as a second or more.)
##########################################################

FRAMES_HOLD=""

FRAMES_HOLD=$(zenity --entry \
   --title "NUMBER-of-'HOLD'-FRAMES" \
   --text "\
Enter the NUMBER-of-FRAMES to 'hold onto' the original selected
image, after each 'swirl' cycle, before continuing into
another swirl cycle.

This gives you a chance to see the original non-swirled image for
as much as a second (or more), after each swirl cycle." \
   --entry-text "5")

if test "$FRAMES_HOLD" = ""
then
   exit
fi


##########################################################
## From the user,
## get the max-angle for the swirl.
##########################################################

MAX_ANGLE=""

MAX_ANGLE=$(zenity --entry \
   --title "MAX-ANGLE for the SWIRL." \
   --text "\
Enter the MAX-ANGLE for the swirl.

Typically between 45 and 270 degrees." \
   --entry-text "270")

if test "$MAX_ANGLE" = ""
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

# OUTFILE="${FILENAMECROP}_${ANITYPE}_${FRAMES}frames_delay${DISPLAYTIME}_ani.gif"
OUTFILE="${FILENAMECROP}_${ANITYPE}_${FRAMES}frames_delay${DISPLAYTIME}_hold${FRAMES_HOLD}_ani.gif"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi

######################################################################
## Use 'convert' with '-swirl' to make the $FRAMES swirled files
## in the counter-clockwise direction --- then the clockwise direction.
######################################################################

# DELTA_ANGLE=`expr $MAX_ANGLE / $FRAMES`
DELTA_ANGLE=`echo "scale = 10; $MAX_ANGLE / $FRAMES" | bc -l`

## Make the counter-clockwise frames.
CNT=1

while test $CNT -le $FRAMES
do
   SWIRLEDFILENAME="/tmp/${FILENAMECROP}_SWIRLED${CNT}.$FILEEXT"
   if test -f "$SWIRLEDFILENAME"
   then
     rm -f "$SWIRLEDFILENAME"
   fi

   # ANGLE=`expr $CNT \* $DELTA_ANGLE`
   ANGLE=`echo "scale = 10; $CNT * $DELTA_ANGLE" | bc -l`

   convert "$FILENAME"  -swirl $ANGLE "$SWIRLEDFILENAME"
   CNT=`expr $CNT + 1`
done
## END OF LOOP while test $CNT -le $FRAMES

## Make the clockwise frames.
CNT=1

while test $CNT -le $FRAMES
do
   SWIRLEDFILENAME="/tmp/${FILENAMECROP}_SWIRLED-${CNT}.$FILEEXT"
   if test -f "$SWIRLEDFILENAME"
   then
     rm -f "$SWIRLEDFILENAME"
   fi

   # ANGLE=`expr $CNT \* $DELTA_ANGLE`
   ANGLE=`echo "scale = 10; $CNT * $DELTA_ANGLE" | bc -l`

   convert "$FILENAME"  -swirl -$ANGLE "$SWIRLEDFILENAME"
   CNT=`expr $CNT + 1`
done
## END OF LOOP while test $CNT -le $FRAMES




##################################################################
## According to $ANITYPE, make the list of filenames to use in
## making the animated GIF file.
##################################################################

FILENAMES=""

if test "$ANITYPE" = "SWIRLED-to-image-and-back"
then

   ## Add counter-clockwise swirled frames, going to unswirled.

   CNT=$FRAMES

   while test $CNT -gt 0
   do
      SWIRLEDFILENAME="/tmp/${FILENAMECROP}_SWIRLED${CNT}.$FILEEXT"
      FILENAMES="$FILENAMES $SWIRLEDFILENAME"
      CNT=`expr $CNT - 1`
   done


   FILENAMES="$FILENAMES $FILENAME"

   ## Add the 'hold' frames of the original (selected) image.

   CNT=1

   while test $CNT -lt $FRAMES_HOLD
   do
      FILENAMES="$FILENAMES $FILENAME"
      CNT=`expr $CNT + 1`
   done


   ## Add clockwise swirled frames, going from unswirled.

   CNT=1

   while test $CNT -lt $FRAMES
   do
      SWIRLEDFILENAME="/tmp/${FILENAMECROP}_SWIRLED-${CNT}.$FILEEXT"
      FILENAMES="$FILENAMES $SWIRLEDFILENAME"
      CNT=`expr $CNT + 1`
   done

   ## Add clockwise swirled frames, going back to unswirled.

   CNT=$FRAMES

   while test $CNT -gt 0
   do
      SWIRLEDFILENAME="/tmp/${FILENAMECROP}_SWIRLED-${CNT}.$FILEEXT"
      FILENAMES="$FILENAMES $SWIRLEDFILENAME"
      CNT=`expr $CNT - 1`
   done


   FILENAMES="$FILENAMES $FILENAME"

   ## Add the 'hold' frames of the original (selected) image.

   CNT=1

   while test $CNT -lt $FRAMES_HOLD
   do
      FILENAMES="$FILENAMES $FILENAME"
      CNT=`expr $CNT + 1`
   done


   ## Add counter-clockwise swirled frames, going from unswirled.

   CNT=1

   while test $CNT -lt $FRAMES
   do
      SWIRLEDFILENAME="/tmp/${FILENAMECROP}_SWIRLED${CNT}.$FILEEXT"
      FILENAMES="$FILENAMES $SWIRLEDFILENAME"
      CNT=`expr $CNT + 1`
   done
fi
## END OF if test "$ANITYPE" = "SWIRLED-to-image-and-back"


if test "$ANITYPE" = "image-to-SWIRLED-and-back"
then

   FILENAMES="$FILENAMES $FILENAME"

   ## Add counter-clockwise swirled frames, going from unswirled.

   CNT=1

   while test $CNT -lt $FRAMES
   do
      SWIRLEDFILENAME="/tmp/${FILENAMECROP}_SWIRLED${CNT}.$FILEEXT"
      FILENAMES="$FILENAMES $SWIRLEDFILENAME"
      CNT=`expr $CNT + 1`
   done


   ## Add counter-clockwise swirled frames, going back to unswirled.

   CNT=$FRAMES

   while test $CNT -gt 0
   do
      SWIRLEDFILENAME="/tmp/${FILENAMECROP}_SWIRLED${CNT}.$FILEEXT"
      FILENAMES="$FILENAMES $SWIRLEDFILENAME"
      CNT=`expr $CNT - 1`
   done


   FILENAMES="$FILENAMES $FILENAME"

   ## Add the 'hold' frames of the original (selected) image.

   CNT=1

   while test $CNT -lt $FRAMES_HOLD
   do
      FILENAMES="$FILENAMES $FILENAME"
      CNT=`expr $CNT + 1`
   done


   ## Add clockwise swirled frames, going from unswirled.

   CNT=1

   while test $CNT -lt $FRAMES
   do
      SWIRLEDFILENAME="/tmp/${FILENAMECROP}_SWIRLED-${CNT}.$FILEEXT"
      FILENAMES="$FILENAMES $SWIRLEDFILENAME"
      CNT=`expr $CNT + 1`
   done

   ## Add clockwise swirled frames, going back to unswirled.

   CNT=$FRAMES

   while test $CNT -gt 0
   do
      SWIRLEDFILENAME="/tmp/${FILENAMECROP}_SWIRLED-${CNT}.$FILEEXT"
      FILENAMES="$FILENAMES $SWIRLEDFILENAME"
      CNT=`expr $CNT - 1`
   done

   ## Add the 'hold' frames of the original (selected) image.

   CNT=1

   while test $CNT -lt $FRAMES_HOLD
   do
      FILENAMES="$FILENAMES $FILENAME"
      CNT=`expr $CNT + 1`
   done

fi
## END OF if test "$ANITYPE" = "image-to-SWIRLED-and-back"


##################################################################
## Use 'convert' to make the animated gif file.
##    -delay 250 pauses 250 hundredths of a second (2.5 sec)
##                                     before showing next image
##    -loop 0 animates 'endlessly'
##################################################################

convert -delay $DISPLAYTIME -loop 0 $FILENAMES "$OUTFILE"


##################################
## Show the new animated gif file.
##################################

$ANIGIFVIEWER "$OUTFILE" &



