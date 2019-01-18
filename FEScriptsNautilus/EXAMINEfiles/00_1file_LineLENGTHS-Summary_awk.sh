#!/bin/sh
##
## Nautilus
## SCRIPT: 00_1file_lineLENGTHS_Summary_awk.sh
##
## PURPOSE: Reads a file and shows the minimum length and maximum length
##          records at end-of-file. Shows a few other summary statistics.
##
## METHOD:  Uses 'awk'. Much more efficient than a while-read
##          loop in this script.
##
##          Puts the results in a temp file and shows it in a GUI
##          text browser/editor of the user's choide.
##
## HOW TO USE: In Nautilus, navigate to a (text) file, select it,
##             right-click and choose this Nautilus script to run.
##
## Created: 2010may27
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012feb29 Changed the script name in the comment above.

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
## Check that the selected file is a text file.
## COMMENTED, for now.
#######################################################

#  FILECHECK=`file "$FILENAME" | egrep 'text|Mail|ASCII'`
 
#  if test "$FILECHECK" = ""
#  then
#     exit
#  fi


#########################################################
## Initialize the output file.
##
## NOTE: If the files is in a directory for which the user
##       does not have write-permission,
##       we put the output file in /tmp rather than in the
##       current working directory.
## CHANGE: To avoid junking up the curdir, we use /tmp.
#########################################################

OUTFILE="${USER}_temp_lineLengths_SUMMARY_1file.lis"

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
#######################################################

echo "\
.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................

SUMMARY LINE LENGTH STATISTICS

for the file

  $FILENAME

in directory

  $CURDIR

.................. START OF 'awk' OUTPUT ............................
" >  "$OUTFILE"


#######################################################
## Use 'awk' to read the file and output, at end-of-file,
## the max and  min length of the lines into the OUTFILE
## --- along with a few other summary stats.
#######################################################

awk  'BEGIN {
MAXLEN = 0;
MINLEN = 64000000;
# NUMLINS = 0;
TOTCHAR = 0;
}
## END OF BEGIN
## START OF BODY
{
         if ( length < MINLEN ) {
		MINLEN = length
         };

         if ( length > MAXLEN ) {
		MAXLEN = length
         };

    # NUMLINS += 1
    TOTCHAR += length
}
## END OF BODY
## START OF END
END {
 printf ("Max Record Length (bytes) = %s\n", MAXLEN); 
 printf ("Min Record Length (bytes) = %s\n", MINLEN);
 printf ("Number of Records         = %s\n", NR);
 CHARPERREC = TOTCHAR / NR;
 # CHARPERREC = TOTCHAR / NUMLINS;
 printf ("Ave. Chars per Recs Read  = %s\n", CHARPERREC); 
}' "$FILENAME" >> "$OUTFILE"


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

...................................................................
" >>  "$OUTFILE"


############################
## Show the list.
############################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
