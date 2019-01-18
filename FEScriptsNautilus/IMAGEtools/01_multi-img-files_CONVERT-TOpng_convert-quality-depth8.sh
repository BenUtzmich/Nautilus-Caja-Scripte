#!/bin/sh
##
## Nautilus
## SCRIPT: 01_multi-img-files_CONVERT-TOpng_convert-quality-depth8.sh
##
## PURPOSE: For a selected set of image files --- '.jpg', '.png', '.gif' or
##          whatever, converts them to '.png' files --- with a
##          quality/compression factor applied --- and '-depth 8'.
##
## METHOD:  Uses 'zenity --entry' to ask user for a quality number.
##
##          Uses 'zenity --entry' to prompt for the number --- which is
##          2 digits of the form {compression-type/level}{filter}.
##
##          The first digit (tens) is the zlib compression level, 1-9.
##          However if a setting of '0' is used you will get Huffman
##          compression rather than 'zlib' compression, which is often better!
##
##          The second digit is the PNG data encoding filtering (before it
##          is comressed) type: 0 is none, 1 is "sub", 2 is "up",
##          3 is "average", 4 is "Paeth", and 5 is "adaptive".
##
##          FOR IMAGES WITH SOLID SEQUENCES OF COLOR, a "none" filter
##          (and Huffman compression) (-quality 00) is typically better.
##
##          FOR IMAGES OF NATURAL LANDSCAPES an "adaptive" filtering,
##          (-quality 05) is claimed to be better.
##
##          Puts the new '.png' files in the directory with the selected
##          image files.
##
## REFERENCES:
##    http://www.imagemagick.org/Usage/formats/#png
##
## HOW TO USE: In Nautilus, select one or more image files.
##             Then right-click and choose this script to run (name above).
##
###########################################################################
## MAINTENANCE HISTORY:
## Created: 2014jun26 Based on the quite similar script to make JPEG files:
##                01_multi-img-files_CONVERT-TOjpg_convert-quality-prompt.sh
## Changed: 2015mar06 Add the '-depth 8' option.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x


#####################################################
## Get the 'quality' factor for the output PNG files.
#####################################################

QUAL=""

QUAL=$(zenity --entry \
   --title "Enter a QUALITY/COMPRESSION number (like 00 or 05)." \
   --text "\
Enter the PNG quality number.

** 00 is recommended for images with mostly AREAS OF SOLID COLORS.
** 05 is recommended for images like NATURAL LANDSCAPES.
** 00 and 90 seem to give small file sizes with good quality.

   The first digit (tens) is the zlib compression level, 1-9.
   However if a setting of '0' is used you will get Huffman
   compression rather than 'zlib' compression, which is often better!

   The second digit is the PNG data encoding filtering type (before
   the data is compressed):    0 is none, 1 is 'sub', 2 is 'up',
   3 is 'average', 4 is 'Paeth', and 5 is 'adaptive'.

Reference: http://www.imagemagick.org/Usage/formats/#png
" \
   --entry-text "00")

if test "$QUAL" = ""
then
   exit
fi



####################################
## START THE LOOP on the filenames.
####################################

for FILENAME
do

   ###########################################################
   ## Get the file extension.
   ##    Assumes one dot (.) in the filename, at the extension.
   ## COMMENTED, for now.
   ###########################################################

   # FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   ###########################################################
   ## Check that the file extension is 'png'.
   ##   Assumes one dot (.) in the filename, at the extension.
   ## COMMENTED, for now.
   ###########################################################
 
   ## if test "$FILEEXT" != "png"
   ## then
   ##    continue 
   ##    #  exit
   ## fi


   ###########################################################
   ## Get the 'midname' of the filename --- by stripping
   ## the file extension.
   ##    Assumes one dot (.) in the filename, at the extension.
   ###########################################################

   # FILEMIDNAME=`echo "$FILENAME" | sed 's|\..*$||'`
   FILEMIDNAME=`echo "$FILENAME" | cut -d\. -f1`


   ##############################################################
   ## Make the name of the output '.png' file. If the file
   ## already exists, skip processing this file.
   ## (We could use 'zenity --info' to pop a notice to the user.)
   ##############################################################

   OUTFILE="${FILEMIDNAME}_CompressType${QUAL}_depth8.png"

   if test -f "$OUTFILE"
   then
      continue 
      #  exit
   fi


   #####################################################
   ## Use 'convert' to make the depth-8 'png' file.
   #####################################################

   convert "$FILENAME" -quality $QUAL -depth 8 "$OUTFILE"


done
## END OF 'for FILENAME' loop


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
