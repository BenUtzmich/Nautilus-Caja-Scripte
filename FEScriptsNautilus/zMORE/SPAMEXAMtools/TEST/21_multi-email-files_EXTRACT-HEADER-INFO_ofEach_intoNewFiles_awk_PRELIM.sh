#!/bin/sh
##
## Nautilus
## SCRIPT: 21_multi-email-files_EXTRACT-HEADER-INFO_ofEach_intoNewFiles_awk.sh
##
## PURPOSE: After a Mail Folder file has been split into separate
##          email files, this script makes a HEADERS-ONLY file
##          for each email file that the user selects (via Nautilus).
##
## METHOD:  We make each new filename using the 'middle' name of each email
##          file (the name in front of the suffix) and concatenating
##          '_headersOnly.eml'.
##
##          The header lines we put in the new 'condensed' file are the
##          lines that start with
##             - 'From - '
##             - 'Return-Path: ' 
##             - 'Received: from ' (usually at least two ;source & destination ISP's)
##             - 'From: '
##             - 'To: '
##             - 'Subject: '
##             - 'Date: '
##
##          There will usually be at least 8 lines put in each headers-only file.
##
##          We use 'awk' rather than 'egrep'. 
##          ('awk' allows for more output options, such as picking up the
##          continuation lines of 'Received: from ' lines, if we should ever
##          want to do that.)
##
## HOW TO USE: In Nautilus, navigate to a directory containing one or more
##             email files, select the ones for which you want to make
##             'headers-only' files,
##             right-click and choose this Nautilus script to run.
##
##########################################################################
## Created: 2010may27
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012may12 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################

#  CURDIR="`pwd`"


########################################################
## LOOP to make a 'headers-only' file for each mail file.
########################################################
## SAMPLE 'header' lines --- WITH continuations of the
## 'Received: from ' lines:
##########################
## From - Sun May 23 12:04:40 2010                                                                                
## Return-Path: <tlparker68key@yahoo.com>
## Received: from fed1rmimpi06.cox.net ([70.169.32.78])
##           by fed1rmmtai105.cox.net
##           (InterMail vM.8.00.01.00 201-2244-105-20090324) with ESMTP
##           id <20100517084715.WQEO11137.fed1rmmtai105.cox.net@fed1rmimpi06.cox.net>
##           for <bullmoose@cox.net>; Mon, 17 May 2010 04:47:15 -0400
## Received: from yahoo.com ([200.75.229.16])
## 	by fed1rmimpi06.cox.net with IMP
## 	id JYkp1e01C0MsKcg05Ykr9Q; Mon, 17 May 2010 04:44:56 -0400
## From: <tlparker68key@yahoo.com>
## To: <mjcronin56@cox.net>
## Subject: Simple solution to# 'your Medz needs
## Date: Mon, 17 May 2010 18:29:35 -0700
######################################################

for FILENAME
do

   #######################################################
   ## Check that the selected file is a Mail file.
   ## COMMENTED, for now.
   #######################################################

   #  FILECHECK=`file "$FILENAME" | egrep 'text|Mail|ASCII'`
 
   #  if test "$FILECHECK" = ""
   #  then
   #     # exit
   #     continue
   #  fi


   #######################################
   ## Make the new 'headers-only' filename
   ## for this mail file.
   ## NOTE: We assume the user has write permission
   ##       on the current directory, so that
   ##       these 'headers-only' files can be put
   ##       in the directory with their 'parent'
  ##       mail files.
   #######################################

   FILEMIDNAME=`echo "$FILENAME" | cut -d'.' -f1`
   OUTFILE="${FILEMIDNAME}_headersOnly.eml"

   ########################################################
   ## Here we use 'awk' to extract header lines.
   ##             - 'From - '
   ##             - 'Return-Path: ' 
   ##             - 'Received: from '  (usually at least two)
   ##             - 'From: '
   ##             - 'To: '
   ##             - 'Subject: '
   ##             - 'Date: '
   ## and put them in the (new) $OUTFILE.
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

   if ( $0 ~ /^From - / )  { print $0 ; continue }

   ######################################################
   ## If the line starts with <Return-Path: >, print it.
   ######################################################

   if ( $0 ~ /^Return-Path: / )  { print $0 ; continue }
 
   ######################################################
   ## If the line starts with <Received: from >, print it.
   ######################################################

   if ( $0 ~ /^Received: from / )  { print $0 ; continue }

   ######################################################
   ## If the line starts with <From: >, print it.
   ######################################################

   if ( $0 ~ /^From: / )  { print $0 ; continue } 

   ######################################################
   ## If the line starts with <To: >, print it.
   ######################################################

   if ( $0 ~ /^To: / )  { print $0 ; continue }

   ######################################################
   ## If the line starts with <Subject: >, print it.
   ######################################################

   if ( $0 ~ /^Subject: / )  { print $0 ; continue }

   ######################################################
   ## If the line starts with <Date: >, print it and
   ## exit to avoid reading the body of the email file.
   ######################################################

   if ( $0 ~ /^Date: / )  { print $0 ; exit }

}' > "$OUTFILE"

   ## Alternate way of feeding input file to awk.
   # }' "$FILENAME" >> "$OUTFILE"

done
## END OF 'for FILENAME' loop
