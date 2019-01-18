#!/bin/sh
##
## Nautilus
## SCRIPT: 00_anyfile_RUN_CALCULATOR_inXterm_bc.sh
##
## PURPOSE: This script opens an xterm and starts a script
##          --- .bc_calcline.sh --- that allows the user to enter
##          formulas to calculate --- line by line.
##
## METHOD: The script '.bc_calcline.sh' uses the 'bc' command to
##         do decimal as well as integer arithmetic.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
############################################################################
## Created: 2010may27
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################

##################################################################
## Run the '.bc_calcline.sh' script in an xterm.
##################################################################
## Some xterm color control parms:
## (They don't seem to work. May need to
##  decomment lines in /etc/X11/app-defaults/XTerm-color )
##
## +bdc +cm +dc
##
## Other xterm parms to consider:
##  -fn fixed
##  -fn "-misc-fixed-medium-r-normal--14-130-75-75-c-70-iso8859-1"
##  -fs 16 (font size ; with truetype fonts)
##  -hold
##################################################################

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi

xterm -fg white -bg black -geometry 85x45+0+0 \
       -fn "-misc-fixed-medium-r-normal--15-120-100-100-c-90-iso8859-1" \
       -e $DIR_NautilusScripts/zMORE/OFFICEtools/.bc_calcline.sh

## WAS  -e ~/.gnome2/nautilus-scripts/zMORE/OFFICEtools/.bc_calcline.sh
