#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_1jpgfile_shoEXIFdata_identify-verbose.sh
##
## PURPOSE: Shows EXIF data stored in a selected JPEG ('.JPG' or '.jpg') file.
##
## METHOD:  This script uses ImageMagick 'identify -verbose' to get
##          the EXIF data of the selected JPEG image file.  This script
##          puts the 'identify' output in a text file.
##
##          This script shows the text file using a text-file viewer
##          of the user's choice.
##
## HOW TO USE: In the Nautilus file manager, navigate to the desired
##             directory and right-click on a JPEG image file in the
##             directory.
##             Then, in the popup script menu(s), select this script
##             to run (name above).
##
## Created: 2011mar28
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012jan23 Added 'identify-verbose' to the script name.
## Changed: 2012feb29 Changed the script name in the comment above.

## FOR TESTING: (show statements as they execute)
#  set -x

########################################
## Get the filename of the selected file.
########################################

   FILENAME="$1"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"


####################################################################
## Get and check that the file extension is 'jpg' or 'JPG' or 'jpeg'.
##     Assumes one period (.) in filename, at the extension.
####################################################################

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "JPG" -a "$FILEEXT" != "jpeg"
then
   zenity --info \
      --title "Not a JPEG file(?). EXITING." \
      --text "\
It appears that the selected file
   $FILENAME
is not a JPEG file.

Exiting."
   exit
fi


############################################################
## Prep a temporary filename, to hold the EXIF data.
##      We put the output in /tmp in case the user does
##      not have write-permission to the current directory.
##      Also we avoid junking-up the current directory.
############################################################

OUTFILE="/tmp/${USER}_EXIF_data.lis"
 
if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


#################################################################
## Use 'identify -verbose' to get the EXIF data of the JPEG file.
#################################################################

## FOR TESTING:
#      set -x

identify -verbose "$FILENAME" >  "$OUTFILE"

## FOR TESTING:
#      set -


########################################
## Show the EXIF data in the temp file.
########################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
