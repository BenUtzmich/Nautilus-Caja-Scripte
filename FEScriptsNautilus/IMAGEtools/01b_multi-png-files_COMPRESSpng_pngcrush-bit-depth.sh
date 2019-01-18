#!/bin/sh
##
## Nautilus
## SCRIPT: 01b_multi-png-files_COMPRESSpng_pngcrush-bit-depth.sh
##
## PURPOSE: For a selected set of PNG files, compresses them to
##          NEW '.png' files --- using the '-brute' option of the
##          'pngcrush' command to use brute force and try about
##          114 different filter/compression methods.
##
##          The '-brute' option is very time consuming but will be
##          able to reduce the size of PNG images by significant factor.
##
## METHOD:  Simply runs 'pngcrush' with no options other than '-brute'.
##          Do there is no need for a 'zenity' prompt to ask the user
##          for parameter values.
##
##          Creates a new PNG file with a suffix like '_pngcrushBRUTE.png'.
##          Puts the new '.png' files in the directory with the selected
##          image files.
##
## REFERENCES:
## http://linuxpoison.blogspot.com/2010/01/pngcrush-optimize-png-file-image-to.html
##
## HOW TO USE: In Nautilus, select one or more image files.
##             Then right-click and choose this script to run (name above).
##
################################################################################
## Created: 2014jun30 Based on the quite similar script to convert image
##                    files to PNG files:
##                '01_multi-img-files_CONVERT-TOpng_convert-quality-prompt.sh'
## Changed: 2014nov21 Changed 'multi-img' to 'multi-png' in script name.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x

#########################################################
## Check if the 'pngcrush' executable exists.
#########################################################

EXE_FULLNAME="/usr/bin/pngcrush"

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
Or, install the 'pngcrush' program."
   exit
fi


######################################################
## Get the '-bit_depth' value for the output PNG files.
######################################################

BITDEPTH=""

BITDEPTH=$(zenity --entry \
   --title "Enter a BIT-DEPTH." \
   --text "\
Enter a BIT-DEPTH ... like
- 8 (256 color)
or
- 7 (128 color)
or
- 6 (64 color)
or
- 5 (32 color)
or
- 4 (16 color)
or
- 3 (8 color)

- 2 (4 color)
" \
   --entry-text "8")

if test "$BITDEPTH" = ""
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
   ###########################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   ###########################################################
   ## Check that the file extension is 'png'.
   ##   Assumes one dot (.) in the filename, at the extension.
   ###########################################################
 
   if test "$FILEEXT" != "png"
   then
      continue 
      #  exit
   fi


   ###########################################################
   ## Get the 'midname' of the filename --- by stripping
   ## the file extension.
   ##    Assumes one dot (.) in the filename, at the extension.
   ###########################################################

   # FILEMIDNAME=`echo "$FILENAME" | sed 's|\..*$||'`
   FILEMIDNAME=`echo "$FILENAME" | cut -d\. -f1`


   ##############################################################
   ## Make the name of the output '.png' file. If the file
   ## already exists, skip processing this file.
   ## (We could use 'zenity --info' to pop a notice to the user.)
   ##############################################################

   OUTFILE="${FILEMIDNAME}_bitdepth${BITDEPTH}.png"

   if test -f "$OUTFILE"
   then
      continue 
      #  exit
   fi


   #####################################################
   ## Use 'pngcrush' to make the 'png' file.
   #####################################################

   $EXE_FULLNAME -q -bit_depth $BITDEPTH "$FILENAME" "$OUTFILE"


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
