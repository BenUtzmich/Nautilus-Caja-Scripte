#!/bin/sh
##
## Nautilus
## SCRIPT: 00_multi-img-files_CONVERT_TOjpg_convert-quality-strip-enhance.sh
##
## PURPOSE: Converts a selected set of image files --- '.png' or '.gif'
##          or whatever --- to '.jpg' files. Can also be used to further
##          compress '.jpg' files.
##
## METHOD:  Uses ImageMagick 'convert' with options '-quality ##', '-strip',
##          '-enhance', and '+dither'.
##
##          Uses 'zenity' to ask user for 'quality factor' --- recommended
##          between 80 and 100 (for less than 80, 'mosquito noise' appears).
##
##          Shows the (last) new image file in an image viewer (or editor)
##          of the user's choice.
##
##          Accrding to http://www.imagemagick.org/script/convert.php,
##          '-enhance' is used to
##          "apply a digital filter to enhance a noisy image".
##
##          NOTE: If '-enhance' proves to be ineffective (a no-operation
##                on JPEG files), this utility may be changed to use a
##                different 'convert' option, in place of '-enhance'.
##                Other possibilities: '-contrast' or '-sharpen' or '-blur'
##
## HOW TO USE: In the Nautilus file manager, navigate to the desired directory
##             and select one or more image files.
##             Then right-click and choose this script to run (name above).
##
## REFERENCES:
##        http://www.imagemagick.org/Usage/formats/#jpg
##    and
##        http://superuser.com/questions/370920/auto-image-enhance-for-ubuntu
##        recommends options '-enhance -equalize -contrast', but one user
##        suggests just '-enhance -contrast'.
##    and
##        http://www.imagemagick.org/discourse-server/viewtopic.php?t=23711
##        points out that multiple iterations of '-enhance' can be used,
##        such as 5 iterations: '-enhance -enhance -enhance -enhance -enhance'
##########################################################################
## Created: 2014jun26 To add a quality prompt to the script
##                    '00_multi-img-files_CONVERT_TOjpg_convert-quality-100.sh'
## Changed: 2014jun30 Added '-strip' & '+dither' & '-enhance'  to the
##                    'convert' command.
## Changed: 2014nov19 Added some info on '-strip' and '-quality' to a
##                    zenity command.
##########################################################################

## FOR TESTING: (show statements as they execute)
#  set -x

#########################################################
## Check if the convert executable exists.
#########################################################

EXE_FULLNAME="/usr/bin/convert"

if test ! -f "$EXE_FULLNAME"
then
   zenity  --info --title "Executable NOT FOUND." \
   --no-wrap \
   --text  "\
The convert executable
   $EXE_FULLNAME
was not found. Exiting.

If the executable is in another location,
you can edit this script to change the filename.
OR, install the ImageMagick package."
   exit
fi

#####################################################
## Get the 'quality' factor for the output JPEG files.
#####################################################
## FROM:
## http://www.imagemagick.org/discourse-server/viewtopic.php?f=1&t=21934&p=93593
##
## No downsampling is used when quality is 91 or more.
## For lower values of quality, the U and V channels are
## downsampled by a factor of 2. You can override that
## default behaviour with "-define jpeg:sampling-factor=...".
## Look at "-define" and "-quality" on the Commandline-Tools/Options page.
########################################################################

QUAL=""

QUAL=`zenity --entry \
   --title "Enter a QUALITY factor (80 - 100)." \
   --text "\
Enter the JPEG quality factor. (Lower results in more compression.)
Recommended between 80 and 100.
For less than 80, 'mosquito noise' becomes apparent.

Reference: http://www.imagemagick.org/Usage/formats/#jpg

This utility uses the '-strip' option of the 'convert'
command, to strip out text data, like EXIF data, from
the output '.jpg' file.
" \
   --entry-text "100"`

if test "$QUAL" = ""
then
   exit
fi


###################################
## START THE LOOP on the filenames.
###################################

for FILENAME
do

   ###########################################################
   ## Get the file extension, such as 'png' or 'gif'.
   ##   Assumes one dot (.) in the filename, at the extension.
   ###########################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   ###########################################################
   ## Check that the file extension is 'png' or 'gif'.
   ## COMMENTED for now. Instead we allow any image file type.
   ###########################################################

   # if test "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
   # then
   #    continue 
   #    #  exit
   # fi


   ###########################################################
   ## Get the 'midname' of the filename by removing the
   ## extension --- such as '.png' or '.gif'.
   ##   Assumes one dot (.) in the filename, at the extension.
   ###########################################################

   # FILENAMECROP=`echo "$FILENAME" | sed 's|\..*$||'`

   FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`


   ##############################################################
   ## Make the name of the output '.jpg' file. If the file
   ## already exists, skip processing this file.
   ## (We could use 'zenity --info' to pop a notice to the user.)
   ##############################################################

   OUTFILE="${FILENAMECROP}_Quality${QUAL}_Stripped_Enhance.jpg"

   if test -f "$OUTFILE"
   then
      continue 
      #  exit
   fi


   ########################################################################
   ## Use 'convert' to make the 'jpg' file --- with '-quality', '-strip',
   ## '+dither', and '-enhance' parameters.
   ########################################################################
   ## NOTE: '+dither' is used to try to make sure that 'convert' does not
   ## try to dither the image, as it seems to do by default in many cases,
   ## especially when creating a '.gif' file.
   ########################################################################
   ## FROM:
   ## http://www.imagemagick.org/discourse-server/viewtopic.php?t=21934
   ## we see we might want to add '-colorspace RGB'.
   ## This might handle input image files in CMYK color format.
   ########################################################################

   $EXE_FULLNAME "$FILENAME" -quality $QUAL -strip +dither -enhance "$OUTFILE"

done
## END OF LOOP: for FILENAME


#############################################################
## Show the LAST new image file.
## NOTE: The viewer may be able to go back through the other
##       image files if multiple image files were resized.
#############################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &

# $IMGEDITOR "$OUTFILE" &
