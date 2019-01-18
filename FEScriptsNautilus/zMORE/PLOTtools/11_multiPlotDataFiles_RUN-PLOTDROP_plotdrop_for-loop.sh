#!/bin/sh
##
## Nautilus
## SCRIPT: 00_multiPlotDataFiles_RUN_PLOTDROP_plotdrop_for-loop.sh
##
## PURPOSE: For the user-selected file(s), the filenames are
##          passed to 'plotdrop'.
##
## METHOD: Brings up one instance of 'plotdrop' at a time, rather than
##         multiple instances --- which would happen if you selected
##         a bunch of plot-data files and right-clicked in Nautilus
##         and chose 'plotdrop' to apply to all of the selected files.
##
##         Uses a 'for' loop to run 'plotdrop', sequentially, for each
##         selected plot file.
##
## HOW TO USE: In Nautilus, select one or more plot-data files and
##             click on the name of this script to run (name above).
##
#########################################################################
## Created: 2010sep06
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
########################################################################

## FOR TESTING: (show statements as they execute)
# set -x


############################################
## START THE LOOP on the filenames.
############################################
## NOTE: This 'for-without-in' technique
## works for filenames with embedded spaces.
############################################

for FILENAME
do

  #########################################
  ## Apply 'plotdrop' to the filename.
  #########################################

  ## FOR TESTING:
  #   set -x

   plotdrop "$FILENAME"

  ## FOR TESTING:
  #   set -

done
