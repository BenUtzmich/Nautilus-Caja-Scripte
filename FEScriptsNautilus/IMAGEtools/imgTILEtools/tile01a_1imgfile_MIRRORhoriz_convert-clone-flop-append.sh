#!/bin/sh
##
## Nautilus
## SCRIPT: tile01a_1imgfile_MIRRORhoriz_convert-clone-flop-append.sh
##
## PURPOSE: Makes a larger image file from a selected image file
##          ('.jpg' or '.png' or '.gif' or whatever) by adding a mirror-image
##          of the file --- in an east-west direction (horizontally).
##
##          This is helpful in making 'tileable' files from non-tileable files.
##
## METHOD:  There is no prompt for a parameter.
##
##          Uses ImageMagick 'convert', with '+clone', '-flop', and
##          '+append'.
##
##          Shows the new image file in an image viewer of the user's choice.
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##
############################################################################
## Created: 2010mar13
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012feb02 Changed name of script and removed requirement that
##                    input be '.jpg' or '.png' or '.gif'.
## Changed: 2012may14 Touched up the comments above. Changed some indenting below.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x

#########################################
## Get the filename of the selected file.
#########################################

  FILENAME="$1"
# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
# FILENAMES="$@"


###################################################################
## Get the extension of the selected file.
##  (Assumes there is only one period in the filename, at the extension.)
###################################################################

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`


###################################################################
## Check that the selected file is a 'jpg' or 'png' or 'gif' file.
## COMMENTED, for now.
###################################################################

#  if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
#  then
#     exit
#  fi


#######################################################################
## Get the midname' of the input file, for naming output file(s).
#######################################################################

#  FILENAMECROP=`echo "$FILENAME" | sed 's|\..*$||'`
   FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`


########################################################################
## Make the name of the output file, based on the name of the input file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
########################################################################

CURDIR="`pwd`"

OUTFILE="${FILENAMECROP}_MIRRORhoriz.$FILEEXT"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi

#######################################################################
## Use 'convert' (with +clone and -flop) to make the new mirrored file.
#######################################################################

convert "$FILENAME" \( +clone -flop \) +append -gravity east "$OUTFILE"


####################################
## Show the new mirrored image file.
####################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER  "$OUTFILE" &

# $IMGEDITOR "$OUTFILE" &
