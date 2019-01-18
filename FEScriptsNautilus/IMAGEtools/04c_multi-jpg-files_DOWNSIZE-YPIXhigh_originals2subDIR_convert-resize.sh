#!/bin/sh
##
## SCRIPT: 04c_multi-jpg-files_DOWNSIZE_YPIXhigh_originals2subDIR_convert-resize.sh
##
## PURPOSE: Changes the size of one or more user-selected '.jpg' files.
##
##          Moves the originals to a subdirectory of the 'current' directory.
##
##       This script is oriented toward taking a batch of 'oversized'
##       *'.jpg'* files, like files from a digital camera, in a directory
##       where you want the DOWNSIZED files, and making a common,
##       smaller Y-size file from the originald in this directory --- while
##       moving the originals to a subdirectory with a name like
##       'ORIG_resizedTO_${YPIXELS}y' subdirectory.
##
## METHOD:  Uses 'zenity' to prompt the user for a Y-size (in pixels)
##          to use for all the selected files.
##
##          Uses 'convert' with '-resize' and '-quality 100' to do the
##          resizing.
##
##          Moves the original files in a subdirectory of the 'current'
##          directory --- with a subdirectory name like
##          "ORIG_resizedTO_${YPIXELS}y".
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
## Created: 2010mar21
## Changed: 2011mar26 Added title to zenity prompt for Y-height.
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2011sep18 Changed name of directory to which originals are
##                    moved --- to ORIGINALS_...
## Changed: 2012jan23 Changed script name slightly. Changed some indenting
##                    of the script statements. Added some text to the
##                    zenity prompt for YPIXELS.
## Changed: 2012feb29 Changed the script name in the comment above.

## FOR TESTING: (show statements as they execute)
# set -x


##################################################
## Get the Y-height for the new sized image files. 
##################################################

YPIXELS=""

YPIXELS=$(zenity --entry \
   --title "Y-RESIZE '.jpg' image files, and move originals to a subdir." \
   --text "\
Enter the Y-PIXEL-SIZE for the output image file(s).

   Typically about 450 to 650 pixels to fit in a web-browser or mail-reader window.

(Generally, do not up-size. Quality of output file(s) will probably be unsatisfactory.)

The original files will be moved to a subdirectory whose name starts with 'ORIGINALS_'." \
   --entry-text "600")

if test "$YPIXELS" = ""
then
   exit
fi

###########################################################
## Make the 'original-files' subdirectory in curdir.
##      The user can rename the dir later, if needed.
###########################################################

DIR4bigIMGS="ORIGINALS_theyWereResizedTO_${YPIXELS}y"

if test ! -d "$DIR4bigIMGS"
then
     mkdir "$DIR4bigIMGS"
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
   ## Use 'convert' to make the resized jpg file.
   ###############################################

   mv "$FILENAME" "./$DIR4bigIMGS/${FILENAME}"
   
   convert "./$DIR4bigIMGS/${FILENAME}" -resize x$YPIXELS \
      -quality 100 "$FILENAME"


   #####################################################################
   ## Rename the resized jpg file to have the new size in the filename
   ## --- in the form XXXxYYY.
   ## 
   ## Remove a string of the form MMMxNNN, like the size of the original
   ## file, in the original filename, $FILENAME --- and if the newly
   ## built output filename does not conflict with an existing file,
   ## rename to the new name. 
   #####################################################################

   IMGSIZE=`identify "$FILENAME" | awk '{print $3}'`

   ## Strip off a string of the form '_MMM...xNNN'
   ## from the original input filename, $FILENAME.
   FILENAMECROP=`echo "$FILENAME" | sed 's|_[0-9][0-9]*x[0-9][0-9]*||'`

   ## Strip off the '.jpg' suffix from FILENAMECROP.
   FILENAMECROP=`echo "$FILENAMECROP" | sed 's|\.jpg$||'`

   NEWFILENAME="${FILENAMECROP}_${IMGSIZE}.jpg"

   if test ! -f "$NEWFILENAME"
   then
      mv "$FILENAME" "$NEWFILENAME"
   fi

done
## END OF LOOP:  for FILENAME
