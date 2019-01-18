#!/bin/sh
##
## NAUTILUS
## SCRIPT: 09_1wabFile_SHOW_STRINGS_inMS-ADDRESS-BOOKfile_strings.sh
##
## PURPOSE: Converts a Microsoft '.wab' (Windows Address Book)
##          file to a text file --- using the 'strings' command.
##
##  METHOD: Uses a user-specified text viewer to display the
##          output text file.
##
## NOTE: Unfortunately the text will contain a lot of superfluous junk,
##       and user names may be many lines from their corresponding
##       email addresses. BUT at least you can see the names and 
##       addresses in the file.
##
##       Furthermore, you may be able to edit the text file into a
##       file that you can import into a mail-reader program or
##       address-book management program --- or at least edit and print a
##       fairly readable cross-reference list of names and email addresses.
##
## REFERENCE:
## http://www.sourcefiles.org/Internet/Mail/Utilities/Address_books/libwab-060901.tar.gz.shtml
## which showed the example line
##                cat YourWabFile.wab |tr -d '\000'|strings|less
##
## HOW TO USE: 
##         1) Click on the name of a valid '.wab' file in a Nautilus
##            directory list. 
##         2) Then right-click and choose this script to run (name above).
##
##########################################################################
## Created: 2011dec06
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
##########################################################################

## FOR TESTING: (show statements as they execute, in a terminal window)
#   set -x

FILENAME="$1"


#######################################################
## Make the output '.txt' filename.
##   (We put the file in /tmp since the source file
##    may be in a Microsoft MSDOS or NTFS file system.)
#######################################################

OUTFILE="/tmp/wabfile.txt"

if test -f "$OUTFILE"
then
   rm "$OUTFILE"
fi


##################################################
## Use 'tr' and 'strings' to make the '.txt' file.
##################################################

cat "$FILENAME" | tr -d '\000' | strings > "$OUTFILE"


#################################
## Show the output '.txt' file.
#################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE"
