#!/bin/sh
##
## Nautilus
## SCRIPT: 05a_anyfile4Dir_SPACE-USEDby_FILES_allLEVS_SIZEsort_find-ls-awk.sh
##
## PURPOSE: This utility will list the files, at ALL levels under
##          the current directory, sorted by size ---
##          all in the same easily-comparable units (MB),
##          with rigid (highly readable) columnar formatting.
##
##          This script uses 'find' to recursively travel through all
##          the subdirectories of the current directory.
##
## METHOD:  This script concatenates the output of 'ls' to a text file ---
##          after piping the output through 'sort' and 'awk', to produce
##          a nicely formatted report.
##
##          Shows the text file using a text-file viewer of the user's
##          choice.
##
## HOW TO USE: 
##          1) Right-click on the name of ANY file (or directory) in a
##             Nautilus directory list. (Uses the Nautilus current
##             directory as the specified/'anchor' directory.)
##          2) Then select this script to run (name above).
##
## Created: 2011apr27
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012feb29 Changed the script name in the comment above.

## FOR TESTING: (show executed statements)
#  set -x

############################################################
## Prep a temporary filename, to hold the list of filenames
## and size info.
##     If the user cannot write to the current directory,
##     put the output file in /tmp.
############################################################
## NOTE:
## We could put the report in the /tmp directory, rather than
## junking up the current directory with this report.
## BUT it may be useful to have the report available in
## the directory to which it applies.
#############################################################

OUTFILE="${USER}_space_files_alllevels_sizesort_temp.lis"

CURDIR="`pwd`"

if test ! -w "$CURDIR"
then
   OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


##########################################################################
## SET REPORT HEADING.
##########################################################################

HOST_ID="`hostname`"

echo "
................... `date '+%Y %b %d  %a  %T%p'` ............................

DISK USAGE OF *FILES* IN *ALL* THE SUB-DIRECTORIES UNDER DIRECTORY:

$CURDIR

                           ****
                SORTED BY *SIZE* --- BIGGEST FILES AT THE TOP.
                           ****

**************
Disk usage                                       Last-Modified
(MegaBytes)     Permissions  Owner     Group         (Day-Time)    Filename
--------------  -----------  --------  --------  ----------------  ----------------------
GigMeg.KilByt
  |  |   |  |" > "$OUTFILE"


########################################################################
## Run the 'find' command with 'ls -l' to generate the guts of the report.
## Format the report with 'sort' and 'awk'.
########################################################################

## FOR TESTING:
#  set -x

find $CURDIR  -type f   -exec ls -l {} \;  | \
   sort +4 -5nr | \
   awk '{ COLfilnam = index($0,$8) ; \
   printf ("%13.6f   %-10s   %-8s  %-8s  %-3s %2s  %s\n", $5/1000000, $1, $3, $4, $6, $7, substr($0,COLfilnam) )}' \
   >> "$OUTFILE"

#  sort -k5nr | \

## A VERSION that does not handle embedded blanks:
# awk '{printf ("%13.6f   %-10s   %-8s  %-8s  %-3s %2s %5s  %s\n", $5/1000000, $1, $3, $4, $6, $7, $8 )}' \

## FOR TESTING:
#  set -


########################################################################
## Add TRAILER to report.
########################################################################

SCRIPT_BASENAME=`basename $0`
SCRIPT_DIRNAME=`dirname $0`

echo "\
  |  |   |  |
GigMeg.KilByt
--------------  -----------  --------  --------  ----------------  ----------------------
(MegaBytes)     Permissions  Owner     Group         (Day-Time)    Filename
Disk usage                                       Last-Modified
*************


................... `date '+%Y %b %d  %a  %T%p'` ............................


   The SIZE-SORTED output above was generated by the script

$SCRIPT_BASENAME

   in directory

$SCRIPT_DIRNAME


   It ran the 'find' and 'ls -l' commands on host $HOST_ID .

-----------------
PROCESSING METHOD:

     A 'pipe' of several commands (find, ls, sort, awk) was used, of the form:

         find <dirname>  -type f   -exec ls -l {} \; | \\
                          sort +4 -5nr | awk '{printf ( ... )}'
 
     where {} represents a filename.

 
     The 'find' command was used to recursively travel through
     the sub-directories of the specified directory

$CURDIR

     and execute the 'ls -l {}' command.


     NOTE: If the directory you specify is actually a 'link'
           to an actual directory, the list above may be empty.
           Re-try, using the actual directory name.

------------
FEATURE NOTE:

      This technique provides a list 

         - without breaks at sub-directory 'section' names
           (which is what would happen if 'ls -lR' were used
            instead of the 'find ... -exec ls -l {}'  command)

      and, instead of 'relative' filenames, provides a list

         - with FULLY-QUALIFIED filenames.

      I.e. a list is produced that is suitable for sorting (re-ordering
      the records) and still have complete filenames for unambiguous
      identification.

........................................................................
" >> "$OUTFILE"


##################################################
## Show the listing.
##################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
