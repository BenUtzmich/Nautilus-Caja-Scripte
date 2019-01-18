#!/bin/sh
##
## Nautilus
## SCRIPT: 05b_anyfile4Dir_SPACE-USEDby_BIGGESTfiles_allLEVS_find-ls-awk.sh
##
## PURPOSE: This utility will list the the BIGGEST files, at ALL levels
##          under the 'current' directory --- sorted with the biggest files
##          at the top of the list.
##
## METHOD:  This script uses 'zenity' to prompt for a query parameter:
##               - a threshold level in Megabytes (to define 'big' files).
##
##          This script uses 'find' with the '-size' parameter to select
##          the biggest files, and apply the 'ls -l' command to them.
##
##          The output of the 'ls -l' command is put in a text file --- after
##          piping the output through 'sort' and 'awk', to produce
##          a nicely formatted report.
##
##          Shows the text file using a text-file viewer of the
##          user's choice.
##
## HOW TO USE: 
##          1) Right-click on the name of any file (or directory) in a
##             Nautilus directory list. (Uses the Nautilus current directory
##             as the specified/'anchor' directory.)
##          2) Then select this script to run (name above).
##
## Created: 2011apr27
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012feb29 Changed the script name in the comment above.

## FOR TESTING: (show executed statements)
#  set -x

############################################################
## Prep a temporary filename, to hold the list of subdirnames
## and file counts.
##     If the user cannot write to the current directory,
##     put the output file in /tmp.
############################################################
## NOTE:
## We could put the report in the /tmp directory, rather than
## junking up the current directory with this report.
##
## BUT it may be useful to have the report available in
## the directory to which it applies.
#############################################################

OUTFILE="${USER}_spac_BIGGESTfiles_underAdir_alllevels_temp.lis"

CURDIR="`pwd`"

if test ! -w "$CURDIR"
then
   OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


################################################################
## Prompt for a threshold file size, in MEGABYTES, using zenity.
################################################################

BIGinMEG=""

BIGinMEG=$(zenity --entry \
   --title "\
Enter number of Megabytes, to define 'big'." \
   --text "\
Enter  an integer.   Example:  1000 for 1 Gigabyte = 1000 Megabytes
NOTE: This utility will show the files under the current directory
         $CURDIR
      with the largest files sorted to the top of the list." \
   --entry-text "200")

if test "$BIGinMEG" = ""
then
   exit
fi

BIGinBYTES=`expr $BIGinMEG \* 1000000`


##########################################################################
## PREPARE THE 'BIGGEST-FILES-IN-ALL-SUBDIRS' REPORT HEADING.
##########################################################################

HOST_ID="`hostname`"

echo "\
..................... `date '+%Y %b %d  %a  %T%p'` ......................

*BIG FILES* under DIRECTORY
 
$CURDIR


          'BIG' = FILES BIGGER THAN $BIGinMEG Meg.

          FILE SIZES are shown in MEGabytes.   The list is SIZE-SORTED.

**SORT-FIELD**
Disk usage                                      Last-Modified
in MEGabytes    Permissions  Owner     Group     Date-Time/Yr  Filename
-------------   -----------  --------  --------  ------------  ----------------------
GigMeg.KilByt
  |  |   |  |
" >  "$OUTFILE"



########################################################################
## Run the 'find' command with the 'ls -l' command
## to generate the guts of the report.
##    Format the report with 'sort' and 'awk'.
########################################################################

## FOR TESTING:
#  set -x

find "$CURDIR"  -type f  -size +${BIGinBYTES}c  -exec ls -l {} \; | \
   sort +4 -5nr | \
   awk '{ COLfilnam = index($0,$8) ; \
   printf ("%13.6f   %-10s   %-8s  %-8s  %-3s %2s  %s\n", $5/1000000, $1, $3, $4, $6, $7, substr($0,COLfilnam) )}' \
   >> "$OUTFILE"

## FOR TESTING:
#  set -


###########################################
## ADD A TRAILER TO THE REPORT-FILE.
###########################################

SCRIPT_BASENAME=`basename $0`
SCRIPT_DIRNAME=`dirname $0`

echo "
  |  |   |  |
GigMeg.KilByt
-------------   -----------  --------  --------  ------------  ----------------------
Disk usage      Permissions  Owner     Group     Date-Time/Yr  Filename
in MEGabytes                                     Modified
**SORT-FIELD**

..................... `date '+%Y %b %d  %a  %T%p'` ......................

  The output above (files bigger than $BIGinMEG Meg) was created by script

$SCRIPT_BASENAME

  in directory

$SCRIPT_DIRNAME

--------

      A 'pipe' of several commands (find, sort, awk) was used, of the form:

        find <directory-name>  -type f  \\
                        -size +${BIGinBYTES}c  -exec ls -l {} \;  \\
                         | sort +4 -5nr | awk '{printf ( ... )}'

      where {} represents a filename.
 
      The 'find' command was used to travel through the sub-directories
      of the given directory --- all levels.

      The 'find' command executes the 'ls -l {}' command and 

         - provides a list with fully-qualified filenames 
 
         - shows files in lower directory levels.

      I.e. a list is produced that is suitable for size-sorting ---
           retaining the identity of the parent directory in each filename.

           In contrast, output of the 'ls -lR' command does not provide
           output suitable for size-sorting.

------------------------------------------------------------------
USAGE OF THESE REPORTS

This file report (of size-sorted, big files) is meant to be useful
IN OUT-OF-DISK-SPACE CONDITIONS of a file system, such a home-directory
file system or a root file system.

It shows only the 'big' files --- thus helping one concentrate on what
to do with the files that will have the most payback in space recovery.
.........................................................................
" >>  "$OUTFILE"


##################################################
## Show the listing.
##################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
