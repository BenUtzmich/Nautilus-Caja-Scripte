#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_anyfile_SHOW-XCOLORS-MORE-RorGorB-SORTED_showrgb-grep-sort.sh
##
## PURPOSE: Show selected (non-grey/gray) X-colors selecting the colors with
##          either
##             - more red   than green or blue
##             - more green than red   or blue
##             - more blue  than red   or green
##           based on the RGB (0-255) values from the 'showrgb' command.
##
## METHOD:  Uses a 'zenity --radiolist' prompt to present a choice
##          of more-R or more-G or more-B.
##
##          Pipes 'showrgb' output through an 'awk' program and into
##          a 'sort' command.
##
##          Puts the text output into a file in /tmp.
##
##          Uses a text-file-viewer of the user's choice to display the
##          text file.
##
########################
##  A 'brightness' value is added to the 'showrgb' records.
##
## 'Brightness' (='Luminance'=Y) is a weighted average of RGB vals:
##
##                    Y = .299*R + .587*G + .114*B
##
## See IRIX On-Line Book "Infinite Reality Video Format Combiner User s Guide",
## the Glossary, terms 'YIQ' and 'YUV'.
##############
## HOW TO USE: 
##         1) In Nautilus, select ANY file in ANY directory.
##            (Note that the selected file and the Nautilus current
##            directory are not used by this script.
##            This is simply a way to get to the Nautilus 'Scripts' menu.)
##         2) Then right-click and choose this script to run (name above).
##
#########################################################################
## Created: 2012sep05
## Changed: 2012
#######################################################################


## FOR TESTING: (show statements as they execute, in a terminal window)
#   set -x

##########################################
## zenity radiolist prompt for R, G, or B.
## -- in a while loop.
##########################################

while :
do

   RorGorB=""

   RorGorB=$(zenity --list --radiolist \
   --title "Select X-colors by more R or G or B?" \
   --height=400 \
   --text "\
Do you want to select 'showrgb' X-colors output by
the 0-255 numbers choosing
   - more R than G or B    or
   - more G than R or B    or
   - more B than R or G    or
   - less R than G or B (more cyan)    or
   - less G than R or B (more magenta) or
   - less B than R or B (more yellow)  ?" \
   --column "Pick1" --column "Selection" \
   NO MORE-R \
   NO MORE-G \
   NO MORE-B \
   NO LESS-R \
   NO LESS-G \
   NO LESS-B
)
 
   if test "$RorGorB" = ""
   then
      exit
   fi

   ## FOR TESTING:
   #   set -x

   if test "$RorGorB" = "MORE-R"
   then
      SORTPARM="-k1nr -k4nr"
   fi

   if test "$RorGorB" = "MORE-G"
   then
      SORTPARM="-k2nr -k4nr"
   fi

   if test "$RorGorB" = "MORE-B"
   then
      SORTPARM="-k3nr -k4nr"
   fi

   if test "$RorGorB" = "LESS-R"
   then
      SORTPARM="-k1n -k4nr"
   fi

   if test "$RorGorB" = "LESS-G"
   then
      SORTPARM="-k2n -k4nr"
   fi

   if test "$RorGorB" = "LESS-B"
   then
      SORTPARM="-k3n -k4nr"
   fi

   ################################################################
   ## Prep a temporary filename, to hold the list of color names.
   ##
   ##      We put the outlist file in /tmp, in case the user
   ##      does not have write-permission in the current directory,
   ##      and because the output does not, usually, have anything
   ##      to do with the current directory.
   ################################################################

   OUTLIST="${USER}_Xcolors_of_showrgb_selectedBy$RorGorB.lis"

   OUTLIST="/tmp/$OUTLIST"
 
   if test -f "$OUTLIST"
   then
      rm -f "$OUTLIST"
   fi

   OUTTEMP="${USER}_Xcolors_of_showrgb_nogray_nodupes_BrightnessAdded.lis"

   OUTTEMP="/tmp/$OUTTEMP"
 
   if test -f "$OUTTEMP"
   then
      rm -f "$OUTTEMP"
   fi


   #############################################
   ## Prepare a HEADER for the text report file.
   #############################################

THISHOST=`hostname`

echo "\
................ `date '+%Y %b %d  %a  %T%p %Z'` ......................

X color names selected according to $RorGorB

--- largest values first (i.e. descending sort).

      ( Brightness = .299*R + .587*G + .114*B 
        is added to the records. )

Some more information is at the bottom of this list.

=========================================================================
  Red Green  Blue  Brightness     Color-name
===== ===== =====  ==========     =====================
" > "$OUTLIST"


   ########################################################
   ## Add the sorted 'showrgb' output to the report file.
   ########################################################
   ## To filter out colors like blue4, blue3, blue2, we 
   ## could insert the following grep-filter:
   ##         grep -v '4$'| grep -v '3$' | grep -v '2$' | \
   ## For now, we filter out the gray and grey recs.
   ########################################################

   showrgb | tr '[A-Z]' '[a-z]' | \
         grep -v gray | grep -v grey | \
         sort | uniq |    awk \
'BEGIN  {
##  INIT PREV VARS.
   prevR=""; prevG=""; prevB="";

   DEBUG=0
   # DEBUG=1

# end of BEGIN
}
{
## START OF awk-BODY (main-section)

if ( $1 == prevR && $2 == prevG && $3 == prevB ) {
   next
   ## Skip recs that have the same RGB vals as a prev rec.
} else {
   prevR=$1
   prevG=$2
   prevB=$3
   print $0
   ## Print a rec that does not match the prev recs RGB vals
   ## and load the 3 prev vars.
}

}' | awk '{
COLcolornam = index($0,$4)
printf ("%5s %5s %5s    %8.0f     %s\n", \
         $1, $2, $3, ( 299*$1 + 587*$2 + 114*$3 ) / 1000 , substr($0,COLcolornam) )
}' >> "$OUTTEMP"


   ###############################
   ## Select the MORE-R recs.
   ###############################

   if test "$RorGorB" = "MORE-R"
   then
      cat  "$OUTTEMP" | awk '{

if ( $1 >= $2 && $1 >= $3 ) {
   print
   ## Print the recs with more red than green or blue.
}

}' | sort $SORTPARM >> $OUTLIST
   fi


   ###############################
   ## Select the MORE-G recs.
   ###############################

   if test "$RorGorB" = "MORE-G"
   then
      cat  "$OUTTEMP" | awk '{

if ( $2 >= $1 && $2 >= $3 ) {
   print
   ## Print the recs with more green than red or blue.
}

}' | sort $SORTPARM >> $OUTLIST
   fi

   ###############################
   ## Select the MORE-B recs.
   ###############################

   if test "$RorGorB" = "MORE-B"
   then
      cat  "$OUTTEMP" | awk '{

if ( $3 >= $1 && $3 >= $2 ) {
   print
   ## Print the recs with more blue than red or green.
}

}' | sort $SORTPARM >> $OUTLIST
   fi


   ###############################
   ## Select the LESS-R recs.
   ###############################

   if test "$RorGorB" = "LESS-R"
   then
      cat  "$OUTTEMP" | awk '{

if ( $1 <= $2 && $1 <= $3 ) {
   print
   ## Print the recs with less red than green or blue.
}

}' | sort $SORTPARM >> $OUTLIST
   fi


   ###############################
   ## Select the LESS-G recs.
   ###############################

   if test "$RorGorB" = "LESS-G"
   then
      cat  "$OUTTEMP" | awk '{

if ( $2 <= $1 && $2 <= $3 ) {
   print
   ## Print the recs with less green than red or blue.
}

}' | sort $SORTPARM >> $OUTLIST
   fi

   ###############################
   ## Select the LESS-B recs.
   ###############################

   if test "$RorGorB" = "LESS-B"
   then
      cat  "$OUTTEMP" | awk '{

if ( $3 <= $1 && $3 <= $2 ) {
   print
   ## Print the recs with less blue than red or green.
}

}' | sort $SORTPARM >> $OUTLIST
   fi


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

  using 'showrgb', 'tr', 'grep', 'sort', 'uniq', and 'awk' to FIRST
  filter out gray/grey recs, remove total dupes (after converting
  all color names to lower-case), and add 'Brightness' to col4.
  Specifically:

   showrgb | tr '[A-Z]' '[a-z]' | \\
            grep -v gray | grep -v grey | sort | uniq | \\
            awk{...remove successive duplicate RGB-val recs...} | \\
            awk {...add brightness in col4 ...} 

   The resulting file is then piped into
            awk{...select the $RorGorB recs...} | \\
            sort $SORTPARM

  If you want to change the presentation format or the sorts or the grep
  filtering or the awk programs or whatever, you can simply edit the script.

------------------------------------------------------------------------------

The 'Brightness' (='Luminance'=Y) was calculated in the 'awk' script
as a weighted average of RGB vals:

               Y = .299*R + .587*G + .114*B

Based on the SGI/IRIX On-Line Book \"Infinite Reality Video Format Combiner
User's Guide\".  See the Glossary, terms 'YIQ' and 'YUV'.
------------------------------------------------------------------------------
FOR MORE INFO:

For more info the executables used,
you can type 'man <exe-name>' to see details on how the program
can be used.  ('man' stands for Manual.  It gives you the user
manual for the command/utility.)

You can type 'man man' at a shell prompt to see a description of
the 'man' command.

Or use the 'show_manhelp_4topic' Nautilus script in the
'LinuxHELPS' group of Nautilus scripts.


******* END OF LIST of X color names, selected by $RorGorB.
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

done
## END of while prompting loop.
