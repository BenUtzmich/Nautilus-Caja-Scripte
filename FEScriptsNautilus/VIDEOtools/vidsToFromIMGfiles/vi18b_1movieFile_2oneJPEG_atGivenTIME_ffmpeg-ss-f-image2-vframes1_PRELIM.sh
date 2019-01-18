#!/bin/sh
##
## Nautilus
## SCRIPT: vi18b_1movieFile_2oneJPEG_atGivenTIME_ffmpeg-ss-f-image2-vframes1_PRELIM.sh
##
## PURPOSE: Extracts one '.jpg' file from a selected movie file,
##          at a user-specified time.
##
## METHOD:  Uses 'zenity --entry' to prompt for the time location in the movie.
##
##          Runs 'ffmpeg' with '-ss' parm and '-f image2' and '-vframes 1' parms.
##           
##          Runs 'ffmpeg' in an 'xterm' so that messages can be seen.
##
##          Shows the extracted '.jpg' file in an image viewer (or image editor)
##          of the user's choice.
##
## REFERENCES: Do a web search on keywords like 'ffmpeg jpg image2 vframes ss'.
##
## From 'man ffmpeg':
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
##  **** If you want to extract just a limited number of frames, you can use the
##  **** above command in combination with the -vframes or -t option, or in
##  **** combination with -ss to start extracting from a certain point in time.
##
## HOW TO USE: In Nautilus, select a movie file.
##             Then right-click and choose this VIDEOtools script to run
##             (name above).
##
################################################################################
## Created: 2010jun16
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
## movie file, and exit if no match.  ## SKIP CHECK, for now. ##
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
## Prompt for the time at which to extract the '.jpg' image.
##
## Example: 8.5 for an image at 8.5 seconds into the movie.
##
##  "hh:mm:ss[.xxx]" syntax is also supported by ffmpeg.
######################################################################

TIMEofFRAME=""

TIMEofFRAME=$(zenity --entry \
   --title "TIME location to extract the JPG image." \
   --text "\
Enter a time in seconds.  'hh:mm:ss[.xxx]' syntax is also supported by ffmpeg.

Equivalent Examples:
8.5    OR    00:00:08.5

        for an image at 8.5 seconds into the movie." \
   --entry-text "8")

if test "$TIMEofFRAME" = ""
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
## Prepare the filename for the '.jpg' output file.
##########################################################

FILEOUT="${FILENAMECROP}_atTIME${TIMEofFRAME}.jpg"


################################################################
## Use 'ffmpeg' to extract the '.jpg' file from the movie file.
################################################################
## REFERENCE:
## http:
################################################################

## FOR TEST: (show statements as they execute)
#   set -x

xterm -hold -fg white -bg black -geometry 90x48+100+100 -e \
      ffmpeg -ss $TIMEofFRAME -i "$FILENAME" \
      -f image2 -vframes 1 "$FILEOUT"

## FOR TEST:
#    set -


###########################################################
## Show the jpg file in an image viewer or editor.
##
##   (Could save the image to a more meaningful filename by
##    using the 'Save as ...' option of the editor.)
###########################################################

if test ! -f "$FILEOUT"
then
   exit
fi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$FILEOUT"

# $IMGEDITOR "$FILEOUT"
