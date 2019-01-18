#!/bin/sh
##
## Nautilus
## SCRIPT: 00_multi-img-files_CONVERT_TOpdf_convert-colorspace-CMYK.sh
##
## PURPOSE: Converts a selected set of image files --- '.png' or '.gif'
##          or '.jpg' or whatever --- to '.pdf' image files.
##
## METHOD:  Uses ImageMagick 'convert' with option '-colorspace CMYK'.
##
##          Shows the (last) new image file in a PDF viewer
##          of the user's choice.
##
## HOW TO USE: In the Nautilus file manager, navigate to the desired directory
##             and select one or more image files.
##             Then right-click and choose this script to run (name above).
##
## REFERENCES:
## http://tex.stackexchange.com/questions/48101/how-do-i-make-sure-images-are-cmyk
## http://www.linuxquestions.org/questions/blog/the-dsc-472367/gruesome-pdf-to-jpg-converter-script-35978/
##########################################################################
## Created: 2014nov14 
## Changed: 2014 
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
   ## Check that the file extension is 'png' or 'gif' or 'jpg'.
   ## COMMENTED for now. Instead we allow any image file type.
   ###########################################################

   # if test "$FILEEXT" != "png" -a "$FILEEXT" != "gif" \
   #   -a "$FILEEXT" != "jpg"
   # then
   #    continue 
   #    #  exit
   # fi


   ###########################################################
   ## Get the 'midname' of the filename by removing the
   ## extension --- such as '.png' or '.gif' or '.jpg'.
   ##   Assumes one dot (.) in the filename, at the extension.
   ###########################################################

   # FILENAMECROP=`echo "$FILENAME" | sed 's|\..*$||'`

   FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`


   ##############################################################
   ## Make the name of the output '.pdf' file. If the file
   ## already exists, skip processing this file.
   ## (We could use 'zenity --info' to pop a notice to the user.)
   ##############################################################

   OUTFILE="${FILENAMECROP}_CMYK.pdf"

   if test -f "$OUTFILE"
   then
      continue 
      #  exit
   fi


   ########################################################################
   ## Use 'convert' to make the 'pdf' file.
   ########################################################################

   $EXE_FULLNAME "$FILENAME" -colorspace CMYK "$OUTFILE"

   ## ALTERNATIVES TO TRY:

   # $EXE_FULLNAME "$FILENAME"  -colorspace CMYK -strip \
   #   -sampling-factor 1x1 -quality 100 -compress JPEG "$OUTFILE"

   # $EXE_FULLNAME "$FILENAME" +profile "*" -profile "path/to/rgb.icc" \
   #   -profile "path/to/cmyk.icc" -strip -sampling-factor 1x1 \
   #   -quality 100 -compress JPEG  "$OUTFILE"

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

$PDFVIEWER "$OUTFILE" &
