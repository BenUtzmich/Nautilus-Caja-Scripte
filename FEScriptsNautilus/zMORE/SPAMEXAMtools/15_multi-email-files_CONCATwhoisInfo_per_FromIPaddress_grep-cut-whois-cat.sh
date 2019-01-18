#!/bin/sh
##
## Nautilus
## SCRIPT: 15_multi-email-files_CONCATwhoisInfo_per_FromIPaddress_grep-cut-whois-cat.sh
##
## PURPOSE: For each user-selected email file (selected via Nautilus),
##          this script
##          extracts the apparent FROM-IP-address from the contents of
##          the email file and uses the 'whois' command to CONCATENATE
##          'whois <IPaddress>' info to each selected email file.
##
## METHOD:  Uses { grep 'Received: from ' } piped to { tail -1 }
##          to get the FROM-IP-address from the contents of the mail file.
##
##          The email files are named 
##              '<prefix>_<IPaddress-with-hyphens>_<date>.<suffix>'
##          if created from a (Thunderbird) mail folder by the
##          mail folder 'SPLIT' FE Nautilus script utility
##          in this family of mail-processing scripts.
##
##          The 'last' received-from IP-address is the probable ORIGINATING
##          mail-server IP-address of each sent mail --- hopefully
##          not tampered with by the sender.
##
##          The other IP addresses in the 'preceding' 'Received: from ' lines
##          in the email file are generally IP addresses for hosts that
##          forwarded the email.
##
## HOW TO USE: In Nautilus, navigate to the directory containing the
##             email files (whatever they are named),
##             select the desired email files in the directory,
##             right-click and choose this Nautilus script to run.
##
###########################################################################
## Created: 2010may25
## Changed: 2010may29 Make sure there is a left-bracket ([) in
##                    the 'Received: from ' line that we use to get
##                    the FROM IP-address. And make sure there is
##                    not a '127.0.0.1' in that line.
## Changed: 2011may02 Added $USER in a temp filename.
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012may12 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################

#  CURDIR="`pwd`"


####################################################
## LOOP to concatenate the 'whois' info to the files.
####################################################
## SAMPLE Top line of each mail file:
## From - Wed May 12 14:56:45 2010
#####################################################
## SAMPLE 'Received: from' line, from ISP cox:
## Received: from fed1rmimpi04.cox.net ([70.169.32.73])
######################################################
## SAMPLE 'Received: from' line, NOT from ISP cox:
## Received: from aol.com ([94.62.202.153])
######################################################

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

   ##############################################################
   ## This original attempt, at getting the proper FROM line,
   ## would be inadequate, when the last
   ## 'Received: from ' line contained no IP address --- or if
   ## the IP address were 127.0.0.1.
   ##############################################################
   ## RCVDFROMLINE=`grep 'Received: from ' "$FILENAME" | tail -1`

   ##################################################################
   ## This should make pretty sure we get the (apparent) FROM address,
   ## but there may be a few 'misses', out of hundreds processed.
   ## We might have to correct those renamings, manually.
   ##    One known exception: When there are two IP addresses in a
   ##    'Received: from ' line, the 2nd one being the one we want.
   ##################################################################
   RCVDFROMLINE=`grep 'Received: from ' "$FILENAME" | grep '[' | \
                      grep -v '127\.0\.0\.1' | tail -1`

  FROMIPADDRESS=`echo "$RCVDFROMLINE" | cut -d'[' -f2 | cut -d ']' -f1`

   ##########################################################
   ## We could put the 'whois' output for the IPaddress into
   ## a separate file, like this:
   ##########################################################

   #  FROMIPADDRESS2=`echo "$FROMIPADDRESS" | sed 's|\.|-|g'`
   #  WHOISFILENAME="whois_${FROMIPADDRESS2}.txt"
   #  whois "$FROMIPADDRESS" > "$WHOISFILENAME"

   #############################################################
   ## We concatenate the 'whois' info to the email file,
   ## like this:
   #############################################################

   echo "
###########################
'whois' info for IP address $FROMIPADDRESS
###########################
" >> "$FILENAME"
   whois "$FROMIPADDRESS" >> "$FILENAME"

  ## FOR TESTING: (turn off display of executed statements)
  # set -

done
## END OF 'for FILENAME' loop
