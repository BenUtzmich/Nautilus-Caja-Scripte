#!/bin/sh
##
## Nautilus
## SCRIPT: ani00_1aniGIF_TRANSPARENTcolor_gifsicle.sh
##
## PURPOSE: For a user-specified color and a user-selected animated 
##          GIF file, make a new animated GIF file with the specified
##          color made transparent.
##
## METHOD:  Uses the 'gifsicle' program with '--transparent'.
##
##          Uses 'zenity' to prompt for a color.
##
##          Shows the resulting animated GIF file in an animated GIF viewer
##          of the user's choice.
##
## HOW TO USE: In a Nautilus list of directory files, select an
##             animated GIF file.
##             Then right-click and choose this script to run (name above).
##
## REFERENCE: http://www.lcdf.org/gifsicle/
##            Also 'man gifsicle'.
##
## Created: 2012feb29
## Changed: 2012


## FOR TESTING: (show statements as they execute)
# set -x

#########################################
## Get the filename of the selected file.
#########################################

# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
# FILENAMES="$@"
  FILENAME="$1"


#####################################################
## Check that the selected file is a 'gif' file.
##    (Assumes one dot in filename, at the extension.)
#####################################################
FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
# if test "$FILEEXT" != "gif" -a "$FILEEXT" != "GIF"
# then
#    exit
# fi


#######################################################################
## Get a 'stub' to use to name the output file.
#######################################################################

# FILENAMECROP=`echo "$FILENAMECROP" | sed 's|\..*$||'`

FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`


#######################################################
## Prompt for the color to be made transparent.
#######################################################

COLOR=""

COLOR=$(zenity --entry \
   --title "COLOR to be made TRANSPARENT?" \
   --text "\
Enter the COLOR to be made transparent in the file
$FILENAME

Examples:
000000  for black
ffffff  for white
ff00ff  for magenta

The new GIF file will have the string 'TRANSPARENT' in the filename
--- along with the 6-character color specification.

The new file will be in this directory --- OR, if you do not have
write permission to this directory, the output will be in /tmp." \
   --entry-text "000000")

 if test "$COLOR" = ""
 then
    exit
 fi

##################################################################
## Make a filename for the optimized-file output --- using the
## name of a selected image file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

OUTFILE="${FILENAMECROP}_TRANSPARENT_${COLOR}_ani.gif"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


##################################################################
## Use 'gifsicle' to make the specified color transparent.
##################################################################

gifsicle --transparent "#$COLOR" "$FILENAME" > "$OUTFILE"


####################################################
## Show the new animated gif file.
####################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$ANIGIFVIEWER  "$OUTFILE" &
