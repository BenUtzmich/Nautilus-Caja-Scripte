#!/bin/sh
##
## SCRIPT: .findANDshow_strings1and2_over2linesINfile_awk.sh
##
## Where:  in $FE_SCRIPTS_DIR
##                                      where $FE_SCRIPTS_DIR is a scripts
##                                      directory of an FE subsystem. Example:
##                                      a Nautilus Scripts (sub)directory.
##
#############################################################################
## PURPOSE: Let $1 $2 $3 $4 represent the 4 positional arguments to this script
##          --- <string1> <string2> <yes/no> <filename>.
##
##          For the filename specified in $4, this script finds the match
##          lines in the file which contain a match to the string1 in the
##          1st of a pair of successive lines and string2 in the 2nd line of
##          the pair of lines.
##
##          This script shows the pair of lines (sends them to stdout), if
##          string1 is in a line and string2 is in an immediate-successor line.
##
##          This awk-based script uses case-sensitivity in the search, depending on
##          whether $3 is 'yes' or 'no'.  'no' is NO-case-sensitivity.
##
##          Example of string1 and string2:  '</tr>'  and  '</td>'
##          (to find cases where HTML tags may be in the wrong order).
##
##         NOTE: '<' and '>' in strings 1 and 2 can cause syntax errors ---
##         in the calling script if not in this script --- so in the HTML example
##         above '\</tr\>' and '\</td\>' are actually the strings than may be
##         passed into this script --- i.e. the '<' and '>' characters, if any,
##         are to be 'escaped' by back-slashes.
##
##         'awk' is used to find the match(es) and save-and-print the pair of lines
##         at a match.
##
#############################################################################
## CALL FORMAT:
##
## $FE_SCRIPTS_DIR/.findANDshow_strings1and2_over2linesINfile_awk.sh \
##                             <string1> <string2> <yes/no> <filename>
##
##  Can test with
## ./.findANDshow_strings1and2_over2linesINfile_awk.sh '\</tr\>' '\</td\>' yes <an-HTML-filename>
## ./.findANDshow_strings1and2_over2linesINfile_awk.sh '\</tr\>' '\</td\>' no  <an-HTML-filename>
#############################################################################
## CALLED BY: the FE Nautilus Scripts utility script
##                05_findSTRover2lines_in_dirMASKFILS_recursive-awk.sh
##
##                                            in $DIR_NautilusScripts/FINDtools
##
#############################################################################
## MAINTENANCE HISTORY:
## Written: Blaise Montandon 2011jun06  On an Ubuntu 9.10 development machine.
## Updated: Blaise Montandon                           
#############################################################################

THISscript="$0"
THISscriptBASE=`basename "$THISscript"`

#############################################################################
## Save input, for err msg below.
#############################################################################

  ALLinput="$*"

## FOR TESTING:
#    echo "
#    ALLinput: $ALLinput"

#############################################################################
## Get input items #1 and #2 and #3 and #4 from one string of input.
#############################################################################
## Based on the following '$1' and 'shift' example,
## from an '.../ideas_9/bin/msplot' script,
## which preserves any arguments that are delimited by quotes
## --- in particular, 'preserves' arguments with embedded spaces:
##
## while test "$1" != ""
##    APP_ARGS="$APP_ARGS \"$1\""
##    shift
## done
##
## In particular, this is meant to handle $4 if it is a filename
## with embedded spaces.
#############################################################################

###################################################################
## 1) Get the first of 4 parms --- the <string> parm.
###################################################################
## Use 'eval' to remove single-quotes that protect the string from
## interpretation by the shell.  Now the string can be special
## characters like '>'. 
####################################################################
## eval STRING1=$1
## seems to work OK. But let's try double-quotes around $1.    
####################################################################
  eval STRING1="$1"

####################################################################
## If STRING1 is a single back-slash,
## change  "\" to "\\" --- to avoid awk err msg
## 'Newline in string  ... at source line 1'
####################################################################
if test "$STRING1" = '\' 
then
    STRING1='\\'
fi

## FOR TESTING:
#    echo "
#    STRING1: $STRING1"

shift
eval STRING2="$1"

####################################################################
## If STRING2 is a single back-slash,
## change  "\" to "\\" --- to avoid awk err msg
## 'Newline in string  ... at source line 1'
####################################################################
if test "$STRING2" = '\' 
then
    STRING2='\\'
fi

## FOR TESTING:
#    echo "
#    STRING2: $STRING2"

shift
CaseSense="$1"

## FOR TESTING:
#    echo "
#    CaseSense: $CaseSense"


shift
FILEin="$1"

## FOR TESTING:
#    echo "
#    FILEin: $FILEin"


#############################################################################
## Check for input item #1 and #2 and #3 and #4.
## Post a msg and exit if any are empty.
#############################################################################

ERRMSG_MAIN="\
***********
INPUT ERROR:
Supply 4 inputs --- a STRING1 and a STRING2 and
                    yes/no (CaseSense) and a FILENAME
to script
$THISscript.

INPUT FORMAT: <STRING1> <STRING2> <yes/no> <FILENAME>

EXAMPLE: 
  $THISscriptBASE  'tr' 'td'  no  yadayadayada.htm

CURRENT INPUT: $ALLinput
"

if test "$STRING1" = "" 
then
	echo "
$ERRMSG_MAIN

Supply a STRING (first of two) to script
$THISscript.

Exiting ...
"
	exit
fi

if test "$STRING2" = ""
then
	echo "
$ERRMSG_MAIN

Supply a STRING (second of two) to script
$THISscript.

Exiting ...
"
	exit
fi

if test "$CaseSense" = ""
then
	echo "
$ERRMSG_MAIN

Supply a Case-Sensitivity Indicator (yes/no) to script
$THISscript.

Exiting ...
"
	exit
fi

if test "$FILEin" = "" 
then
	echo "
$ERRMSG_MAIN

Supply the FILENAME (of the file to search) to script
$THISscript.

Exiting ...
"
	exit
fi


#############################################################################
## CALL 'awk' -- with an appropriate awk program -- with a file as input. 
#############################################################################
## 'awk' program (AN EXAMPLE) to
##  write all lines whose first field is different from the previous one.
##
##               $1 != prev { print; prev = $1 }
##  NOTE:
##  This script is basically a more complex version of this example.
#############################################################################

##################################################
## FOR TESTING:
##################################################
#  TEST="YES"
   TEST="NO"

if test "$TEST" = "YES"
then

echo "
*..........................................................
* Pairs of lines in file $FILEin
* that match the strings '$STRING1' in the 1st line and
* '$STRING2' in the 2nd line of the pair
* --- are shown below.
*..........................................................
*  All lines are preceded by line numbers.
*  An asterisk (*) before a line-number indicates a match.
*..........................................................
"
  # set -x

fi


##################################################
## HERE's the 'awk'.
##################################################
## Add 'cut -c1-3071 $FILEin |' before
## awk, to avoid 'Input record too long'
## error that stops awk dead.
##################################################
## DO NOT USE SINGLE-QUOTES IN COMMENT STATEMENTS
## IN AWK PROGRAMS. CAUSES PREMATURE END TO PARSING.
####################################################

cut -c1-3071 "$FILEin" | \
awk  -v STRING1="$STRING1"  -v STRING2="$STRING2" -v CASESENSE="$CaseSense" \
     -v FILEIN="$FILEin" \
'BEGIN  {

   #######################################################
   ## Initialize the "PREVcomp" & "PREVorig" vars to null.
   ## They are to hold the previous line read ---
   ## for comparison and for display.
   #######################################################
   PREVcomp = ""
   PREVorig = ""

   ##################################################
   ## Convert STRING1 and STRING2 to upper-case,
   ## if CASESENSE=no.
   ##################################################

   if ( CASESENSE == "no" ) {
      STRING1 = toupper(STRING1)
      STRING2 = toupper(STRING2)
   }


   ## FOR TESTING:
   #    print "CASESENSE: " CASESENSE
   #    print "STRING1 :" STRING1
   #    print "STRING2 :" STRING2

}
#END OF BEGIN
#START OF BODY
{

   ###########################################################
   ## Set the case of the next line read, according to
   ## whether CASESENSE is "no" or "yes" --- in var HOLDcomp.
   ###########################################################

   if ( CASESENSE == "no" ) {
      HOLDcomp = toupper($0)
   } 
   if ( CASESENSE == "yes" )  {
      HOLDcomp = $0
   }
   HOLDorig = $0


   ########################################################
   ## IF WE HAVE A MATCH to STRING1, save the line in 
   ## var "PREVcomp" and use the awk "getline" function
   ## to get the next line ---
   ## to check if it matches STRING2.
   ########################################################
   ## If there is a match to STRING2, print the pair
   ## of lines --- prefixed by the filename FILEIN
   ## and by the linenums NR-1 and NR.
   ########################################################

   ## FOR TESTING: (print first 10 lines read)
   #   if  ( NR < 10 ) { print "HOLDcomp :" $HOLDcomp }
  
   ## This fails when certain special chars are in the substring.
   # if (  HOLDcomp ~ subSTRING[i] )  {  ... }

   ## FOR TESTING:
   # }" "$FILEin"
   # exit

   ## In HOLDcomp, look for a match with STRING1.
   ## If a match, get the NEXT record and
   ## look for a match with STRING2.

   if ( index(HOLDcomp,STRING1) != 0  )  {
      ## Save the current line before reading the next line.
      PREVcomp = HOLDcomp
      PREVorig = HOLDorig
      ## Read the next line.
      getline
      ## Set the case of the new line, in var HOLDcomp.
      if ( CASESENSE == "no" ) {
         HOLDcomp = toupper($0)
      } 
      if ( CASESENSE == "yes" )  {
         HOLDcomp = $0
      }
      HOLDorig = $0
      ## If a match with STRING2 in the 2nd line, print both lines.
      if ( index(HOLDcomp,STRING2) != 0  )  {
         # NRm1 = NR - 1
         printf ("*%s : %s : %s\n", FILEIN, NR - 1, PREVorig);
         printf ("*%s : %s : %s\n\n", FILEIN, NR, HOLDorig);
         # print ""
         # print ""
      }
      ## END OF if ( index(HOLDcomp,STRING2) != 0  )
   }
   ## END OF if ( index(HOLDcomp,STRING1) != 0  )

   ## FOR TESTING:
   #   print ""
   #   print "PREVcomp    : " PREVcomp
   #   print "HOLDcomp: " HOLDcomp
   #   print "index(HOLDcomp,subSTRING1): "index(HOLDcomp,subSTRING1)


#END OF BODY
}' "$FILEin"


