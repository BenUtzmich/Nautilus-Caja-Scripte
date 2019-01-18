#!/bin/sh
##
## Nautilus
## SCRIPT: 0A_1movieFile_show_PROPERTIES_ffmpeg-i.sh
##
## PURPOSE: Shows the properties of a movie file ('.mpg', '.flv', '.avi',
##          '.mov', '.wmv', '.mp4', '.mkv', '.asf', '3gp', whatever).
##
## METHOD: There is no prompt for a parameter.
##
##         Uses 'ffmpeg -i' to get the properties of the selected
##         movie file.
##
##         Puts the text output in a file in the '/tmp' directory.
##
##         Shows the text output in a text viewer of the user's choice
##         --- after eliminating some distracting text.
##
## HOW TO USE: In Nautilus, select a movie file.
##             Then right-click and choose this script to run (name above).
##
##########################################################################
## Started: 2010mar08
## Changed: 2011may02 Add $USER to 2 temp filenames.
## Changed: 2012may14 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
## Changed: 2013apr10 Added check for the ffmpeg executable. 
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x

#########################################################
## Check if the ffmpeg executable exists.
#########################################################

EXE_FULLNAME="/usr/bin/ffmpeg"

if test ! -f "$EXE_FULLNAME"
then
   zenity  --info --title "Executable NOT FOUND." \
   --no-wrap \
   --text  "\
The ffmpeg executable
   $EXE_FULLNAME
was not found. Exiting.

If the executable is in another location,
you can edit this script to change the filename.
OR, install the 'ffmpeg' package."
   exit
fi


#########################################
## Get the filename of the selected file.
#########################################

  FILENAME="$1"
# FILENAMES="$@"
# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"


#########################################################################
## Check that the selected file looks like a 'supported' movie file,
## via its suffix.
##
## MIGHT BE BETTER TO COMMENT OUT THIS CHECK, and just let the
## 'properties' output be generated and viewed, even if the
## output is only error messages.
##
##     (Assumes just one dot [.] in the filename, at the extension.)
#########################################################################

#  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
#  if test "$FILEEXT" != "mp4" -a "$FILEEXT" != "mkv"  -a \
#          "$FILEEXT" != "flv" -a \
#          "$FILEEXT" != "wmv" -a "$FILEEXT" != "asf"  -a \
#          "$FILEEXT" != "mpg" -a "$FILEEXT" != "mpeg" -a \
#          "$FILEEXT" != "ogg" -a "$FILEEXT" != "ogv"  -a \
#          "$FILEEXT" != "avi" -a "$FILEEXT" != "mov"  -a \
#          "$FILEEXT" != "3gp"
#  then
#     exit
#  fi


##################################
## Prepare the output filename(s).
##################################

FILEOUT="/tmp/${USER}_movie_properties_ffmpeg.txt"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi

FILEOUT2="/tmp/${USER}_movie_properties_ffmpeg_2.txt"

if test -f "$FILEOUT2"
then
   rm -f "$FILEOUT2"
fi


########################################################################
## Use 'ffmpeg' to put the properties of the movie file in a text file,
## along with header and trailer info.
########################################################################
## Meaning of the ffmpeg parms:
##
## -i  val = input filename
###############################

echo "\
'ffmpeg -i' output:
##################
" > "$FILEOUT"

## FOR TESTING:
# xterm -hold -e \

# ffmpeg -i "$FILENAME" 2> "$FILEOUT2" >>  "$FILEOUT"

$EXE_FULLNAME -i "$FILENAME" 2> "$FILEOUT2" >>  "$FILEOUT"


################################
## Cleanup the FILEOUT2 file and
## attach it to the FILEOUT file.
################################

#  tail -n +11 "$FILEOUT2" | head -4 >>  "$FILEOUT"
## IS REPLACED by the several lines below.

LINE_BUILTON=`grep -n 'built on' "$FILEOUT2" | cut -d: -f1`
LINE_BUILTON=`expr $LINE_BUILTON + 1`

#  tail -n +$LINE_BUILTON "$FILEOUT2" | head -4 >>  "$FILEOUT2"

tail -n +$LINE_BUILTON "$FILEOUT2" | grep -v 'output file must be specified' \
         >>  "$FILEOUT"


###########################
## Show the output file.
###########################

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$FILEOUT" &
