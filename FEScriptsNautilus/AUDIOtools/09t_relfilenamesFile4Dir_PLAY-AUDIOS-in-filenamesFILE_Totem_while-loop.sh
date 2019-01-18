#!/bin/sh
##
## Nautilus
## SCRIPT: 09t_relfilenamesFile4Dir_PLAY-AUDIOS-in-filenamesFILE_Totem_while-loop.sh
##
## PURPOSE: Plays the audio files in a selected filenames file. The filenames file
##          simply contains a list of filenames, relative to the current directory
##          (the directory containing the filenames file).
##
## METHOD:  In a 'while' loop, reads a line of the selected play-list file and
##          plays the audio filename read with 'totem'.
##
## HOW TO USE: In Nautilus, navigate to a directory containing a filenames file
##             and audio files. The audio files can be in that directory or in
##             sub-directories of the directory containing the filenames file.
##             Select the filenames file.
##             Then right-click and choose this Nautilus script to run (name above).
##
## REFERENCE:
##   http://www.askdavetaylor.com/how_do_i_read_lines_of_data_in_a_shell_script.html
############################################################################
## Created: 2012jul25
## Changed: 2012oct01 Changed script name from '_playlistFile4Dir' to
##                    '_relfilenamesFile4Dir' --- and '-in-PLAYLIST' to
##                    '-in-filenamesFILE'.
## Changed: 2013apr10 Added check for the player executable. 
###########################################################################

## FOR TESTING: (display statements as they execute)
# set -x

#########################################################
## Check if the player executable exists.
#########################################################

EXE_FULLNAME="/usr/bin/totem"

if test ! -f "$EXE_FULLNAME"
then
   zenity  --info --title "Player NOT FOUND." \
   --no-wrap \
   --text  "\
The player executable
   $EXE_FULLNAME
was not found. Exiting.

If the executable is in another location,
you can edit this script to change the filename."
   exit
fi


############################################
## Get the filenames filename.
############################################

FILENAMESFILE="$1"


############################################################
## In a while loop, read each line of the filenames file
## and play the filename in each line, with 'totem'.
########
## If the line is empty or starts with "#", skip the line.
############################################################

while read FILENAME
do

   if test "$FILENAME" = ""
   then
      continue
   fi

   FIRSTCHAR=`echo "$FILENAME" | cut -c1`

   if test "$FIRSTCHAR" = "#"
   then
      continue
   fi

   # /usr/bin/totem "$FILENAME"

   $EXE_FULLNAME "$FILENAME"

   zenity --question \
      --title "Continue or CANCEL?" \
      --text "\
Keep playing the audio files in the filenames file?

  $FILENAMESFILE

CANCEL or OK?"  --no-wrap

   RETCODE=$?

   if test $RETCODE = 1
   then
      exit
   fi

done < "$FILENAMESFILE"
## END OF 'while read FILENAME' loop.
