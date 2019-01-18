#!/bin/sh
##
## Nautilus
## SCRIPT: 01_multi-img-files_CONVERT-TOpng_convert-colors-prompt.sh
##
## PURPOSE: For a selected set of image files --- '.jpg', '.png', '.gif' or
##          whatever, converts them to '.png' files --- with a
##          colors limit applied.
##
## METHOD:  Uses 'zenity --entry' to ask user for max number of colors.
##
##          Uses 'zenity --entry' to prompt for the number --- which is
##          defaulted to 256.
##
##          Numbers less than 256 result in an 8-bit, 'map' ('palette')
##          file, even if the input file was an 'RGB' (24-bit, up to
##          16-million colors) file. 
##
##          Puts the new '.png' file(s) in the directory with the selected
##          image files.
##
## REFERENCES:
## http://stackoverflow.com/questions/7609210/%D0%A1onvert-image-to-indexed-color-use-custom-palette-use-console
##
## HOW TO USE: In Nautilus, select one or more image files.
##             Then right-click and choose this script to run (name above).
##
################################################################################
## Created: 2014jul01 Based on the quite similar script to make JPEG files:
##                01_multi-img-files_CONVERT-TOpng_convert-quality-prompt.sh
## Changed: 2013
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x



#####################################################
## Get the 'max colors' for the output PNG files.
#####################################################

MAXCOLORS=""

MAXCOLORS=$(zenity --entry \
   --title "Enter MAXIMUM COLORS for output PNG file." \
   --text "\
Enter the MAXimum number of COLORS for the output file.

Numbers less than 256 result in an 8-bit, 'map' ('palette')
PNG file, even if the input file was an 'RGB' (24-bit, up to
16-million colors) file.
" \
   --entry-text "256")

if test "$MAXCOLORS" = ""
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
   ## Make the name of the output '.png' file.
   ## If a previously existing file by that name already exists,
   ## delete it.
   ## Alternatively, we could:
   ## If the file already exists, skip processing this file.
   ## (We could use 'zenity --info' to pop a notice to the user.)
   ##############################################################

   OUTFILE="${FILEMIDNAME}_MaxColors${MAXCOLORS}.png"

   rm -f "$OUTFILE"

   # if test -f "$OUTFILE"
   # then
   #    continue 
   #    #  exit
   # fi


   #####################################################
   ## Use 'convert' to make the 'png' file.
   #####################################################

   convert "$FILENAME" +dither -colors $MAXCOLORS "$OUTFILE"


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
