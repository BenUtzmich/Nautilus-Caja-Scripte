#!/bin/sh
##
## Nautilus
## SCRIPT: 00_multi-img-files_CONVERT_TOjpg_convert-quality-strip.sh
##
## PURPOSE: Converts a selected set of image files --- '.png' or '.gif'
##          or whatever --- to '.jpg' files.
##
## METHOD:  Uses ImageMagick 'convert' with option '-quality'.
##
##          Uses 'zenity' to ask user for 'quality factor' --- recommended
##          between 80 and 100 (no less than 80, quality suffers).
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
## Changed: 2014nov14 Added '-strip' to 'convert' command, and added to
##                    the end of the name of this script.
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
## http://www.imagemagick.org/script/formats.php
##
## Note, JPEG is a lossy compression. In addition, you cannot create
## black and white images with JPEG nor can you save transparency.
##
## Requires jpegsrc.v8c.tar.gz. *** You can set quality scaling for
## luminance and chrominance separately (e.g. -quality 90,70). ***
## You can optionally define the DCT method, for example to specify the
## float method, use -define jpeg:dct-method=float. By default we compute
## optimal Huffman coding tables. Specify -define jpeg:optimize-coding=false
## to use the default Huffman tables. Two other options include
## -define jpeg:block-smoothing and -define jpeg:fancy-upsampling.
## Set the sampling factor with -define jpeg:sampling-factor. 
########################################################################

QUAL=""

QUAL=`zenity --entry \
   --title "Enter a QUALITY factor (80 - 100)." \
   --text "\
Enter the JPEG quality factor. (Lower results in more compression.)
(Recommended between 80 and 100.
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

   OUTFILE="${FILENAMECROP}_Quality${QUAL}_Stripped.jpg"

   if test -f "$OUTFILE"
   then
      continue 
      #  exit
   fi


   ########################################################################
   ## Use 'convert' to make the 'jpg' file --- with '-quality' and
   ## '-strip' and '+dither' options.
   ########################################################################
   ## We use '-strip' to remove profiles and comments, to reduce filesize
   ## by about 120 KB (?) typically, for JPEG files.
   ## REFERENCE: http://www.imagemagick.org/Usage/formats/#jpg_read
   ########################################################################
   ## NOTE: '+dither' is used to try to make sure that 'convert' does not
   ## try to dither the image, as it seems to do by default in many cases,
   ## especially when creating a '.gif' file.
   ########################################################################
   ## FROM:
   ## http://www.imagemagick.org/discourse-server/viewtopic.php?t=21934
   ## we see we might want to add '-colorspace RGB'.
   ########################################################################

   $EXE_FULLNAME "$FILENAME" -strip +dither -quality $QUAL "$OUTFILE"

   ## COULD TRY the following to reduce 'mosquito noise' for quality < 91.

   ## REFERENCE ON '-sampling-factor 1x1':
   ## http://www.sitepoint.com/forums/showthread.php?310644-Looking-for-better-JPEG-compression-in-PHP-than-GD-offers
   ## REFERENCE ON '-filter':
   ## http://dpzen.com/node/1164715

   # $EXE_FULLNAME "$FILENAME" -strip +dither -quality $QUAL \
   #   -filter Mitchell -sampling-factor 1x1 "$OUTFILE"
   ## Could try Catrom or Cubic or Lanczos for '-filter'.

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
