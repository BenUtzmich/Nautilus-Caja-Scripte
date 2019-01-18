#!/bin/sh
##
## Nautilus
## SCRIPT: 01_anyfile_show_PROCESS-TREE_pstree.sh
##
## PURPOSE: Runs the 'pstree' command to show the hierarchical
##          process tree.
##
## METHOD:  Puts the output of 'pstree' in a text file.
##
##          Shows the text file using a text-file viewer of the
##          user's choice.
##
## HOW TO USE: In the Nautilus file manager, right-click on the name of
##             ANY file (or directory) in ANY Nautilus directory list.
##             Then select this script to run (name above).
##
## Created: 2010apr21
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

OUTFILE="/tmp/${USER}_pstree.lis"
 
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

PROCESS TREE ON HOST *** $HOST_ID ***

        PROCESSES WITH THE SAME ANCESTOR
        ARE SORTED BY  PROCESS ID
                       **********
" > "$OUTFILE"


##########################################################################
## Run 'pstree' to GENERATE REPORT CONTENTS.
##########################################################################

## FOR TESTING:
#  set -x

pstree -punaAl >> "$OUTFILE"

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


   It ran the 'pstree -punaAl' command on host  $HOST_ID .

.............................................................................

NOTE1: 
       pstree visually merges identical branches by  putting  them  in	square
       brackets and prefixing them with the repetition count, e.g.

	   init-+-gettyps
		|-getty
		|-getty
		|-getty

       becomes

	   init---4*[getty]


       Child  threads  of a process are found under the parent process and are
       shown with the process name in curly braces, e.g.

	   icecast2---13*[{icecast2}]


NOTE2: Here is a description of the '-punaAl' options:

       -p     Show  PIDs.  PIDs  are  shown  as decimal numbers in parentheses
	      after each process name. -p implicitly disables compaction.

       -u     Show uid transitions. Whenever the uid of a process differs from
	      the uid of its parent, the new uid is shown in parentheses after
	      the process name.

       -n     Sort processes with the same ancestor by PID instead of by name.
	      (Numeric sort.)

       -a     Show command line arguments. If the command line of a process is
	      swapped out, that process is shown in parentheses. -a implicitly
	      disables compaction.

       -A     Use ASCII characters to draw the tree.

       -l     Display long lines. By default, lines are truncated to the  dis-
	      play  width or 132 if output is sent to a non-tty or if the dis-
	      play width is unknown.


......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................
" >> "$OUTFILE"


##################################################
## Show the listing.
##################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
   