#!/bin/sh
##
## Nautilus
## SCRIPT: 14_multi-email-files_RENAME_add_From-IPaddresses_Date_grep-cut-sed-awk-mv.sh
##
## PURPOSE: Rename the user-selected email files
##          (split out from a mail-folder file using 'csplit')
##          to names based on the apparent From-IP-addresses
##          (and a date) in each email file.
##
## METHOD:  Uses { grep 'Received: from ' } piped to { tail -1 }
##          to get the FROM-IP-address from each email file.
##
##          Uses { grep 'Date: ' } piped to { head -1 } and 'awk'
##          to get the date (yyyymmmdd).
##
##          The IP address is piped into 'sed' to replace the
##          periods (.) by hyphens (-) --- to make the IP address
##          indicator to put in the new filename.
##
## HOW TO USE: In Nautilus, navigate to the directory containing the
##             email files, select the email files to be renamed,
##             right-click and choose this Nautilus script to run.
##
#######################################################################
## Created: 2010may25
## Changed: 2010may29 1) Get date from the 'Date: ' line, instead of 
##                       from the 'From - ' (first) line.
##                    2) Make sure there is a left-bracket ([) in
##                       the 'Received: from ' line that we use to get
##                       the FROM IP-address. And make sure there is
##                       not a '127.0.0.1' in that line.
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012may12 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################

## FOR TESTING: (show statements as they execute)
#  set -x

#  CURDIR="`pwd`"

##########################################################
## Prompt for a prefix to use for the renamed email files.
##########################################################

FILEPREFX=""

FILEPREFX=$(zenity --entry \
   --title "PREFIX for renamed email files." \
   --text "\
Enter a prefix.  Examples:
  spam_from      - gives names like  spam_from_<IP-address-with-hyphens>_<Date>.eml
  goodmail_from  - gives names like  goodmail_from_<IP-address-with-hyphens>_<Date>.eml
  spamPRE2009    - gives names like  spamPRE2009_from_<IP-address-with-hyphens>_<Date>.eml" \
   --entry-text "spam_from")

if test "$FILEPREFX" = ""
then
   exit
fi


##########################################
## LOOP to rename the selected email files.
##########################################
## SAMPLE Top line of each mail file:
## From - Wed May 12 14:56:45 2010
##########################################
## SAMPLE 'Received: from' line, from ISP cox:
## Received: from fed1rmimpi04.cox.net ([70.169.32.73])
##########################################
## SAMPLE 'Received: from' line, NOT from ISP cox:
## Received: from aol.com ([94.62.202.153])
##########################################
## Date: Mon, 17 May 2010 18:29:35 -0700
##----------------------------------------
## This will give us a date to use in the
## file renaming. The yyyymmmdd will be good
## enough to give the time frame of the mail.
#############################################

for FILENAME
do

   #######################################################
   ## Check that the selected file is a Mail file.
   ## This check is COMMENTED, for now.
   #######################################################

   #  FILECHECK=`file "$FILENAME" | egrep 'text|Mail|ASCII'`
 
   #  if test "$FILECHECK" = ""
   #  then
   #     exit
   #  fi

   ## FOR TESTING: (show statements as they execute)
   # set -x

   ####################################################################
   ## We don't filter out 'Received' lines from our own ISP, because
   ## spam can come from there also --- as I found out in my first test
   ## of this script.
   ####################################################################
   ## RCVDFROMLINE=`grep 'Received: from ' "$FILENAME" | grep -v "$ISP" | tail -1`
   ####################################################################

   RCVDFROMLINE=`grep 'Received: from ' "$FILENAME" | grep '[' | \
                       grep -v '127\.0\.0\.1' | tail -1`

   FROMIPADDRESS=`echo "$RCVDFROMLINE" | cut -d'[' -f2 | cut -d ']' -f1`

   FROMIPADDRESS2=`echo "$FROMIPADDRESS" | sed 's|\.|-|g'`

   ## Here's how to get date from the 'From - ' line (first line).
   # FROMDATE=`head -1 "$FILENAME" | awk '{print $7 $4 $5}'`

   ## Here's how to get date from the 'Date: ' line.
   FROMDATE=`grep 'Date: ' "$FILENAME" | head -1 | awk '{print $5 $4 $3}'`

   ## '-n' equals '--no-clobber'
   mv -n "$FILENAME" "${FILEPREFX}_${FROMIPADDRESS2}_${FROMDATE}.eml"

   ## FOR TESTING:
   # set -

done
## END OF 'for FILENAME' loop
