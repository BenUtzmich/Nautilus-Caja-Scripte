#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_anyfile_SHOW-XCOLORS-NEAR-RGB_showrgb-grep-nawk-sort.sh
##
## PURPOSE: For a given RGB triplet (0 to 255), this script
##          generates a report showing the X-colors that are
##          closest to the given RGB triplet.
##
## METHOD:  'zenity --entry' is used to prompt for an RGB triplet.
##
##          For each X-color rec from 'showrgb'  a 'nawk' program
##          calculates the square-root of the sum of the squares of the
##          differences between the X-color RGB values in each 'showrgb' rec
##          and the given 3 RGB values --- to get a difference-measure.
##
##          NOTE: We are using 'nawk' to perform floating-point arithmetic
##                and we are using its built-in 'sqrt' function.
##
##          Sorts the awk output records by this difference-measure.
##
##          Puts the text output into a file in /tmp.
##
##          Uses a text-file-viewer of the user's choice to display the
##          text file.          
##
##############
## HOW TO USE: 
##         1) In Nautilus, select ANY file in ANY directory.
##            (Note that the selected file and the Nautilus current
##            directory are not used by this script.
##            This is simply a way to get to the Nautilus 'Scripts' menu.)
##         2) Then right-click and choose this script to run (name above).
##
#########################################################################
## Created: 2012sep06
## Changed: 2012
#######################################################################


## FOR TESTING: (show statements as they execute, in a terminal window)
#   set -x

##########################################
## zenity entry prompt for R, G, or B
## -- in a while loop.
##########################################

MSG="NOTE: You can exit this prompting loop by clicking 'Cancel'."

while :
do

   #################################
   ## Prompt for the RGB triplet.
   #################################

   RGB255=""

   RGB255=$(zenity --entry \
           --title "Enter 3 RGB values --- 0 to 255." \
           --text "\
$MSG

Enter 3 Red-Green-Blue values, each value between
0 and 255, inclusive. OR, click 'Cancel' to exit." \
           --entry-text "$RGB255")

   if test "$RGB255" = ""
   then
      exit
   fi

   NUMCHK=`echo -n "$RGB255" | sed 's|[0-9]||g' | sed 's| ||g'`

   if test ! "$NUMCHK" = ""
   then
      MSG="*** Entry must be numeric or spaces. ***"
      continue
   fi

   NUMWORDS=`echo "$RGB255" | wc -w`

   if test ! "$NUMWORDS" = 3
   then
      MSG="*** More or less than 3 values were entered. ***"
      continue
   fi

   ## FOR TESTING: (show statements as they execute)
   #   set -x

   R255=`echo "$RGB255" | awk '{print $1}'`
   G255=`echo "$RGB255" | awk '{print $2}'`
   B255=`echo "$RGB255" | awk '{print $3}'`

   ## FOR TESTING: (turn off display of executing statements)
   #   set -

   if test "$R255" -gt 255 -o "$R255" -lt 0
   then
      MSG="*** The RED value was out of range. ***"
      continue
   fi

   if test "$G255" -gt 255 -o "$G255" -lt 0
   then
      MSG="*** The GREEN value was out of range. ***"
      continue
   fi

   if test "$B255" -gt 255 -o "$B255" -lt 0
   then
      MSG="*** The BLUE value was out of range. ***"
      continue
   fi


   ################################################################
   ## Prep a temporary filename, to hold the list of color names.
   ##
   ##      We put the outlist file in /tmp, in case the user
   ##      does not have write-permission in the current directory,
   ##      and because the output does not, usually, have anything
   ##      to do with the current directory.
   ################################################################

   OUTLIST="${USER}_Xcolors_of_showrgb_NEAR_${R255}_${G255}_${B255}.lis"

   OUTLIST="/tmp/$OUTLIST"
 
   if test -f "$OUTLIST"
   then
      rm -f "$OUTLIST"
   fi


   ###########################################################################
   ## PREPARE OUTPUT (REPORT) FILE HEADING.
   ###########################################################################

   echo "\
.................... `date ` ...................

X-COLOR NAMES NEAR $R255 $G255 $B255


The X-color names and their RGB values (0-255) come from the
'showrgb' command. The X-colors are sorted by their

                                    ***********
closeness to the 3 R-G-B values --- $R255 $G255 $B255
                                    ***********
...............................................................

   NOTE:
 
   Closeness is determined by the 'hypotenuse norm', i.e.
   square-root of sum of squares of differences: 

   sqrt( delta-Red ** 2 + delta-Green ** 2 + delta-Blue ** 2)


   If the norm is less than 30, the named color is a 'pretty
   good' match to the RGB triplet.

   Named colors for which the difference-norm is in the range of
   30 to 50 will probably be give a 'satisfactory' color match.

..............................................................

   This list is prepared by a simple 'nawk' program ---
   combined with 'sort'.

   See more info on this utility at the bottom of this report.

=========================================================================
Delta Delta Delta  Tot-Difference
  Red Green  Blue      (norm)       X-Color-name (and RGB values)
===== ===== =====  ==============   =============================
" > "$OUTLIST"


   ###########################################################################
   ######### USE 'nawk' TO ADD UP THE 'DELTA' OF 3 RGB VALUES AND   ##########
   ######### THEIR SUM.   PUT RECS IN OUTPUT FILE.                  ##########
   ###########################################################################
   ## In the following 'nawk' report formatter,
   ## the input recs from 'showrgb' are of form:
   ##
   ## Field#1=Red    Field#2=Green    Field#3=Blue    Field#4(and more)=color-name
   ##
   ## To get the 'norm' of the 3 differences, we use the 'sqrt' function of 'nawk'
   ## on the sum of the squares of the differences.
   ##
   ###########################################################################
   ## The 'awk' output recs contain 8 fields:
   ##           Delta-R, Delta-G, Delta-B, Tot-Difference, Color-name (R G B).
   ## The 'sort -k4n' sorts on Tot-Difference.
   ###########################################################################

   showrgb | tr '[A-Z]' '[a-z]' | \
         grep -v gray | grep -v grey | sort | uniq | \
         nawk -v RVAL="$R255" -v GVAL="$G255" -v BVAL="$B255" '{

   rdiff = $1 - RVAL
   gdiff = $2 - GVAL
   bdiff = $3 - BVAL
   tdiff = sqrt(rdiff*rdiff + gdiff*gdiff + bdiff*bdiff)

   COLcolornam = index($0,$4)
   printf ("%5s %5s %5s    %12.2f   %s (%s %s %s)\n", \
            rdiff, gdiff, bdiff, tdiff,  substr($0,COLcolornam) , $1, $2, $3)   

}' | sort  -k4n >> "$OUTLIST"


   #############################################
   ## Prepare a TRAILER for the text report file.
   #############################################

   SCRIPT_DIRNAME=`dirname $0`
   SCRIPT_BASENAME=`basename $0`

   echo "
------------------------------------------------------------------------------

  The list above was generated by the script

$SCRIPT_BASENAME

  in directory

$SCRIPT_DIRNAME

  The script uses 'showrgb', 'tr', 'grep', 'sort', 'uniq', and 'awk' to FIRST
  filter out gray/grey recs (after converting all color names to lower-case),
  remove total duplicates with 'sort | uniq', and remove 'extra' records
  with the same RGB values (via an 'awk' program).
  Specifically:

   showrgb | tr '[A-Z]' '[a-z]' | \\
            grep -v gray | grep -v grey | sort | uniq | \\
            awk{...remove successive duplicate RGB-val recs...} 

   The resulting data records are piped into
            nawk{...calculate the RGB differences and their total...} | \\
            sort -k4n

  If you want to change the presentation format or the sorts or the grep
  filtering or the awk programs or whatever, you can simply edit the script.

------------------------------------------------------------------------------
   NOTE: We are using 'nawk' to perform floating-point arithmetic
         and we are using its built-in 'sqrt' function. A lot of
         script programmers probably do not know that you can do
         floating-point math with 'awk' and 'nawk' --- thus giving
         you many of the capabilities of a C or FORTRAN program.
------------------------------------------------------------------------------
FOR MORE INFO:

For more info on the executables used,
you can type 'man <exe-name>' to see details on how the program
can be used.  ('man' stands for Manual.  It gives you the Linux
'man' system's info for the command/utility.)

You can type 'man man' at a shell prompt to see a description of
the 'man' command.

Or use the 'show_manhelp_4topic' Nautilus script in the
'LinuxHELPS' group of Nautilus scripts.


******* END OF LIST of X color names close to $R255 $G255 $B255.
" >> "$OUTLIST"


   #################################
   ## Show the selected file.
   #################################

   ## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

   ## FOR TESTING:
   #   set -x

   . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
   . $DIR_NautilusScripts/.set_VIEWERvars.shi

   $TXTVIEWER "$OUTLIST"


   ## FOR TESTING: (turn off display of executing statements)
   #    set -

   MSG="NOTE: You can exit this prompting loop by clicking 'Cancel'."

done
## END of 'while' loop