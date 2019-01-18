#!/bin/sh
##
## Nautilus
## SCRIPT: ani07_1ani-gif_CHG-DELAY_convert-adjoin-coalesce-convert-delay-loop.sh
##
## PURPOSE: Splits an animated '.gif' file into a sequence of
##          '.gif' files in the /tmp directory --- then puts those
##          '.gif' files into an animated '.gif' file with a user-specified
##          delay value between frames.
##
## METHOD:  Uses the ImageMagick 'convert +adjoin -coalesce' command to split
##          the animated-GIF file into separate '.gif' files.
##
##          Uses 'zenity' to prompt the user for an inter-image delay
##          (in hundredths of seconds).
##
##          Uses the ImageMagick 'convert' program with '-delay' and
##          '-loop 0' options to make the new animated GIF file.
## 
##          Shows the new animated '.gif' file in an animated gif viewer
##          of the user's choice (which could be a web browser).
##
##          Shows the resulting '.gif' image files in an image viewer
##          of the user's choice.
##
## Reference: http://www.imagemagick.org/Usage/anim_basics/#adjoin
##
## HOW TO USE: In Nautilus, select an animated '.gif' file.
##             Then right-click and choose this script to run (name above).
##
############################################################################
## Created: 2014may22
## Changed: 2014
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x

#########################################
## Get the filename of the selected file.
#########################################

# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
# FILENAMES="$@"
  FILENAME="$1"


#####################################################
## Check that the selected file is a 'gif' file.
## (Assumes one dot in filename, at the extension.)
##          (Assumes no spaces in filename.)
#####################################################

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
if test "$FILEEXT" != "gif"
then
   exit
fi

##################################################################
## Get the mid-name of the input 'gif' file.
##################################################################

FILENAMECROP=`echo "$FILENAME" | sed 's|\.gif$||'`


##################################################################
## Use 'convert' to 'split' the several 'gif' files out of
## the animated-GIF file.
## Reference: http://www.imagemagick.org/Usage/anim_basics/#adjoin
##################################################################

rm /tmp/CHG-DELAY_*.gif

convert +adjoin -coalesce "$FILENAME" "/tmp/CHG-DELAY_%03d.gif"


#######################################################################
## Set the viewer to be used to show the output animated GIF file.
######################################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi


##########################################################
## Set the delay time between frames of the animation ---
## in 100ths of a second. Example: 250 = 2.5 seconds.
##########################################################

DELAY100s=""

DELAY100s=$(zenity --entry --title "Inter-image Delay Time" \
   --text "\
Enter the inter-image DELAY-TIME, in 100ths of seconds.
Example: 20 gives 0.2 seconds

The resulting animated GIF file will be shown using
$ANIGIFVIEWER .
(If the viewer is a web browser, it may take more than
10 seconds to start up.)" \
   --entry-text "10")

if test "$DELAY100s" = ""
then
   exit
fi


##################################################################
## Make full filename for the output ani-gif file --- using the
## name of a selected input ani-gif file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

OUTFILE="${FILENAMECROP}_NEW_ani.gif"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


##################################################################
## Use 'convert' to make the animated gif file.
##    -delay 20 pauses 20 hundredths of a second (0.2 sec)
##                                     before showing next image
##    -loop 0 animates 'endlessly'
##################################################################

convert -delay $DELAY100s -loop 0 /tmp/CHG-DELAY_*.gif "$OUTFILE"


##################################
## Show the new animated gif file.
##################################

$ANIGIFVIEWER "$OUTFILE" &
