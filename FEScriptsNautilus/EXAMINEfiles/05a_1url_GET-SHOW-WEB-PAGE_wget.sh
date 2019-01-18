#!/bin/sh
##
## Nautilus
## SCRIPT: 05a_1url_GET-SHOW-WEB-PAGE_wget.sh
##
## PURPOSE: Show the contents of a web page that has been fetched
##          (using 'wget') from a web site into a local temp-file.
##
## METHOD:  Uses 'zenity --entry' to prompt for the URL of the web page.
##
##          Uses the 'wget' command to put the page in a local text file.
##
##          Shows the text file with a text-file viewer of the
##          user's choice.
##
## HOW TO USE: In Nautilus, navigate to ANY file, select it,
##             right-click and choose this Nautilus script to run.
##
## Created: 2015dec21
## Changed: 2017sep10 Chgd 'EXAMINE-WEB-PAGE' to 'GET-SHOW-WEB-PAGE'.

## FOR TESTING: (show statements as they execute)
# set -x

TEMPDIR="/tmp"

##############################################
## Use 'zenity' to prompt for the URL.
##############################################

URL=$(zenity --entry \
   --title "Get the URL of a web page." \
   --text "\
Enter a web page URL.

Examples:
http://www.example.com/   OR
http://www.example.com/yadayada/whatever.htm

A copy of the web page will be put in a file in directory

     $TEMPDIR
" \
   --entry-text "")

if test "$URL" = ""
then
   exit
fi


########################################################
## Initialize the output file.
##
## NOTE: If the user has write permission on the current
##       directory, we put the output file in the 'pwd'.
##       Otherwise, we put it in /tmp.
#######################################################

OUTFILE="$TEMPDIR/${USER}_temp.htm"

if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi

#######################################
## Prepare a header in the output file.
#######################################

echo "The following text is from
$URL
VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
" >> "$OUTFILE"


#######################################
## Get the web page using 'wget'.
##
## Some examples: ( from http://www.labnol.org/software/wget-command-examples/28750/ )
##
## To download a file but save it locally under a different name:
##    wget --output-document=filename.html example.com
##
## To download files from websites that check the User Agent and the HTTP Referer:
##   wget --refer=http://google.com --user-agent="Mozilla/5.0 Firefox/4.0.1?" http://nytimes.com
#######################################

## Some pages have very long lines. We need 'fold'.
# wget --refer=http://google.com --user-agent="Mozilla/5.0 Firefox/4.0.1?" \
#      -O "$OUTFILE" $URL

wget --refer=http://google.com --user-agent="Mozilla/5.0 Firefox/4.0.1?" \
     -O - "$URL" | fold -s -b -w 72 >> "$OUTFILE"


############################
## Show the list.
############################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
