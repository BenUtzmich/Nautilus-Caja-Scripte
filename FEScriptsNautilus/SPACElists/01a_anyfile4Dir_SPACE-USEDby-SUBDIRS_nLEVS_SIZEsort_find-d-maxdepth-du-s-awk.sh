#!/bin/sh
##
## Nautilus
## SCRIPT: 01_anyfile4Dir_SPACE-USEDby_SUBDIRS_nLEVS_SIZEsort_find-d-maxdepth-du-s-awk.sh
##
## PURPOSE: This utility will show the space used by all subdirs
##          UP TO 'N' levels down, under the 'current' directory.
##
##          This utility will list the subdirs, at ALL levels under
##          the current directory, sorted by size ---
##          all in the same easily-comparable units (MB),
##          with a fixed (highly readable) columnar formatting.
##
##          This script uses 'find' to recursively travel through all
##          the subdirectories, down to level 'N', of the current directory.
##
## METHOD:  This script uses 'zenity' to prompt for N, the max number
##          of levels of subdirectories to report on.
##
##          This script puts the output of 'du -s', for each subdir,
##          into a text file --- after piping the 'find-du' output
##          through 'sort' and 'awk', to produce a nicely formatted report.
##
##          Shows the text file using a text-file viewer of the user's
##          choice.
##
## HOW TO USE: 
##          1) Right-click on the name of ANY file (or directory) in a
##             Nautilus directory list. (Uses the Nautilus current
##             directory as the specified/'anchor' directory.)
##          2) Then select this script to run (name above).
##             (NOTE: The report will be based at the parent directory
##             of the selected file.)
##
## MAINTENANCE HISTORY:
## Created: 2015mar01 Based on the script
##                    01_anyfile4Dir_SPACE-USEDby_SUBDIRS_nLEVS_SIZEsort_du-maxdepth-awk.sh
##                    which seemed to run too slow on 'deep' directories ---
##                    apparently because the '--max-depth' parm of 'du' was
##                    not as efficient as I thought it would be.
##
## Changed: 2015

## FOR TESTING: (show executed statements)
#  set -x

############################################################
## Get the current directory name.
############################################################

CURDIR="`pwd`"


################################################################
## Prompt for a MAX-LEVELS of subdirectories, using zenity.
################################################################

MAXLEVELS=""

MAXLEVELS=$(zenity --entry \
   --title "\
Enter a MAXIMUM NUMBER, an integer." \
   --text "\
Enter an integer --- the MAXIMUM NUMBER of levels of
subdirectories, from this directory DOWN, on which
to report sub-directory sizes.

   Example:  3 for three levels of subdirectoires, down.

NOTE: This utility will show the subdirs under the current directory
         $CURDIR
        with the largest subdirs SORTED to the top of the list.

WARNING: If you enter a LARGE integer and if this is a DEEP or
HEAVILY-POPULATED directory, you may have a wait of a minute
or more before you see the report popup.

NOTE: If you use 0 (zero), a summary is reported.
. . . . . Use an EMPTY response or 'Cancel' to EXIT." \
   --entry-text "3")

if test "$MAXLEVELS" = ""
then
   exit
fi


##############################################################
## Prep a temporary filename, to hold the list of subdir names
## and size info.
##      If the user does not have write-permission to the
##      current directory, we put the list in /tmp.
##############################################################
## NOTE:
## We could put the report in the /tmp directory, rather than
## junking up the current directory with this report.
## BUT it may be useful to have the report available in
## the directory to which it applies.
#############################################################

OUTFILE="${USER}_spaceINsubdirs_${MAXLEVELS}_LEVELSdown_find-du-sizesort_temp.lis"

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

DISK USAGE (in Megabytes) IN *$MAXLEVELS* LEVELS OF SUB-DIRECTORIES

UNDER DIRECTORY:   $CURDIR

ON HOST:        ${HOST_ID}

                             SORTED BY *SIZE* --- BIGGEST SUB-DIRECTORIES
                             AT THE TOP.

                             This report was generated by running the 'find'
                             command with parm '-maxdepth $MAXLEVELS' ---
                             and then applying the 'du -s' command to each
                             subdirectory found.

                             Total usage is shown on the first line, for the
                             top-level directory.
SIZE-SORT
**************
Disk usage
(MegaBytes)    Subdirectory name
-------------- ------------------------
TerGigMeg.Kil
  |  |   |  |" > "$OUTFILE"


########################################################################
## GENERATE REPORT CONTENTS.
## Run the 'find' command with '-type d -maxdepth N' and applying the
## 'du -s' command to each subdirectory found --- to generate the guts
## of the report.  Format the report with 'sort' and 'awk'.
########################################################################

## FOR TESTING:
#  set -x

find "$CURDIR"  -type d  -maxdepth $MAXLEVELS  -exec du -k -s {} \; \
 | sort +0 -1nr | \
   awk '{
COLdirnam = index($0,$2)
printf ("%13.3f  %s\n", $1/1000, substr($0,COLdirnam) )
}' >> "$OUTFILE"

## Alternative sort (more 'modern'format):  sort -k1nr

## FOR TESTING:
#  set -


########################################################################
## Add TRAILER to report.
########################################################################

SCRIPT_BASENAME=`basename $0`
SCRIPT_DIRNAME=`dirname $0`

echo "\
  |  |   |  |
TerGigMeg.Kil
-------------- ------------------------
(MegaBytes)    Subdirectory name
Disk usage
*************
SIZE-SORT

................... `date '+%Y %b %d  %a  %T%p'` ............................

   The SIZE-SORTED output above was generated by the script

$SCRIPT_BASENAME

   in directory

$SCRIPT_DIRNAME


   It ran the 'find' and 'du' commands on host $HOST_ID .

-----------------
PROCESSING METHOD:

   The script runs a 'pipe' of several commands (find, ls, sort, awk) like:

      find <dirname>  -type d -maxdepth $MAXLEVELS  -exec du -k -s {} \; | \\
                          sort +0 -1nr | awk '{ ... printf ( ... )}'
 
   where {} represents a subdirectory name.

 
   The 'find' command was used to recursively travel through the
   sub-directories, in the first $MAXLEVELS levels, of the specified directory

 $CURDIR

   and execute the 'du -k -s {}' command.


   NOTE: If the directory you select is actually a 'link'
         to an actual directory, the list above may be empty.
         Re-try, using the actual directory name.

------------
FEATURE NOTE:

      This utility provides subdirectory-selecting, size-sorting,
      and columnar-formatting that is not available by using only
      the 'du' command --- without 'find' and 'sort' and 'awk'.

........................................................................
" >> "$OUTFILE"


##################################################
## Show the listing.
##################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
