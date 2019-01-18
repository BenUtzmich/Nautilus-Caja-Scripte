#!/bin/sh
##
## Nautilus
## SCRIPT: 13_1MailFolderFile_SPLIT_into_emailFiles_withYourPrefix9999_csplit.sh
##
## PURPOSE: Splits a Mail folder-file into separate emails.
##
## METHOD:  Uses 'csplit' to split at the lines starting with
##          'From - '.
##
##          The new filenames are of the form 
##          <prefix>0000, <prefix>0001, <prefix>0002, ...
##
##          We use 'zenity' to prompt for a prefix to use.
##
## HOW TO USE: In Nautilus, navigate to a mail-folder file, select it,
##             right-click and choose this Nautilus script to run.
##
#########################################################################
## Created: 2010may25
## Changed: 2010may29 Add a 'zenity' prompt for prefix.
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


#############################################################
## Prompt for a prefix to use for the 'csplit'-ed email files.
#############################################################

FILEPREFX=""

FILEPREFX=$(zenity --entry \
   --title "PREFIX for the email files created by 'csplit'." \
   --text "\
Enter a prefix.  Examples:
  spam         - gives names like  spam0001, spam0002, spam0003, ...
  goodmail     - gives names like  goodmail0001, goodmail0002, ...
  spamPRE2009_ - gives names like  spamPRE2009_0001, spamPRE2009_0002, ..." \
   --entry-text "spam_from")

if test "$FILEPREFX" = ""
then
   exit
fi


##########################################
## Generate the separate mail files,
## using 'csplit'.
##########################################

# csplit  -k -s -n 4 -f "$FILEPREFX" "$FILENAME" "/^From \- /" "{*}"

csplit  -k -s -n 4 -f "$FILEPREFX" "$FILENAME" "/From - /" "{*}"
