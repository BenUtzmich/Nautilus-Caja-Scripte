#!/bin/sh
##
## Nautilus
## SCRIPT: 00a_1mailFolderFile_COUNT-Emails_awk.sh
##
## PURPOSE: Counts the Emails in a Mail Folder file ---
##          by counting the number of records that start with
##          'From - '.
##
## METHOD:   This works for Thunderbird mail folders in which
##           a 'From - ' rec starts each email. If this does
##           not work for the folders of your email client,
##           you can change a line below to count 'Subject: '
##           or 'Date: ' or 'To: ' recs instead.)
##
##          We use 'awk' rather than 'grep' and 'wc'. 
##          'awk' allows for more processing-options/enhancements.
##
##          The email count is shown in a 'zenity' popup.
##
## HOW TO USE: In Nautilus, navigate to a mail-folder file, select it,
##             right-click and choose this Nautilus script to run.
##
##             For Thunderbird mail (2010), the Mail Folder files are in
##             a directory whose name is of the form
##    $HOME/.mozilla-thunderbird/[8-scrambled-chars].default/Mail/Local Folders
##
###########################################################################
## Created: 2010may27
## Changed: 2010may29 Use 'zenity' to show the number of emails, instead
##                    of putting the number in a file and showing the file.
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
##########################################################################

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


#######################################################
## Initialize the output file.
##
## NOTE: If the user has write permission on the current
##       directory, we put the output file in the 'pwd'.
##       Otherwise, we put it in /tmp.
#######################################################

#  OUTFILE="${USER}_temp_countEmails_in1mailFolder.txt"

  # FILEMIDNAME=`echo "$FILENAME" | cut -d'.' -f1`
  # OUTFILE="${FILEMIDNAME}_emailsCOUNT.txt"

#  if test ! -w "$CURDIR"
#  then
#     OUTFILE="/tmp/$OUTFILE"
#  fi

#  rm -f "$OUTFILE"


##########################################
## Generate the 'awk' output, with heading.
##########################################
## SAMPLE Top line of each email received:
## From - Wed May 12 14:56:45 2010
######################################################
## SAMPLE 'Received: from' line, from ISP cox:
## Received: from fed1rmimpi04.cox.net ([70.169.32.73])
######################################################
## SAMPLE 'Received: from' line, NOT from ISP cox:
## Received: from aol.com ([94.62.202.153])
######################################################

# echo "\
# .................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................
# 
# NUMBER OF EMAILS
# 
# in the MAIL FILE
# 
#   $FILENAME
# 
# in directory
# 
#   $CURDIR
# 
# .................. START OF 'awk' OUTPUT ............................
# " >  "$OUTFILE"


##################################################
## HERE's the 'awk' -- to count the emails
## in the selected file.
##################################################
## Add 'cut -c1-3071 $FILENAME |' before
## awk, to avoid 'Input record too long'
## error that stops awk dead. (on SGI-IRIX)
##################################################

AWKOUTPUT=`cut -c1-3071 "$FILENAME" | awk  \
'BEGIN  {
# MAXLEN = 0;
# MINLEN = 64000000;
NUM_EMAILS = 0;
# TOTCHAR = 0;
}
#END OF BEGIN
#START OF BODY
{

   ####################################################
   ## If the line starts with <From - >, augment
   ## the NUM_EMAILS count.
   ####################################################
   ## NOTE TO SELF: Must not put single-quote in comment
   ## lines of awk code. The comment indicator (#) does
   ## NOT hide the single-quote character.
   ####################################################

   if ( $0 ~ /^From - / )  { NUM_EMAILS = NUM_EMAILS + 1 }

}
## END OF BODY
## START OF END
END {
   printf ("Number of Emails  = %s\n", NUM_EMAILS);
}'`

# }' >> "$OUTFILE"

## Alternate way of feeding input file to awk.
# }' "$FILENAME" >> "$OUTFILE"


###############################
## Add a trailer to the listing.
###############################

# echo "
# .................. END OF 'awk' OUTPUT ............................
# 
#    The output above is from script
# 
# $BASENAME
#
#   in directory
#
# $DIRNAME
#
# ....................................................................
# " >>  "$OUTFILE"

############################
## Show the list.
############################

## OLD WAY:
## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

# . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
# . $DIR_NautilusScripts/.set_VIEWERvars.shi

# $TXTVIEWER  "$OUTFILE"


##################################
## Show the awk output with zenity.
##################################

CURDIRFOLDED=`echo "$CURDIR" | fold -40`

zenity --info \
   --title "NUMBER of EMAILS in a file." \
   --text "\
$AWKOUTPUT

in mail file

    $FILENAME

in directory

    $CURDIRFOLDED"
