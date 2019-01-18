#!/bin/sh
##
## SCRIPT: 05_anyfile4Dir_findFILES-BIGGERthanNmeg_allLEVS_find-f-size-ls-sort-awk.sh
##
## PURPOSE: Relative to a 'base' directory (the 'current' directory),
##          this script lists ALL files in the directory AND in its
##          subdirectories at ALL levels below ---
##          that are bigger than a user-specified size ---
##          using the 'find' command with the '-size' option.
##
## METHOD:  Uses 'zenity' to prompt for the number of megabytes for
##          the minimum size reported.
##
##          Puts the output of the 'find' command in a text file ---
##          after piping the output through a reverse-sort on 'ls -l' field 5,
##          file size.
##
##          Shows the text file using a text-file viewer of the
##          user's choice.
##
## HOW TO USE: In Nautilus, select any file in the desired 'base' directory.
##             Then right-click and choose this Nautilus script to run.
##             (See the script name above.)
##
## Created: 2012jun25 Based on FE Nautilus Script
##       05_anyfile4Dir_findFILES-OLD-BIGGEST_allLEVS_find-f-mtime-ls-sort.sh
## Changed: 2012

## FOR TESTING: (show statements as they execute)
#  set -x


############################################
## Prompt for N megabytes, using zenity.
############################################

SIZE_MINinMEG=""

SIZE_MINinMEG=$(zenity --entry \
   --title "\
Enter N megabytes, for this 'files bigger than N megabytes' utility." \
   --text "\
Enter  an integer.
Examples:  1000 to see files bigger than one GIGabyte, and 100 for files bigger than 100 Megabytes." \
   --entry-text "500")

if test "$SIZE_MINinMEG" = ""
then
   exit
fi

SIZE_MINinBYTES=`expr $SIZE_MINinMEG \* 1000000`


#################################################
## Prepare the output file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
#################################################

CURDIR="`pwd`"

OUTFILE="${USER}_temp_dirFilesRecursiveLIST_BIGGERthan${SIZE_MINinMEG}meg_find-size-ls-sort.txt"

if test ! -w "$CURDIR"
then
   OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


#####################################
## Generate a heading for the listing.
#####################################

DATETIME=`date '+%Y %b %d  %a  %T%p'`

echo "\
..................... $DATETIME ............................

List of (non-directory) FILES under the directory
  $CURDIR
--- at ALL levels (recursive) ---
files that larger than $SIZE_MINinMEG MEGabyte(s)
and sorted so that the BIGGEST are at the top.

              Owner    FileSize(Meg) Last Modify
Permissions   Userid   GigMeg.KilByt Date-Time        Filename
----------    --------   |  |   |  | ---------------- ------------------------------
" >  "$OUTFILE"


############################################################################
## In the variable $REFMT_LS_CMD, we set an 'awk' command-script to reformat
## 'ls -l' output.    TO BE USED AT THE 'find' COMMAND BELOW ---
## AFTER the 'sort' command.
############################################################################
## NOTE on 'ls -l' format (Gnu):
##
## Sample:
## -rw-r--r--  1 userid groupid   167 2009-11-01 16:33 filename
##
## In 'ls -l' output, we will to show fields
## $1=permissions $3=userid $5=bytes $6=date $7=time $NF=$8=filename
############################################################################

  REFMT_LS_CMD="eval awk 'BEGIN {
sumsize=0
}
{ COLfilnam = index(\$0,\$8) ; \
meg=\$5/1000000 ; \
printf (\"%-13s %-8s %13.6f %10s %5s %s\n\", \$1, \$3, meg, \$6, \$7, substr(\$0,COLfilnam) ) ; \
sumsize = sumsize + meg
}
END {
printf (\"\nTOTAL (Megabytes)\ \ \ \ \ \ %13.6f \n\", sumsize )

}'"


########################################
## Add the 'find' output to the listing.
########################################

find . -type f -size +${SIZE_MINinBYTES}c -name "*" -exec ls -l {} \; |  \
      sort -r -n -k5 | $REFMT_LS_CMD >> "$OUTFILE"


#####################################
## Generate a trailer for the listing.
#####################################

SCRIPT_BASENAME=`basename $0`
SCRIPT_DIRNAME=`dirname $0`

echo "
----------    --------   |  |   |  | ---------------- ------------------------------
Permissions   Userid   GigMeg.KilByt Date-Time        Filename
              Owner    FileSize(Meg) Last Modify
 
This list was generated by script
   $SCRIPT_BASENAME
in directory
   $SCRIPT_DIRNAME

Used command

find . -type f -size +${SIZE_MINinBYTES}c -name \"*\"  -exec ls -l {} \;  |  \\
        sort -r -n -k5 | awk ...

..................... $DATETIME ............................
" >>  "$OUTFILE"


######################
## Show the listing.
######################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
