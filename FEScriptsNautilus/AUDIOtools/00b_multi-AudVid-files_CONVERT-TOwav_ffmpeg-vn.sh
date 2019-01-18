#!/bin/sh
##
## Nautilus
## SCRIPT: 00b_multi-AudVid-files_CONVERT_TOwav_ffmpeg-vn.sh
##
## PURPOSE: To convert selected media files --- such as '.mp3' or '.ogg'
##          audio file(s) --- to '.wav' audio file(s).
##          (Might also work on input movie files.) 
##
## METHOD:  Uses 'ffmpeg -vn', in a loop on filenames.
##
##          The user should see the '.wav' files popping up in the
##          'current' directory.
##
## HOW-TO-USE: Using the Nautilus file manager,
##             navigate to a directory of audio or video files.
##             Then select the files from which the audio is to be
##             extracted or converted.
##             Then right-click and choose this script to run (name above).
##
###########################################################################
## Created: 2010oct04
## Changed: 2011jun24 Remove check for '.wav' suffix on input file.
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2011feb28 Changed the scriptname, in the comment above.
##                    Added the 'HOW-TO-USE' comments section above.
##                    Added to the 'METHOD' comments section above.
## Changed: 2013apr10 Added check for the ffmpeg executable.
###########################################################################

## FOR TESTING: (turn ON display of executed statements)
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
you can edit this script to change the filename."
   exit
fi


###########################################
## START THE LOOP on the filenames.
###########################################

for FILENAME
do

   #########################################################
   ## Check that the selected file is a 'mp3' or 'ogg' file.
   ## 
   ##  Assumes one period in filename, at extension.
   ##
   ## ## COMMENTED ## check for now --- to try this
   ## script on media files (movies as well as audio).
   ########################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
   #  if test "$FILEEXT" != "mp3" -a  "$FILEEXT" != "ogg"
   #  then
   #     continue
   #     # exit
   #  fi


   ########################################################
   ## Make the output 'wav' filename.
   ########################################################

   FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`

   FILEOUT="${FILENAMECROP}.wav"


   ########################################################
   ## Use 'ffmpeg' to make the 'wav' file --- high-quality.
   ########################################################

   # ffmpeg -i "$FILENAME" -ab 192k -ar 44100 -vn \
   #       -y "$FILEOUT"

   $EXE_FULLNAME -i "$FILENAME" -ab 192k -ar 44100 -vn \
          -y "$FILEOUT"

   ## If necessary use '-acode' parm, like '-acode pcm_s16le'.

   ## Could try '-threads 0' to use all processors.

done
## END of LOOP:  for FILENAME

exit

################################################################
## Meaning of the ffmpeg parms:
##
## -i  val = input filename
## -ab val = audio bitrate in k?bits/sec (default = 64 kbps)
## -ar val = audio sampling frequency in Hz (default = 44100 Hz)
## -r  val = frame rate in frames/sec
## -b  val = video bitrate in kbits/sec (default = 200 kbps)
## -s  val = frame size, wxh where w and h are pixels or abbrevs:
##          qqvga =  160x120
##           qvga =  320x240
##            vga =  640x480
##           svga =  800x600
##            xga = 1024x768
##           sxga = 1280x1024
##           uxga = 1600x1200
##               
## Some other useful params:
## 
## Video:
##   -aspect (4:3, 16:9 or 1.3333, 1.7777)
##   -croptop pixels
##   -cropbottom pixels
##   -cropleft pixels
##   -cropright pixels
##   -padtop (bottom, left, right)
##   -padcolor <6 digit hex number>
##   -vn - disable video recording
##   -y  = overwrite output file(s)
##   -t duration - format is hh:mm:ss[.xxx]
##   -fs file-size-limit
##   -ss position - seek to given position, in secs or hh:mm:ss[.xxx]
##   -target type - where type is vcd or svcd or dvd or ..., then
##    bitrate, codecs, buffersizes are set automatically.
##   -vcodec codec - to force the video codec.
##                   Example: -vcodec mpeg4 
##                   Try  "ffmpeg -formats"
##   -pass n, where n is 1 or 2
##
## Audio:
##   -ac channels - default = 1
##   -an - disable audio recording
##   -acode codec - to force the audio codec. Example:
##                                      -acodec libmp3lame
## Other:
##   -debug
##   -threads count
##
####################################################################
