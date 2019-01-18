#!/bin/sh
##
## Nautilus
## SCRIPT: 00_multi-img-files_REMOVEtext_convert-strip.sh
##
## PURPOSE: Reads each of a selected set of image files --- '.jpg' or
##          even '.png' or '.gif' or whatever --- and makes a new
##          file from each file with text-removed via the '-strip'
##          option of the Imagemagick 'convert' command.
##
##          Mainly intended to strip EXIF data from JPEG files.
##
## METHOD:  Uses ImageMagick 'convert' with option '-strip'.
##
##          No need to use 'zenity' to ask user for a parameter.
##
##          Shows the (last) new image file in an image viewer (or editor)
##          of the user's choice.
##
## HOW TO USE: In the Nautilus file manager, navigate to the desired directory
##             and select one or more image files.
##             Then right-click and choose this script to run (name above).
##
## REFERENCES:
##         http://www.imagemagick.org/Usage/formats/#jpg_read
##########################################################################
## Created: 2014nov14 Based on some 'multi-img-files_CONVERT_TO' scripts.
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
   ## Check that the file extension is 'jpg'.
   ## COMMENTED for now. Instead we allow any image file type.
   ###########################################################

   # if test "$FILEEXT" != "jpg"
   # then
   #    continue 
   #    #  exit
   # fi


   ###########################################################
   ## Get the 'midname' of the filename by removing the
   ## extension --- such as '.jpg', '.png' or '.gif'.
   ##   Assumes one dot (.) in the filename, at the extension.
   ###########################################################

   # FILENAMECROP=`echo "$FILENAME" | sed 's|\..*$||'`

   FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`


   ##############################################################
   ## Make the name of the output '.jpg' file. If the file
   ## already exists, skip processing this file.
   ## (We could use 'zenity --info' to pop a notice to the user.)
   ##############################################################

   OUTFILE="${FILENAMECROP}_Stripped.$FILEEXT"

   if test -f "$OUTFILE"
   then
      continue 
      #  exit
   fi


   ########################################################################
   ## Use 'convert' to make the image file --- with '-strip' parm.
   ########################################################################
   ## We use '-strip' to remove profiles and comments, to reduce filesize
   ## by about 120 KB (?) typically, for JPEG files.
   ## REFERENCE: http://www.imagemagick.org/Usage/formats/#jpg_read
   ########################################################################

   $EXE_FULLNAME "$FILENAME" -strip "$OUTFILE"

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
