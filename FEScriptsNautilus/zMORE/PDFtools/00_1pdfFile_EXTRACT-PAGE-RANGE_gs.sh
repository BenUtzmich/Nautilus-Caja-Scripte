#!/bin/sh
##
## Nautilus
## SCRIPT: 00_1pdfFile_EXTRACT-PAGE-RANGE_gs.sh
##
## PURPOSE: Extracts a user-specified range of pages from a PDF file
##          The output is another PDF file.
##
## MEHTOD:  Uses the 'gs' (Ghostscript) command, with about 4 parameters,
##          to do the extract.
##
##          Uses 'zenity' to prompt for the page range.
##
##          Puts the output PDF file in the same directory with the
##          input file --- or in /tmp if the user does not have
##          write permission on the current directory.
##
##          The user is put in view mode of the output PDF file, using
##          a PDF viewer of the user's choice.
##
## HOW TO USE: In Nautilus, navigate to a PDF file, select it,
##             right-click and choose this Nautilus script to run.
##
## REFERENCE: http://www.linuxjournal.com/content/tech-tip-extract-pages-pdf
##
############################################################################
## Created: 2012mar25 
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Added a 'zenity --info' call to
##                    show if 'gs' is not found.
#######################################################################


## FOR TESTING: (show statements as they execute)
#  set -x

#######################################
## Get the PDF filename.
#######################################

FILENAME="$1"


#######################################################
## Check that the selected file is a PDF file.
#######################################################

#  FILESUFFIX=`echo "$FILENAME" | cut -d'.' -f2`

FILECHECK=`file "$FILENAME" | grep 'PDF'`
 
if test "$FILECHECK" = ""
then
   exit
fi


#################################################
## Set the PDFVIEWER var.
#################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi


###########################################################
## Get the 1st and last pages to convert.
###########################################################

PAGESTARTEND=""

PAGESTARTEND=$(zenity --entry \
   --title "Enter Page Range." \
   --text "\
Enter Page Range to extract.
   Example: 1 16

The messages from the 'gs' command are shown in a terminal window.
Close the terminal when the extraction is complete. The PDF will
be shown via viewer '$PDFVIEWER'." \
   --entry-text "1 16")

if test "$PAGESTARTEND" = ""
then
   exit
fi

PAGECHECK=`echo "$PAGESTARTEND" | wc -w`

if test ! "$PAGECHECK" = "2"
then
   exit
fi

PAGEFIRST=`echo "$PAGESTARTEND" | awk '{print $1}'`
PAGELAST=`echo "$PAGESTARTEND" | awk '{print $2}'`



##########################################################
## Get the 'midname' of the selected PDF file,
## and make a name for the new output file.
##     Assumes just one period (.) in the filename,
##     at the suffix.
## If the user does not have write permission to the
## current directory, put the output file in /tmp.
##########################################################

FILEMIDNAME=`echo "$FILENAME" | cut -d'.' -f1`

OUTFILE="${FILEMIDNAME}_PAGES_${PAGEFIRST}to${PAGELAST}.pdf"

CURDIR="`pwd`"

if test ! -w "$CURDIR"
then
   OUTFILE="/tmp/$OUTFILE"
fi


###########################################################
## Generate the image files from the pages of the PDF file.
###########################################################

EXECHECK=`which gs`

if test -f "$EXECHECK"
then
   xterm -hold -fg white -bg black -e \
   gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER \
       -dFirstPage=$PAGEFIRST -dLastPage=$PAGELAST \
       -sOutputFile="$OUTFILE" "$FILENAME"
else
   zenity --info \
   --title "'gs' not found. EXITING." \
   --text "\
It appears that the executable
'gs' (ghostscript) is not installed.

Exiting."
   exit
fi


#################################################
## Show the output PDF file.
#################################################

$PDFVIEWER "$OUTFILE" &
