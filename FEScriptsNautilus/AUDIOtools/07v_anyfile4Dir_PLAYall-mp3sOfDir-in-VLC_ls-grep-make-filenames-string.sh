#!/bin/sh
##
## Nautilus
## SCRIPT: 07v_anyfile4Dir_PLAYall-mp3sOfDir-in-VLC_ls-grep-make-filenames-string.sh
##
## PURPOSE: Plays the mp3 files in the current directory,
##          sequentially using 'vlc'.
##
## METHOD:  It would be nice to use a 'playlist' file
##          to feed the filenames to ONE call of 'vlc',
##          but after much web searching, I have not
##          found an example of doing that.
##
##          Furthermore, 'vlc' does not seem to take a playlist
##          file on the command line (according to 'man vlc'),
##          so we build a string of filenames (quoted to handle
##          filenames with spaces) --- by using 'ls' and then
##          a for-loop with 'grep' to select only '.mp3' files.
##
##          Note: Uses IFS, the field-separator environment variable.
##
##          Plays the files by passing the string of filenames
##          to the 'vlc' command.
##
##         NOTE:
##         I am concerned about passing all the filenames
##         on the VLC command line. There is a limit of around 2KB
##         (maybe much more nowadays) on the length of a command line.
##         An alternate implementation could call 'vlc' once for
##         each file.
##
## HOW TO USE: In Nautilus, navigate to a directory of mp3 files,
##             right-click on any file in the directory, then
##             choose this Nautilus script to run.
##
#########################################################################
## Created: 2010mar11
## Changed: 2010apr11 Touched up the comment statements.
## Changed: 2011jul08 To handle filenames with spaces in the names.
## Changed: 2012feb29 Changed the scriptname, in the comment above.
##                    Reorged the 'METHOD' comment section above.
## Changed: 2012oct01 Changed script name from '_VLC' to
##                    '-in-VLC' --- and added
##                    '_ls-grep-make-filenames-string'.
## Changed: 2013apr10 Added check for the player executable. 
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x

#########################################################
## Check if the player executable exists.
#########################################################

EXE_FULLNAME="/usr/bin/vlc"

if test ! -f "$EXE_FULLNAME"
then
   zenity  --info --title "Player NOT FOUND." \
   --no-wrap \
   --text  "\
The player executable
   $EXE_FULLNAME
was not found. Exiting."
   exit
fi


#########################################################
## Prepare a 'play list' file to hold the audio filenames.
##
## NOTE: 'vlc' does not seem to accept a playlist file,
## although you can '--playlist-enqueue' filenames into
## its playlist when in '--one-instance' mode.
## Ref: vlc -H
##
## So the following playlist-file creation is commented.
## It may be activated if it ever becomes known that
## VLC supports input via a playlist file.
#########################################################

#  TEMPFILE="/tmp/${USER}_vlc.pls"
#  rm -f $TEMPFILE


#############################################################
## Generate a string of '.mp3' filenames.
#############################################################

## This does not work for filenames with embedded spaces.
#  MP3NAMES=`ls  | grep '\.mp3$' | sed 's|$| |'`

FILENAMES=`ls`
 
HOLD_IFS="$IFS"
## We put a single line-feed in IFS.
IFS='
'

## It would be nice to avoid changing IFS, but I have not
## found a way, yet, to make the 'in' reader
## of the 'for' loop recognize the separate filenames
## when filenames contain spaces.
##   (Perhaps we could use 'sed' to put a quote at the
##    beginning and end of each line in $FILENAMES.)

MP3NAMES=""

for FILENAME in $FILENAMES
do
   FILECHK=`echo "$FILENAME" | grep '\.mp3$'`
   if test ! "$FILECHK" = ""
   then
      MP3NAMES="$MP3NAMES \"$FILENAME\""
   fi
done

IFS="$HOLD_IFS"


##################################################################
## Play the audio files with 'vlc'.
##################################################################
## vlc has command line option '--random' to randomize
## the playing of the files.
##
## vlc has command line option '--loop' to repeat playing
## the playlist indefinitely.
##
## We could use zenity to prompt for those actions to be triggered.
##################################################################

## FOR TESTING:
#  set -x

# eval /usr/bin/vlc --no-http-album-art --album-art 0 \
#       --no-http-forward-cookies --playlist-tree "$MP3NAMES"

eval $EXE_FULLNAME --no-http-album-art --album-art 0 \
      --no-http-forward-cookies --playlist-tree "$MP3NAMES"

## '--album-art 0' means DO NOT download album art.

## Some OTHER vlc options that might be useful:
## --random
## --loop
## --playlist-tree
## --one-instance
## --play-and-exit
## --qt-start-minimized


exit
#############################################
## Script ENDS HERE. Following is an
## ALTERNATIVE APPROACH, calling VLC once for
## each mp3 file in the current directory.
#############################################

FILENAMES=`ls`

#########################################
## START THE LOOP on the filenames.
##
## Could use a Linux utility like 'shuf' to
## randomize the filenames. Could use zenity
## to prompt whether to shuffle.
#########################################
 
HOLD_IFS="$IFS"
## We put a single line-feed in IFS.
IFS='
'

for FILENAME in "$FILENAMES"
do

   ##################################################
   ## Get and check that file extension is 'mp3'. 
   ## THIS ASSUMES one '.' in filename, at the extension.
   ##################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   if test "$FILEEXT" != "mp3" 
   then
      continue
      # exit
   fi

   ####################################
   ## Play the file with 'vlc'.
   ## Try to suppress Internet queries.
   ####################################

   # /usr/bin/vlc --no-http-album-art --album-art 0 \
   #              --playlist-tree "$FILENAME"

   $EXE_FULLNAME --no-http-album-art --album-art 0 \
                --playlist-tree "$FILENAME"

   ## '--album-art 0' means DO NOT download album art.
   ## '--no-http-album-art' means 

   ## Some OTHER vlc options that might be useful:
   ## --random
   ## --loop
   ## --playlist-tree
   ## --one-instance
   ## --play-and-exit
   ## --qt-start-minimized

done

# IFS="$HOLD_IFS"
