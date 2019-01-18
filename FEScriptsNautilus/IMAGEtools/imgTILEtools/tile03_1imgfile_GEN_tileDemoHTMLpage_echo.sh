#!/bin/sh
##
## Nautilus
## SCRIPT: tile03_1imgfile_GEN_tileDemoHTMLpage_echo.sh
##
## PURPOSE: For a selected image file ('.jpg', '.png', '.gif' or whatever)
##          this script generates an HTML page using the selected image file
##          as a background 'tile' for the 'body' of the HTML page.
##
## METHOD:  There is no prompt for a parameter.
##
##          Uses the 'echo' command to build up the HTML file.
##
##          Shows the HTML page in a web browser of the user's choice.
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##
##############################################################################
## Created: 2010apr01
## Changed: 2010apr06 Put output HTML file in /tmp if the
##                    current directory is not writeable.
##                    Adjust image filename accordingly ---
##                    i.e. make it fully-qualified.
## Changed: 2010apr06 Add escaped-quotes in the url() statement,
##                    to handle files with spaces in the name.
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012feb02 Changed the name of the script. Changed the name of
##                    the output HTML tile-demo file.
## Changed: 2012may14 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x

#########################################
## Get the filename of the selected file.
#########################################

  FILENAME="$1"
# FILENAME="$@"


#######################################################################
## Get the midname' of the input file, for naming output file(s).
##  (Assumes there is only one period in the filename, at the extension.)
#######################################################################

#  FILEMIDNAME=`echo "$FILENAME" | sed 's|\..*$||'`
   FILEMIDNAME=`echo "$FILENAME" | cut -d\. -f1`


###########################################################
## Set the HTML output filename and, in var FILENAME2,
## put the image filename in a format suitable to the
## 'background: url();' statement of the 'body' statment.
## (Fully qualify the image filename if the HTML file
##  is put in the /tmp directory instead of the current
##  directory.)
##
##     We put the HTML file in the current directory
##     (the same directory as the image file) if the user
##     has write-permission to the directory. If not,
##     we put the HTML file in /tmp and set FILENAME2
##     to its fully-qualified name.
###########################################################

CURDIR="`pwd`"

HTMFILE="${FILEMIDNAME}_TILEDEMO.htm"

if test ! -w "$CURDIR"
then
   HTMFILE="/tmp/$HTMLFILE"
   FILENAME2="$CURDIR/$FILENAME"
else
   FILENAME2="./$FILENAME"
fi

if test -f "$HTMFILE"
then
   rm -f "$HTMFILE"
fi


################################################################
## Write out the HTML page with body (background-tile) statement
## putting HTMFILE in the current directory.
################################################################

echo "
<html>
<head>
<title>
Web Page tiled with $FILENAME
</title>
<style>
body {
background: url(\"$FILENAME2\");
background-repeat: repeat;
background-attachment: scroll;
}
</style>
</head>
<body>
<p align=\"center\">
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
The quick brown fox<br>
ran over the lazy dog.<br>
</body>
</html>
" > "$HTMFILE"


######################################################
## Display the HTML page for the selected image file.
######################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$HTMLVIEWER "$HTMFILE" &
