#!/bin/sh
##
## Nautilus
## SCRIPT: 06_multi-jpg-png-gif-files_toTHUMBSjpg_YPIXhigh_2thumbsDIR_convert-resize.sh
##
## PURPOSE: Makes '.jpg' 'thumbnail' files for a set of selected image files
##          --- '.jpg' or '.png' or '.gif'.
##
##          Puts the new 'thumbnail' files into a subdirectory named 'thumbs'
##          in the 'current' directory.
##
## METHOD:  Uses 'zenity' to prompt the user for a Y-height (in pixels)
##          to use to make thumbnail files of all the selected image files.
##
##          Uses ImageMagick 'convert -resize' with '-quality 100' to
##          make all the thumbnails that height.
##
##          Inserts '_thumb' in the original filename, before the extension
##          --- '.jpg' or '.png' or '.gif' --- to get the thumbnail filename.
##
##          Example: joe_640x423.jpg        yields thumbnail file
##                   joe_640x423_thumb.jpg
##
##          Puts the thumbnails into a (new) 'thumbs' subdirectory of the
##          current directory.
##
## HOW TO USE: In the Nautilus file manager, navigate to the desired directory
##             and select one or more image files --- currently restricted
##             to '.jpg' or '.png' or '.gif' files, but this restriction
##             could be lifted by commenting out an if-then section below
##             and dealing with the insertion of '_thumb' before the file
##             extension.
##             Then right-click and select this script to run (name above).
##
## Created: 2010feb17
## Changed: 2010mar30 To allow for creating jpg-thumbs from png and gif files,
##                    as well as from jpg files.
## Changed: 2010apr01 Added zenity prompt for Y-size.
## Changed: 2010apr06 Added exit if Y-size is null, as on zenity Cancel.
## Changed: 2011apr12 Added a note on the zenity prompt to indicate that
##                    thumb files will go into a 'thumbs' subdirectory.
## Changed: 2012jan23 Added '_2thumbsDIR' to script name. Also,
##                    changed to use the 'for-loop-without-in' technique
##                    to handle filenames with embedded spaces.
## Changed: 2012feb29 Changed the script name in the comment above.

## FOR TESTING: (show statements as they execute)
# set -x


###################################################################
## Get the filenames of the selected files.
##   COMMENTED. Instead, we use the 'for-loop-without-in' technique
##              in the 'for' loop below.
###################################################################

#   FILENAMES="$@"
##  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
##  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"


####################################################
## Make the 'thumbs' directory, if needed, in curdir
####################################################

if test ! -d thumbs
then
     mkdir thumbs
fi


###################################
## Get the Y-height for the thumbs. 
###################################

YPIXELS=""

YPIXELS=$(zenity --entry \
   --title "Enter Y-size." \
   --text "\
Enter the Y-pixel-size for the thumbs.

      Typically 60 or 90 pixels for small thumbs.

The thumbnail files will be put in a 'thumbs' subdirectory
of the current directory." \
   --entry-text "60")

if test "$YPIXELS" = ""
then
   exit
fi


####################################################
## START THE LOOP on the filenames.
##
## NOTE: We use the 'for-loop-without-in' technique.
####################################################

# for FILENAME in $FILENAMES

for FILENAME
do

   #########################################################
   ## Check that the file is a 'jpg' or 'png' or 'gif' file.
   ## If not, skip it.
   ##   Assumes there is only one period (.) in the filename,
   ##   at the filename extension.
   ##       We may want to comment this if-then check, someday.
   #########################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
   then
      continue
      # exit
   fi


  ##################################################
  ## Use 'convert' with '-resize' to make the thumb.
  ##################################################

  ## This could be used if we drop the check for jpg/png/gif
  ## as the allowed file extensions.
  # FILENAMECROP=`echo "$FILENAME" | sed 's|\..*$||'`

  FILENAMECROP=`echo "$FILENAME" | sed 's|\.jpg$||' |  sed 's|\.png$||' | sed 's|\.gif$||'`
   
  convert "$FILENAME" -resize x$YPIXELS -quality 100 \
          "./thumbs/${FILENAMECROP}_thumb.jpg"

done
## END OF LOOP:  for FILENAME
