#!/bin/sh
##
## Nautilus
## SCRIPT: ani12_1imgfile_MAKEaniGif_to-fromPIXELATED_inpDELAY.sh
##
## PURPOSE: From a user selected image file (.jpg' or '.png' or '.gif'
##          or whatever), this script makes a sequence of 'pixelated'
##          images (more and more 'blotchy') and makes an animated '.gif'
##          file from that sequence of images.
##
##          Uses 'zenity' 3 times:
##
##          1. Uses 'zenity' to prompt the user for number of images to make
##             for the animated GIF and for an inter-image 'delay'
##             (in hundredths of seconds).
##
##          2. Uses 'zenity' to prompt the user whether to
##             1 - start from the extreme (blotchiest) pixelation and go
##                 to the original image file --- and back (in a loop)
##             2 - start from the original image file and go to the extreme
##                 (blotchiest) pixelation --- and back (in a loop).
##
##          3. Uses 'zenity' to prompt for #frames to 'hold onto' the original
##             selected image in each animation cycle.
##
##          To make the sequence of blotchier and blotchier pixelated files,
##          this script uses the ImageMagick 'convert' program with two
##          '-scale' options --- to scale down and then up.
##
##          To make the animated GIF file, this script uses the
##          ImageMagick 'convert' program with '-delay' and '-loop' options.
## 
##          Shows the animated '.gif' file in an image viewer of the
##          user's choice (which could be a web browser).
##
## NOTE: The pixelated animations from this utility are a little 'jumpy'.
##       You can get a smoother transition from the image file to a
##       'blotchier' pixelated image by making the blotchy extreme image
##       with the 'PIXELATE' feNautilusScript that makes a single pixelated
##       image from a given image, and then use the 'MORPH' feNautilusScript
##       that makes a series of images between the two images. Then use
##       the 'MAKEaniGIF'-fromMultiImgFiles feNautilusScript to make an
##       animated GIF from the sequence of 'morph' image files.
##
##       This may all be automated into a second 'PIXELATEDandBack'
##       'MAKEaniGIF' script, as an alternative to this script ---
##       or as a replacement.
##
## Created: 2012feb08
## Changed: 2012feb12 Add prompt for #frames to 'hold onto' the original image.


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
   --title "NUMBR of PIXELATED frames & frame DISPLAY TIME" \
   --text "\
Enter the NUMBER-of-PIXELATED-FRAMES to make (max 10) ---
from least-blotchy to most-blotchy
    and
the DISPLAY-TIME for each frame, in 100ths of seconds.
Examples:
 250 gives 2.5 seconds for the display time of each frame
 100 gives 1.0 seconds for the display time of each frame
   10 gives 0.1 seconds for the display time of each frame

The resulting animated GIF file will be shown using
$ANIGIFVIEWER .
     (If the viewer is a web browser, it may take more than
      10 seconds to start up.)

NOTE: It may take 15 seconds or more for this utility to complete." \
   --entry-text "5 150")

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
## image-to-PIXELATED-and-back OR PIXELATED-to-image-and-back.
##############################################################

ANITYPE=""

ANITYPE=$(zenity --list --radiolist \
   --title "ANI-GIF type: pixelated-to-image OR image-to-pixelated?" \
   --text "\
Choose one of the following types of PIXELATED animated-GIF files to make.

START FROM the MOST-BLOTCHY pixelated image and go to the selected image and back
      OR
START FROM the SELECTED IMAGE and go to the most-blotchy pixelated image and back.

NOTE: After the 1st cycle, these two animations look the same." \
   --column "" --column "Type" \
   FALSE PIXELATED-to-image-and-back TRUE image-to-PIXELATED-and-back)

if test "$ANITYPE" = ""
then
   exit
fi


##########################################################
## From the user,
## get the number of frames to make to 'hold' on the orignal
## image before continuing to 'make oily'.
##     (This gives the user a chance to see the original
##      non-oily image for as much as a second or more.)
##########################################################

FRAMES_HOLD=""

FRAMES_HOLD=$(zenity --entry \
   --title "NUMBER-of-'HOLD'-FRAMES" \
   --text "\
Enter the NUMBER-of-FRAMES to 'hold onto' the original selected
image, after each 'pixelation' cycle, before continuing into
another pixelation cycle.

This gives you a chance to see the original un-pixelated image for
as much as a second (or more), after each full pixelation cycle." \
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


##################################################################
## Use 'convert' to make the $FRAMES pixelated files.
##################################################################


CNT=1

# for FACTOR in 2 4 5 10 20 25 50
while test $CNT -le $FRAMES
do
   PIXELATEDFILENAME="/tmp/${FILENAMECROP}_PIXELATED${CNT}.$FILEEXT"
   if test -f "$PIXELATEDFILENAME"
   then
     rm -f "$PIXELATEDFILENAME"
   fi

   FACTOR=`expr $CNT + 1`

   ## ALTERNATIVE:
   # FACTOR=`expr $CNT \* 2`

   ## ALTERNATIVE:
   # FACTOR=`echo "scale = 0; 2 ^ $CNT" | bc`

   SCALE1=`echo "scale = 5; 100 / $FACTOR" | bc`

   ## To get an integer from bc-muliply, cut off the decimal places
   ## even if scale=0:
   # SCALE2=`echo "scale = 5; 100 * $FACTOR" | bc | cut -dx -f1`

   SCALE2=`echo "scale = 5; 100 * $FACTOR" | bc`

   convert "$FILENAME"  -scale ${SCALE1}%  -scale ${SCALE2}% "$PIXELATEDFILENAME"

   CNT=`expr $CNT + 1`

done
## END OF LOOP while test $CNT -le $FRAMES


##################################################################
## According to $ANITYPE, make the list of filenames to use in
## making the animated GIF file.
##################################################################

FILENAMES=""

if test "$ANITYPE" = "PIXELATED-to-image-and-back"
then

   ## Add pixelated images, from most pixelated toward non-pixelated.

   CNT=$FRAMES

   while test $CNT -gt 0
   do
      PIXELATEDFILENAME="/tmp/${FILENAMECROP}_PIXELATED${CNT}.$FILEEXT"
      FILENAMES="$FILENAMES $PIXELATEDFILENAME"
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


   ## Add pixelated images, from non-pixelated toward most pixelated.

   CNT=1

   while test $CNT -lt $FRAMES
   do
      PIXELATEDFILENAME="/tmp/${FILENAMECROP}_PIXELATED${CNT}.$FILEEXT"
      FILENAMES="$FILENAMES $PIXELATEDFILENAME"
      CNT=`expr $CNT + 1`
   done

fi
## END OF if test "$ANITYPE" = "PIXELATED-to-image-and-back"


if test "$ANITYPE" = "image-to-PIXELATED-and-back"
then

   FILENAMES="$FILENAMES $FILENAME"


   ## Add pixelated images, from non-pixelated toward most pixelated.

   CNT=1

   while test $CNT -lt $FRAMES
   do
      PIXELATEDFILENAME="/tmp/${FILENAMECROP}_PIXELATED${CNT}.$FILEEXT"
      FILENAMES="$FILENAMES $PIXELATEDFILENAME"
      CNT=`expr $CNT + 1`
   done


   ## Add pixelated images, from most-pixelated toward non-pixelated.

   CNT=$FRAMES

   while test $CNT -gt 0
   do
      PIXELATEDFILENAME="/tmp/${FILENAMECROP}_PIXELATED${CNT}.$FILEEXT"
      FILENAMES="$FILENAMES $PIXELATEDFILENAME"
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
## END OF if test "$ANITYPE" = "image-to-PIXELATED-and-back"


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



