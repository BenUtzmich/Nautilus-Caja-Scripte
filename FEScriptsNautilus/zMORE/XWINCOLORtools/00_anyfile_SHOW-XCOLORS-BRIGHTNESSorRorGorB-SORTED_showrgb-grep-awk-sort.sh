#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_anyfile_SHOW-XCOLORS-BRIGHTNESSorRorGorB-SORTED_showrgb-grep-awk-sort.sh
##
## PURPOSE: Show selected (non-grey/gray) X-colors sorted by
##          brightness (weighted average of RGB values) and/or the
##          red value and/or the green value and/or the blue value
##          of the RGB (0-255) columns from the 'showrgb' command.
##
#############################################################################
## Reference for the weighted sum of RGB vals:
##
## 'Luminance' (Y) is a weighted average of RGB vals:
##
##                    Y = .299*R + .587*G + .114*B
##
## See IRIX On-Line Book "Infinite Reality Video Format Combiner User s Guide",
## the Glossary, terms 'YIQ' and 'YUV'.
##############################################################################
##
## METHOD:  Uses a 'zenity --radiolist' prompt to present a choice
##          of BRIGHTNESS-then-R or  BRIGHTNESS-then-G or  BRIGHTNESS-then-B
##          or R-then-BRIGHTNESS  or G-then-BRIGHTNESS or B-then-BRIGHTNESS sort.
##
##          Pipes 'showrgb' output through a 'grep' filter to an 'awk'
##          program to an uppercase-to-lowercase translation to 'uniq'
##          to the 'sort' command.
##
##          Puts the (text) output into a text file in /tmp.
##
##          Uses a text-viewer of the user's choice to display the
##          text file.
##
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

########################################################
## zenity radiolist prompt for the BRIGHTNESS/R/G/B sort
## -- in a while loop.
########################################################

while :
do

   RorGorB=""

   RorGorB=$(zenity --list --radiolist \
   --title "Sort X-colors by R, G, B or Brightness?" \
   --height=300 \
   --text "\
How do you want to sort 'showrgb' output by the 0-255
numbers in the R, G, B, or Brightness columns?" \
   --column "Pick1" --column "Sort" \
   NO BRIGHTNESS \
   NO BRIGHTNESS-then-R \
   NO BRIGHTNESS-then-G \
   NO BRIGHTNESS-then-B \
   NO R-then-BRIGHTNESS \
   NO G-then-BRIGHTNESS \
   NO B-then-BRIGHTNESS \
   NO R-then-G-then-B \
   NO R-then-B-then-G \
   NO G-then-R-then-B \
   NO G-then-B-then-R \
   NO B-then-R-then-G \
   NO B-then-G-then-R
)
 
   if test "$RorGorB" = ""
   then
      exit
   fi

   ## FOR TESTING:
   #   set -x

   if test "$RorGorB" = "BRIGHTNESS"
   then
      SORTPARM="-k4nr"
   fi

   if test "$RorGorB" = "BRIGHTNESS-then-R"
   then
      SORTPARM="-k4nr -k1nr"
   fi

   if test "$RorGorB" = "BRIGHTNESS-then-G"
   then
      SORTPARM="-k4nr -k2nr"
   fi

   if test "$RorGorB" = "BRIGHTNESS-then-B"
   then
      SORTPARM="-k4nr -k3nr"
   fi

   if test "$RorGorB" = "R-then-BRIGHTNESS"
   then
      SORTPARM="-k1nr -k4nr"
   fi

   if test "$RorGorB" = "G-then-BRIGHTNESS"
   then
      SORTPARM="-k2nr -k4nr"
   fi

   if test "$RorGorB" = "B-then-BRIGHTNESS"
   then
      SORTPARM="-k3nr -k4nr"
   fi

   if test "$RorGorB" = "R-then-G-then-B"
   then
      SORTPARM="-k1nr -k2nr -k3nr"
   fi

   if test "$RorGorB" = "R-then-B-then-G"
   then
      SORTPARM="-k1nr -k3nr -k2nr"
   fi

   if test "$RorGorB" = "G-then-R-then-B"
   then
      SORTPARM="-k2nr -k1nr -k3nr"
   fi

   if test "$RorGorB" = "G-then-B-then-R"
   then
      SORTPARM="-k2nr -k3nr -k1nr"
   fi

   if test "$RorGorB" = "B-then-R-then-G"
   then
      SORTPARM="-k3nr -k1nr -k2nr"
   fi

   if test "$RorGorB" = "B-then-G-then-R"
   then
      SORTPARM="-k3nr -k2nr -k1nr"
   fi


   ################################################################
   ## Prep a temporary filename, to hold the list of color names.
   ##
   ##      We put the outlist file in /tmp, in case the user
   ##      does not have write-permission in the current directory,
   ##      and because the output does not, usually, have anything
   ##      to do with the current directory.
   ################################################################

   OUTLIST="${USER}_Xcolors_of_showrgb_sortedBy$RorGorB.lis"

   OUTLIST="/tmp/$OUTLIST"
 
   if test -f "$OUTLIST"
   then
      rm -f "$OUTLIST"
   fi

   #############################################
   ## Prepare a HEADER for the text report file.
   #############################################

THISHOST=`hostname`

echo "\
................ `date '+%Y %b %d  %a  %T%p %Z'` ......................

X color names sorted by  $RorGorB

--- largest  $RorGorB  values first (i.e. descending sort).

      ( Brightness = .299*R + .587*G + .114*B )

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
         sort | uniq |  awk \
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
}' | sort $SORTPARM  >> $OUTLIST


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

  using 'showrgb', 'grep', 'sort', 'tr', and 'uniq'. Specifically:

   showrgb | tr '[A-Z]' '[a-z]' | \\
            grep -v gray | grep -v grey | sort | uniq | \\
            awk{...remove successive duplicate RGB-val recs...} | \\
            awk {...add brightness in col4 ...} | \\
            sort $SORTPARM 

  If you want to change the presentation format or the sorts or the grep
  filtering or the awk programs or whatever, you can simply edit the script.

  NOTE: All the color names were changed to lower-case --- to help
        get rid of duplicate color names (and numbers).

------------------------------------------------------------------------------

The 'Brightness' (='Luminance'=Y) was calculated in the 'awk' script
as a weighted average of RGB vals:

               Y = .299*R + .587*G + .114*B

------------------------------------------------------------------------------
FOR MORE INFO:

For more info on the executables used,
you can type 'man <exe-name>' to see details on how the program
can be used.  ('man' stands for Manual.  It gives you the user
manual for the command/utility.)

You can type 'man man' at a shell prompt to see a description of
the 'man' command.

Or use the 'show_manhelp_4topic' Nautilus script in the
'LinuxHELPS' group of Nautilus scripts.


******* END OF LIST of X color names, sorted by $RorGorB .
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
