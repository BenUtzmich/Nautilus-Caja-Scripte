#!/bin/sh
##
## Nautilus
## SCRIPT: 00_1xyColDataFile_EDIT-CMDS-and-RUN-GNUPLOT_gnuplot.sh
##
## PURPOSE: Uses the 'gnuplot' command to plot data from a
##          user-selected file --- or from user-entered data.
##
## METHOD:  Presents the user with a sample file of gnuplot commands
##          to edit --- with the selected data filename embedded
##          in the gnuplot 'plot' command line.
##
##             (Instead of the data filename, the user could enter
##              data 'in-line', in the sample gnuplot commands file.
##              We need to put an example in the commands file.)
##
##          The user-selected file should contain at least 2 columns
##          of data --- one column for the x-axis and one or two
##          columns for the y-axis.
##
##          The user is put in edit mode on the sample file of gnuplot
##          COMMANDS.
##          The user edits the commands in this file to provide info like
##            - which column to use for the x-data
##            - which one or two columns to use for the y-data
##            - plot title
##            - x-axis label
##            - y-axis label
##            - type of plot (dots, lines, points, boxes, ...)
##            - plot output (png, jpg, gif, ps, or svg file)
##            - x data range (min, max)
##            - y data range (min, max)
##            - show a legend (no,yes)
##            - if a legend is requested: y1,y2 text for the legend
##            - whether to put the x-axis thru 0 on the y-axis (if zero
##                      is interior to the y-data range) 
##            - whether to put the y-axis thru 0 on the x-axis (if zero
##                      is interior to the x-data range) 
##            - a curve fit option: none, linear, quadratic, ....
##            - a few other options
##
##          Shows the PNG or GIF or JPG or PS or SVG output in a viewer
##          for the output file type.
##
##          Of course you can edit this script to change the editor
##          and the output viewer(s) --- and even to add more commented or
##          un-commented gnuplot commands --- and more command parameters.
##
## HOW TO USE: 
##          1) Right-click on the name of a columnar plot-data file in
##             any directory in a Nautilus directory list.
##
##               OR, if the user is going to enter/paste data into the
##               gnuplot commands file, the user can click on ANY file
##               in ANY directory.
##
##          2) Then choose this Nautilus script (name above).
##
##########################################################################
## Created: 2011may12
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################

## FOR TESTING: (show the statements as they execute)
#  set -x

########################################
## Get the filename of the selected file.
########################################

   DATAFILENAME="$1"
#  DATAFILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  DATAFILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

#################################################
## Put the fullname of the data file in a var.
#################################################

CURDIR="`pwd`"

FULLDATAFILENAME="$CURDIR/$DATAFILENAME"


#################################################
## Prepare a file to use for the gnuplot commands.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
#################################################

GPCMDSFILE="00_TEMP_gnuplot_COMMANDS.txt"

if test ! -w "$CURDIR"
then
  GPCMDSFILE="/tmp/$GPCMDSFILE"
fi

if test -f "$GPCMDSFILE"
then
  rm -f "$GPCMDSFILE"
fi


##########################################################
## Set the text editor and viewers to use ---
## like $TXTVIEWER to ## view gnuplot messages (if any).
##########################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

## NOTE: The editor is assumed, below, to run in foreground mode.
##       I have not found a way to run 'gedit' in 'foreground' mode.
##       Since I cannot guarantee that the text-editor that the
##       user may have specified in '.set_VIEWERvars.shi' will run
##       in foreground mode, I set the editor here.

TXTEDITOR="scite"


#################################################
## Show how to use this utility.
#################################################
   zenity --info \
   --title "Guide to editing the 'gnuplot' commands." \
   --text "\
Edit the 'gnuplot' commands in the commands file that pops up
in a text-editor --- to provide info like:
  - which column to use for the x-data
  - which one or two columns to use for the y-data
  - plot title
  - x-axis label
  - y-axis label
  - type of plot (dots, lines, points, boxes, ...)
  - plot output (png, jpg, gif, ps, or svg file)
  - x data range (min, max)
  - y data range (min, max)
  - show a legend (no,yes)
  - if a legend is requested: y1,y2 text for the legend
  - whether to put the x-axis thru 0 on the y-axis (if zero
            is interior to the y-data range) 
  - whether to put the y-axis thru 0 on the x-axis (if zero
            is interior to the x-data range) 
  - a curve fit option: none, linear, quadratic, ....
  - a few other options

The data file you selected is named in the 'plot' command
near the bottom of the commands list.

The text-editor used in this script is '$TXTEDITOR'.
To change it, edit this script:
   $0
" &


############################################
## Put a sample set of gnuplot COMMANDS into
## the gnuplot GPCMDSFILE. 
############################################

GNUPLOT_VERSION="`gnuplot --version`"

HOST_ID="`hostname`"

echo "\
## 'gnuplot' COMMANDS for plotting dataset
##   $DATAFILENAME
##
## in directory
##   $CURDIR
##
## Typically, at least CHANGE the X-AXIS and Y-AXIS
## range parameters below.
##
## SAVE this (temporary) file and EXIT your editor
## to initiate the gnuplot command.
##
## The lines with '##' in column 1 are comments and should
## not be de-commented.
##
## The lines with a single '#' in column 1 are sample gnuplot
## command lines and may be commented. In some cases, the line
## replaces another line, which should be commented.
##
#####################################################
## SOME SAMPLE (TEST) PLOT FILES:
##
## PLOT_DATAFILE=~/.gnome2/nautilus-scripts/zMORE/PLOTtools/.gnuplot_test_worldpopulation.txt
##                Suggested XRANGE=0,2500 YRANGE=0,8000
##
## PLOT_DATAFILE=~/.gnome2/nautilus-scripts/zMORE/PLOTtools/.gnuplot_test_lifeExpectancy_US.txt
##               Suggested XRANGE=1650,2050 YRANGE=0,100
##
## PLOT_DATAFILE=~/.gnome2/nautilus-scripts/zMORE/PLOTtools/.gnuplot_test_xycols.txt
##               Suggested XRANGE=0,20 YRANGE=0,100
##
#####################################################
## gnuplot Version on this host: $GNUPLOT_VERSION
## This host: $HOST_ID
##
## These gnuplot commands were created by the script:
## $0
##
## Set a working directory for gnuplot.
## gnuplot may put 'extra' files here.
## 
cd \"/tmp\"
##
##########################
## Set the gnuplot OUTPUT :
##
## A PNG plot:
##
set output '/tmp/gnuplot.png'
set terminal png size 1280, 960
##
## ALTERNATIVELY, a GIF plot:
##
# set output '/tmp/gnuplot.gif'
# set terminal gif size 1280, 960
##
## ALTERNATIVELY, a JPG plot:
##
# set output '/tmp/gnuplot.jpg'
# set terminal jpg size 1280, 960
##
## ALTERNATIVELY, a SVG plot:
##
# set output '/tmp/gnuplot.svg'
# set terminal svg size 1280, 960
##
## ALTERNATIVELY, a Postscript plot:
##
# set output '/tmp/gnuplot.ps'
# set terminal ps 
## 
##################################
## Set PLOT TITLE (at top of plot):
## 
set title 'Plot Title Goes Here'
##
#########################################
## Set TIMESTAMP (at bottom-left of plot):
## 
set timestamp '%Y %b %d %a %H:%M:%S'
##   Y=yyyy  b=mmm  d=dd  a=day-of-week  HMS=hours-mins-secs
##
###################
## Set X-AXIS PARMS:
## 
set xlabel 'X-axis Label Goes Here'
set xrange [ 0 : 100 ]
set xtic
## No mid-x-tickmarks:
set nomxtics
##
## Example of setting x-tic-marks manually:
# set xtics 0, 5 , 100
##
## To force vertical axis thru x=0, de-comment:
# set xzeroaxis
##
###################
## Set Y-AXIS PARMS:
## 
set ylabel 'Y-axis Label Goes Here'
set yrange [ 0 : 2000 ]
##
## To force horizontal axis thru y=0, de-comment:
# set yzeroaxis
##
##############################################
## Request PLOT LEGEND a.k.a. 'key' --- or not:
## 
set nokey
##
## set key top right
##
## set key bottom right
##
## set key top left
##
## set key bottom left
##
##
##############################
## Request PLOT FIT --- or not:
##
###################
## For a LINEAR fit:
##
# f(x) = a*x+b
# fit f(x) '$FULLDATAFILENAME' using 1:2 via a,b
##
## and attach the following line (including the leading comma)
## to the 'plot' command below.
##
# , f(x)  title 'a*x+b'  with lines
##
##
######################
## For a QUADRATIC fit:
##
# f(x) = a*x**2 + b*x + c
# fit f(x) '$FULLDATAFILENAME' using 1:2 via a,b,c
##
## and attach the following line (including the leading comma)
## to the 'plot' command below.
##
#  , f(x)  title 'a*x**2 + b*x + c'   with lines
##
##
#######################
## For a POWER-OF-X fit:
##
# f(x) = a*x**b
# fit f(x) '$FULLDATAFILENAME' using 1:2 via a,b
##
## and attach the following line (including the leading comma)
## to the 'plot' command below.
##
#  , f(x)  title 'a*x**b'   with lines
##
##
##################################
## For an EXPONENTIAL(base 10) fit:
##
# f(x) = a * 10 ** (b*x)
# fit f(x) '$FULLDATAFILENAME' using 1:2 via a,b
##
## and attach the following line (including the leading comma)
## to the 'plot' command below.
##
# , f(x)  title 'a * 10 ** (b*x)'  with lines
##
##
##################################
## For an EXPONENTIAL(base e) fit:
##
# f(x) = a * exp ( b * x )
# fit f(x) '$FULLDATAFILENAME' using 1:2 via a,b
##
## and attach the following line (including the leading comma)
## to the 'plot' command below.
##
#  , f(x)  title 'a * exp ( b * x )'  with lines
##
##
######################
######################
## The PLOT COMMAND(s):
##
# set multiplot
##
plot '$FULLDATAFILENAME' using 1:2 \
     title 'Y1 legend-label text goes here' \
     with lines lw 1 
##
## To add a 2nd Y-plot, add a back-slash to the line above and
## MOVE the lines below (including the leading comma) underneath
## the line above, after removing the leading '#' comment indicators.
##
# , '$FULLDATAFILENAME' using 1:3 \
#   title 'Y2 legend-label text goes here' \
#   with lines lw 1
##
##
# set nomultiplot
##
###################################
## ADD A LABEL anywhere on the plot:
##
# set label 'A plot note can go here.' at 1000,-2 center
##
## If your x-axis went from 0 to 2000, then '1000,-2 center' would locate the
## label below the x-axis (because of '-2') and just about centered in the
## x-direction on the plot (because of '1000' and 'center').
##
#########################
## Put ARROWS on the plot:
##
# set arrow ....
##
## See a gnuplot help guide, with FE Nautilus Script
##       00_show_GNUPLOT_MANUAL_{version-number}.sh
##
## See more gnuplot help at its home page, with FE Nautilus Script
##       00_show_GNUPLOT_HOMEPAGE.sh
##
##
######################
## View the image plot:
##
## The exclamation point tells gnuplot to pass the command to
## a shell (a command interpreter for the operating system).
## 
! /usr/bin/eog  /tmp/gnuplot.png
# ! /usr/bin/eog  /tmp/gnuplot.gif
# ! /usr/bin/eog  /tmp/gnuplot.jpg
# ! /usr/bin/inkscape  /tmp/gnuplot.svg
# ! /usr/bin/evince  /tmp/gnuplot.ps
##
## END of 'gnuplot' COMMANDS.
" > "$GPCMDSFILE"




########################################################################
## START OF EDIT-PLOT LOOP, FOR PLOT DATA & PLOT PARMS.
########################################################################

# while true
while :
do

   #################################################################
   ## 10. Put the user in (foreground) edit mode on the GPCMDSFILE.
   #################################################################
   ## The editor is assumed to run in foreground mode.
   ## That is, the script is to continue only after the editor is closed. 
   #################################################################

   # $TXTEDITOR "$GPCMDSFILE"
   #  wait

   # $TXTEDITOR "$GPCMDSFILE" &
   # cmd_pid=$!
   # wait $cmd_pid;

   ## NOTE: I have not found a way to run 'gedit' in 'foreground' mode.
   ##       These attempts did not work.

   $TXTEDITOR "$GPCMDSFILE"


   #####################################################################
   ## 20. We will put gnuplot messages in file named in var $OUTLIST_PLOTMSGS.
   #####################################################################

   OUTLIST_PLOTMSGS="00_TEMP_GnuPlotMessages.txt"

   if test ! -w "$CURDIR"
   then
      OUTLIST_PLOTMSGS="/tmp/$OUTLIST_PLOTMSGS"
   fi

   if test -f "$OUTLIST_PLOTMSGS"
   then
      rm -f "$OUTLIST_PLOTMSGS"
   fi


   ####################### HERE'S THE GNUPLOT CMD ####################
   ###################################################################
   ## 30. PLOT THE $OUTLIST_PLOTCMDS FILE, with gnuplot.
   ###################################################################

   gnuplot "$GPCMDSFILE"  2>  "$OUTLIST_PLOTMSGS"
 

   ###################################################################
   ## PopUp a window to show the location of the gnuplot output
   ## image file --- png or jpg or gif or whatever. Uses 'zenity'.
   ###################################################################

   zenity  --info --title "gnuplot PlotFile Location - INFO" \
          --text  "\
The OUTPUT image file may be, if the default was unchanged,
in directory /tmp 

You can move the file from there, if you want to use it
--- say, in a web page or in an archive directory.
" &


   ###################################################################
   ## 40. SHOW/PRINT the gnuplot messages file ---
   ##      $OUTLIST_PLOTMSGS --- if it is non-empty.
   ###################################################################

   if test -s "$OUTLIST_PLOTMSGS"
   then
      $TXTVIEWER  "$OUTLIST_PLOTMSGS"
      sleep 5
   fi


   ###################################################################
   ## 50. SHOW/PRINT the gnuplot commands file --- $GPCMDSFILE ---
   ##      if the user wants to see it.
   ###################################################################

   zenity  --question --title "View the plot commands fed to gnuplot?" \
            --text  "\
Do you want to see the gnuplot commands file
that was fed to the 'gnuplot' command?

File:
$GPCMDSFILE

   You can save this file and edit it
   to enhance it, to feed to gnuplot.

Cancel = No."

   if test $? = 0
   then
      ANS="Yes"
   else
      ANS="No"
   fi

   if test "$ANS" = "Yes"
   then
      $TXTVIEWER "$GPCMDSFILE"
      sleep 5
   fi 


  ####################################################################
  ## 70. A zenity OK/Cancel prompt for 'Another plot with this data?'.
  ####################################################################

   # sleep 6

   zenity  --question --title "Another plot?" \
          --text  "\
Do you want to edit the gnuplot COMMANDS file
of this utility, again, for ANOTHER PLOT?

COMMANDS file:
$GPCMDSFILE

Cancel = No. (EXIT)"

   if test $? = 0
   then
      ANS="Yes"
   else
      ANS="No"
   fi

   if test "$ANS" = "No"
   then
     exit
   fi 

   ########################################################################
   ## RETURN TO AN EDIT-GNUPLOT-COMMANDS WINDOW.
   ########################################################################

done
## END of while loop, editing a 'temp' file of gnuplot commands.
