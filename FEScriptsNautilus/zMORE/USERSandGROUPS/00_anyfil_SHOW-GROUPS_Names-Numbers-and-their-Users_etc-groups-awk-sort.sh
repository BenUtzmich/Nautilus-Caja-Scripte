#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_anyfil_SHO_GROUPS_Names-Numbers-and-their-Users_etc-groups-awk-sort.sh
##
## PURPOSE: Show the groupid lines of /etc/group, sorted by groupid.
##
## METHOD: Uses 'awk' and 'sort' to build the text file.
##
##         This script shows the text file in a textfile-viewer of the
##         user's choice.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
############################################################################
## Created: 2011may02
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012may12 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
############################################################################


## FOR TESTING: (show statements as they execute)
#  set -x

###############################################################
## Prep a temporary filename, to hold the list.
##      We put the output file in /tmp, in case the user
##      does not have write-permission in the current directory.
###############################################################

OUTFILE="/tmp/${USER}_ALLgroupids_SORTED_thisHost.lis"
 
if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


#############################
## PREPARE REPORT HEADING.
#############################

THISHOST=`hostname`

echo "\
***************************** `date '+%Y %b %d  %a  %T%p %Z'` *****************

Groups on this host: $THISHOST

       From the /etc/group file.  Sorted by group-name.

                           See below for a 2nd list sorted by group-number.

***SORT FIELD*** 
GroupName        GroupNum  Userid
---------------- --------  ----------------
" > "$OUTFILE"


##############################
## PREP REPORT CONTENTS.
##############################

# awk -F : '{ COL4 = index($0,$4) ; \
# printf ("%-16s %8d  %s\n", $1, $3, substr($0,COL4) ); }' /etc/group | \
#     sort -k1 >> "$OUTFILE"

awk -F : '{ printf ("%-16s %8d  %s\n", $1, $3, $4 ); }' /etc/group | \
      sort -k1 >> "$OUTFILE"

echo "
LIST2:
               *SORT FIELD*
GroupName        GroupNum  Userid
---------------- --------  -----------------
" >> "$OUTFILE" 

awk -F : '{ printf ("%-16s %8d  %s\n", $1, $3, $4 ); }' /etc/group | \
      sort -k2n >> "$OUTFILE"


###############################
## ADD A TRAILER TO THE REPORT.
###############################

SCRIPT_BASENAME=`basename $0`
SCRIPT_DIRNAME=`dirname $0`

echo "
-----------------------------------------------------------------------------

   The list above was generated by script

$SCRIPT_BASENAME

   in directory

$SCRIPT_DIRNAME


     Commands of the form

awk -F : '{ printf (\"...\", \$1, \$3, \$4 ); }' /etc/group | sort -k1

     and

awk -F : '{ printf (\"...\", \$1, \$3, \$4 ); }' /etc/group | sort -k2n

     were used.

-----------------------------------------------------------------------------
" >>  "$OUTFILE"


############################
## SHOW REPORT FILE.
############################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
