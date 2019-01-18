#!/bin/sh
##
## Nautilus
## SCRIPT: 00_1file_ADD-CNT-inCol1_wc-while-read.sh
##                                 
## PURPOSE: Reads a file and puts a count number in column 1 ---
##          that is, puts the contents of each line read after
##          a line-count --- in each line of the new file copy.
##
##          This is intended to be used to add vertex counts
##          to xyz data lines of a 3D data file, starting the
##          count at 0.
##
##          Lines that start with '#' (typically an indicator
##          of a comment line) are output without adding a line count.
##
##          Also blank lines (lines that are just a line-feed or
##          spaces and a line-feed) are skipped (not put in the
##          output file).
##
## METHOD:  Uses a while-read loop to read the user-selected input
##          file, and an 'echo "....." >' statement to
##          concatenate the lines to the output file.
##
##          Puts the results in a temp file and shows it in a GUI
##          text browser/editor of the user's choice.
##
## HOW TO USE: In Nautilus, navigate to a (text) file, select it,
##             right-click and choose this Nautilus script to run.
##
## Created: 2012aug17
## Changed: 2012

## FOR TESTING: (show statements as they execute)
# set -x

#######################################
## Get the filename.
#######################################

FILENAME="$1"


#######################################################
## Check that the selected file is a text file.
## COMMENTED, for now.
#######################################################

#  FILECHECK=`file "$FILENAME" | egrep 'text|Mail|ASCII'`
 
#  if test "$FILECHECK" = ""
#  then
#     exit
#  fi


################################################################
## Prompt for an end indicator to stop processing the input file.
################################################################

ENDSTRING=""

ENDSTRING=$(zenity --entry \
   --title "Enter an end-of-processing indicator." \
   --text "\
Enter a string that indicates this utility should stop processing
the input file when a record is encountered that contains this
string anywhere in the record (case-sensitive).

Examples:
 cnx - an indicator that connection data records follow and
       no more vertex records.

NOTE: If you enter a string that cannot be found in the file,
      the processing will continue to the end-of-file." \
   --entry-text "cnx")

if test "$ENDSTRING" = ""
then
   exit
fi

#########################################################
## Initialize the output file.
##
## NOTE: If the files is in a directory for which the user
##       does not have write-permission,
##       we put the output file in /tmp rather than in the
##       current working directory.
## CHANGE: To avoid junking up curdir, we use /tmp.
#########################################################

CURDIR="`pwd`"

OUTFILE="${FILENAME}_ADDED-COUNTS-in-COL1"

# if test ! -w "$CURDIR"
# then
OUTFILE="/tmp/$OUTFILE"
# fi

if test -f  "$OUTFILE"
then
   rm -f "$OUTFILE"
fi



###############################################################
## Use a while-read loop to read the file and put the
## count at the start of each line that is not a comment line
## or a blank line (line-feed only or spaces and a line-feed).
###############################################################

CNT=0

while read LINE
do

   ## FOR TESTING:
   #   echo "$LINE"


   ## Break out of this read-loop if the end indicator is found.

   ENDCHECK=`echo "$LINE" | grep "$ENDSTRING"`

 #  if test ! "$ENDCHECK" = ""
 #  then
 #     break
 #  fi


   ## Skip comment lines.

   FIRSTCHAR=`echo "$LINE" | cut -c1`

   if test "$FIRSTCHAR" = "#"
   then
	   echo "$LINE" >> "$OUTFILE"
      continue
   fi

   ## Skip blank lines.
   ## Put the count in any other line and augment the count,
   ## then read another line.

   BLANKCHECK=`echo "$LINE" | sed 's/^ *$/EMPTY/'`

   if test "$BLANKCHECK" = "EMPTY"
   then
      continue
   else
	   echo "$CNT $LINE" >> "$OUTFILE"
      CNT=`expr $CNT + 1`
      continue
   fi


done < "$1"
## END OF LOOP: while read LINE


###############################
## Add a trailer to the listing.
###############################

SCRIPT_BASENAME=`basename $0`
SCRIPT_DIRNAME=`dirname $0`

echo "
.....................................
END OF ADDING COUNTS TO LINES OF FILE
$FILENAME

Check the lines above for properly numbered lines.
If OK, cut and paste the lines into the desired file.

.....................................................................

The output above is from script

  $SCRIPT_BASENAME

in directory

  $SCRIPT_DIRNAME

.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................
" >> "$OUTFILE"


############################
## Show the list.
############################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
