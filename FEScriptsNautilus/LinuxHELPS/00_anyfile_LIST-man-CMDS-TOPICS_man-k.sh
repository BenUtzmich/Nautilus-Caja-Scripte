#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_anyfile_list_manCMDS-TOPICS_man-k.sh
##
## PURPOSE: This script gives an overview of the 'man' helps
##          available on the host running this script.
##
## METHOD:  Uses the 'man -k' command to list man-help title lines.
##
##          Puts the 'man -k' output in a text file.
##
##          Shows the text file using a text-file viewer of the
##          user's choice.
##
## HOW TO USE: In the Nautilus file manager, right-click on the name of
##             ANY file (or directory) in a Nautilus directory list.
##             Then choose this Nautilus script to run (see name above).
##
## Created: 2010apr04
## Changed: 2011may02 Add $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012feb29 Changed the script name in the comment above.

## FOR TESTING: (show statements as they execute)
#  set -x

############################################################
## Prep a temporary filename, to hold the list of filenames.
##      We put the output in /tmp in case the user does
##      not have write-permission to the current directory.
############################################################

OUTFILE="/tmp/${USER}_manTopics_man-k.lis"
 
if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


####################################################################
## Generate HEADING for the listing.
####################################################################

THISHOST=`hostname`

echo "\
................ `date '+%Y %b %d  %a  %T%p %Z'` ......................

LIST OF Linux COMMANDS and UTILITIES (and systems, protocols) that may be
AVAILABLE ON THIS HOST:  $THISHOST

Some information on checking availability of these commands and utilities
is at the bottom of this list.

------------------------------------------------------------------------------
" > "$OUTFILE"


####################################################################
## Generate 'guts' of the list with man -k ' '.
## This command works on Ubuntu (9.x).
## A somewhat different command may be needed on other Linux distros.
## See comments below.
####################################################################
####################################################################
## The   man -k '.'  technique worked, quite rapidly on SGI-IRIX
## systems, to make a list of the Unix cmds-etc with man-helps.
## But takes about 4 minutes to create the list on Mandriva 2007.
## man -k '.' >> "$OUTFILE"
###################################################################
####################################################################
## Found that  man -k ' '   works well on Ubuntu 9.10 (Karmic), 2009.
####################################################################

## FOR TESTING:
# set -x

man -k ' ' >> "$OUTFILE"


####################################################################
## Add a TRAILER to the listing.
####################################################################

SCRIPT_BASENAME=`basename $0`
SCRIPT_DIRNAME=`dirname $0`

echo "
................ `date '+%Y %b %d  %a  %T%p %Z'` ......................

   The report above was generated by the script

$SCRIPT_BASENAME

   in directory

$SCRIPT_DIRNAME


   It created this list using the command

           man -k ' '

This gives essentially all the Linux/Unix commands (and topics) for
which there is 'man' help on this host.

-----------------------------------------------------------------------------
CHECKING AVAILABILITY OF THE UTILITIES:

You can type one of these utility names at a Linux/Unix shell prompt,
to see if you get a 'not found' message.   Or, to avoid starting up
a 'monolithic' program, ...

At a Linux/Unix shell prompt, you can type 'which <utility-name>' ---
to see the directory location of the utility.  This works if the utility
is installed and if it is in one of the directories in your PATH
environment variable.

(NOTE: Many of these utilities are subroutines that are meant to be called
       within a compiled language like C.  And some of these man helps are
       for a system or a protocol, like 'tcp' man help for the TCP protocol.
       There is no command or executable called 'tcp'. So 'which' will
       fail on those kinds of names.)

If the command/utility is NOT found with 'which' --- at a Linux/Unix shell
prompt, you can type 'whereis <utility-name>' as an alternate way to query
the directory location of the utility. Try 'man whereis' to see how
'whereis' works.

If <utility-name> is still not found (by 'which' or 'whereis'), it is quite
likely that it is not installed on this host. Or, the name is not that of
an executable file (i.e. not the name of a script nor of compiled code).

If you are on a network of Linux/Unix machines,
the utility might be on another machine on the network, like a server
--- or on a different workstation (newer, older, different distro).

If the utility exists and is a shell-command or executable,
you can type 
               file <fully-qualified-util-name>

(at a shell prompt) to see what kind of executable the utility is.

-----------------------------------------------------------------------------
GETTING 'man' HELP FOR A UTILITY:

You can type 'man <util-name>', at a terminal command prompt,
to see details on how the command/utility can be used.

('man' stands for Manual.  That command gives you a user manual
 for the specified utility.)

Another way to get the man help:

In Nautilus, right-click on any file and in the popup menu
go to 'Scripts > LinuxHELPS' and click on 'show_manhelp_4topic'.
There will be a prompt at which you can enter the utility-name.

The man help is presented in a text browser.

You will probably find this much better for browsing large man helps
than using the man command in a terminal (which uses an ancient text
browser, like the 'less' command, to present the man help).

You can type 'man man' at a shell prompt (or use 'show_manhelp_4topic')
to see a description of the 'man' command.

** END OF LIST of Linux/Unix commands and utilities with man help
   on host $THISHOST
" >> "$OUTFILE"


##################################################
## Show the listing.
#################################################
   
## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
