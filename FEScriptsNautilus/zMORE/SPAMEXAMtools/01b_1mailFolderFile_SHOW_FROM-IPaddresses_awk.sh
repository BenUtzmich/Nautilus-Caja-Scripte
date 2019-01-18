#!/bin/sh
##
## Nautilus
## SCRIPT: 01b_1MailFolderFile_SHOW_FROM-IPaddresses_awk.sh
##
## PURPOSE: Show the the lines of a Mail Folder file
##          that contain 'from' IP-adresses of the sent mail ---
##          namely, the IP address from the last of multiple
##          'Received: from ' lines in each email in the Folder file.
##
## METHOD:  Uses 'awk' to extrace the received-from lines.
##
##          Also show the 'From - ' lines that separate the emails
##          in the (Thunderbird) Mail Folder file.
##
##          Puts the 'From - ' lines and IP addresses, extracted from
##          the Mail Folder file, into a temp text file.
##
##          This script shows the text file with a textfile-viewer of
##          the user's choice.
##
## HOW TO USE: In Nautilus, navigate to a mail-folder file, select it,
##             right-click and choose this Nautilus script to run.
##
##             For Thunderbird mail (2010), the Mail Folder files are in
##             a directory whose name is of the form
##    $HOME/.mozilla-thunderbird/[8-scrambled-chars].default/Mail/Local Folders
##
##############################################################################
## Created: 2010may27
## Changed: 2010may29 Do not load FROMIP if the IP is 127.0.0.1
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012may12 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################

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

OUTFILE="${USER}_temp_FromIPaddresses_1mailFilder.txt"

# FILEMIDNAME=`echo "$FILENAME" | cut -d'.' -f1`
# OUTFILE="${FILEMIDNAME}_FromIPaddresses_1mailFilder.txt"

if test ! -w "$CURDIR"
then
   OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


##########################################
## Generate the awk output.
##########################################
## SAMPLE Top line of each email received:
## From - Wed May 12 14:56:45 2010
#######################################################
## SAMPLE 'Received: from' line, from ISP cox:
## Received: from fed1rmimpi04.cox.net ([70.169.32.73])
#######################################################
## SAMPLE 'Received: from' line, NOT from ISP cox:
## Received: from aol.com ([94.62.202.153])
#######################################################


echo "\
.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................

          The 'From - ' email separator LINES, the 'Date: ' lines,

          AND

          the (apparent) FROM IP-address of each email

EXTRACTED from the MAIL FOLDER FILE

  $FILENAME

in directory

   $CURDIR

.................. START OF 'awk' OUTPUT ............................
" >  "$OUTFILE"

##################################################
## HERE's the 'awk' to print out JUST the
## FROM IP *address(es)* --- NOT the rest of the
## 'Received: from ' line(s).
##################################################
## Add 'cut -c1-3071 $FILENAME |' before
## awk, to avoid 'Input record too long'
## error that stops awk dead. (on SGI-IRIX)
##################################################

cut -c1-3071 "$FILENAME" | awk  \
'BEGIN  {
   ## FOR TESTING:
   # print "Entered BEGIN" > "/dev/pts/0"
   #######################################################
   ## Initialize the FROMIP var to null.
   ## It is to hold the last-read IP address extracted from
   ## the lines being read in each email.
   #######################################################
   FROMIP = ""
   IP = ""
}
#END OF BEGIN
#START OF BODY
{
   ## FOR TESTING:
   # print "Entered BODY"
   ####################################################
   ## If the line starts with <From - >, print the
   ## value currently held in FROMIP and print that line.
   ####################################################
   ## NOTE TO SELF: Must not put single-quote in comment
   ## lines of awk code. The comment indicator, #, does
   ## NOT hide the single-quote character.
   ####################################################

   if ( $0 ~ /^From - / )  {
     print FROMIP
     print ""
     print $0 
     FROMIP = ""
   }

   ######################################################
   ## If the line starts with <Received: from >, extract
   ## the IP address from the line and store it in FROMIP.
   ######################################################

   if ( $0 ~ /^Received: from / )  {
      IDX1 = 0
      IDX2 = 0
      IP = ""

      if ( index($0,"[") != 0  )  { IDX1 = index($0,"[") ; IDX1 = IDX1 + 1 }

      if ( index($0,"]") != 0  )  { IDX2 = index($0,"]") ; IDX2 = IDX2 - 1 }

      ## FOR TESTING:
      # print "IDX1 and IDX2 :" IDX1 " " IDX2

      if ( IDX2 > IDX1 ) {
         LEN = 1 + IDX2 - IDX1
         IP = substr($0,IDX1,LEN)
         if ( IP != '127.0.0.1' ) { FROMIP = IP }
      }

   }

   ######################################################
   ## If the line starts with <Date: >, print it.
   ######################################################

   if ( $0 ~ /^Date: / )  { print $0 ; print $5 $4 $3 }

   ######################################################
   ## If the line starts with <Subject: >, print it.
   ######################################################

   if ( $0 ~ /^Subject: / )  { print $0 }

}
## END OF BODY
## START OF END
END {
     print FROMIP
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

$BASENAME

   in directory

$DIRNAME

...................................................................
" >>  "$OUTFILE"


############################
## Show the list.
############################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER  "$OUTFILE"
