#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_multi-img-files_CONTRAST_convert-enhance-contrast.sh
##
## PURPOSE: Makes 'enhanced' file(s) from selected image file(s).
##
## METHOD:  Uses ImageMagick 'convert' with the '-enhance' and '-contrast' options.
##
##          No need to use 'zenity' to prompt the user for parameters.
##
##          This script shows the (last) new image file in an image viewer of
##          the user's choice.
##
## REFERENCE:  http://superuser.com/questions/370920/auto-image-enhance-for-ubuntu
##
## HOW TO USE: In the Nautilus file manager, select the name(s) of image
##             file(s) in a Nautilus directory list.
##             Then right-click and choose this script to run (name above).
##
## Created: 2014nov14
## Changed: 2014

## FOR TESTING: (show statements as they execute)
#  set -x



####################################
## START THE LOOP on the filenames.
####################################

for FILENAME
do

   ##########################################################
   ## Get the 'midname' and suffix of the selected image file,
   ## to use to name the new output file.
   ##     Assumes just one period (.) in the filename,
   ##     at the suffix.
   ##########################################################

   FILEMIDNAME=`echo "$FILENAME" | cut -d'.' -f1`
   FILESUFFIX=`echo "$FILENAME" | cut -d'.' -f2`


   ####################################################################
   ## Get and check that the file extension is 'jpg' or 'png' or 'gif'.
   ##     Assumes one period (.) in filename, at the extension.
   ## COMMENTED, for now.
   ####################################################################
   # FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
   # if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
   # then
   #    continue
   #    # exit
   # fi


   ##################################################################
   ## Make full filename for the output file --- using the
   ## name of the input file.
   ##
   ## If the user has write-permission on the
   ## current directory, put the file in the pwd.
   ## Otherwise, put the file in /tmp.
   ##################################################################

   CURDIR="`pwd`"

   OUTFILE="${FILEMIDNAME}_ContrastAndEnhance.$FILESUFFIX"

   if test ! -w "$CURDIR"
   then
      OUTFILE="/tmp/$OUTFILE"
   fi

   if test -f "$OUTFILE"
   then
      rm -f "$OUTFILE"
   fi


   ###########################################
   ## Use 'convert' to make the new image file.
   ###########################################

   ## FOR TESTING:
   #      set -x

   convert "$FILENAME"  -contrast -enhance "$OUTFILE"

   ## ALTERNATIVE: (see superuser.com reference)
   # convert "$FILENAME"  -contrast -enhance -equalize "$OUTFILE"


   ## FOR TESTING:
   #      set -

done
## END OF LOOP: for FILENAME


############################################################
## Show the LAST new image file.
## NOTE: The viewer may be able to go back through the other
##       image files if multiple image files were resized.
############################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &

# $IMGEDITOR "$OUTFILE" &
