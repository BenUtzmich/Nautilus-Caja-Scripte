#!/bin/sh
##
## Nautilus
## SCRIPT: 0D_1movieFile_show_CONTAINER-TYPE_ffmpeg-i.sh
##
## PURPOSE: Shows the 'container type' of a movie file --- using
##          'ffmpeg -i' along with 'grep' and 'cut'.
##
## METHOD:  Uses 'zenity --info' to show the string extracted from
##          the 'ffmpeg -i' output.
##
## HOW TO USE: In Nautilus, select one movie file.
##             Then right-click and choose this VIDEOtools script to run
##             (name above).
##
##     NOTE on TESTING:
##       This script may need to be tested on more movie files ---
##       files with container-format or suffix
##       'mp4', 'mkv', 'flv', 'wmv', 'asf', 'avi', 'mov', 'mpg', 'mpeg',
##       '3gp', etc.
##
##       This script was intended for use mainly to determine the
##       grep-and-head-and-cut commands to use to extract the container-id
##       string from 'ffmpeg -i' output.
##
##       The ffmpeg-grep-head-cut code may be used in some VIDEOtools scripts
##       to determine parameters to use --- based on ffmpeg-determined
##       container type, rather than based on a file suffix.
##
##       Initially, in this script, we use
##           grep '^Input'
##       piped to 
##          cut.
##
############################################################################
## Started: 2010jun20
## Changed: 2011nov11 Chgd script name and the NOTE above.
## Changed: 2012may24 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x

#########################################
## Get the filename of the selected file.
#########################################

# FILENAMES="$@"
# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

FILENAME="$1"


########################################################################
## Use 'ffmpeg' to get the container type of the movie file ---
## into a variable.
########################################################################
## Meaning of the ffmpeg parms:
##
## -i  val = input filename
###############################

CONFMT=`ffmpeg -i "$FILENAME" 2>&1 | grep '^Input' | cut -d' ' -f3`


###########################
## Show the info in zenity.
###########################

zenity --info --title "Container type." \
       --no-wrap \
       --text "\
Container type of file
 $FILENAME
is
 $CONFMT

This was determined by using:    grep '^Input' | cut -d' ' -f3

on the 'ffmpeg -i' output for the file."
