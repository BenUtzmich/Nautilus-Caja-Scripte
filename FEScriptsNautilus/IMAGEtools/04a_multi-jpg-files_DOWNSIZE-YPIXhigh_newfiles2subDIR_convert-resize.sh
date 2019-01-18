#!/bin/sh
##
## Nautilus
## SCRIPT: 04a_multi-jpg-files_DOWNSIZE_YPIXhigh_newfiles2subDIR_convert-resize.sh
##
## PURPOSE: Changes the size of one or more user-selected '.jpg' files.
##
##       This script is oriented toward taking a batch of 'oversized'
##       '.jpg' files, like files from a digital camera, in a directory
##       where you want to keep the original files, and making a common,
##       smaller Y-size file from each original --- with the new, smaller
##       files being put into a (new) 'IMAGES_${YPIXELS}y' subdirectory.
##          
## METHOD:  Uses 'zenity' to prompt the user for a Y-size (in pixels)
##          to use for all the selected files.
##
##          Uses ImageMagick 'convert' with '-resize' and '-quality 100'
##          to do the resizing.
##
##          Puts the new files in a new directory, named "IMAGES_${YPIXELS}y",
##          in the current directory.
##             (The user can change this directory name or move the files
##              later.)
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
## Created: 2010feb17
## Changed: 2010apr01 Added zenity prompt for Y-height.
## Changed: 2011mar26 Added title to zenity prompt for Y-height.
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012jan23 Changed the name of the output directory from
##                    'photos_${YPIXELS}y' to 'IMAGES_${YPIXELS}y'.
## Changed: 2012feb29 Changed the script name in the comment above.

## FOR TESTING: (show statements as they execute)
# set -x


##################################################
## Get the Y-height for the new sized image files. 
##################################################

YPIXELS="600"

YPIXELS=$(zenity --entry \
   --title "Y-RESIZE image files. Put new files in a subdir." \
   --text "\
Enter the Y-PIXEL-SIZE for the output image file(s).

   Typically about 450 to 650 pixels to fit in a web-browser or mail-reader window.

(Generally, do not up-size. Quality of output file(s) will probably be unsatisfactory.)

The new files will be put in a subdirectory whose name starts with 'IMAGES_'." \
   --entry-text "600")

if test "$YPIXELS" = ""
then
   exit
fi


################################################################
## Make the 'IMAGES_${YPIXELS}y' directory, if needed, in curdir.
##      The user can move/rename the dir later, if needed.
################################################################

DIR4resizedIMAGES="IMAGES_${YPIXELS}y"

if test ! -d "$DIR4resizedIMAGES"
then
   mkdir "$DIR4resizedIMAGES"
fi


####################################
## START THE LOOP on the filenames.
####################################

for FILENAME
do

   #######################################
   ## Check that the file is a 'jpg' file.
   ## If not, skip it.
   ##    We may want to comment this check.
   #######################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   if test "$FILEEXT" != "jpg" 
   then 
      continue
      # exit
   fi


   ####################################################################
   ## Get the 'midname' of the filename. (Strip off the '.jpg' suffix.)
   ####################################################################

   FILENAMECROP=`echo "$FILENAME" | sed 's|\.jpg$||'`
   
   ## Strip off suffix of the form '_MMM...xNNN..._yadayada.jpg'
   # FILENAMECROP=`echo "$FILENAME" | sed 's|_[0-9][0-9]*x[0-9][0-9]*.*\.jpg$||'`

 
   #############################################################
   ## Use 'convert' with '-resize' to make the resized jpg file.
   #############################################################
  
   convert "$FILENAME" -resize x$YPIXELS -quality 100 \
           "./$DIR4resizedIMAGES/${FILENAMECROP}_XXXx${YPIXELS}.jpg"

   ## Can then use the script xx_multi-img-files_RENAME_toXXXxYYY_mv.sh
   ## to rename the resized photos with the XXX size filled in.
   ##
   ## Someday we may use 'identify' here to get the size of the new
   ## file and do the rename right here, automatically, in this loop.
   ##
   ## Some 'starter' code follows. Needs testing.
   #####################################################################
   ## Rename the resized jpg file ---
   ##        "./$DIR4resizedIMAGES/${FILENAMECROP}_XXXx${YPIXELS}.jpg"
   ## to have the new size in the filename
   ## --- in the form '_MMMxNNN.jpg'.
   ## 
   ## Remove the string of the form XXXx${YPIXELS}, replacing it by
   ## the actual xy-pixels size of the file--- and if the newly
   ## built output filename does not conflict with an existing file,
   ## rename to the new name. 
   #####################################################################

   # IMGSIZE=`identify "./$DIR4resizedIMAGES/${FILENAMECROP}_XXXx${YPIXELS}.jpg" | awk '{print $3}'`

   ## Strip off a string of the form '_XXXx${YPIXELS}'
   ## from the downsized file's midname.
   # NEWFILENAMEMID=`echo "${FILENAMECROP}_XXXx${YPIXELS}" | sed 's|_XXXx[0-9][0-9]*||'`

   # NEWFILENAME="${NEWFILENAMEMID}_${IMGSIZE}.jpg"

   # if test ! -f "./$DIR4resizedIMAGES/$NEWFILENAME"
   # then
   #   mv "./$DIR4resizedIMAGES/${FILENAMECROP}_XXXx${YPIXELS}.jpg" "./$DIR4resizedIMAGES/$NEWFILENAME"
   # fi

done
## END OF LOOP:  for FILENAME
