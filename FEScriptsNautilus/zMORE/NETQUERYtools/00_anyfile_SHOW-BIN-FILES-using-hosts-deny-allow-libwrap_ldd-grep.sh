#!/bin/sh
##
## Nautilus
## SCRIPT: 00_anyfile_SHOW_BIN-FILES-using hosts-deny-allow-libwrap_ldd-grep.sh
##
## PURPOSE: Runs the 'ldd' command on the files in /bin, /usr/bin,
##          /sbin, /usr/sbin to show which ones are "TCP wrapper aware".
##          --- that is, which ones use the '/etc/hosts.deny' and
##          '/etc.hosts.allow' files.
##
## METHOD: In a 'for' loop, pipes the 'ldd' output for each executable
##         to 'grep -q libwrap' to determine whether to put the
##         executable name into a temporary text file.
##
##         Shows the text file in a text-file viewer of the user's
##         choice.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this Nautilus script to run
##             (name above).
##
## REFERENCES: 'man hosts_access' and 'man hosts_options' and
##             Linux Format Magazine column, Apr2012, LXF issue #156,
##             'Dr. Brown's Administeria', page 61.
##
##          That article said:
##          The 'for' loop "turned up 23 executables on Ubuntu 10.04
##          and 38 on Fedora 15.
##
##          Noteworthy includsions on this list are the secure shell
##          daemon (sshd) and the portmapper (rpcbindd), which is
##          required by services such as NFS and NIS."
##
##          "TCP wrappers ... provides an extra layer of security for
##          network services by allowing you to control which services
##          can be accessed from which client machines or networks."
##
##          "TCP wrappers was written by Wietsa Venema, who worked at
##          the University of Eindhoven ..."
##
##          "... if you read Venema's original paper at
##               ftp://ftp.porcupine.org/pub/security/tcp_wrapper.pdf
##           you'll discover that his main driver in developing TCP wrappers
##           was to monitor the attempts of a cracker to break into their
##           systems in Eindhoven."
##
#######################################################################
## Created: 2011jun04
## Changed: 2012
#######################################################################

## FOR TESTING: (show statements as they execute)
# set -x

######################################################################
## Prep a temporary filename, to hold the list of bin filenames
## that are 'TCP wrapper aware'.
################################
## Since the user may not have write-permission to the current directory,
## and since this listing may not pertain to the current directory,
## put the list in the /tmp directory.
######################################################################

OUTFILE="/tmp/${USER}_bin-files-that-use-libwrap.lis"

if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


#######################################################
## Make a heading for the output file.
#######################################################

echo "\
.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................

Executables in  directories
      /bin  /usr/bin  /sbin  /usr/sbin
that are 'TCP wrapper aware' --- that is, that use 'libwrap' ---
that is, that use files '/etc/hosts.deny' and '/etc/host.allow'.

.................... START OF 'libwrap' EXECUTABLES ......................


" > "$OUTFILE"

#######################################################
## In a 'for' loop, use 'ldd' and 'grep -q' to put
## the executables using 'libwrap' into the text file.
#######################################################

for EXECFILE in /bin/*  /usr/bin/*  /sbin/*  /usr/sbin/*
do

   if ldd $EXECFILE | grep -q libwrap
   then
      echo "$EXECFILE" >> "$OUTFILE"
   fi

done
## END OF 'for EXECFILE ...' loop.


###########################
## Add report 'TRAILER'.
###########################

SCRIPT_BASENAME=`basename $0`
SCRIPT_DIRNAME=`dirname $0`

HOST_ID="`hostname`"

echo "
.........................  END OF 'libwrap' EXECUTABLES .....................

   The output above is from script

$SCRIPT_BASENAME

   in directory

$SCRIPT_DIRNAME

on host  $HOST_ID .

   The script ran the 'ldd' command on each of the executables in directories
      /bin  /usr/bin  /sbin  /usr/sbin
   and used the command 'grep -q libwrap' to determine which executables
   use the library 'libwrap'.

......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................
" >> "$OUTFILE"

###########################
## Show the listing.
###########################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
