#!/bin/sh
##
## Nautilus
## SCRIPT: ani16_1imgfile_MAKEaniGif_WAVE_likeFlag_convert-delay-loop.sh
##
## PURPOSE: From a user selected image file (.jpg' or '.png' or '.gif'
##          or whatever), this script makes a sequence of 'waving'
##          images --- and makes an animated '.gif' file from that
##          sequence of images.
##
## METHOD:  Uses a 'zenity' prompt to ask the user for
##            a. number of frames to make, per animation cycle
##            b. number of cycles in the animation (0 = endless)
##            c. an inter-image 'delay' (in hundredths of seconds).
##
##          To make the sequence of 'wavy' files,
##          this script uses the ImageMagick 'convert' program with the
##          '-wave {amplitude-pixels}x{wavelength-pixels}' option.
##          The '-splice' and '-chop' options are used to advance the wave.
##
##          To make the animated GIF file, this script uses the
##          ImageMagick 'convert' program with '-delay' and '-loop' options.
## 
##          Shows the animated '.gif' file in an image viewer of the
##          user's choice (which could be a web browser).
##
## REFERENCE: http://www.imagemagick.org/Usage/warping/#wave
##
## Created: 2012feb24
## Changed: 2012

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
## zenity-PROMPT-1:
## From the user, get
## - the number of frames to make to 'roll' completely across the image
## - the number of complete roll-loops to make (0 = keep rolling)
## - the 'delay' time - time to display each frame of the animation ---
##   in 100ths of a second. Example: 250 = 2.5 seconds.
##########################################################

FRAMES_LOOPS_TIME=""

FRAMES_LOOPS_TIME=$(zenity --entry \
   --title "NUMBER-of-WAVE-FRAMES, NUM-LOOPS, DISPLAY-TIME" \
   --text "\
Enter the NUMBER-of-FRAMES to make, in a complete 'wave' across the image
      and
enter the NUMBER-of-animation-CYCLES (loops) to make (0 = keep waving)
      and
enter the FRAME-DISPLAY-TIME (the 'delay'), in 100ths of seconds.
Examples:
  250 gives 2.5 seconds for the display time of each frame.
  100 gives 1.0 seconds for the display time of each frame.
   10 gives 0.1 second for the display time of each frame.
    5 gives 20 frames/sec for a fairly smooth animation, if the
      adjacent frames don't differ too much.

The resulting animated GIF file will be shown using
$ANIGIFVIEWER .
   (If the viewer is a web browser, it may take more than
     10 seconds to start up.)" \
   --entry-text "20 0 5")

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


#######################################################
## zenity-PROMPT-2:
## Prompt for the BACKGROUND COLOR parameter.
#######################################################

BKGND_COLOR=""

BKGND_COLOR=$(zenity --entry \
   --title "Enter BACKGROUND COLOR." \
   --text "\
Enter a BACKGROUND COLOR --- to fill in the background at the
top and bottom of the waving image.

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
## name of a selected image file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

OUTFILE="${FILENAMECROP}_WAVY_${FRAMES}frames_${NUMLOOPS}loops_delay${DISPLAYTIME}_ani.gif"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi



######################################################################
## Use 'convert' with '-wave {amplitude-pixels}x{wavelength-pixels}'
## along with '-splice {Xpixels}x0+0+0' and '-chop {Xpixels}x0+0+0' to
## make the number ($FRAMES) of 'wavy' files from file $FILENAME.
######################################################################
## We make the amplitude about 10% of the y-pixels-height of the image.
## We make the wavelength about 150% of the x-pixels-width of the image.
## We make the DELTAX for determining 'Xpixels' for '-splice' and '-chop'
## about {wavelength-pixels}/$FRAMES.
########################################################################
## NOTE: For multiplication with the '*' operator with 'bc',
## scale=0 does not yield integers. It seems to perform as if scale=1.
## Example:
##   $ echo "scale = 0 ; 2 * 5.1"  | bc
##   10.2
## Hence I use 'cut' to assure that I get an integer from the
## multiplication operation when using 'bc'.
####################################################################

XYPIXELS=`identify "$FILENAME" | head -1 | awk '{print $3}'` 
XPIXELS=`echo $XYPIXELS | cut -dx -f1`
YPIXELS=`echo $XYPIXELS | cut -dx -f2`

AMPLITUDE=`echo "scale = 3; $YPIXELS / 10" | bc | cut -d'.' -f1`
WAVELENGTH=`echo "scale = 3; $XPIXELS * 1.5" | bc | cut -d'.' -f1`

DELTAX=`echo "scale = 3; $WAVELENGTH / $FRAMES" | bc | cut -d'.' -f1`

CNT=1

while test $CNT -lt $FRAMES
do
   WAVYFILENAME="/tmp/${FILENAMECROP}_WAVY${CNT}.$FILEEXT"
   if test -f "$WAVYFILENAME"
   then
      rm -f "$WAVYFILENAME"
   fi

   MOVEPIXELSX=`echo "scale = 3; $CNT * $DELTAX" | bc`

   convert "$FILENAME"  -splice ${MOVEPIXELSX}x0+0+0 -background $BKGND_COLOR \
           -wave ${AMPLITUDE}x$WAVELENGTH  -chop ${MOVEPIXELSX}x0+0+0 \
          "$WAVYFILENAME"

   CNT=`expr $CNT + 1`
done



#####################################################################
## Make the list of filenames to use in making the animated GIF file.
#####################################################################

# FILENAMES="$FILENAME"
FILENAMES=""

CNT=1

while test $CNT -lt $FRAMES
do
   WAVYFILENAME="/tmp/${FILENAMECROP}_WAVY${CNT}.$FILEEXT"
   FILENAMES="$FILENAMES $WAVYFILENAME"
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



