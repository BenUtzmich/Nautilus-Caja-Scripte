#!/bin/sh
##
## Nautilus
## SCRIPT: 01_anyfile4Dir_start_Xterminal_here_withMultiCmds_xterm.sh
##
## PURPOSE: This script opens an xterm with the shell environment
##          'positioned' at the current' directory  ---
##          and executes a user-specified 'string' of commands ---
##          and only those commands. (There is no command prompt for further
##          command entry.)
##
## METHOD:  This script uses zenity to prompt for the command(s),
##          with examples shown.
##
##          'xterm' is run with the '-hold' parameter, to see error messages
##          if the command fails with a syntax error or whatever.
##
##          Since the '-e' option of xterm accepts only one command (with
##          optional parameters), this script uses a separate, hidden (Nautilus)
##          script, '.eval_cmds4term.sh', in the scripts directory with
##          this script, to pass the (multi-)command string to 'xterm'
##          for execution.
##
## HOW TO USE: In the Nautilus file manager, right-click on ANY file
##             (or directory) in the desired 'here' directory.
##             Then select this script to run (name above).
##
## Created: 2010apr11
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012feb29 Changed the script name in the comment above.


## FOR TESTING: (show statements as they execute)
#  set -x

#####################################################
## Get the current directory, to set the title below.
#####################################################

CURDIR="`pwd`"

#############################################
## 'cd' to the current directory. NOT NEEDED.
## Nautilus will start this script 'there'.
############################################

## OLD: (We should try to avoid using NAUTILUS_SCRIPT vars,
##       so that these scripts might be used in non-Nautilus
##       environments.)
# cd "$NAUTILUS_SCRIPT_CURRENT_URI"

# cd "$CURDIR"

######################################
## zenity prompt for the command(s).
#####################################

CMDS=""

CMDS=$(zenity --entry \
   --title "Execute command(s) in an xterm." \
   --text "Enter a string of commands.  Examples:
  1)  grep awk *.sh  --- to find scripts, in this directory, using awk
  2)  grep -i onmouseover *.htm* --- to find HTML files, in this dir, using onmouseover
  3)  strings ls --- to see the strings in the 'ls' executable, if I am in its dir, /bin
  4)  uname -a;ifconfig --- to see uname and ifconfig output
  5)  top --- to monitor running processes

Note:There will be no command prompt for further command entry." \
   --entry-text "uname -a;ifconfig")

if test "$CMDS" = ""
then
   exit
fi


#################################
## Run the command(s) in an xterm.
#################################

 . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi

CURDIR_BASENAME=`basename "$CURDIR"`
CURDIR_DIRNAME=`dirname  "$CURDIR"`

xterm -fg white -bg black -hold -geometry 115x34+100+100 \
   -title "subdir $CURDIR_BASENAME of dir $CURDIR_DIRNAME" \
   -e $DIR_NautilusScripts/TERMtools/.eval_cmds4term.sh "$CMDS"

 ## WAS -e ~/.gnome2/nautilus-scripts/.eval_cmds4term.sh "$CMDS"

 ## Use 'exec'?
 # exec xterm ....
