#!/bin/sh
##
## SCRIPT: 04b_multi-jpg-files_DOWNSIZE_YPIXhigh_withOriginals_convert-resize.sh
##
## PURPOSE: Changes the size of one or more user-selected '.jpg' files.
##
##       The new, downsized files are put in the current directory,
##       with the originals.
##
##       This script is oriented toward the case of wanting to DOWNSIZE
##       a batch of 'oversized' *'.jpg'* files, like files from a digital
##       camera, that were put in one directory. This script deals with
##       the case where we want to put the DOWNSIZED files in the same
##       directory as the originals.
##          
## METHOD:  Uses 'zenity' to prompt the user for a Y-size (in pixels)
##          to use for all the selected files.
##
##          Uses ImageMagick 'convert' with '-resize' and '-quality 100'
##          to do the resizing.
##
##          Puts the new files in the 'current' directory.
##             (The user can move the new files or the originals
##              later, if he/she wishes.)
##
## QUALITY NOTE: You could up-size files with this script, but that
##               usually results in loss of quality.
##
## HOW TO USE: In the Nautilus file manager, navigate to the desired directory
##             and select one or more image files --- currently restricted
##             to '.jpg' files, but this restriction could easily be lifted
##             by commenting out an if-then section below.
##             Then right-click and select this script to run (name above).
##
## Created: 2012jan23 Based on script
##                    '04_multiDOWNSIZE_4jpgFiles_YPIXhigh_INPLACE_originals2newDir'.
## Changed: 2012feb29 Changed the script name in the comment above.

## FOR TESTING: (show statements as they execute)
# set -x


##################################################
## Get the Y-height for the new sized image files. 
##################################################

YPIXELS=""

YPIXELS=$(zenity --entry \
   --title "Y-RESIZE '.jpg' image files. (Put new files in dir with originals.)" \
   --text "\
Enter the Y-PIXEL-SIZE for the output image file(s).

Typically a max of about 450 to 650 pixels, to fit in a web-browser or mail-reader window.

(Generally, do not up-size. Quality of output file(s) will probably be unsatisfactory.)" \
   --entry-text "600")

if test "$YPIXELS" = ""
then
   exit
fi


####################################
## START THE LOOP on the filenames.
####################################

for FILENAME
do

   ########################################
   ## Check that the file is a 'jpg' file.
   ## If not, skip it.
   ##    We may want to comment this check.
   ########################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   if test "$FILEEXT" != "jpg" 
   then 
      continue
      # exit
   fi


   ###############################################
   ## Make the output filename from $FILENAME.
   ###############################################

   FILEMIDNAME=`echo "$FILENAME" | cut -d\. -f1`

   OUTFILE="${FILEMIDNAME}_x${YPIXELS}.$FILEEXT"


   ###############################################
   ## Use 'convert' to make the resized jpg file.
   ###############################################
   
   convert "$FILENAME" -resize x$YPIXELS -quality 100 "$OUTFILE"


   #####################################################################
   ## Rename the resized jpg file to have the new size in the filename
   ## --- in the form XXXxYYY.
   ## 
   ## Remove a string of the form MMMxNNN, like the size of the original
   ## file, in the original filename, $FILENAME --- and if the newly
   ## built output filename does not conflict with an existing file,
   ## rename to the new name.      
   #####################################################################

   IMGSIZE=`identify "$OUTFILE" | awk '{print $3}'`

   ## Strip off a string of the form '_MMM...xNNN...'
   ## from the original input filename, $FILENAME.
   FILENAMECROP=`echo "$FILENAME" | sed 's|_[0-9][0-9]*x[0-9][0-9]*||'`

   ## Strip off the '.jpg' suffix from FILENAMECROP.
   FILENAMECROP=`echo "$FILENAMECROP" | sed 's|\.jpg$||'`

   NEWFILENAME="${FILENAMECROP}_${IMGSIZE}.jpg"

   if test ! -f "$NEWFILENAME"
   then
      mv "$OUTFILE" "$NEWFILENAME"
   fi

done
## END OF LOOP:  for FILENAME
