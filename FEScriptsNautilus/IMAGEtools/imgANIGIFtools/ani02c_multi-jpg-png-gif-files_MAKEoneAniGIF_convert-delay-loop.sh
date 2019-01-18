#!/bin/sh
##
## Nautilus
## SCRIPT: ani02c_multi-jpg-png-gif-files_MAKEoneAniGIF_convert-delay-loop.sh
##
## PURPOSE: Makes an animated '.gif' file from a selected set of
##          image files --- '.jpg' or '.png' or '.gif'.
##
## METHOD:  Uses 'zenity' to prompt the user for an inter-image delay
##          (in hundredths of seconds).
##
##          Uses the ImageMagick 'convert' program with '-delay' and
##          '-loop 0' options to make the animated GIF file.
## 
##          Shows the animated '.gif' file in an animated gif viewer of the
##          user's choice (which could be a web browser).
##
## HOW TO USE: In Nautilus, select one or more '.jpg', '.png', or '.gif'
##             files.
##             Then right-click and choose this script to run (name above).
##
############################################################################
## Created: 2010mar18
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012jan19 Added a note to the delay-secs prompt, to let the
##                    user know that $ANIGIFVIEWER will be used to view
##                    the output animated GIF file.
## Changed: 2012may12 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
## Changed: 2015sep25 Added 2 examples to the zenity prompt for display-time.
###########################################################################

## FOR TESTING: (show statements as they execute)
#  set -x


####################################################################
## START THE LOOP on the filenames --- to make IMAGE filenames list.
####################################################################

FILENAMES2=""

for FILENAME
do

  ####################################################################
  ## Get and check that the file extension is 'jpg' or 'png' or 'gif'.
  ## Assumes one period (.) in filename, at the extension.
  ####################################################################
  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
  if test "$FILEEXT" = "jpg" -o "$FILEEXT" = "png" -o "$FILEEXT" = "gif"
  then
     FILENAMES2="$FILENAMES2 $FILENAME"
  fi

done


#######################################################################
## Use the last FILENAME to get the 'stub' to use to name the output
## animated GIF file.
#######################################################################

# FILENAMECROP=`echo "$FILENAME" | sed 's|\.jpg$||'`
# FILENAMECROP=`echo "$FILENAMECROP" | sed 's|\.png$||'`
# FILENAMECROP=`echo "$FILENAMECROP" | sed 's|\.gif$||'`

# FILENAMECROP=`echo "$FILENAMECROP" | sed 's|\..*$||'`

FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`


#######################################################################
## Set the viewer to be used to show the output animated GIF file.
######################################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi


##########################################################
## Set the display time for frames of the animation ---
## in 100ths of a second. Example: 250 = 2.5 seconds.
##########################################################

DELAY100s=""

DELAY100s=$(zenity --entry --title "Each-image Display Time" \
   --text "\
Enter the each-image DISPLAY-TIME, in 100ths of seconds.
Example1: 250 gives 2.5 seconds per image
Example2: 100 gives 1.0 seconds per image
Example3: 10 gives 0.1 seconds per image

The resulting animated GIF file will be shown using
$ANIGIFVIEWER .
(If the viewer is a web browser, it may take more than
10 seconds to start up.)" \
   --entry-text "250")

if test "$DELAY100s" = ""
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

OUTFILE="${FILENAMECROP}_ani.gif"

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
##    -delay 250 pauses 250 hundredths of a second (2.5 sec)
##                                     before showing next image
##    -loop 0 animates 'endlessly'
##################################################################

convert -delay $DELAY100s -loop 0 $FILENAMES2 "$OUTFILE"


##################################
## Show the new animated gif file.
##################################

$ANIGIFVIEWER "$OUTFILE" &
