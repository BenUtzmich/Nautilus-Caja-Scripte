#!/bin/sh
##
## Nautilus
## SCRIPT: 00_anyfile_LIST-MODULES-dynamically-loadable_lsmod_modprobe.sh
##
## PURPOSE: Lists (dynamically loadable) modules:
##            a) currently in-memory (via 'lsmod'), and
##            b) all kernel modules on this host (via 'modprobe -l'), and
##            c) kernel driver modules available for all currently
##               plugged-in PCI devices (via 'pcimodules').
##
## METHOD:  Shows the list in a text viewer/editor of your choice, as
##          seen at the bottom of this script.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory. Then
##             right-click and choose this Nautilus script to run
##             (name above).
##
## Started: 2010may12
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012apr18 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.

## FOR TESTING: (show statements as they execute)
# set -x

##############################################
## Prepare the output file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##############################################

CURDIR="`pwd`"

OUTFILE="${USER}_temp_openFilesLIST.txt"
if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi

#################################################################
## Generate the list.
##
#################################################################

EXECHECK=`which lsmod`

if test -f "$EXECHECK"
then
   echo "
#####
lsmod: (list modules currently connected to the kernel)
#####"  > "$OUTFILE"

   lsmod >> "$OUTFILE"
fi


EXECHECK=`which modprobe`

if test -f "$EXECHECK"
then
   echo "
###########
modprobe -l: (list all kernel modules on this host)
###########"  >> "$OUTFILE"

   modprobe -l >> "$OUTFILE"
fi


EXECHECK=`which pcimodules`

if test -f "$EXECHECK"
then
   echo "
##########
pcimodules:
##########
   (kernel driver modules available for all currently plugged in PCI devices)
"  >> "$OUTFILE"

   pcimodules >> "$OUTFILE"
fi


###################
## Show the list.
###################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE"
