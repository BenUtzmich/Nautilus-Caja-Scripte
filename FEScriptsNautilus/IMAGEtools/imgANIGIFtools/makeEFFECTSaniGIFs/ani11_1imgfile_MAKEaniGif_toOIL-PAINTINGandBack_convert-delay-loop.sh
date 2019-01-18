#!/bin/sh
##
## Nautilus
## SCRIPT: ani11_1imgfile_MAKEaniGif_toOIL-PAINTINGandBack_convert-delay-loop.sh
##
## PURPOSE: From a user selected image file (.jpg' or '.png' or '.gif'
##          or whatever), this script makes a sequence of 'oil painting'
##          images (more and more 'blotchy') and makes an animated '.gif'
##          file from that sequence of images.
##
## METHOD:  Uses 'zenity' to prompt the user for number of images to make
##          for the animated GIF and for an inter-image delay
##          (in hundredths of seconds).
##
##          Uses 'zenity' to prompt the user whether to
##             1 - start from the extreme (blotchiest) oil painting and go
##                 to the original image file --- and back (in a loop)
##             2 - start from the original image file and go to the extreme
##                 (blotchiest) oil painting --- and back (in a loop).
##
##          Uses 'zenity' to prompt for #frames of the original selected
##          image to 'hold onto' (repeat) in each animation cycle.
##
##          To make the sequence of blotchier and blotchier oil painting files,
##          this script uses the ImageMagick 'convert' program with the
##          '-paint' option.
##
##          To make the animated GIF file, this script uses the
##          ImageMagick 'convert' program with '-delay' and '-loop' options.
## 
##          Shows the animated '.gif' file in an animated gif file viewer of the
##          user's choice. (It can be a web browser.)
##
## HOW TO USE: In Nautilus, select ONE image file --- such as a '.jpg',
##             '.png', or '.gif' file.
##             Then right-click and choose this script to run (name above).
##
#############################################################################
## Created: 2012feb08
## Changed: 2012feb09 Add $FRAMES to the output '_ani.gif' filename.
## Changed: 2012feb12 Add prompt for #frames to 'hold onto' the original image.
## Changed: 2012may12 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

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
   --title "NUMBER of OIL-FRAMES and Image DISPLAY TIME" \
   --text "\
Enter the NUMBER-of-OIL-FRAMES to make (max 10) ---
in advancing degrees of 'blotchiness'
   and
enter the image DISPLAY-TIME, in 100ths of seconds.
Examples:
 250 gives 2.5 seconds for the display time of each image
 100 gives 1.0 seconds for the display time of each image
  10 gives 0.1 seconds for the display time of each image

The resulting animated GIF file will be shown using
$ANIGIFVIEWER .
   (If the viewer is a web browser, it may take more than
    10 seconds to start up.)

It may take 15 seconds or more for the processing to complete." \
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


#######################################################
## Prompt for 'direction' of the animated GIF ---
## image-to-oil-and-back OR oil-to-image-and-back.
#######################################################

ANITYPE=""

ANITYPE=$(zenity --list --radiolist \
   --title "ANI-GIF type: oil-to-image OR image-to-oil?" \
   --text "\
Choose one of the following types of animated GIF files to make.

In other words, start with the selected image OR start with the
'blotchiest' oil painting image first.

NOTE: After the first cycle is complete, both these animation
types look the same." \
   --column "" --column "Type" \
   FALSE oil-to-image-and-back TRUE image-to-oil-and-back)

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
image, after each 'show-oils' cycle, before continuing into
another 'show-oils' cycle.

This gives you a chance to see the full image for as much as
a second (or more) at a time, after each full cycle." \
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
## Use 'convert' to make the $FRAMES oil-painting files.
##################################################################

CNT=1

while test $CNT -le $FRAMES
do
   OILFILENAME="/tmp/${FILENAMECROP}_OIL${CNT}.$FILEEXT"
   if test -f "$OILFILENAME"
   then
     rm -f "$OILFILENAME"
   fi
   convert "$FILENAME"  -paint $CNT  "$OILFILENAME"
   # convert "$FILENAME" -blur 0x3 -paint $CNT  "$OILFILENAME"
   CNT=`expr $CNT + 1`
done
## END OF LOOP while test $CNT -le $FRAMES


##################################################################
## According to $ANITYPE, make the list of filenames to use in
## making the animated GIF file.
##################################################################

FILENAMES=""

if test "$ANITYPE" = "oil-to-image-and-back"
then

   ## From the 'oiliest' frame, go to the original image.

   CNT=$FRAMES
   while test $CNT -gt 0
   do
      OILFILENAME="/tmp/${FILENAMECROP}_OIL${CNT}.$FILEEXT"
      FILENAMES="$FILENAMES $OILFILENAME"
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


   ## From the original image, go to the 'oiliest' frame.

   CNT=1
   while test $CNT -lt $FRAMES
   do
      OILFILENAME="/tmp/${FILENAMECROP}_OIL${CNT}.$FILEEXT"
      FILENAMES="$FILENAMES $OILFILENAME"
      CNT=`expr $CNT + 1`
   done

fi
## END OF if test "$ANITYPE" = "oil-to-image-and-back"


if test "$ANITYPE" = "image-to-oil-and-back"
then

   FILENAMES="$FILENAMES $FILENAME"


   ## From the original image, go to the 'oiliest' frame.

   CNT=1

   while test $CNT -lt $FRAMES
   do
      OILFILENAME="/tmp/${FILENAMECROP}_OIL${CNT}.$FILEEXT"
      FILENAMES="$FILENAMES $OILFILENAME"
      CNT=`expr $CNT + 1`
   done


   ## From the 'oiliest' frame, go to the original image.

   CNT=$FRAMES

   while test $CNT -gt 0
   do
      OILFILENAME="/tmp/${FILENAMECROP}_OIL${CNT}.$FILEEXT"
      FILENAMES="$FILENAMES $OILFILENAME"
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
## END OF if test "$ANITYPE" = "image-to-oil-and-back"




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
