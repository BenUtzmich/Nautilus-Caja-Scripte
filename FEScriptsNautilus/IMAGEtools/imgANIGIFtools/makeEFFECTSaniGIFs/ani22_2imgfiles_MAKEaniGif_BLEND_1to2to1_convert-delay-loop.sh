#!/bin/sh
##
## Nautilus
## SCRIPT: ani22_2imgfiles_MAKEaniGif_BLEND_1to2to1_inpDELAY.sh
##
## PURPOSE: For a pair of user selected image files (.jpg' or '.png' or '.gif'
##          or whatever), this script makes it appear as if one image is
##          BLENDed into the other and back to the first image again.
##
##          Uses 'zenity' to prompt the user for 3 items:
##             (1) number of 'frames' to make for each blend from one
##             image to the other --- and (2) how many blend cycles
##             to request (0 means keep blending back-and-forth) --- and (3)
##             an inter-image delay (in hundredths of seconds), i.e. amount
##             of time to show each frame.
## 
##          To make the sequence of 'blend' files,
##          this script uses the ImageMagick 'composite' program with the
##          '-blend {percent}' option, where 'percent' is between 0 and 100.
##
##          To make the animated GIF file, this script uses the
##          ImageMagick 'convert' program with '-delay' and '-loop' options.
## 
##          Shows the animated '.gif' file in an image viewer of the
##          user's choice (which could be a web browser).
##
## Reference: http://www.imagemagick.org/Usage/compose/#blend
##
## Created: 2012feb11
## Changed: 2012feb12 Add prompt for #frames to 'hold onto' the 2 selected images.

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
This 2-image-BLEND utility requires TWO filenames to be selected.

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
This 2-image-BLEND utility requires exactly TWO filenames to be selected.

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
This 2-image-BLEND utility requires that both files have the same
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
## - the number of frames to make to 'BLEND' one image tto the other
## - the number of blend cycles to request (0 = keep blending)
## - the 'delay' time - time to display each frame of the animation ---
##   in 100ths of a second. Example: 250 = 2.5 seconds.
##########################################################################

FRAMES_LOOPS_TIME=""

FRAMES_LOOPS_TIME=$(zenity --entry \
   --title "NUMBER-of-BLEND-FRAMES, NUM-LOOPS, DISPLAY-TIME" \
   --text "\
Enter the NUMBER-of-FRAMES to make, in blending one image into the other
      and
enter the NUMBER-of-BLEND-CYCLES(loops) to make (0 = keep cycling)
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
## 2images before continuing to 'blend'.
##
##    (Gives the user a chance to see the 2 selected images,
##     in full, for a second or more.)
############################################################

FRAMES_HOLD=""

FRAMES_HOLD=$(zenity --entry \
   --title "NUMBER-of-'HOLD'-FRAMES" \
   --text "\
Enter the NUMBER-of-FRAMES to 'hold onto' each of the 2 selected
images, after each complete blend cycle, before continuing to blend
back and forth between the 2 images.

This gives you a chance to see the 2 full images for as much as
a second or more at a time, after each full blend cycle.
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

# OUTFILE="${FILEMIDNAME1}_${FILEMIDNAME2}_BLENDED_${FRAMES}frames_${NUMLOOPS}loops_delay${DISPLAYTIME}_ani.gif"
OUTFILE="${FILEMIDNAME1}_${FILEMIDNAME2}_BLENDED_${FRAMES}frames_${NUMLOOPS}loops_delay${DISPLAYTIME}_hold${FRAMES_HOLD}_ani.gif"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


######################################################################
## Use 'composite' with '-blend {percent}' to make
## the requested number ($FRAMES) of blend files from
## file1 to file2.
######################################################################
## NOTE: Blend-percent 0 corresponds to file1.
##       Blend-percent 100 corresponds to file2.
######################################################################

CNT=1

DELTAPERCENT=`echo "scale = 0 ; 100 / $FRAMES" | bc`
      
while test $CNT -lt $FRAMES
do
   BLENDEDFILENAME="/tmp/${FILEMIDNAME1}_${FILEMIDNAME2}_BLENDED${CNT}.png"
   if test -f "$BLENDEDFILENAME"
   then
      rm -f "$BLENDEDFILENAME"
   fi

   ###############################################################
   ## Use 'composite' to make the sequence of blend files.
   ###############################################################

   BLENDPERCENT=`expr 100 - $CNT \* $DELTAPERCENT`

   composite -blend $BLENDPERCENT  -gravity Center \
             "$FILENAME1"  "$FILENAME2" \
             -alpha Set "$BLENDEDFILENAME"

   CNT=`expr $CNT + 1`
done
## END OF while test $CNT -lt $FRAMES


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


## Add the blend frames, from image1 to image2.

CNT=1

while test $CNT -lt $FRAMES
do
   BLENDEDFILENAME="/tmp/${FILEMIDNAME1}_${FILEMIDNAME2}_BLENDED${CNT}.png"
   FILENAMES="$FILENAMES $BLENDEDFILENAME"
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


## Add the blend frames, from image2 to image1.

CNT=$FRAMES

while test $CNT -gt 0
do
   CNT=`expr $CNT - 1`
   BLENDEDFILENAME="/tmp/${FILEMIDNAME1}_${FILEMIDNAME2}_BLENDED${CNT}.png"
   FILENAMES="$FILENAMES $BLENDEDFILENAME"
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



