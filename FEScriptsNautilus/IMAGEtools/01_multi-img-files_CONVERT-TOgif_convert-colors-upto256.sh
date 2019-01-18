#!/bin/sh
##
## Nautilus
## SCRIPT: 01_multi-img-files_CONVERT_TOgif_convert-colors-upto256.sh
##
## PURPOSE: Converts a selected set of image files --- '.png' or '.jpg'
##          or whatever -- to '.gif' files.
##
## METHOD:  Uses ImageMagick 'convert' with the '-colors' option.
##
##          Uses 'zenity' to ask user for 'palette-size' (# of colors) to use
##          for the '.gif' output file(s).
##
##          Shows the (last) new image file in an image viewer (or editor)
##          of the user's choice.
##
## HOW TO USE: In the Nautilus file manager, navigate to the desired directory
##             and select one or more image files.
##             Then right-click and choose this script to run (name above).
##
## REFERENCES:
##    http://www.imagemagick.org/discourse-server/viewtopic.php?f=3&t=17316
##    http://www.imagemagick.org/discourse-server/viewtopic.php?f=1&t=14833
##
############################################################################
## Created: 2011feb02
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012feb14 Changed name of script. Changed script to allow
##                    input files other than '.png' or '.jpg'.
## Changed: 2012feb29 Touched up the comments above.
## Changed: 2012mar31 Chgd 'f2' to 'f1' in FILENAMECROP statement.
## Changed: 2013apr10 Added check for the convert executable.
## Changed: 2014jul01 Added '+dither' to the 'convert' command to avoid
##                    dithering. (I hate those speckles.)
## Changed: 2015jan17 Change script name from '_convert-palette-size.sh' to
##                    '_convert-colors-upto256.sh'. 
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
## Get the 'palette size' for the output GIF files.
###################################################

PSIZE=""

PSIZE=$(zenity --entry \
   --title "Enter the GIF palette size (2-256)." \
   --text "\
Enter the GIF palette size (2-256).
      Typically use 2 for monochrome (2 color) images ---
      8 or more if they are anti-aliased or shaded images.

Typical values:
256, 128, 64, 32, 16, 8, 4, 2

Enter 0 to let ImageMagick 'convert' determine a minimum palette." \
   --entry-text "256")

if test "$PSIZE" = ""
then
   exit
fi

PALPARM="-colors $PSIZE"

if test "$PSIZE" = "0"
then
   PALPARM=""
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
   ## Make the name of the output '.gif' file. If the file
   ## already exists, skip processing this file.
   ## (We could use 'zenity --info' to pop a notice to the user.)
   ##############################################################

   OUTFILE="${FILENAMECROP}_PALETTE${PSIZE}.gif"

   if test -f "$OUTFILE"
   then
      continue 
      #  exit
   fi


   ###########################################
   ## Use 'convert' to make the 'gif' file.
   ###########################################

   # convert "$FILENAME" $PALPARM "$OUTFILE"

   $EXE_FULLNAME "$FILENAME" +dither $PALPARM "$OUTFILE"

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
