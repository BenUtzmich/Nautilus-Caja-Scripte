#!/bin/sh
##
## Nautilus
## SCRIPT: 00_1file_SHOW-STR-MATCH-LINES_awk.sh
##
## PURPOSE: Reads a (huge) file and shows the lines that contain
##          a user-specified string. (The file can contain 'binary' data.)
##
## METHOD:  Uses 'zenity --entry' to prompt for a string.
##
##          Uses 'awk' to read the file and extract matching lines.
##          (Much more efficient than a while-read loop in this script.)
##
##          Puts the results in a temp file and shows it in a GUI
##          text browser/editor of the user's choide.
##
## HOW TO USE: In Nautilus, navigate to a (huge) file, select it,
##             right-click and choose this Nautilus script to run.
##
## Created: 2014jul28 Based on the script
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


##############################################
## Prompt for the search string, using zenity.
##############################################

STRINGS=""

STRINGS=$(zenity --entry \
   --title "Enter STRING(s) to search for." \
   --text "\
Enter STRING(s) for the (Case-INsensitive) FILES search.

For example, in a huge mail file (INBOX or SENT or ...),
one could look for lines that contain 'From:' or 'Subject:'.

Multiple-strings can be specified by separating the
multiple strings by vertical-bars (|).
Example:  'from:|subject:'" \
   --entry-text "From:"
)

if test "$STRINGS" = ""
then
   exit
fi


#########################################################
## Initialize the output file.
##
## NOTE: If the selected file is in a directory for which
##       the user does not have write-permission, we
##       put the output file in /tmp rather than in the
##       current working directory.
## CHANGE: To avoid junking up the curdir, we use /tmp.
#########################################################

OUTFILE="${USER}_temp_STRINGS-MATCH_1file.lis"

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
Nlines=4
CaseSense="no"

echo "\
.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................

LINES THAT CONTAIN THE STRING(s):  $STRINGS

in the FILE

  $FILENAME

in DIRECTORY

  $CURDIR

The following listing includes PLUS-OR-MINUS $Nlines LINES before and
after each 'match-line'.

The matches are determined case-INsensitively. In other words, any
combination of upper and lower case letters in the above string(s)
is considered a match.

Line numbers are shown on the left of each printed line of the input
file, and 'match-lines' are indicated by an asterisk (*) to the left 
of the line numbers.

.................. START OF 'awk' OUTPUT ............................
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
awk  -v N="$Nlines"  -v STRING="$STRINGS" -v CASESENSE="$CaseSense" \
'BEGIN {

   ## Zero some counters.
   TOTlinesREAD = 0
   NUMmatchLINES = 0

   #######################################################
   ## Initialize the N "prev" vars to null.
   ## They are to hold the last N lines read.
   #######################################################
   for ( i = 1 ; i <= N ; i++ )
   {
       prev[i] = ""
   }


   ##################################################
   ## After converting STRING to upper-case,
   ## if CASESENSE=no,
   ## split the "STRING" into NS "subSTRING"s -- at
   ## occurrences of a vertical bar (|).
   ##################################################

   if ( CASESENSE == "no" ) {
      STRING = toupper(STRING)
   }

   NS=split(STRING,subSTRING,"|")

   ## FOR TESTING:
   #    print "CASESENSE: " CASESENSE
   #    print "NS: " NS
   #    print "subSTRING[1] :" subSTRING[1]
   #    print "subSTRING[2] :" subSTRING[2]
   #    print "subSTRING[3] :" subSTRING[3]

   ###################################################
   ## "aftcount" holds the integer N,N-1,...,2,1, or 0
   ## --- representing the number of lines after the
   ## last matched line that still need to be printed.
   ###################################################
   aftcount = 0

   ######################################################
   ## "lastprt" holds the line# of the line last printed.
   ## "lastprt" is reset any time "printf" is called.
   ######################################################
   lastprt = 0

}
#END OF BEGIN
#START OF BODY
{
   ####################################################
   ## IF WE HAVE A MATCH, SUSPEND PRINTING
   ## at N "AFTER-A-MATCH-LINES":
   ## If there is a new match, reset "aftcount" to zero.
   ##            (We do not want to print a line twice.)
   ## We will restart aftcount at N after the new match
   ## line is printed.
   ####################################################
   ## We use "Match" to indicate whether there was a
   ## match to at least one of the subSTRINGs, in the
   ## current line ($0).  Match==1 indicates a match.
   ####################################################

   Match = 0

   if ( CASESENSE == "no" ) {
      HOLDline = toupper($0)
   } 
   if ( CASESENSE == "yes" )  {
      HOLDline = $0
   }

   TOTlinesREAD += 1

   ## FOR TESTING:
   #   if  ( NR < 10 ) { print "HOLDline :" $HOLDline }

   for  ( i = 1 ; i <= NS ; i++ ) {  

      ## This fails when certain special chars are in the substring.
      # if (  HOLDline ~ subSTRING[i] )  { aftcount = 0 ; Match = 1 }

      if ( index(HOLDline,subSTRING[i]) != 0  )  {
         aftcount = 0
         Match = 1
         NUMmatchLINES += 1
      }

      ## FOR TESTING:
      #   print ""
      #   print "HOLDline: " HOLDline
      #   print "subSTRING LOOP - i: " i " subSTRING[i]: " subSTRING[i] " aftcount: " aftcount " Match: " Match
      #   print "index(HOLDline,subSTRING[i]): "index(HOLDline,subSTRING[i])

   }

   ## FOR TESTING:
   # }" "$FILENAME"
   # exit


   ######################################################
   ## PRINT ONE OF THE N "AFTER-A-MATCH-LINES":
   ## If "aftcount" is non-zero, print the current line.
   ## We had a match up to N lines ago. Decrement "aftcount"
   ## and save the number of the printed line in "lastprt".
   ######################################################

   if ( aftcount != 0 ) {

      printf (" %s : %s \n", NR, $0);

      ## If this is the last of the "aftcount" lines,
      ## print a blank line.
      if ( aftcount == 1 ) {print ""}

      aftcount = aftcount - 1 ;
      lastprt = NR

      ## FOR TESTING:
      #  print "aftcount != 0  CHECK::  aftcount: " aftcount " lastprt: " lastprt
   }

   ## FOR TESTING:
   # }" "$FILENAME"
   # exit


   ######################################################
   ## IF WE HAVE A MATCH, PRINT N-PREV & CURRENT:
   ## If there is a match, print the N previous lines
   ## --- as long as their linenums are greater than
   ## the last-printed line number.  (We do not want
   ## to print a line twice.)
   ##
   ## Then print the current line.  Also set "aftcount"
   ## to N, and save the
   ## number of the matched-printed line in "lastprt".
   ######################################################

   for  ( i = N ; i > 0 ; i-- ) {  

      recnum = NR - i
      if ( Match == 1 && recnum > lastprt ) {
         printf (" %s : %s \n", recnum, prev[i])
      }

      ## FOR TESTING:
      #  print "prev[] PRINT-LOOP::  NR= " NR " recnum= " recnum " i= " i
      #  print "prev[] PRINT-LOOP::  lastprt= " lastprt " prev[i]= " prev[i]
   }


   if ( Match == 1 ) {

       printf ("*%s : %s \n", NR, $0);
       aftcount = N;
       lastprt = NR

       ## FOR TESTING:
       #  print "Match == 1 TEST::  aftcount: " aftcount " lastprt: " lastprt
   }


   ########################################################
   ## Update prev[N], prev[N-1], ... , prev[2], and prev[1]
   ## before reading the next line.
   ########################################################

   for  ( i = N ; i > 1 ; i-- )
   {  
     prev[i] = prev[i-1]
   }

   prev[1] = $0

}
#END OF BODY
## START OF END
END {
 printf ("*********************************************************\n")
 printf ("SUMMARY:\n")
 printf ("Number of lines containing the string(s) = %s\n", NUMmatchLINES)
 printf ("Total number of lines read = %s\n", TOTlinesREAD)
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

This utility script uses an 'awk' program that essentially extends the
capabilities of the 'egrep' (extended grep) program. ['grep' is a program
that can find lines in a file that contain a given string of characters.]

'egrep' can show the lines of a file that contain matches to *one-or-more*
strings.  Example: 'error', 'fail', 'fatal', or 'warning'.

With 'egrep', the multiple-strings argument is formed by separating the
multiple strings by vertical-bars (|).  Example:  'fatal|error|fail|warning'

But 'egrep' cannot show nearby lines.  The 'awk' program used here essentially
creates an extension of the 'egrep' (extended grep) utility.

----------------------------------------------------------------------------
THE PLUS-OR-MINUS N LINES CAPABILITY:

This utility can show plus-or-minus N lines above and below the lines that
have a match for the search string(s).

For now, N is hard-coded to $Nlines --- so this utility shows plus-or-minus
$Nlines lines above and below the 'match-lines'.

You could say this is an 'eegrep' utility --- extended, extended grep.

----------------------------------------------------------------------------
CASE-(IN)SENSITIVITY OF THE SEARCH:

With 'egrep', one can make the search case-insenstive with the '-i' option.
Likewise, this utility COULD be told to make the search either
case-sensitive or NOT.

For now, this utility is hard-coded to case-sense=\"no\". For example,
to find all lines containing either 'memory' or 'RAM' or 'disk', you
can use the search string 'memory|ram|disk'.

Note that the example search may return too many lines for the string 'ram'
--- lines with words like 'datagram' or 'telegram' or 'ramble' or 'gram'.

We could add a prompt for case-sensitivity of the search. Then, with a
case-sensitivity switch set to ON --- one could use a search string like
'memory|RAM|disk'.

----------------------------------------------------------------------------
MAXIMUM LINE LENGTH OF THE SEARCH:

The first $MAXlineLEN characters of each line of the input file is
searched for matches. Any characters beyond that column in a file
record is not searched for a match.

.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................
" >>  "$OUTFILE"


############################
## Show the list.
############################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
