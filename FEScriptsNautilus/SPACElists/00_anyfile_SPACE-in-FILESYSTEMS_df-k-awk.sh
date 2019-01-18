#!/bin/sh
##
## Nautilus
## SCRIPT: 01_anyfile_SPACEin_FILESYSTEMS_df-k-awk.sh
##
## PURPOSE: This utility will show the space allocated and used
##          in the several file systems on the host running this script.
##
## METHOD:  Puts the output of 'df -k' into a text file --- after piping
##          the output through 'sed', 'sort', and 'awk' to format the
##          output nicely.
##
##          Shows the text file using a text-file viewer of the user's
##          choice.
##
## HOW TO USE: In the Nautilus file manager, right-click on the name of
##             ANY file (or directory) in ANY Nautilus directory list.
##             Then select this script to run (name above).
##
## Created: 2010apr07
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012feb29 Changed the script name in the comment above.

## FOR TESTING: (show statements as they execute)
#  set -x

#############################################################
## Prep a temporary filename, to hold the list of filenames.
## 
## We always put the report in the /tmp directory, rather than
## junking up the current directory with this report that
## applies to the entire filesystem. Also, the user might
## not have write-permission to the current directory.
#############################################################

OUTFILE="/tmp/${USER}_space_filsys_dfk_temp.lis"
 
if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


##########################################################################
## SET REPORT HEADING.
##########################################################################

HOST_ID="`hostname`"

echo "\
......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................

DISK USAGE (in Gigabytes) IN FILE SYSTEMS ON HOST *** $HOST_ID ***


           SORTED BY *PERCENT-USED* --- HIGHEST %-USED AT THE TOP
                      ************
" > "$OUTFILE"

DATAHEAD="\
                                                                    FileSystem
Directory                 ******  ALLOCATED  USED       AVAILABLE   Device-partition,
(Filesystem Mount Point)  % USED  Gigabytes  Gigabytes  Gigabytes   if any
------------------------- ------  ---------- ---------- ----------  -------------------------------------"

##########################################################################
## GENERATE REPORT CONTENTS.
##########################################################################
## Sample output of 'df -k' on Linux:
##
## Filesystem           1K-blocks      Used Available Use% Mounted on
## /dev/sda1             74594118   9818430  60985555  14% /
## /dev/sdb5             76902227   5531130  71371097   8% /home
## none                   1037884        40   1037844   1% /tmp
##########################################################################

   echo "
******************
LOCAL FILE-SYSTEMS:
******************
$DATAHEAD
" >>  "$OUTFILE"


## FOR TESTING:
#  set -x

df -kl | sed '1d;s/\%/ /g' | sort -n -r -k5 | awk \
   '{printf ("%-25s %6s %11.3f %10.3f %10.3f  %s \n\n", $6, $5, $2/1000000, $3/1000000, $4/1000000, $1)}' \
   >> "$OUTFILE"

## FOR TESTING:
#  set -


##########################################################################
## ADD REPORT 'TRAILER'.
##########################################################################

SCRIPT_BASENAME=`basename $0`
SCRIPT_DIRNAME=`dirname $0`

echo "
......................... `date '+%Y %b %d  %a  %T%p'` ........................

NOTE1: This file-systems report is SORTED by %-Used .... LARGEST %-Used FIRST.

       Hence the file-system on the first line may be the one of most
       immediate concern, if the %-Used is greater than 85%, say.

.............................................................................

   The output above is from script

$SCRIPT_BASENAME

   in directory

$SCRIPT_DIRNAME


   It ran the 'df' command on host  $HOST_ID .

   The script uses a 'pipe' of several commands (df, sed, sort, awk) like:

         df -kl | sed ... | sort -n -r -k5 |  awk '{printf ( ... ) }'

.............................................................................
NOTE2: The 'l' option of the 'df' command specifies that info is requested
       only for 'local' file systems.  This utility could be enhanced to
       also show 'df' data for 'nfs' mounted file systems.

NOTE3: This utility provides columnar formatting (in Gigabytes only) and sorting
       that is not available by use of the 'df' command by itself.
.............................................................................

......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................
" >> "$OUTFILE"


###################################################
## Show the listing.
###################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
