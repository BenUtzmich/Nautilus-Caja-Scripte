#!/bin/sh
##
## Nautilus
## SCRIPT: 00_1pdfile_CONVERTtoHTML_pdftohtml.sh
##
## PURPOSE: Runs the 'pdftohtml' command to create '.html' and image files (PNG)
##          (and an optional '.xml' file), from a user-selected PDF file.
##          This script is designed to support file-selection via Nautilus.
##
## METHOD:  The user is put in view mode of the (main) HTML file, using
##          an HTML viewer of the user's choice.
##
## HOW TO USE: In Nautilus, navigate to a PDF file, select it,
##             right-click and choose this Nautilus script to run.
##
## WARNING: If there are hundreds of pages in the PDF file,
##          'pdftohtml' may generate hundreds of image files.
##          If that proves to often be a problem, we can make a
##          temporary directory in which to put the image files 
##          and HTML (and XML) files ---
##          so that we do not junk-up the current directory.
##
##          Also, note that it may take about 2 seconds to process each page,
##          and 'pdftohtml' seems to make about one PNG file for each page.
##          So for a PDF containing about 100 pages, it may take about 3 minutes
##          to process all of the pages. You can keep refreshing the Nautilus
##          directory (with the Reload 'button' in the middle of the Nautilus
##          tool bar) to see the files popping up as they are created, in
##          the current directory. (A poor man's progress bar.)
##
############################################################################
## Created: 2010may12
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################

## FOR TESTING: (show statements as they execute)
#  set -x

#######################################
## Get the filename.
#######################################

#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

# FILENAME="$@"
FILENAME="$1"

#  CURDIR="$NAUTILUS_SCRIPT_CURRENT_URI"
CURDIR="`pwd`"


#######################################################
## Check that the selected file is a PDF file.
#######################################################

FILECHECK=`file "$FILENAME" | grep 'PDF'`
 
if test "$FILECHECK" = ""
then
   exit
fi


#########################################
## Initialize the directory for the output
## image and other HTML files.
##
## If the user has write-permission on the
## current directory, put the directory
## in the pwd.
## Otherwise, put the directory in /tmp.
#########################################

# OUTDIR="${USER}_temp_pdf_images_dir"
# if test ! -w "$CURDIR"
# then
#   OUTDIR="/tmp/$OUTDIR"
# fi

# if test ! -f "$OUTDIR"
# then
#    mkdir "$OUTDIR"
# fi


###########################################################
## Get the 1st and last pages to convert.
###########################################################

PAGESTARTEND=""

PAGESTARTEND=$(zenity --entry \
   --title "Enter Page Range - First and Last Pages to process." \
   --text "\
Enter Page Range to process.
      Example: 1 16" \
   --entry-text "1 1")

PAGECHECK=`echo "$PAGESTARTEND" | wc -w`

if test ! "$PAGECHECK" = "2"
then
   exit
fi

PAGEFIRST=`echo "$PAGESTARTEND" | awk '{print $1}'`
PAGELAST=`echo "$PAGESTARTEND" | awk '{print $2}'`


###########################################################
## Generate the image files from the pages of the PDF file.
###########################################################

EXECHECK=`which pdftohtml`

if test -f "$EXECHECK"
then

   HTML_ROOT="00_temp_pdftohtml"

   pdftohtml -f $PAGEFIRST -l $PAGELAST -c -noframes \
             -nomerge -zoom 1.5 -hidden -nodrm \
             "$FILENAME" "${HTML_ROOT}.html"
   ## "${HTML_ROOT}.xml"

else
   zenity --info \
   --title "'pdftohtml' not found. EXITING." \
   --text "\
It appears that the executable
'pdftohtml' is not installed.

Exiting."
   exit
fi


#################################################
## Show the first image file with an image viewer.
#################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$HTMLVIEWER "${HTML_ROOT}.html" &
