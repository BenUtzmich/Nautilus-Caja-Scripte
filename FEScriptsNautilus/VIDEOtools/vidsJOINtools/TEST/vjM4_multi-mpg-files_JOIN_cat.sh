#!/bin/sh
##
## Nautilus
## SCRIPT: vjM4_multi-mpg-files_JOIN_cat.sh
##
## PURPOSE: Merges several '.mpg' movies (of the same type, like mpeg2
##          and image size, etc.) into ONE movie, of type mpeg ---
##          using 'cat'.
##
## METHOD:  In a 'for' loop, puts the selected movie filenames in a string
##          --- space-separated and each filename in double-quotes.
##
##          Passes the string of selected filenames to 'eval cat'.
##
##          Shows the output movie with a movie player.
##
## REFERENCES:
##       http://ffmpeg.org/faq.html#SEC27
##       talks about a way to 'cat' videos together.
##            "A few multimedia containers (MPEG-1, MPEG-2 PS, DV) allow
##            one to join video files by merely concatenating them."
##   OR 
##       http://www.arsgeek.com/2006/08/07/how-to-join-multiple-avi-or-mpg-files/
##       gives an example of putting together '.avi' files ---
##       using two commands --- cat and mencoder:
##
##           cat  b1.avi  b2.avi  b3.avi  b4.avi  >  bloodspell.avi
##
##       Stringing together .avi files can cause a breakdown in the sync between
##       video and sound. So, we will use mencoder to sort things out.
##
##           mencoder -forceidx -oac copy -ovc copy -of avi \
##                     bloodspell.avi -o bloodspell_final.avi
##   OR
##       do a web search on keywords such as '(join|merge) movie files cat'.
##
##
## HOW TO USE: In Nautilus, select one or more '.mpg' movie files (of the same
##             video-audio encoding. (Can use the Ctl or Shift
##             keys to select multiple files.)
##             Then right-click and choose this VIDEOtools script to run
##             (name above).
##
##############################################################################
## Created: 2011apr20
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of 'in $FILENAMES' and we use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2011dec13 Touched up some comments on the possible need to
##                    use 'mencoder -forceidx'.
## Changed: 2012may24 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (display commands that are executed)
# set -x


############################################################
## LOOP thru the selected files.
## 1) Save the file extension of the first file.
## 2) Make sure they all have a common extension (type).
##        (May have to check for certain types, like 'mpg',
##         supported by 'cat'/'mencoder'.)
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
## END OF 'for FILENAME' loop.


###########################################
## Prepare the output movie filename.
###########################################
   
FILEOUT="${FILENAMECROP1}_mergedBYcat.$FILEEXT1"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


###########################################################################
## Use 'cat' to merge the mpeg (.mpg) movies into one movie.
##########################################################################

## FOR TESTING: (the 'eval' may cause a problem in using this)
# xterm -hold -fg white -bg black -e \

eval cat "$FILENAMES"  "$FILEOUT"

## NOTE --- may need to fix the index with mencoder. Example:
##
# mencoder -forceidx -oac copy -ovc copy  -of mpeg \
#          "$FILEOUT" -o "${FILEOUT}_NEWidx"


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
