#!/bin/sh
##
## Nautilus
## SCRIPT: 00_anyfile_show_MEMORY-USED_free.sh
##
## PURPOSE: Runs the 'free' command to show free and used memory.
##
## METHOD:  Puts the output of 'free' in a text file.
##
##          Shows the text file using a text-file viewer of the
##          user's choice.
##
## HOW TO USE: In the Nautilus file manager, right-click on the name of
##             ANY file (or directory) in ANY Nautilus directory list.
##             Then select this script to run (name above).
##
## Created: 2011dec21
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

OUTFILE="/tmp/${USER}_mem_free.lis"
 
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

MEMORY IN KILOBYTES (free and used) ON HOST *** $HOST_ID ***

" > "$OUTFILE"


##########################################################################
## Run 'free' to GENERATE REPORT CONTENTS.
##########################################################################

## FOR TESTING:
#  set -x

free -k >> "$OUTFILE"

## FOR TESTING:
#  set -


##########################################################################
## ADD REPORT 'TRAILER'.
##########################################################################

SCRIPT_BASENAME=`basename $0`
SCRIPT_DIRNAME=`dirname $0`

echo "
......................... `date '+%Y %b %d  %a  %T%p'` ........................

   The output above is from script

$SCRIPT_BASENAME

   in directory

$SCRIPT_DIRNAME


   It ran the 'free -k' command on host  $HOST_ID .

.............................................................................

FROM 'man free':

       'free' displays the total amount of free and used physical and swap mem-
       ory in the system, as well as the buffers  used  by  the  kernel.   The
       shared memory column should be ignored; it is obsolete.


......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................
" >> "$OUTFILE"


##################################################
## Show the listing.
##################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
