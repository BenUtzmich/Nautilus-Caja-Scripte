#!/bin/sh
##
## Nautilus
## SCRIPT: ani00_1aniGIF_OPTIMIZE_gifsicle-O1or2.sh
##
## PURPOSE: Optimize (reduce the size of) a user-selected animated '.gif' file.
##
## METHOD:  Uses the 'gifsicle' program with '-O1' or '-O2'.
##
##          Uses 'zenity' to prompt for the optimization number.
##
##          Shows the resulting optimized file in an animated GIF viewer
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
## (Assumes one dot in filename, at the extension.)
##          (Assumes no spaces in filename.)
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
## Prompt for the optimization level.
#######################################################

 OPTLEVEL=""

 OPTLEVEL=$(zenity --list --radiolist \
   --title "OPTIMIZATION LEVEL - 1 or 2?" \
   --text "Choose one of the following optimization levels.

1  stores only the changed portion of each image.
2  also uses transparency to shrink the file further.

Typically shrinks an animated-GIF that was created using
ImageMagick by about 20%.
" \
   --column "" --column "Type" \
   TRUE 1 \
   FALSE 2)

 if test "$OPTLEVEL" = ""
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

OUTFILE="${FILENAMECROP}_OPTIMIZED_gifsicle_O${OPTLEVEL}_ani.gif"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


##################################################################
## Use 'gifsicle' to put the info in a text file.
##################################################################

gifsicle -O$OPTLEVEL "$FILENAME" > "$OUTFILE"


####################################################
## Show the gif files split from the animated gif.
####################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$ANIGIFVIEWER  "$OUTFILE" &
