#!/bin/sh
##
## Nautilus
## SCRIPT: 09_multi-img-files_CROP_convert-crop-repage.sh
##
## PURPOSE: Converts a selected set of image files --- '.png' or '.jpg'
##          or whatever -- to CROPPED files of the same type.
##
## METHOD:  Uses ImageMagick 'convert' with the '-crop' and '+repage' options.
##
##          Uses 'zenity' to ask user for the 'geometry' of the crop.
##          Example: 400x300+10+10
##
##          Shows the (last) new image file in an image viewer (or editor)
##          of the user's choice.
##
## HOW TO USE: In the Nautilus file manager, navigate to the desired directory
##             and select one or more image files.
##             Then right-click and choose this script to run (name above).
##
## REFERENCES:
##    http://www.imagemagick.org/Usage/crop/#crop
##
############################################################################
## Created: 2014apr18
## Changed: 2015sep25 Added explanatory text to zenity prompt.
########################################################################### 

## FOR TESTING: (show statements as they execute)
# set -x

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


###################################################
## Get the 'geometry' for the crop.
###################################################

GEOM=""

GEOM=$(zenity --entry \
   --title "Enter the 'geometry' for the crop." \
   --text "\
Enter the 'geometry' for the crop. Example1: 600x400+0+0
crops out a 600x400 image, whose upper-left corner is based at
the upper-left corner (0,0) of the selected image file(s).

Example2: 400x300+10+20
crops out a 400x300 image, whose upper-left corner is based at
the point (10,20) measured from the upper-left corner of the
selected image file(s).

" \
   --entry-text "400x300+0+0")

if test "$GEOM" = ""
then
   exit
fi



####################################
## START THE LOOP on the filenames.
####################################

for FILENAME
do

   ###########################################################
   ## Get the file extension, such as 'png' or 'jpg'.
   ##   Assumes one dot (.) in the filename, at the extension.
   ###########################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`


   ###########################################################
   ## Check that the file extension is 'png' or 'jpg'.
   ## COMMENTED for now.
   ###########################################################

   # if test "$FILEEXT" != "png" -a "$FILEEXT" != "jpg"
   # then
   #    continue 
   #    #  exit
   # fi


   ###########################################################
   ## Get the 'midname' of the filename --- by stripping
   ## the extension.
   ##   Assumes one dot (.) in the filename, at the extension.
   ###########################################################

   # FILENAMECROP=`echo "$FILENAME" | sed 's|\..*$||'`

   FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`


   ##############################################################
   ## Make the name of the output (cropped) file. If the file
   ## already exists, skip processing this file.
   ## (We could use 'zenity --info' to pop a notice to the user.)
   ##############################################################

   OUTFILE="${FILENAMECROP}_CROP$GEOM.$FILEEXT"

   if test -f "$OUTFILE"
   then
      continue 
      #  exit
   fi


   ###########################################
   ## Use 'convert' to make the cropped file.
   ###########################################

   # convert "$FILENAME" -crop $GEOM +repage "$OUTFILE"

   $EXE_FULLNAME "$FILENAME" -crop $GEOM +repage "$OUTFILE"

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
