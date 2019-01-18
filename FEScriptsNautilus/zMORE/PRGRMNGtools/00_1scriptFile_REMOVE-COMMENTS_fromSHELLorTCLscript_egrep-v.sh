#!/bin/sh
##
## Nautilus
## SCRIPT: 00_1scriptFile_REMOVE-COMMENTS_fromSHELLorTCLscript_egrep-v.sh
##
## PURPOSE: This script makes a NEW script file from a selected
##          shell or Tcl-Tk script. The new file has the comment
##          lines (the ones 'starting with' #) stripped out.
##
##          We also strip out blank or null lines, to make a really
##          compact output file.
##
## METHOD:  See details in comments below, near the code that does
##          the stripping.
##
##          If the user has write permission on the current directory
##          (the directory in which the script resides), the NEW
##          script file is put in the directory with the original script.
##          Otherwise, the script is put in /tmp.
##
##          The name of the NEW script is the same as the old, but
##          with '_DECOMMENTED' added to the end of the original name.
##          Examples: 'test.sh' becomes 'test.sh_DECOMMENTED'
##                        'xpg' becomes 'xpg_DECOMMENTED'
##                  'shofil.tk' becomes 'shofil.tk_DECOMMENTED'
##
##              This script shows the NEW script with an editor, or
##              with whatever GUI text display program the user puts below.
##
## HOW TO USE: Right-click on any script file in a Nautilus directory list
##             and select this Nautilus script to run (name above).
##
## TESTING NOTE: The first test of this script was on itself.
##               It made a 23 line script out of a 160 line script.
###########################################################################
## NOTE: You can see only the non-commented, executable lines of a
##       script by using
##        egrep -v '^ *##|^ *# |^ *$' <script-name>
##   or 
##        grep -v '^ *##' <script-name> | grep -v '^ *# ' | grep -v '^ *$'
##########################################################################
##
## Created: 2010aug26
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011oct08 Commented a 'read' line at the bottom (meant for testing). 
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
##########################################################################

## FOR TESTING: (show statements as they execute)
#  set -x


#####################################################
## Get the filename of the selected file.
#####################################################

  FILENAME="$1"
# FILENAMES="$@"
# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"


##########################################################
## Check that the selected file is a script file.
##
## We perform the check by using the 'file' command
## and looking for the string 'script' in the output.
##
## Example output on applying 'file' to a Tcl-Tk script:
## <scriptname>: a /usr/bin/wish -f script text executable
##
## Example output on applying 'file' to a shell script:
## <scriptname>: POSIX shell script text executable
#########################################################

SCRIPTFILEcheck=`file "$FILENAME" | grep 'script'`

if test "$SCRIPTFILEcheck" = ""
then
   exit
fi


##################################
## Prepare the output filename.
##################################

# FILEOUT="${FILENAME}_DECOMMENTED_by$USER"
FILEOUT="${FILENAME}_DECOMMENTED"


####################################
## Prepare the output directory.
####################################

# THISscriptDIR=`dirname $0`

THISnautilusDIR="`pwd`"

## FOR TESTING:
#   zenity -info -text "THISnautilusDIR = $THISnautilusDIR"

if test ! -w "$THISnautilusDIR"
then
   FILEOUT="/tmp/$FILEOUT"
fi

#######################################
## Remove the output file, if it exists
## --- say, from a previous run.
#######################################

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi

############################################
## Make the new file, without comment lines.
############################################

egrep -v '^ *##|^ *# |^ *$' "$FILENAME" > "$FILEOUT"

## ALTERNATIVE (using grep instead of egrep):
##
## Like the 'egrep' line above, this alternative removes 
##
##  - lines that start with '...##', where ... represents zero or more spaces
##
##  - lines that start with '...# ', where ... represents zero or more spaces
##
##    [You might want to remove the blank after #, but if you have a line of
##     code setting a hex string like '#ecefff" and the line starts with that
##     hex string, that code line will be removed.
##     Also a line like "#!/bin/sh" or "!/usr/bin/wish", which starts many
##     shell or Tcl-Tk scripts, would be removed.]
##
##  - blank lines (lines with zero or more spaces)
##
#  grep -v '^ *##' "$FILENAME" | grep -v '^ *# ' | grep -v '^ *$' > "$FILEOUT"


##########################################################
## Show the new file --- the script without comment lines.
##########################################################

. $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

$TXTVIEWER  "$FILEOUT"


####################################################################
## FOR TESTING:
####################################################################
## The following statement keeps this script from completing,
## so that the script can be tested --- with output to stdout and
## stderr showing in a terminal --- when using Nautilus
## 'Open > Run in a Terminal'. NOTE: Since xpg runs as a 'background'
## process, the terminal window would, without the statement below,
## immediately close after xpg shows the file. (Also could use 'xpg -f'.)
##
## Comment this line, to deactivate it.
####################################################################
#   read ANY_key_to_exit
