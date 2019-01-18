#!/bin/sh
##
## Nautilus
## SCRIPT: 0B_1audioFile_show_PROPERTIES_mplayer-identify.sh
##
## PURPOSE: Shows the properties of a user-selected audio file.
##
## METHOD:  Uses 'mplayer -frames 0 -identify'.
##
##          Shows the text output in a text viewer of the user's choice,
##          after eliminating some distracting text.
##
############################################################################
## Started: 2012feb24 Based on a similar script in the 'VIDEOtools' group.
## Changed: 2013apr10 Added check for the mplayer executable.
## Changed: 2014jun30 Added '-vo null -ao null -nolirc' to the
##                    command 'mplayer -frames 0 -identify'.
############################################################################

## FOR TESTING: (show statements as they execute)
# set -x

#########################################################
## Check if the mplayer executable exists.
#########################################################

EXE_FULLNAME="/usr/bin/mplayer"

if test ! -f "$EXE_FULLNAME"
then
   zenity  --info --title "Executable NOT FOUND." \
   --no-wrap \
   --text  "\
The mplayer executable
   $EXE_FULLNAME
was not found. Exiting.

If the mplayer executable is in another location,
you can edit this script to change the filename."
   exit
fi


#########################################
## Get the filename of the selected file.
#########################################

  FILENAME="$1"
# FILENAMES="$@"
# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"


#########################################################################
## Check that the selected file looks like a 'supported' audio file,
## via its suffix.
##
## MIGHT BE BETTER TO COMMENT OUT THIS CHECK, and just let the
## 'properties' output be generated and viewed, even if the
## output is only error messages.
##
##     (Assumes just one dot [.] in the filename, at the extension.)
#########################################################################

#  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
#  if test "$FILEEXT" != "mp3" -a "$FILEEXT" != "wav"  -a \
#          "$FILEEXT" != "aac"
#  then
#     exit
#  fi


##################################
## Prepare the output filename(s).
##################################

FILEOUT="/tmp/${USER}_audio_properties_mplayer.txt"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi

FILEOUT2="/tmp/${USER}_audio_properties_mplayer_2.txt"

if test -f "$FILEOUT2"
then
   rm -f "$FILEOUT2"
fi


########################################################################
## Use 'mplayer' to put the properties of the audio file in a text file,
## along with header and trailer info.
########################################################################

echo "\
'mplayer -frames 0 -identify' output:
####################################
" > "$FILEOUT"

## FOR TESTING:
# xterm -hold -e \

#  mplayer -frames 0 -identify "$FILENAME" 2> "$FILEOUT2"  >>  "$FILEOUT"

$EXE_FULLNAME -vo null -ao null -nolirc -frames 0 \
   -identify "$FILENAME" 2> "$FILEOUT2"  >>  "$FILEOUT"

if test ! -z "$FILEOUT2"
then
    cat "$FILEOUT2" >> "$FILEOUT"
fi

echo "
####
NOTE: 'mplayer -frames 0 -identify' will give error messages on some files,
       whereas 'ffmpeg -i' may not." >> "$FILEOUT"


###########################
## Show the output file.
###########################

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$FILEOUT" &
