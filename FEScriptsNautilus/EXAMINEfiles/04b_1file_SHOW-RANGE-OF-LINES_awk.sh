#!/bin/sh
##
## Nautilus
## SCRIPT: 00_1file_SHOW-RANGE-OF-LINES_awk.sh
##
## PURPOSE: Reads a (huge) file and shows the lines for a given range
##          (start,end) of line numbers. (The file can contain 'binary' data.)
##
## METHOD:  Uses 'zenity --entry' to prompt for the start and end numbers.
##
##          Uses 'awk' to read the file and extract the range of lines.
##          (Much more efficient than a while-read loop in this script.)
##
##          Puts the results in a temp file and shows it in a GUI
##          text browser/editor of the user's choide.
##
## HOW TO USE: In Nautilus, navigate to a (huge) file, select it,
##             right-click and choose this Nautilus script to run.
##
## Created: 2014jul28 Based on the script
##                    '04a_1file_SHOW-STR-MATCH-LINES_awk.sh'
##                    which was based on the script
##                    'findANDshow_stringsINfile_plusminusNlines.sh'
##                    of the FE 'xpg' utility.
## Changed: 2014 

## FOR TESTING: (show statements as they execute)
# set -x

#######################################
## Get the filename.
## Also get the current directory, for
## use in report header/trailer lines.
#######################################

FILENAME="$1"

CURDIR="`pwd`"


#######################################################
## Check that the selected file is a text file.
## COMMENTED, for now.
#######################################################

#  FILECHECK=`file "$FILENAME" | egrep 'text|Mail|ASCII'`
 
#  if test "$FILECHECK" = ""
#  then
#     exit
#  fi


######################################################
## Prompt for the start,end line numbers, using zenity.
######################################################

CURDIRFOLD=`echo "$CURDIR" | fold -55`

MandN=""

MandN=$(zenity --entry \
   --title "Enter M-N, a range of line numbers." \
   --text "\
Enter M and N separated by a hyphen (i.e. minus sign).
Example: 1700-3550

Those lines of file

     $FILENAME

in directory

     $CURDIRFOLD

will be extracted into an output file." \
   --entry-text "20-50")

if test "$MandN" = ""
then
   exit
fi


#######################################
## Separate M and N at the '-' sign.
#######################################

## FOR TESTING:  (turn ON display of executed-statements)
# set -x

M=`echo "$MandN" | cut -d'-' -f1`
N=`echo "$MandN" | cut -d'-' -f2`

NM1=`expr 1 + $N - $M`

## FOR TESTING:  (turn OFF display of executed-statements)
# set -


#########################################################
## Initialize the output file.
##
## NOTE: If the selected file is in a directory for which
##       the user does not have write-permission, we
##       put the output file in /tmp rather than in the
##       current working directory.
## CHANGE: To avoid junking up the curdir, we use /tmp.
#########################################################

OUTFILE="${USER}_temp_LINES-RANGE_${M}_TO_${N}_1file.lis"

# if test ! -w "$CURDIR"
# then
  OUTFILE="/tmp/$OUTFILE"
# fi

if test -f  "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


#######################################################
## Generate a header for the listing.
## (Following are some parameters for the search that
## may be described in the header.)
#######################################################

MAXlineLEN=3071

echo "\
.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................

PRINTOUT OF LINES $M to $N OF FILE

  $FILENAME

in DIRECTORY

  $CURDIR

....... START OF 'awk' OUTPUT --- at LINE-NUMBER $M ............................
" >  "$OUTFILE"


###########################################################
## Use 'awk' to read the file and output each 'match-line'.
## --- along with a few summary stats, like number of
## match-lines found.
#############################################################
## Add 'cut -c1-$MAXLINELEN $FILENAME |' before awk, to avoid
## 'Input record too long' error that stops awk dead.
#############################################################

cut -c1-$MAXlineLEN "$FILENAME" | \
awk  -v LINESTART="$M"  -v LINEEND="$N" \
'BEGIN {

   ## Zero some counters. (Could probably use NR.)
   LINEcount = 0
}
#END OF BEGIN
#START OF BODY
{
   LINEcount += 1

   if  ( LINEcount >= LINESTART && LINEcount <= LINEEND ) { print $0 }

   if  ( LINEcount > LINEEND ) {exit}

   # printf (" %s : %s \n", LINEcount, $0)
   # printf ("*%s : %s \n", NR, $0)

}
#END OF BODY
## START OF END
END {
 printf ("\n")
 printf ("*********************************************************\n")
 printf ("SUMMARY:\n")
 printf ("START line number = %s\n", LINESTART)
 printf ("END line number = %s\n", LINEEND)
 DIFF = LINEEND - LINESTART
 printf ("DIFFERENCE (NUMBER OF LINES PRINTED) = %s\n", DIFF)
}' >> "$OUTFILE"
## WAS:
## }' "$FILENAME" >> "$OUTFILE"


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

.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................
DESCRIPTION OF SCRIPT:

This utility script uses an 'awk' program that extracts a range of lines
from a given file. The user is prompted for a pair of line numbers (start
and end numbers).

By using 'awk', we can process very large files with very long lines ---
and files with lines that contain some 'binary' data.

----------------------------------------------------------------------------
MAXIMUM LINE LENGTH OF THE SEARCH:

The first $MAXlineLEN characters of each line of the input file is
read and printed. Any characters beyond that column in a file
record is not printed.

.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................
" >>  "$OUTFILE"


############################
## Show the list.
############################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
