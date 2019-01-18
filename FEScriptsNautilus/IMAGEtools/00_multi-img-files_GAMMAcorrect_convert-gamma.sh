#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_multi-img-files_GAMMAcorrect_convert-gamma.sh
##
## PURPOSE: Makes a gamma-corrected file(s) from a selected image file(s).
##
## METHOD:  Uses ImageMagick 'convert' with the '-gamma' option.
##
##          Uses 'zenity' to prompt the user for an ImageMagick 'convert'
##          '-gamma' parameter value.
##          Examples: 0.3  -or-  1.3  -or-  3.5
##                    OR, for RGB channels separately:  0.8,1.3,1.0
##
##          Shows the new (last) new image file in an image viewer (or editor)
##          of the user's choice.
##
## REFERENCE: http://www.imagemagick.org/Usage/color_mods/#gamma
##
## HOW TO USE: In the Nautilus file manager, navigate to a desired directory
##             and select one or more image files. The right-click
##             and select this script to run (name above).
##
## Created: 2012jan17
## Changed: 2012jan25 Add Gamma factor to the name of the output file.
## Changed: 2012feb24 Changed to handle multiple image files. (Added do-loop.)
## Changed: 2012feb29 Changed the script name in the comment above.

## FOR TESTING: (show statements as they execute)
#  set -x


#######################################################
## Prompt for the gamma parameter.
#######################################################

GAMMA=""

GAMMA=$(zenity --entry \
   --title "Enter GAMMA factor(s)." \
   --text "\
Enter the GAMMA value. Examples:  0.3  -or-  1.3  -or-  3.5

Greater than 1 to brighten the image; less than 1 to darken.

OR, for RGB channels separately, 3 values, comma separated.
Example:  0.8,1.3,1.0" \
   --entry-text "0.8,1.3,1.0")

if test "$GAMMA" = ""
then
   exit
fi


####################################
## START THE LOOP on the filenames.
####################################

for FILENAME
do

   ####################################################################
   ## Get the file extension.
   ##     Assumes one period (.) in filename, at the extension.
   ####################################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`


   ####################################################################
   ## Check that the file extension is 'jpg' or 'png' or 'gif'.
   ##     Assumes one period (.) in filename, at the extension.
   ## COMMENTED, for now.
   ####################################################################
 
   # if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
   # then
   #    continue
   #    # exit
   # fi


   ##########################################################
   ## Get the 'midname' of the input file, to use to name the
   ## new output file.
   ##     Assumes just one period (.) in the filename,
   ##     at the suffix.
   ######################################################

   FILEMIDNAME=`echo "$FILENAME" | cut -d'.' -f1`


   ##################################################################
   ## Make a filename for the output file --- using the
   ## name of the input file.
   ##
   ## If the user has write-permission on the
   ## current directory, put the file in the pwd.
   ## Otherwise, put the file in /tmp.
   ##################################################################

   CURDIR="`pwd`"

   GAMMASTRING=`echo "$GAMMA" | sed 's|\.|-|' | sed 's|\,|_|' `

   OUTFILE="${FILEMIDNAME}_GAMMAcorrected${GAMMASTRING}.$FILEEXT"

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

   convert "$FILENAME"  -gamma $GAMMA  "$OUTFILE"

   ## FOR TESTING:
   #      set -

done
## END OF LOOP: for FILENAME


############################################################
## Show the LAST new image file.
############################################################
## NOTE: The viewer may be able to go back through the other
##  image files if multiple image files were gamma-corrected.
############################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &

# $IMGEDITOR "$OUTFILE" &
