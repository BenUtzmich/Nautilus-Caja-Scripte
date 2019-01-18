#!/bin/sh
##
## Nautilus
## SCRIPT: 99_multifiles_DEMO_of_a-for-loop-without-in_LISTSeachSelectedFilename_TOxterm.sh
##
## PURPOSE: A TEST script --- Lists selected files to stdout, in an xterm.
##
##          For demo-ing the getting and using of filenames in a 'for' loop
##          --- esp. filenames with spaces in names.
##
## METHOD: This script runs a for-loop in which, for each filename selected,
##         and 'xterm' is popped up which echoes the filename.
##
##         The loop is run a second time to show that the filename arguments
##         have not been destroyed/shifted by execution of the first loop.
##
## HOW TO USE: In Nautilus, select ANY group of file(s) in ANY directory.
##             Then right-click and choose this Nautilus script to run
##             (name above).
##
##########################################################################
## Created: 2011jul07
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################

## FOR TESTING:
#  set -x

###########################################
## Get the filenames of the selected files.
###########################################

## OLD WAY:
## FILENAMES="$@"

# echo "Number of parms: $#"

# echo "Parms: $@"

###################################
## START THE LOOP on the filenames.
###################################

## OLD WAY:
## for FILENAME in $FILENAMES

for FILENAME
do

  xterm -hold -fg white -bg black -e echo "
$FILENAME"

  ## The following 'shift' command is not needed and
  ## actually is not desirable, since it 'destroys'
  ## in input filenames.

  #  shift

done


###################################
## START 2nd LOOP on the filenames.
########
## This proves that the previous loop
## does not destroy/shift the input
## filenames.
###################################

for FILENAME
do

  xterm -hold -fg white -bg black -e echo "
$FILENAME"

done
