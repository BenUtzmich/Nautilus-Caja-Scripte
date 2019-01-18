#!/bin/sh
##
## Nautilus
## SCRIPT: vjA4_multi-avi-files_JOIN_avimerge.sh
##
## PURPOSE: Merges several '.avi' container movies (of the same type,
##          supported by avimerge) into ONE '.avi' container movie
##          --- using 'avimerge'.
##
## METHOD:  Check that 'avimerge' is installed in the usual place
##          and use 'zenity --info' to popup a message if 'avimerge'
##          is not found.
##
##          In a 'for' loop, puts the selected movie filenames in a string
##          --- space-separated and each filename in double-quotes
##
##          Passes the string of selected filenames to 'eval avimerge -i'.
##
##          Shows the resulting '.avi' file with a movie player.
##
## REFERENCES: man avimerge
##       OR
##     http://www.arsgeek.com/2006/08/07/how-to-join-multiple-avi-or-mpg-files/
##       OR
##            do a web search on keywords such as 'avimerge multiple files'.
##
##
## HOW TO USE: In Nautilus, select one or more '.avi' movie files (of the same
##             video-audio encoding. (Can use the Ctl or Shift
##             keys to select multiple files.)
##             Then right-click and choose this VIDEOtools script to run
##             (name above).
##
#############################################################################
## Created: 2011dec13
## Changed: 2012feb14 Changed script name.
## Changed: 2012may24 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (display commands that are executed)
# set -x


##########################################
## If /usr/bin/avimerge does not exist,
## pop a zenity msg and exit.
##########################################

if test ! -f /usr/bin/avimerge
then

   SCRIPT_BASENAME=`basename $0`

   zenity --info \
          --title "'/usr/bin/avimerge' NOT FOUND.  EXITING ..." \
          --text "\
This utility, $SCRIPT_BASENAME,
requires the 'avimerge' program, which is ordinarily at
/usr/bin/avimerge.

It is not there.  EXITING.

You may be able to install it with the command
    sudo apt-get install transcode
or
    sudo apt-get install avimerge
or use the Software Center of your distro,
or use the Synaptic Package Manager."

   exit

fi


############################################################
## LOOP thru the selected files.
## 1) Save the file extension of the first file.
## 2) Make sure they all have a common extension (type).
##        (May have to check for certain types, like 'avi',
##         supported by 'avimerge'.)
## 3) Save the 'middle-name' of the first file.
## 4) Save the filenames (quoted) in FILENAMES var.
############################################################

FILEEXT1=""
FILENAMECROP1=""
FILENAMES=""

for FILENAME
do
   ###############################################################
   ## Get the file extension of the file.
   ##  (Assumes one dot (.) in the filename, at the extension.)
   ###############################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   ##############################################################
   ## If the file extension has not been set yet in var FILEEXT1
   ## (i.e. for the first file), put the file extension
   ## into var FILEEXT1.
   ##############################################################

   if test "$FILEEXT1" = ""
   then
      FILEEXT1="$FILEEXT"
   fi

   if test "$FILEEXT" != "$FILEEXT1"
   then 

      JUNK=`zenity -- question --title "Merge Movies: EXITING" \
         --text "\
The movies do not seem to be all of the same type ---
they do not have a common file extension:

$FILENAMES

EXITING ...."`

      exit
   fi

   ################################################################
   ## If the file 'middle-name' has not been set yet in var
   ## FILENAMECROP1 (i.e. for the first file),
   ## put the 'middlename' into into var FILENAMECROP1.
   ##  (Assumes one dot (.) in the filename, at the extension.)
   ###############################################################

   if test "$FILENAMECROP1" = ""
   then

      FILENAMECROP1=`echo "$FILENAME" | cut -d\. -f1`

   fi

   FILENAMES="$FILENAMES \"$FILENAME\""

done
## END OF LOOP: for FILENAME


###########################################
## Prepare the output movie filename.
###########################################
   
FILEOUT="${FILENAMECROP1}_merged.$FILEEXT1"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


###########################################################################
## Use 'avimerge' to merge the movies into one movie,
## of the same type.
##
## Example:
##    avimerge -i b1.avi b2.avi b3.avi -o output.avi
##
#########################
## NOTE from the web page 
## http://superuser.com/questions/21736/
## how-to-trim-or-delete-parts-of-an-mpeg-video-from-the-linux-command-line :
##
##    Re-encoding an mpeg file if the timings are off
##
##    You may find that the timings are not very accurate because of
##    the way that mpgtx works (which is on a group of pictures, GOP, basis).
##    I have found that reencoding the mpeg at a constant bitrate leads
##    to files which then can be split very precisely with the above method.
##    A simple re-encoding call is as follows.
##
##    Re-encode at a constant bit rate of 2250k
##
##    ffmpeg -i input.mpg -b 2250k -minrate 2250k -maxrate 2250k \
##           -bufsize 1000k output.mpg
##
##    Note. ffmpeg can do much of what mpgtx can do, but the latter makes
##    it much easier to specify multiple cuts (and you can give the input
##    in start and end times, as opposed to start and durations). However,
##    ffmpeg is a great companion. I find that converting AVIs to mpeg with
##    ffmeg, then doing the splitting with mpgtx is the quickest means to
##    get the job done. 
##########################################################################

## FOR TESTING: (but the 'eval' may cause a problem in using this)
# xterm -hold -fg white -bg black -e \

# avimerge -i $FILENAMES  -o "$FILEOUT"

eval avimerge -i "$FILENAMES"  -o "$FILEOUT"
         

#########################################
## Show the new (combined) movie file.
#########################################

if test ! -f "$FILEOUT"
then
   exit
fi

# MOVIEPLAYER="/usr/bin/vlc"
# MOVIEPLAYER="/usr/bin/gnome-mplayer"
# MOVIEPLAYER="/usr/bin/smplayer"
# MOVIEPLAYER="/usr/bin/totem"

MOVIEPLAYER="/usr/bin/ffplay -stats"

xterm -fg white -bg black -hold -geometry 90x24+100+100 -e \
        $MOVIEPLAYER "$FILEOUT"

###############################################################
## Use a user-specified MOVIEPLAYER.  Someday?
###############################################################

#  . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
#  . $DIR_NautilusScripts/.set_VIEWERvars.shi

#   $MOVIEPLAYER "$FILEOUT" &
