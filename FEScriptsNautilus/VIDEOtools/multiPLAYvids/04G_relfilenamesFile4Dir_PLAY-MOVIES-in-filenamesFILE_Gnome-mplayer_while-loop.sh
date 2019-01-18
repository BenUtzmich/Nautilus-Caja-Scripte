#!/bin/sh
##
## Nautilus
## SCRIPT: 04G_filenamesFile4Dir_PLAY-MOVIES-in-filenamesFILE_Gnome-mplayer_while-loop.sh
##
## PURPOSE: Plays the movie files in a selected filenames file. The filenames file
##          simply contains a list of filenames, relative to the current directory
##          (the directory containing the filenames file).
##
## METHOD:  In a 'while' loop, reads a line of the selected play-list file and
##          plays the movie filename read --- using 'gnome-mplayer'.
##
## HOW TO USE: In Nautilus, navigate to a directory containing a filenames file
##             and movie files. The movie files can be in that directory or in
##             sub-directories of the directory containing the filenames file.
##             Select the filenames file.
##             Then right-click and choose this Nautilus script to run (name above).
##
## REFERENCE:
##   http://www.askdavetaylor.com/how_do_i_read_lines_of_data_in_a_shell_script.html
############################################################################
## Created: 2012jul25
## Changed: 2012oct01 Chgd scriptname and changed occurrences of playlist/PLAYLIST
##                    to filenames/FILENAMES.
###########################################################################

## FOR TESTING: (display statements as they execute)
# set -x

############################################
## Get the filenames filename.
############################################

FILENAMESFILE="$1"


############################################################
## In a while loop, read each line of the filenames file
## and play the filename in each line, with 'gnome-mplayer'.
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

   /usr/bin/gnome-mplayer "$FILENAME"

   zenity --question \
      --title "Continue or CANCEL?" \
      --text "\
Keep playing the movie files in the filenames file?

  $FILENAMESFILE

CANCEL or OK?"  --no-wrap

   RETCODE=$?

   if test $RETCODE = 1
   then
      exit
   fi

done < "$FILENAMESFILE"
## END OF 'while read FILENAME' loop.
