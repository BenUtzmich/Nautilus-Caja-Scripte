#!/bin/sh
##
## Nautilus
## SCRIPT: 01d_1MailFolderFile_SHOW_All-HEADERlines_awk.sh
##
## PURPOSE: Show the mail header lines in a Mail Folder file (or
##          in a file containing a single email).
##
## METHOD:  The header lines we print are lines that start with
##             - 'From - '
##             - 'Return-Path: ' 
##             - 'Received: from ' (usually at least two:
##                                  source & destination ISP's)
##             - 'From: '
##             - 'To: '
##             - 'Subject: '
##             - 'Date: '
##
##          There will usually be at least 8 lines printed for each email.
##
##          We use 'awk' rather than 'egrep'. 
##          ('awk' allows for more output options, such as adding blank lines
##          to separate header lines from different emails in a Folder file.)
##
##          The extracted lines are put in a temp text file.
##
##          This script shows the text file with a textfile-viewer of
##          the user's choice.
##
## HOW TO USE: In Nautilus, navigate to a mail-folder file (or a file
##             containing one email), select it,
##             right-click and choose this Nautilus script to run.
##
############################################################################
## Created: 2010may27
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012may12 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x

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
## Check that the selected file is a Mail file.
## COMMENTED, for now.
#######################################################

#  FILECHECK=`file "$FILENAME" | egrep 'text|Mail|ASCII'`
 
#  if test "$FILECHECK" = ""
#  then
#     exit
#  fi


#######################################
## Initialize the output file.
##
## NOTE: If the user has write permission on the current
##       directory, we put the output file in the 'pwd'.
##       Otherwise, we put it in /tmp.
#######################################

# OUTFILE="${USER}_temp_mailHEADERlines_1mailFilder.txt"

FILEMIDNAME=`echo "$FILENAME" | cut -d'.' -f1`
OUTFILE="${FILEMIDNAME}_headers_${USER}.txt"

if test ! -w "$CURDIR"
then
   OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


##########################################
## Generate the egrep output, with heading.
##########################################
## SAMPLE Top line of each email received:
## From - Wed May 12 14:56:45 2010
######################################################
## SAMPLE 'Received: from' line, from ISP cox:
## Received: from fed1rmimpi04.cox.net ([70.169.32.73])
######################################################
## SAMPLE 'Received: from' line, NOT from ISP cox:
## Received: from aol.com ([94.62.202.153])
##################################################

echo "\
.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................

Mail HEADER lines

extracted from the MAIL file

  $FILENAME

in directory

  $CURDIR

.................. START OF 'awk' OUTPUT ............................
" >  "$OUTFILE"

########################################################
## Here we use 'awk' to extract header lines.
##             - 'From - '
##             - 'Return-Path: ' 
##             - 'Received: from '  (usually at least two)
##             - 'From: '
##             - 'To: '
##             - 'Subject: '
##             - 'Date: '
########################################################
## Add 'cut -c1-3071 $FILEin |' before
## awk, to avoid 'Input record too long'
## error that stops awk dead. (on SGI-IRIX)
########################################################

cut -c1-3071 "$FILENAME" | awk  \
'{

   ####################################################
   ## If the line starts with <From - >, print it.
   ####################################################
   ## NOTE TO SELF: Must not put single-quote in comment
   ## lines of awk code. The comment indicator (#) does
   ## NOT hide the single-quote character.
   ####################################################

   if ( $0 ~ /^From - / )  { print "" ; print $0 }

   ######################################################
   ## If the line starts with <Return-Path: >, print it.
   ######################################################

   if ( $0 ~ /^Return-Path: / )  { print $0 }
 
   ######################################################
   ## If the line starts with <Received: from >, print it.
   ######################################################

   if ( $0 ~ /^Received: from / )  { print $0 }

   ######################################################
   ## If the line starts with <From: >, print it.
   ######################################################

   if ( $0 ~ /^From: / )  { print $0 } 

   ######################################################
   ## If the line starts with <To: >, print it.
   ######################################################

   if ( $0 ~ /^To: / )  { print $0 }

   ######################################################
   ## If the line starts with <Subject: >, print it.
   ######################################################

   if ( $0 ~ /^Subject: / )  { print $0 }

   ######################################################
   ## If the line starts with <Date: >, print it.
   ######################################################

   if ( $0 ~ /^Date: / )  { print $0 }

}' >> "$OUTFILE"

## Alternate way of feeding input file to awk.
# }' "$FILENAME" >> "$OUTFILE"



###############################
## Add a trailer to the listing.
###############################

SCRIPT_BASENAME=`basename $0`
SCRIPT_DIRNAME=`dirname $0`

echo "
.................. END OF 'awk' OUTPUT ............................

   The output above is from script

$SCRIPT_BASENAME

   in directory

$SCRIPT_DIRNAME

...................................................................
" >>  "$OUTFILE"


############################
## Show the list.
############################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER  "$OUTFILE"
