#!/bin/sh
##
## Nautilus
## SCRIPT: 02_multi-wav-files_MERGE_sox.sh
##
## PURPOSE: Merges several user-selected audio files (.wav) into
##          ONE audio file (.wav), using 'sox'.
##
## METHOD: Loops through the selected files to build an output filename
##         based on the midnames of the selected files.
##
##         (Also the loop checks that the selected files are '.wav' files.)
##
##         Uses 'sox' to merge the selected files.
##
## HOW TO USE: In the Nautilus file manager, navigate to directory and
##             select a set of '.wav' files.
##             Then right-click and choose this nautilus script to run
##             (name above). 
##
## REFERENCE: http://fixunix.com/ubuntu/126724-merge-wav-files-mplayer.html
##
###########################################################################
## Created: 2010oct04
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and use a 'for' loop
##                     WITHOUT the 'in' phrase.  Use "$@" to pass all the
##                     filenames in to 'sox'.  Ref: man bash )
## Changed: 2012feb29 Changed the script name in the comment above.
##                    Added the METHOD comments section above.
## Changed: 2013apr10 Added check for the sox executable. 
###########################################################################

## FOR TESTING: (turn ON display of executed statements)
# set -x

#########################################################
## Check if the sox executable exists.
#########################################################

EXE_FULLNAME="/usr/bin/sox"

if test ! -f "$EXE_FULLNAME"
then
   zenity  --info --title "Executable NOT FOUND." \
   --no-wrap \
   --text  "\
The sox executable
   $EXE_FULLNAME
was not found. Exiting."
   exit
fi


#################################################################
## LOOP thru the selected files.
## 1) Check that the file extension of each file is '.wav'.
## 2) Add the 'middle-name' of each file to form a new 'midname'.
#################################################################

NEWMIDNAME=""

for FILENAME
do

   ############################################################
   ## Get the file extension of the file.
   ##  (Assumes one dot (.) in the filename, at the extension.)
   ############################################################
   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   ###############################################
   ## If the file extension is not 'wav', exit.
   ###############################################

   if test "$FILEEXT" != "wav"
   then 

      JUNK=`zenity -- question --title "Merge Audio Files: EXITING" \
      --text "\
The audio files do not seem to be all of type '.wav' ---
at least one does not have that file extension:

$FILENAME

EXITING ...."`

     exit
   fi

   ###############################################################
   ## Add the file 'middle-name' to NEWMIDNAME.
   ##  (Assumes one dot (.) in the filename, at the extension.)
   ###############################################################

   FILEMIDNAME=`echo "$FILENAME" | cut -d\. -f1`

   NEWMIDNAME="${NEWMIDNAME}_$FILEMIDNAME"

done
## END OF looping thru the selected files.


#####################################
## Prepare the output audio filename.
#####################################
   
OUTFILE="${NEWMIDNAME}_MERGED.wav"

if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


###########################################################
## Use 'sox' to merge the audio files into one audio file.
###########################################################

## FOR TESTING:
# xterm -hold -e \

# sox "$@" "$OUTFILE"

$EXE_FULLNAME "$@" "$OUTFILE"


#######################################
## Play the new (combined) audio file.
#######################################

if test ! -f "$OUTFILE"
then
   exit
fi

# gnome-mplayer  "$OUTFILE"

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$AUDIOPLAYER "$OUTFILE" &

