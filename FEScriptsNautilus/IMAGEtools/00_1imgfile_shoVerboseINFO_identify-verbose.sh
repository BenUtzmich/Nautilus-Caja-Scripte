#!/bin/sh
##
## Nautilus
## SCRIPT: 00_1imgfile_shoVerboseINFO_identify-verbose.sh
##
## PURPOSE: For one image file --- jpg, png, gif, or whatever ---
##          shows 'verbose' info on the file.
##
## METHOD:  This script uses ImageMagick 'identify -verbose' to get
##          the properties of the selected image file.  This script
##          puts the 'identify' output in a text file.
##
##          This script shows the text file using a text-file viewer
##          of the user's choice.
##
## HOW TO USE: In the Nautilus file manager, navigate to the desired
##             directory and right-click on an image file (any of the
##             40-plus types supported by ImageMagick) in the
##             directory.
##             Then, in the popup script menu(s), select this script
##             to run (name above).
##
## REFERENCE:
##  http://www.imagemagick.org/discourse-server/viewtopic.php?f=1&t=14833
##
############################################################################
## Created: 2011feb03
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012jan18 Reworded the report trailer.
## Changed: 2012jan23 Change the script name slightly.
## Changed: 2012feb29 Changed the script name in the comment above.
## Changed: 2013apr10 Added check for the identify executable.
###########################################################################

## FOR TESTING: (show the statements as executed)
# set -x

#########################################################
## Check if the identify executable exists.
#########################################################

EXE_FULLNAME="/usr/bin/identify"

if test ! -f "$EXE_FULLNAME"
then
   zenity  --info --title "Executable NOT FOUND." \
   --no-wrap \
   --text  "\
The identify executable
   $EXE_FULLNAME
was not found. Exiting.

If the executable is in another location,
you can edit this script to change the location.
OR, install the ImageMagick package."
   exit
fi


#########################################
## Get the filename of the selected file.
#########################################

# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
# FILENAMES="$@"
  FILENAME="$1"


#####################################################
## Check that the selected file is a 'jpg', 'png', or
## 'gif' file.
##    (Assumes one dot in filename, at the extension.)
#####################################################
## COMMENTED FOR NOW.
#####################################################

#  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
#  if test "$FILEEXT" != "jpg" -o  "$FILEEXT" != "png" -o \
#          "$FILEEXT" != "gif"
#  then
#     exit
#  fi


##################################################################
## Make a full filename for the text output.
##
##    If the user has write-permission on the
##    current directory, put the file in the pwd.
##    Otherwise, put the file in /tmp.
##
## On second thought, to avoid junking up the 
## current directory, ALWAYS put the file in /tmp.
##################################################################

CURDIR="`pwd`"

OUTFILE="${USER}_temp_identify_imgINFO.txt"

# if test ! -w "$CURDIR"
# then
OUTFILE="/tmp/$OUTFILE"
# fi

if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


##################################################################
## Generate a 'header' for the listing.
##################################################################

echo "\
Output from the ImageMagick command 'identify -verbose' :
#######################################################
" > "$OUTFILE"


##################################################################
## Add 'identify -verbose' output to the listing.
##################################################################

# identify -verbose "$FILENAME"  >> "$OUTFILE"

$EXE_FULLNAME  -verbose "$FILENAME"  >> "$OUTFILE"


##################################################################
## Add a 'trailer' to the listing.
##################################################################

echo "\
...........................................................................

For GIF files, the 'Histogram:' and 'Colormap:' sections may be of special interest.

For JPEG and PNG files, the 'Channel statistics:' and 'Histogram:' sections
may be of special interest.

...........................................................................
" >> "$OUTFILE"


####################################################
## Show the listing.
####################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
