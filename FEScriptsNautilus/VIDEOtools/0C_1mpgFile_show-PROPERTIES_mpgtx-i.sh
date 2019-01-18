#!/bin/sh
##
## Nautilus
## SCRIPT: 0C_1mpgFile_show_PROPERTIES_mpgtx-i.sh
##
## PURPOSE: Shows the properties of a movie file. (Will work on some
##          MPEG files but not '.flv', '.mov', '.avi', '.wmv', etc.)
##
## METHOD:  There is no prompt for a parameter.
##
##          Uses 'mpgtx -i' to get the properties of the selected movie file.
##
##          Shows the text output in a text viewer of the user's choice
##          --- after attaching stderr msgs to stdout.
##
##     NOTE: The 'man' help on 'mpgtx' (2004) says:
##
##    "Three  file  types are  currently  handled (more  to  come):
##       - MPEG 1 Video files,
##       - MPEG 1/2 Audio files (mp1, mp2, and mp3),
##       - MPEG 1 System files (audio  and  video files),
##       - MPEG  2  Program  files (Experimental),
##       - MPEG 2 Transport files (demultiplex and info modes only)."
##
##        Hence 'mpgtx' will NOT give properties of many movie types
##        such as a 'flv' Flash movie file --- or Microsoft 'wmv' or
##        'avi' or 'asf' --- or 'mkv' (Matroska container) movie files
##        --- or 'ogg' and many others.
##
## HOW TO USE: In Nautilus, select a movie file.
##             Then right-click and choose this script to run (name above).
##
###########################################################################
## Started: 2011apr20
## Changed: 2011may02 Added $USER to 2 temp filenames.
## Changed: 2011jun12 Added a check for '/usr/bin/mpgtx'.
## Changed: 2012may14 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
## Changed: 2013apr10 Added check for the mpgtx executable.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x

#########################################################
## Check if the mpgtx executable exists.
#########################################################

EXE_FULLNAME="/usr/bin/mpgtx"

if test ! -f "$EXE_FULLNAME"
then
   zenity  --info --title "Executable NOT FOUND." \
   --no-wrap \
   --text  "\
The mpgtx executable
   $EXE_FULLNAME
was not found. Exiting.

If the executable is in another location,
you can edit this script to change the filename.
OR, install the 'mpgtx' package."
   exit
fi


#########################################
## Get the filename of the selected file.
#########################################

  FILENAME="$1"
# FILENAMES="$@"
# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"


#########################################################################
## Check that the selected file looks like an MPEG file,
## via its suffix.
##
## MIGHT BE BETTER TO COMMENT OUT THIS CHECK, and just let the
## 'properties' output be generated and viewed, even if the
## output is only error messages.
##
##     (Assumes just one dot [.] in the filename, at the extension.)
#########################################################################

#  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
#  if test "$FILEEXT" != "mpg" -a "$FILEEXT" != "mpeg" -a \
#          "$FILEEXT" != "mp4" -a "$FILEEXT" != "mov"
#  then
#     exit
#  fi


##################################
## Prepare the output filename(s).
##################################

FILEOUT="/tmp/${USER}_movie_properties_mpgtx.txt"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi

FILEOUT2="/tmp/${USER}_movie_properties_mpgtx_2.txt"

if test -f "$FILEOUT2"
then
   rm -f "$FILEOUT2"
fi


########################################################################
## Use 'mpgtx' to put the properties of the movie file in a text file,
## along with header and trailer info.
###############################
## Meaning of the mpgtx parms:
##
## -i  val = input filename
########################################################################

echo "\
'mpgtx -i' output:
#################
" > "$FILEOUT"

## FOR TESTING:
# xterm -hold -e \

# /usr/bin/mpgtx -i "$FILENAME" 2> "$FILEOUT2"  >>  "$FILEOUT"

$EXE_FULLNAME -i "$FILENAME" 2> "$FILEOUT2"  >>  "$FILEOUT"


if test ! -z "$FILEOUT2"
then
    cat "$FILEOUT2" >> "$FILEOUT"
fi

echo "
####
NOTE: 'mpgtx -i' will give error messages on some movie files,
      whereas 'ffmpeg -i' will not on those same files." >> "$FILEOUT"


###########################
## Show the output file.
###########################

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$FILEOUT" &
