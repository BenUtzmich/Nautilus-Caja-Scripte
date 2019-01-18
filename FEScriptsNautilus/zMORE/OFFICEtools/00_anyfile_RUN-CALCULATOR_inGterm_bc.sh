#!/bin/sh
##
## Nautilus
## SCRIPT: 00_anyfile_RUN_CALCULATOR_inGterm_bc.sh
##
## PURPOSE: This script opens a Gterm (gnome-terminal) and starts a
##          script --- .bc_calcline.sh --- that allows the user to
##          enter formulas to be calculated --- line by line ---
##          whenever the Enter key is pressed.
##
## METHOD: The script '.bc_calcline.sh' uses the 'bc' command to
##         do decimal as well as integer arithmetic.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
###########################################################################
## Created: 2010may30
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################


###################################################
## Run the '.bc_calcline.sh' script in a 'gterm'.
######################################################

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi

gnome-terminal --geometry 85x45+0+0 -t '.bc_calcline.sh' \
        -e $DIR_NautilusScripts/zMORE/OFFICEtools/.bc_calcline.sh

## WAS   -e ~/.gnome2/nautilus-scripts/zMORE/OFFICEtools/.bc_calcline.sh
