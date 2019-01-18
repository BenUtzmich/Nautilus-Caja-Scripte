#!/bin/sh
##
## Nautilus
## SCRIPT: 16_multi-email-files-with-whois-info_RENAME_addCOUNTRYcode_grep-mv.sh
##
## PURPOSE: For each user-selected email file (selected via Nautilus)
##          --- TO WHICH 'whois' INFO HAS BEEN CONCATENATED TO THE FILE
##          --- this script
##          extracts the country code (from a 'country: ' line in the
##          email file and uses it to rename the email file.
##
## METHOD:  We use  { grep -i 'country: ' } piped to { awk '{print $2}' }
##          to get the COUNTRY CODE (should be 2 character).
##
##             ('cut' might be used instead of 'awk', for quicker execution
##              on hundreds of mail files.)
##
##          The email files are, typically, named from names like
##              '<prefix>_<IPaddress-with-hyphens>_<date>.eml'
##          to
##              '<prefix>_<IPaddress-with-hyphens>_<date>_<countryCode>.eml'.
##
##          The names of the mail files will be of that form
##          IF created from a mail folder by the
##          'RENAME_add_From-IPaddresses_and_Date'
##          FE Nautilus script utility ,
##          in this family of mail-processing scripts.
##
##          If no country code is found, the email file is not renamed.
##
## HOW TO USE: In Nautilus, navigate to the directory containing the
##             '*.eml' mail files (or whatever they are named),
##             select the desired '*.eml' files in the directory,
##             right-click and choose this Nautilus script to run.
##
########################################################################
## Created: 2010may25
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012may12 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################

#  CURDIR="`pwd`"


####################################################
## LOOP to get the country-code from the 'whois' info
## in each file and to rename each file.
####################################################
## SAMPLE 'whois' data:
## 
## inetnum:        83.203.178.0 - 83.203.178.255
## netname:        IP2000-ADSL-BAS
## descr:          BSNCY156 Nancy Bloc 1
## country:        FR
## admin-c:        WITR1-RIPE
## tech-c:         WITR1-RIPE
## status:         ASSIGNED PA
## remarks:        for hacking, spamming or security problems send mail to
## remarks:        postmaster@wanadoo.fr AND abuse@wanadoo.fr
## mnt-by:         FT-BRX
## source:         RIPE # Filtered
## 
## role:           Wanadoo France Technical Role
## address:        FRANCE TELECOM/SCR
## address:        48 rue Camille Desmoulins
## address:        92791 ISSY LES MOULINEAUX CEDEX 9
## address:        FR
## phone:          +33 1 58 88 50 00
## e-mail:         abuse@orange.fr
## admin-c:        WITR1-RIPE
## tech-c:         WITR1-RIPE
## nic-hdl:        WITR1-RIPE
## mnt-by:         FT-BRX
## source:         RIPE # Filtered
## 
## % Information related to '83.200.0.0/14AS3215'
## 
## route:          83.200.0.0/14
## descr:          France Telecom
## origin:         AS3215
## mnt-by:         RAIN-TRANSPAC
## source:         RIPE # Filtered
#########################################################

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

   COUNTRYLINE=`grep -i 'country: ' "$FILENAME" | tail -1`

   # COUNTRYCODE=`echo "$COUNTRYLINE" | cut -d':' -f2`
   COUNTRYCODE=`echo "$COUNTRYLINE" |  awk '{print $2}'`

   ###############################################
   ## Make the new 'country-code' filename
   ## for this mail file and rename it with 'mv'.
   ## (Assumes at most one period in the filename,
   ##  at a suffix like '.eml'.)
   ##
   ## NOTE: We assume the user has write permission
   ##       on the current directory, so that
   ##       the 'mv' command can be performed.
   ###############################################

   if test ! "$COUNTRYCODE" = ""
   then

      FILEMIDNAME=`echo "$FILENAME" | cut -d'.' -f1`
      NEWFILENAME="${FILEMIDNAME}_${COUNTRYCODE}.eml"

      mv "$FILENAME" "$NEWFILENAME"

   fi

   ## FOR TESTING: (turn off display of executed statements)
   # set -

done
## END OF 'for FILENAME' loop
