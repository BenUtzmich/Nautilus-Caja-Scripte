#!/bin/sh
##
## Nautilus
## SCRIPT: 00_multi-img-files_CONVERT_TOjpg_convert-quality-strip.sh
##
## PURPOSE: Converts a selected set of image files --- '.png' or '.gif'
##          or whatever --- to '.jpg' files.
##
## METHOD:  Uses ImageMagick 'convert' with options '-quality', '-strip',
##          and '+dither'.
##
##          Uses 'zenity' to ask user for 'quality factor' --- recommended
##          between 80 and 100. For less than 80, 'mosquito noise' appears.
##
##          Shows the (last) new image file in an image viewer (or editor)
##          of the user's choice.
##
## HOW TO USE: In the Nautilus file manager, navigate to the desired directory
##             and select one or more image files.
##             Then right-click and choose this script to run (name above).
##
## REFERENCES:
##        http://www.imagemagick.org/Usage/formats/#jpg
##########################################################################
## Created: 2014jun26 To add a quality prompt to the script
##                    '00_multi-img-files_CONVERT_TOjpg_convert-quality-100.sh'
## Changed: 2014jun30 Added '+dither'to the 'convert' command.
## Changed: 2014jul16 Added '-strip'.
## Changed: 2014nov14 Changed the ending of the name of this script.
## Changed: 2014nov19 Added some info on '-strip' to the zenity command.
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
   ## Make the name of the output '.jpg' file.
   ## If the file already exists, remove it.
   ## If the file already exists, we could skip processing this file.
   ## (We could use 'zenity --info' to pop a notice to the user.)
   ##############################################################

   OUTFILE="${FILENAMECROP}_Quality${QUAL}_Stripped.jpg"


   rm - f "$OUTFILE"

   # if test -f "$OUTFILE"
   # then
   #    continue 
   #    #  exit
   # fi


   ########################################################################
   ## Use 'convert' to make the '.jpg' file --- with '-quality', '-strip',
   ## and '+dither'.
   ########################################################################
   ## For info on '-strip', SEE
   ## http://www.imagemagick.org/Usage/formats/#jpg_read
   ########################################################################
   ## NOTE: '+dither' is used to try to make sure that 'convert' does not
   ## try to dither the image, as it seems to do by default in many cases,
   ## especially when creating a '.gif' file.
   ########################################################################

   $EXE_FULLNAME "$FILENAME" -strip +dither -quality $QUAL "$OUTFILE"

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
