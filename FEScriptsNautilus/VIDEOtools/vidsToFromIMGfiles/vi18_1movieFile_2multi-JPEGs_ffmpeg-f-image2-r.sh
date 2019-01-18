#!/bin/sh
##
## Nautilus
## SCRIPT: vi18_1movieFile_2multi-JPEGs_ffmpeg-f-image2-r.sh
##
## PURPOSE: Extracts '.jpg' files from a selected movie file,
##          at a user-specified time sampling rate. Uses 'ffmpeg'.
##
## METHOD:  Uses 'zenity --entry' to prompt for a sampling-rate.
##
##          Runs 'ffmpeg' with '-f image2' and '-r' parms and an
##          output filename of the form  ${FILENAMECROP}_%03d.jpg.
##
##          Runs 'ffmpeg' in an 'xterm' so that messages can be seen.
##
##          Shows the first of the '.jpg' files in an image viewer
##          of the user's choice.
##
## REFERENCES: http://electron.mit.edu/~gsteele/ffmpeg/ (circa 2005)
##
##             May need corrections according to 'man ffmpeg'.
##
##     From 'man ffmpeg':
##
##     * You can extract images from a video:
##
##	       ffmpeg -i foo.avi -r 1 -s WxH -f image2 foo-%03d.jpeg
##
##       This will extract one video frame per second from the video and will
##       output them in files named foo-001.jpeg, foo-002.jpeg, etc. Images will
##       be rescaled to fit the new WxH values.
##
##       The syntax "foo-%03d.jpeg" specifies to use a decimal number composed
##       of three digits padded with zeroes to express the sequence number. It
##       is the same syntax supported by the C printf function, but only formats
##       accepting a normal integer are suitable.
##
##       If you want to extract just a limited number of frames, you can use the
##       above command in combination with the -vframes or -t option, or in
##       combination with -ss to start extracting from a certain point in time.
##
## HOW TO USE: In Nautilus, select a movie file.
##             Then right-click and choose this VIDEOtools script to run
##             (name above).
##
#############################################################################
## Created: 2010apr17
## Changed: 2011jun13 Added '-geometry' parm to xterm.
## Changed: 2012may24 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
##############################################################################

## FOR TESTING: (display statements that are executed)
# set -x

#########################################
## Get the filename of the selected file.
#########################################

#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES="$@"
   FILENAME="$1"

###############################################################
## WE COULD
## Check that the file extension seems to indicate a 'supported'
## movie file, and exit if no match.
##
## We may have to add the '-f' container specification parm
## to the ffmpeg command, to support the suffixes below.
##
##   (Assumes one dot [.] in the filename, at the extension.)
###############################################################

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

#  if test "$FILEEXT" != "mpg"  -a  "$FILEEXT" != "mpeg" -a \
#          "$FILEEXT" != "flv"  -a  "$FILEEXT" != "mp4"  -a \
#          "$FILEEXT" != "mkv"  -a  "$FILEEXT" != "webm" -a \
#          "$FILEEXT" != "wmv"  -a  "$FILEEXT" != "asf"  -a \
#          "$FILEEXT" != "avi"  -a  "$FILEEXT" != "mov"  -a \
#          "$FILEEXT" != "ogg"  -a  "$FILEEXT" != "ogv"
#  then
#     exit
#  fi


######################################################################
## Prompt for the sampling rate at which to extract the '.jpg' images.
##
## Example: 8 for every 8 seconds.
##
##  "hh:mm:ss[.xxx]" syntax is also supported by ffmpeg.
######################################################################

SAMPLETIMING="0.5"

SAMPLETIMING=$(zenity --entry \
   --title "SAMPLE RATE for JPG image Extraction." \
   --text "\
Enter SAMPLING RATE, for JPG image Extraction.
     Examples: 1     for sampling an image every 1 second.
               0.5   for sampling an image every 2 seconds (1/2).
               0.1   for sampling an image every 10 seconds (1/10).
               0.05  for sampling an image every 20 seconds (1/20).
               0.025 for sampling an image every 40 seconds (1/40).
               0.01  for sampling an image every 100 seconds (1/100).
               0.005 for sampling an image every 200 seconds (about every 3.3 mins).
               0.001 for sampling an image every 1000 seconds (about every 16 mins)." \
   --entry-text "0.5")

if test "$SAMPLETIMING" = ""
then
   exit
fi

####################################################################
## Get the middle name of the movie file ---
## to make a name for the jpg file.
##
##    (Assumes one dot in the movie filename, at the file extension.)
#####################################################################

FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`


##########################################################
## Remove any pre-existing '.jpg' output file(s) with
## the same 'midname' as the movie file.
##########################################################

# FILES2DELETE=`ls ${FILENAMECROP}_*.jpg`
# for FILE in $FILES2DELETE
# do
#   rm "$FILE"
# done


################################################################
## Use 'ffmpeg' to extract the '.jpg' files from the movie file.
################################################################
## Example from 'man ffmpeg':
##     ffmpeg -i foo.avi -r 1 -s WxH -f image2 foo-%03d.jpeg
################################################################

## FOR TEST: (show statements as they execute)
#   set -x

xterm -hold -fg white -bg black -geometry 90x48+100+100 -e \
      ffmpeg -i "$FILENAME" -f image2 -r $SAMPLETIMING "${FILENAMECROP}_%03d.jpg"

#  '-loop_input' needed?

## FOR TEST:
#    set -


###########################################################
## Show the first jpg file in an image viewer or editor.
##
##   (Could save the image to a more meaningful filename by
##    using the 'Save as ...' option of the editor.)
###########################################################

FILEOUT1="${FILENAMECROP}_001.jpg"

if test ! -f "$FILEOUT1"
then
   exit
fi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER  "$FILEOUT1"
