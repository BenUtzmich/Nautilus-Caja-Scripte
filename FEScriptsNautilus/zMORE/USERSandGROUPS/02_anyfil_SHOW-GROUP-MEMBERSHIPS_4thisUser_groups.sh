#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_anyfil_SHO_GROUP-MEMBERSHIPS_4thisUser_groups.sh
##
## PURPOSE: Show the groupids in which the 'current' user is a member.
##
## METHOD:  Uses the 'group' command on env-var $USER to get the
##          memberships.
##
##          This list is put in a text file and the text file is shown
##          using a textfile-viewer of the user's choice.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
#############################################################################
## Created: 2011may02
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012may12 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################


## FOR TESTING: (show statements as they execute)
#  set -x

###############################################################
## Prep a temporary filename, to hold the list of filenames.
##      We put the output file in /tmp, in case the user
##      does not have write-permission in the current directory.
###############################################################

OUTFILE="/tmp/${USER}_groupids.lis"
 
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

Groups in which this user ($USER) is a member --- on host: $THISHOST 

User  Groups
----- -----------------------------------------------------------------------
" > "$OUTFILE"


##############################
## PREP REPORT CONTENTS.
##############################

echo "$USER `groups`" >> "$OUTFILE"


###############################
## ADD A TRAILER TO THE REPORT.
###############################

SCRIPT_BASENAME=`basename $0`
SCRIPT_DIRNAME=`dirname $0`

echo "
----------------------- `date '+%Y %b %d  %a  %T%p %Z'` ----------------

   The list above was generated by script

$SCRIPT_BASENAME

   in directory

$SCRIPT_DIRNAME


     Command used: groups

-----------------------------------------------------------------------------
" >>  "$OUTFILE"


############################
## SHOW REPORT FILE.
############################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
