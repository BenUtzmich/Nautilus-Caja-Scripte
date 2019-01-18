#!/bin/sh
##
## Nautilus
## SCRIPT: 04_2imgFiles_ApplyBlackMASKtoMakeTRANSPARENTfile_convert-copy-opacity.sh
##
## PURPOSE: For two selected image files in a directory ('.jpg' or
##          '.png' or '.gif' or whatever), OF THE SAME DIMENSIONS,
##          with one of the files being a mask file (black and one
##          other color),
##
##          this script 'applies' the mask file to the other 'target' file,
##          making the pixels of the target file transparent where the
##          corresponding pixels in the mask file are black.
##
## METHOD:  Uses 'zenity --list --radiolist' twice:
##           1)  to show the two filenames as file 1 and file2 and
##               ask the user for which image is the mask file, 1 or 2
##           2)  to ask the user whether GIF or PNG output file is wanted.
##
##          Runs a 'convert' command with the filenames in the proper
##          argument order to make the transparent file.
##
##          Makes the output filename based on the name of the 'target'
##          image file.
##
##          Shows the new output (overlayed) file in an image viewer of
##          the user's choice.
##
## REFERENCES: 
##      http://www.imagemagick.org/Usage/compose/#copyopacity
##      http://www.multipole.org/discourse-server/viewtopic.php?f=1&t=18019
##      Examples:
## convert pic.tif mask.tif -alpha off -compose copy_opacity -composite result.tif
## OR
## convert pic.tif mask.tif +matte -compose copy_opacity -composite result.tif
## OR
## convert pic.tif -alpha set \( mask.tif -alpha Copy \) -compose DstIn -composite result.tif
##
## HOW TO USE: In Nautilus, select a pair of image files in a directory.
##             Then right-click and choose this script to run (name above).
##
##########################################################################
## Created: 2012aug14
## Changed: 2012
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x

####################################
## Get the 2 filenames.
##    (Ignore any others selected.)
####################################

FILENAME1="$1"
FILENAME2="$2"

## ALTERNATIVE WAY of getting the 2 filenames:

# FILENAME1="$1"
# shift
# FILENAME2="$1"


####################################################################
## Check that the two selected files are the same size ---
## in X and Y pixels.
####################################################################

FILESIZE1=`identify "$FILENAME1" | head -1 | awk '{print $3}'` 
FILESIZE2=`identify "$FILENAME2" | head -1 | awk '{print $3}'` 

if test ! "$FILESIZE1" = "$FILESIZE2"
then
   zenity --info \
      --title "THE 2 FILES ARE DIFFERENT PIXEL SIZES. EXITING ..." \
      -text "\
This MAKE-TRANSPARENT-FILE utility (which uses a 'mask' file and
a 'target' file) requires that both files have the same size
--- in X and Y pixels.

FILE1:
NAME: $FILENAME1
SIZE: $FILESIZE1

FILE2:
NAME: $FILENAME2
SIZE: $FILESIZE2

You can make the 'mask' file the same size as the 'target' file
with some of the other 'feNautilusScripts' 'IMAGEtools' utilities
--- such as a 'RESIZE' utility.

Exiting ..."
   exit
fi


#######################################################
## Prompt for the which file is the mask file ---
## 1 or 2.
#######################################################

MASKFILENUM=""

MASKFILENUM=$(zenity --list --radiolist \
   --title "Which is the black-MASK file --- 1 or 2?" \
   --text "\
FILE1: $FILENAME1
FILE2: $FILENAME2

Choose 1 or 2." \
   --column "" --column "" \
   FALSE 1 FALSE 2)

if test "$MASKFILENUM" = ""
then
   exit
fi


##########################################################
## Put the filenames in new vars - MASKFILE, TARGETFILE.
##########################################################

if test "$MASKFILENUM" = "1"
then
   MASKFILE="$FILENAME1"
   TARGETFILE="$FILENAME2"
else
   MASKFILE="$FILENAME2"
   TARGETFILE="$FILENAME1"
fi


##########################################################
## Get the 'mid-name' of the 'target' image file ---
## i.e. remove the extension/suffix.
##
##   (Assumes one dot in filename, at the extension.)
#########################################################

TARGETFILE_MIDNAME=`echo "$TARGETFILE" | cut -d\. -f1`


#######################################################
## Prompt for GIF or PNG, for the output file.
#######################################################

OUTTYPE=""

OUTTYPE=$(zenity --list --radiolist \
   --title "What type of transparent output file --- GIF or PNG?" \
   --text "\
Choose GIF or PNG --- for the format of the (transparent) output file." \
   --column "" --column "" \
   FALSE GIF FALSE PNG)

if test "$OUTTYPE" = ""
then
   exit
fi


##################################################################
## Make full filename for the output file --- using the
## name of the midname of the target file and the gif/png extension.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

OUTFILE="${TARGETFILE_MIDNAME}_TRANSPARENT.$OUTTYPE"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi



########################################################
## Call 'convert' with the two filenames passed on the
## command line.
########################################################

convert $TARGETFILE $MASKFILE -alpha off -compose copy_opacity \
       -composite $OUTFILE

## OR
## convert $TARGETFILE $MASKFILE +matte -compose copy_opacity \
##        -composite $OUTFILE
## OR
## convert $TARGETFILE -alpha set \( $MASKFILE -alpha Copy \) \
##        -compose DstIn -composite $OUTFILE


####################################################
## Show the appended output image file.
####################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &
