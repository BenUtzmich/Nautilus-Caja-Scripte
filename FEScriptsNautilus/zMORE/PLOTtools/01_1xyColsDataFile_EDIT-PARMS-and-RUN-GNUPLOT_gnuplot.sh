#!/bin/sh
##
## Nautilus
## SCRIPT: 00_1xyColsDataFile_EDIT-PARMS-and-RUN-GNUPLOT_gnuplot.sh
##
## PURPOSE: Uses the 'gnuplot' command to plot data from a
##          user-selected x-y-cols data file.
##          Uses a 'parameters-only file' to build a gnuplot command file.
##
## METHOD:  The user-selected data file should contain at least 2 columns
##          of data --- one column for the x-axis and one or two columns
##          for the y-axis.
##
##          The user is put in edit mode on a file of plot options.
##          The user edits this file to provide info like
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
##          Of course you can edit this script to change viewers --- and
##          even to handle more plot parameter values and added gnuplot options.
##
## HOW TO USE: 
##          1) Right-click on the name of a columnar plot-data file in
##             any directory in a Nautilus directory list.
##          2) Then choose this Nautilus script (name above).
##
#######################################################################
## Created: 2011apr28
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


##########################################################
## Set the text editor and viewers to use ---
## like $TXTVIEWER to view gnuplot messages (if any).
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


##############################################
## Prepare a file to use for the gnuplot params.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##############################################

CURDIR="`pwd`"

PARAMSFILE="00_TEMP2_gnuplot_params.txt"

if test ! -w "$CURDIR"
then
  PARAMSFILE="/tmp/$PARAMSFILE"
fi

if test -f "$PARAMSFILE"
then
  rm -f "$PARAMSFILE"
fi


############################################
## Set a directory for work files.
############################################

DIR_WORK="/tmp"


#################################################
## Show how to use this utility.
#################################################
   zenity --info \
   --title "Guide to editing the 'gnuplot' commands." \
   --text "\
Edit the 'gnuplot' command options (put in environment variables)
in the following 'plot-parms' file to provide info like:
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

The data file that you selected to plot is
   $DATAFILENAME

The text-editor used in this script is '$TXTEDITOR'.
To change it, edit this script:
   $0

Work files and plot output files, like '.png' files,
will be put in the directory:
   $DIR_WORK
" &



############################################
## Copy a sample set of gnuplot params into
## the gnuplot PARAMSFILE. 
############################################

## cp "$HOME/.gnome2/nautilus-scripts/zMORE/PLOTtools/.gnuplot_init_parms.txt" \
##    "$PARAMSFILE"

echo "\
## 'gnuplot' control file.
## (PARAMETERS that are used to build a gnuplot COMMANDS file.)
##
##    Scan the equal signs for parameters to change.
##
##    Leave the equal signs untouched and leave the variable indicators
##    on the left of the equal signs untouched.
##
##    In particular, you will usually need to edit the
##    'X RANGE' and 'Y RANGE' parameters below.
##
##    SAVE this file and EXIT your editor, to continue to the plotting phase.
##
##    This parameters file could be replaced by a Tcl-Tk prompting GUI,
##    someday.
##
PLOT_TITLE=Plot Title Goes Here
##
PLOT_DATAFILE=$DATAFILENAME
##
## The input datafile could be a name like  /home/userid/plot_xycols_whatever.txt
##
## Or use an example (test) file like one of the following.
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
PLOT_TYPE_OPT=lines lw 1
## PLOT_TYPE_OPTs are: dots lines points linespoints boxes steps impulses
## For different line widths, use 'lw N' where N is 1 to 6.
##
PLOT_OUTPUT_OPT=png
## PLOT_OUTPUT_OPTs are: png jpg gif ps svg
## (PNG or JPG or GIF image file --- or PS = PostScript file, for printing
##  --- or SVG = Scalable Vector Graphics format)
##
## X-RANGE:
PLOT_XMIN=0
PLOT_XMAX=2500
##
## Y-RANGE:
PLOT_YMIN=0
PLOT_YMAX=8000
##
## AXIS LABELS:
PLOT_XAXIS_LABEL=X-axis Label Goes Here
PLOT_YAXIS_LABEL=Y-axis Label Goes Here
##
## X-and-Y DATA COLUMNS:  (Leave Y2 blank if only one set of Y data.)
PLOT_XDATA_COLNUM=1
PLOT_Y1DATA_COLNUM=2
PLOT_Y2DATA_COLNUM=
##
## LEGEND (if any):
PLOT_LEGEND_OPT=none
## PLOT_LEGEND_OPTs are: none, topright, bottomright, topleft, bottomleft
##
PLOT_Y1LEGEND_LABEL=Y1 legend-label text goes here
PLOT_Y2LEGEND_LABEL=Y2 legend-label text goes here
##
## PLOT AXES THRU X or Y AXIS ZERO VALUE?
PLOT_LINE_AT_XZERO_OPT=no
PLOT_LINE_AT_YZERO_OPT=no
##
## 'rotate' or 'norotate' XTIC marks. (A null entry = norotate.)
PLOT_XTIC_OPT=norotate
##
PLOT_FIT_TYPE_OPT=none
## PLOT_FIT_TYPE_OPTs are: none linear quadratic
##                         power-of-x exp-base10 exp-baseE
##
## END OF DATA FOR 'gnuplot'
" > "$PARAMSFILE"



###########################################################################
## Set PLOT_TITLE_INIT to be default in the '.gnuplot_init_parms.txt' file.
## This will be used to build a better title for some types of plot.
###########################################################################

PLOT_TITLE_INIT="Plot Title Goes Here"


########################################################################
## START OF EDIT-PLOT LOOP, FOR PLOT DATA & PLOT PARMS.
########################################################################

# while true
while :
do


  ###############################################################
  ## 10. Put the user in (foreground) edit mode on the PARAMSFILE.
  ###############################################################
  ## The editor is assumed to run in foreground mode.
  ## That is, the script continues when the editor is closed. 
  ###############################################################

  # $TXTEDITOR "$PARAMSFILE"
  #  wait

  # $TXTEDITOR "$PARAMSFILE" &
  # cmd_pid=$!
  # wait $cmd_pid;

  ## NOTE: I have not found a way to run 'gedit' in 'foreground' mode.
  ##       These attempts did not work.

  $TXTEDITOR  "$PARAMSFILE"


  #################################################
  ## 20. After the user has edited the PARAMSFILE,
  ## extract the user-specifications in the file
  ## into environment variables to be used to
  ## pass an appropriate set of commands to gnuplot. 
  #################################################

   PLOT_TITLE=`grep '^PLOT_TITLE=' "$PARAMSFILE" | head -1 | cut -d= -f2`

   PLOT_DATAFILE=`grep '^PLOT_DATAFILE=' "$PARAMSFILE" | head -1 | cut -d= -f2`

   ## Strip trailing blanks, if any.
   PLOT_DATAFILE=`echo "$PLOT_DATAFILE" | sed -e 's| *$||'`

   if test "$PLOT_DATAFILE" = ""
   then
      PLOT_DATAFILE="$CURDIR/$DATAFILENAME"
   fi

   PLOT_TYPE_OPT=`grep '^PLOT_TYPE_OPT=' "$PARAMSFILE" | head -1 | cut -d= -f2`

   ## PLOT_TYPE_OPTs are: dots lines points linespoints boxes steps impulses
 
   PLOT_OUTPUT_OPT=`grep '^PLOT_OUTPUT_OPT=' "$PARAMSFILE" | head -1 | cut -d= -f2`

   ## PLOT_OUTPUT_OPTs are: png, jpg, gif, ps, or svg
 
    PLOT_FIT_TYPE_OPT=`grep '^PLOT_FIT_TYPE_OPT=' "$PARAMSFILE" | head -1 | cut -d= -f2`

    ## PLOT_FIT_TYPE_OPTs are: none linear quadratic power-of-x exp-base10 exp-baseE

    ##
    ## X-RANGE:
    PLOT_XMIN=`grep '^PLOT_XMIN=' "$PARAMSFILE" | head -1 | cut -d= -f2`
    PLOT_XMAX=`grep '^PLOT_XMAX=' "$PARAMSFILE" | head -1 | cut -d= -f2`

    ##
    ## Y-RANGE:
    PLOT_YMIN=`grep '^PLOT_YMIN=' "$PARAMSFILE" | head -1 | cut -d= -f2`
    PLOT_YMAX=`grep '^PLOT_YMAX=' "$PARAMSFILE" | head -1 | cut -d= -f2`

    ##
    ## AXIS LABELS:
    PLOT_XAXIS_LABEL=`grep '^PLOT_XAXIS_LABEL=' "$PARAMSFILE" | head -1 | cut -d= -f2`
    PLOT_YAXIS_LABEL=`grep '^PLOT_YAXIS_LABEL=' "$PARAMSFILE" | head -1 | cut -d= -f2`

    ##
    ## X-and-Y DATA COLUMNS:  (Leave Y2 blank if only one set of Y data.)
    PLOT_XDATA_COLNUM=`grep '^PLOT_XDATA_COLNUM=' "$PARAMSFILE" | head -1 | cut -d= -f2`
    PLOT_Y1DATA_COLNUM=`grep '^PLOT_Y1DATA_COLNUM=' "$PARAMSFILE" | head -1 | cut -d= -f2`
    PLOT_Y2DATA_COLNUM=`grep '^PLOT_Y2DATA_COLNUM=' "$PARAMSFILE" | head -1 | cut -d= -f2`

    ##
    ## LEGEND (if any):
    PLOT_LEGEND_OPT=`grep '^PLOT_LEGEND_OPT=' "$PARAMSFILE" | head -1 | cut -d= -f2`
    PLOT_Y1LEGEND_LABEL=`grep '^PLOT_Y1LEGEND_LABEL=' "$PARAMSFILE" | head -1 | cut -d= -f2`
    PLOT_Y2LEGEND_LABEL=`grep '^PLOT_Y2LEGEND_LABEL=' "$PARAMSFILE" | head -1 | cut -d= -f2`

    ##
    ## PLOT AXES THRU X or Y AXIS ZERO VALUE?
    PLOT_LINE_AT_XZERO_OPT=`grep '^PLOT_LINE_AT_XZERO_OPT=' "$PARAMSFILE" | head -1 | cut -d= -f2`
    PLOT_LINE_AT_YZERO_OPT=`grep '^PLOT_LINE_AT_YZERO_OPT=' "$PARAMSFILE" | head -1 | cut -d= -f2`

    ##
    PLOT_XTIC_OPT=`grep '^PLOT_XTIC_OPT=' "$PARAMSFILE" | head -1 | cut -d= -f2`


   ###############################################
   ## Prompt for the size for the image file.
   ###############################################

   if test "$PLOT_OUTPUT_OPT" = "png" -o \
           "$PLOT_OUTPUT_OPT" = "jpg" -o \
           "$PLOT_OUTPUT_OPT" = "gif" -o \
           "$PLOT_OUTPUT_OPT" = "svg"
   then

      SIZEXY=""
      SIZEXY=$(zenity --entry --title "Enter size of image file, in x y pixels." \
               --text "\
Enter the X and Y sizes for the $PLOT_OUTPUT_OPT image file.
Examples: 1280 960   OR   640 480" \
               --entry-text "1280 960")

      if test "$SIZEXY" = ""
      then
         exit
      fi

      SIZEX=`echo "$SIZEXY" | cut -d' ' -f1`
      SIZEY=`echo "$SIZEXY" | cut -d' ' -f2`

   fi
   ## END of if test "$PLOT_OUTPUT_OPT" = "png" ... "jpg" ... "gif" ... "xvg"



   #####################################################################
   ## 30. We will put gnuplot-cmds in file named in var $OUTLIST_PLOTCMDS.
   #####################################################################
   #####################################################################
   ## We will put gnuplot messages in file named in var $OUTLIST_PLOTMSGS.
   #####################################################################

   OUTLIST_PLOTCMDS="00_TEMP2_GnuPlotCmds.txt"
   OUTLIST_PLOTMSGS="00_TEMP2_GnuPlotMessages.txt"

   if test ! -w "$CURDIR"
   then
     OUTLIST_PLOTCMDS="/tmp/$OUTLIST_PLOTCMDS"
     OUTLIST_PLOTMSGS="/tmp/$OUTLIST_PLOTMSGS"
   fi

   if test -f "$OUTLIST_PLOTCMDS"
   then
     rm -f "$OUTLIST_PLOTCMDS"
   fi

   if test -f "$OUTLIST_PLOTMSGS"
   then
     rm -f "$OUTLIST_PLOTMSGS"
   fi


   #######################################################################
   ## MAKE THE 'gnuplot' commands file, OUTLIST_PLOTCMDS, to do the plot.
   #######################################################################
   ## We build up the commands and comments in PLOT_BODY, which contains
   ## commands independent of the output type chosen.
   ##
   ## PLOT_BODY is built from the variables
   ## PLOT_TITLE , PLOT_XAXIS_LABEL , PLOT_XMIN : PLOT_XMAX ,
   ##              PLOT_XTIC_OPTLINE , PLOT_LINE_AT_YZERO_OPTLINE ,
   ##              PLOT_YAXIS_LABEL , PLOT_YMIN : PLOT_YMAX ,
   ##              PLOT_LINE_AT_XZERO_OPTLINE , PLOT_LEGEND_LINE ,
   ## and PLOT_FIT_LINES , PLOT_CMD .
   ##
   ## PLOT_FIT_LINES and PLOT_CMD are built-up, rather non-trivially, below.
   ## They use the gnuplot 'fit' and 'plot' commands, respectively.
   #######################################################################

   ########################################################################
   ## 50. FIRST,
   ## Translate some of the options into 'gnuplot' vernacular, in LINE vars.
   ########################################################################
   ## By this, I mean:
   ## If there are options that cannot be used directly,
   ## we use a '...LINE' variable to build the plot commands.
   ##
   ## Example: With PLOT_XTIC_OPT='norotate', 'norotate' is not an
   ##          actual parm of the 'xtic' var.  Rather we use 
   ##          PLOT_XTIC_OPTLINE="set xtic"  for 'norotate'  and
   ##          PLOT_XTIC_OPTLINE="set xtic rotate"  for 'rotate'.
   ###################################################################

   #########################
   ## USE $PLOT_XTIC_OPT:
   #########################

   PLOT_XTIC_OPTLINE="set xtic $PLOT_XTIC_OPT"
   if test "$PLOT_XTIC_OPT" = "norotate"
   then
      PLOT_XTIC_OPTLINE="set xtic"
   fi

   ##############################
   ## USE $PLOT_LINE_AT_XZERO_OPT:
   ##############################

   PLOT_LINE_AT_XZERO_OPTLINE="## 'set yzeroaxis' would have gone here, if requested."
   if test "$PLOT_LINE_AT_XZERO_OPT" = "yes"
   then
      PLOT_LINE_AT_XZERO_OPTLINE="set yzeroaxis"
   fi

   ##############################
   ## USE $PLOT_LINE_AT_YZERO_OPT:
   ##############################

   PLOT_LINE_AT_YZERO_OPTLINE="## 'set xzeroaxis' would have gone here, if requested."
   if test "$PLOT_LINE_AT_YZERO_OPT" = "yes"
   then
      PLOT_LINE_AT_YZERO_OPTLINE="set xzeroaxis"
   fi

   #########################
   ## USE $PLOT_LEGEND_OPT:
   #########################
   PLOT_LEGEND_LINE=""

   if test "$PLOT_LEGEND_OPT" = "none"
   then
      PLOT_LEGEND_LINE="set nokey"
   fi

   if test "$PLOT_LEGEND_OPT" = "topright"
   then
      PLOT_LEGEND_LINE="set key top right"
   fi

   if test "$PLOT_LEGEND_OPT" = "bottomright"
   then
      PLOT_LEGEND_LINE="set key bottom right"
   fi

   if test "$PLOT_LEGEND_OPT" = "topleft"
   then
      PLOT_LEGEND_LINE="set key top left"
   fi

   if test "$PLOT_LEGEND_OPT" = "bottomleft"
   then
      PLOT_LEGEND_LINE="set key bottom left"
   fi


   ########################################################
   ## 60. Set a default PLOT_CMD line, that plots Y1 against X.
   ##     THIS IS THE MAIN PLOT COMMAND.
   ########################################################

   PLOT_CMD="\
plot \"$PLOT_DATAFILE\" using ${PLOT_XDATA_COLNUM}:${PLOT_Y1DATA_COLNUM} title '$PLOT_Y1LEGEND_LABEL'  with $PLOT_TYPE_OPT"


   ################################################################
   ## 70. USE $PLOT_Y2DATA_COLNUM (if not empty) to add to PLOT_CMD:
   ################################################################
   ## We do not support a curve-fit when more
   ## than one y-column is being plotted.
   ##
   ## So we set PLOT_FIT_TYPE_OPT="none" ---
   ## so that PLOT_FIT_TYPE_OPT checks below
   ## are not activated.
   #######################################

   if test "$PLOT_Y2DATA_COLNUM" != ""
   then
       PLOT_FIT_TYPE_OPT="none"
       PLOT_CMD="\
$PLOT_CMD , \"$PLOT_DATAFILE\" using ${PLOT_XDATA_COLNUM}:${PLOT_Y2DATA_COLNUM}  title '$PLOT_Y2LEGEND_LABEL'  with $PLOT_TYPE_OPT "

      if test  \( "$PLOT_TITLE" = "$PLOT_TITLE_INIT"  -o "$PLOT_TITLE" = "" \)
      then
         PLOT_TITLE="Plot of TWO-y-data-columns in $PLOT_DATAFILE"
      fi
   fi


   ################################################################
   ## 80. USE $PLOT_FIT_TYPE_OPT to
   ##     build the variable PLOT_FIT_LINES, to contain fit commands.
   ################################################################

   if test "$PLOT_FIT_TYPE_OPT" = "none"
   then
      PLOT_FIT_LINES="## A 'fit' command would have gone here, if a fit was requested."
   fi


   #################################
   ## 80.1. FOR FIT_TYPE="linear":
   #################################

   if test "$PLOT_FIT_TYPE_OPT" = "linear"
   then
      if test \( "$PLOT_TITLE" = "$PLOT_TITLE_INIT"  -o "$PLOT_TITLE" = "" \)
      then
         PLOT_TITLE="a*x+b (LINEAR) fit to data in $PLOT_DATAFILE"
      fi

      PLOT_FIT_LINES="\
f(x) = a*x+b
fit f(x) \"$PLOT_DATAFILE\" using ${PLOT_XDATA_COLNUM}:${PLOT_Y1DATA_COLNUM} via a,b"

      PLOT_CMD="$PLOT_CMD , f(x)  title 'a*x+b'  with lines"
   fi


   ###################################
   ## 80.2. FOR FIT_TYPE="quadratic":
   ###################################

   if test "$PLOT_FIT_TYPE_OPT" = "quadratic"
   then
      if test \( "$PLOT_TITLE" = "$PLOT_TITLE_INIT" -o "$PLOT_TITLE" = "" \)
      then
         PLOT_TITLE="a*x**2+b*x+c (QUADRATIC) fit to data in $PLOT_DATAFILE"
      fi

      PLOT_FIT_LINES="\
f(x) = a*x**2 + b*x + c
fit f(x) \"$PLOT_DATAFILE\" using ${PLOT_XDATA_COLNUM}:${PLOT_Y1DATA_COLNUM} via a,b,c"

      PLOT_CMD="$PLOT_CMD , f(x)  title 'a*x**2 + b*x + c'   with lines"
   fi

   #####################################
   ## 80.3. FOR FIT_TYPE="power-of-x":
   #####################################

   if test "$PLOT_FIT_TYPE_OPT" = "power-of-x"
   then
      if test \( "$PLOT_TITLE" = "$PLOT_TITLE_INIT" -o "$PLOT_TITLE" = "" \)
      then
         PLOT_TITLE="a*x**b (POWER-of-X) fit to data in $PLOT_DATAFILE"
      fi

      PLOT_FIT_LINES="\
f(x) = a*x**b
fit f(x) \"$PLOT_DATAFILE\" using ${PLOT_XDATA_COLNUM}:${PLOT_Y1DATA_COLNUM} via a,b"

      PLOT_CMD="$PLOT_CMD , f(x)  title 'a*x**b'   with lines"
   fi

   ####################################
   ## 80.4. FOR FIT_TYPE="exp-baseE":
   ####################################

   if test "$PLOT_FIT_TYPE_OPT" = "exp-base10"
   then
      if test \( "$PLOT_TITLE" = "$PLOT_TITLE_INIT"  -o "$PLOT_TITLE" = "" \)
      then
         PLOT_TITLE="a*10**(b*x) (exp-base-10) fit to data in $PLOT_DATAFILE"
      fi

      PLOT_FIT_LINES="\
f(x) = a * 10 ** (b*x)
fit f(x) \"$PLOT_DATAFILE\" using ${PLOT_XDATA_COLNUM}:${PLOT_Y1DATA_COLNUM} via a,b"

      PLOT_CMD="$PLOT_CMD , f(x)  title 'a * 10 ** (b*x)'  with lines"
   fi


   ####################################
   ## 80.5. FOR FIT_TYPE="exp-baseE":
   ####################################

   if test "$PLOT_FIT_TYPE_OPT" = "exp-baseE"
   then
      if test \( "$PLOT_TITLE" = "$PLOT_TITLE_INIT"  -o "$PLOT_TITLE" = "" \)
      then
         PLOT_TITLE="a*exp(b*x)  (exp-base-E) fit to data in $PLOT_DATAFILE"
      fi

      
      PLOT_FIT_LINES="\
f(x) = a * exp ( b * x )
fit f(x) \"$PLOT_DATAFILE\" using ${PLOT_XDATA_COLNUM}:${PLOT_Y1DATA_COLNUM} via a,b"

      PLOT_CMD="$PLOT_CMD , f(x)  title 'a * exp ( b * x )'  with lines"
   fi


   ##########################################################
   ##########################################################
   ## 90. Set $PLOT_BODY --- to set OUTPUT-TYPE-INDEPENDENT
   ##     commands, for use in the output-type sections below.
   ##     (png/jpg/gif, ps, svg)
   ##########################################################
   ##########################################################

   PLOT_BODY="\
##
## 
## Set plot title (at top of plot):
## 
set title \"$PLOT_TITLE\"
##
## 
## Set timestamp (at bottom-left of plot):
## 
set timestamp '%Y %b %d %a %H:%M:%S'
##
##
## Set x-axis parms:
## 
set xlabel \"$PLOT_XAXIS_LABEL\"
set xrange [ $PLOT_XMIN : $PLOT_XMAX ]
$PLOT_XTIC_OPTLINE
set nomxtics
##
## Example of setting x-tic-marks manually:
## set xtics $PLOT_XMIN, 5 , $PLOT_XMAX
##
$PLOT_LINE_AT_YZERO_OPTLINE
##
##
## Set y-axis parms:
## 
set ylabel \"$PLOT_YAXIS_LABEL\"
set yrange [ $PLOT_YMIN : $PLOT_YMAX ]
##
$PLOT_LINE_AT_XZERO_OPTLINE
##
##
## Set plot 'legend' a.k.a. 'key' (if user requested):
## 
$PLOT_LEGEND_LINE
##
##
## Do plot fit (if user requested):
## 
$PLOT_FIT_LINES
##
##
## Execute the plot command(s):
##
# set multiplot
#
$PLOT_CMD
#
# set nomultiplot
######################################################
## Example of how to add a label anywhere on the plot:
##
## set label \"A plot note can go here.\" at 1000,-2 center
##
## If your x-axis went from 0 to 2000, then '1000,-2 center' would locate the
## label below the x-axis (because of '-2') and just about centered in the
## x-direction on the plot (because of '1000' and 'center').
##
## You can even put arrows on your plot with a 'set arrow' command.
##
## See site gnuplot help guides via ???.
##
########################################################
"

   ##################################################################
   ## 95. Set $PLOT_HEAD --- to use below in the output-type sections
   ##     (png/jpg/gif, ps, svg) to build the file OUTLIST_PLOTCMDS:
   ##################################################################

GNUPLOT_VERSION=`gnuplot --version`
HOST_ID="`hostname`

   PLOT_HEAD="\
## THIS IS A FILE OF COMMANDS for 'gnuplot' .
## Version $GNUPLOT_VERSION is on this host, $HOST_ID .
##
## The gnuplot commands were created by the script:
## $0
##
## ---
##
## The older 'gnuplot 3.5' does not have the PNG image-file output
## option, and it does not have many enhancements that are available in 3.7
## and later releases.
##########################################################################
## Commands for GNUPLOT start here:
##########################################################################"


   ###############################################################
   ## 100.1. START of the 'ps' (postscript) commands output section:
   ###############################################################

   if test "$PLOT_OUTPUT_OPT" = "ps"
   then
 
      ## FOR TESTING:
      #  set -x

      PSOUTFILE="$DIR_WORK/gnuplot.ps"
      PSVIEWER="evince"

      echo "\
$PLOT_HEAD
##
## 
## Set CWD.  gnuplot may put 'extra' files here.
## 
cd \"$DIR_WORK\"
##
##
## Setup for Postscript plot:
##
set output \"$PSOUTFILE\"
set terminal postscript 
##
$PLOT_BODY
##
##
## View/Print Postscript plot:
##
## ! $PSVIEWER \"$PSOUTFILE\"
" >> $OUTLIST_PLOTCMDS
 
# ! $FEDIR/scripts/xlpps -q \"$PSOUTFILE\"

      ## FOR TESTING:
      #  set -

   fi
   ## END OF     if test "$PLOT_OUTPUT_OPT" = "ps"


   ###########################################################
   ## 100.2. START of the 'png/jpg/gif' commands output section:
   ###########################################################

   if test "$PLOT_OUTPUT_OPT" = "png" -o \
           "$PLOT_OUTPUT_OPT" = "jpg" -o \
           "$PLOT_OUTPUT_OPT" = "gif"
   then

      ## FOR TESTING:
      #  set -x

      IMGOUTFILE="$DIR_WORK/gnuplot.$PLOT_OUTPUT_OPT"
      IMGVIEWER="eog"

      echo "\
$PLOT_HEAD
##
## 
## Set CWD.  gnuplot may put 'extra' files here.
## 
cd \"$DIR_WORK\"
##
##
## Setup for $PLOT_OUTPUT_OPT plot:
## 
set output \"$IMGOUTFILE\"
set terminal $PLOT_OUTPUT_OPT size ${SIZEX}, $SIZEY
##
$PLOT_BODY
##
##
## View the image plot:
## 
## ! $IMGVIEWER  \"$IMGOUTFILE\"
" > $OUTLIST_PLOTCMDS

      ## FOR TESTING:
      #  set -

   fi
   ## END OF  "$PLOT_OUTPUT_OPT" = "png" ... "jpg" ... "gif"


   ###############################################################
   ## 100.3. START of the 'svg' commands output section:
   ###############################################################

   if test "$PLOT_OUTPUT_OPT" = "svg"
   then
 
      ## FOR TESTING:
      #  set -x

      SVGOUTFILE="$DIR_WORK/gnuplot.svg"
      SVGVIEWER="inkscape"

      echo "\
$PLOT_HEAD
##
## 
## Set CWD.  gnuplot may put 'extra' files here.
## 
cd \"$DIR_WORK\"
##
##
## Setup for SVG plot:
##
set output \"$SVGOUTFILE\"
set terminal svg size ${SIZEX}, $SIZEY
##
$PLOT_BODY
##
##
## View/Print SVG plot:
##
## ! $SVGVIEWER \"$SVGOUTFILE\"
" >> $OUTLIST_PLOTCMDS

      ## FOR TESTING:
      #  set -

   fi
   ## END OF     if test "$PLOT_OUTPUT_OPT" = "svg"



   ####################### HERE'S THE GNUPLOT CMD ####################
   ###################################################################
   ## 300. PLOT THE $OUTLIST_PLOTCMDS FILE, with gnuplot.
   ###################################################################
   ## OLD 3.5 command:
   ## $FEDIR/doc_tools/gnuplot_ideas.dir/gnuplot_startup.scr \
   ##                       $OUTLIST_PLOTCMDS &
   ###################################################################
   ## OLD 3.7 command:
   ## $FEDIR/doc_tools/gnuplot3.7.dir/gnuplot3.7_startup.scr \
   ##                       $OUTLIST_PLOTCMDS  2>  $OUTLIST_PLOTMSGS
   ###################################################################
   ###################################################################

   gnuplot $OUTLIST_PLOTCMDS  2>  $OUTLIST_PLOTMSGS
 

   ###################################################################
   ## 400.1. If the PNG/JPG/GIF output file exists and is non-empty,
   ##       and one was requested, show it.
   ###################################################################

   if test -s "$IMGOUTFILE" -a \( "$PLOT_OUTPUT_OPT" = "png" -o \
           "$PLOT_OUTPUT_OPT" = "jpg" -o "$PLOT_OUTPUT_OPT" = "gif" \)
   then
      $IMGVIEWER "$IMGOUTFILE"

      ###################################################################
      ## PopUp a window to show the name of the gnuplot image file ---
      ###################################################################
      ## png or jpg or gif. Uses 'zenity'.
      ###################################################################

      zenity  --info --title "gnuplot PlotFile Location - INFO" \
          --text  "\
The image file is in  $IMGOUTFILE 

You can move the file from there, if you want to use it
--- say, in a web page or in an archive directory.
" &

   fi


   ###################################################################
   ## 400.2. If the PS  output file exists and is non-empty, and one
   ##        was requested,show it.
   ###################################################################

   if test -s "$PSOUTFILE" -a "$PLOT_OUTPUT_OPT" = "ps"
   then
      $PSVIEWER "$PSOUTFILE"

      ###################################################################
      ## PopUp a window to show the name of the gnuplot PS file.
      ###################################################################
      ## Uses 'zenity'.
      ###################################################################

      zenity  --info --title "gnuplot Plot - INFO" \
          --text  "\
The Postscript file is in  $PSOUTFILE .
You can move the file from there, if you want to use it
--- say, in a web page or in an archive directory.
" &


   fi


   ###################################################################
   ## 400.3. If the SVG  output file exists and is non-empty, and one
   ##        was requested,show it.
   ###################################################################

   if test -s "$SVGOUTFILE" -a "$PLOT_OUTPUT_OPT" = "svg"
   then
      $SVGVIEWER "$SVGOUTFILE"

      ###################################################################
      ## PopUp a window to show the name of the gnuplot SVG file.
      ###################################################################
      ## Uses 'zenity'.
      ###################################################################

      zenity  --info --title "gnuplot Plot - INFO" \
          --text  "\
The SVG file is in  $SVGOUTFILE .
You can move the file from there, if you want to use it
--- say, in a web page or in an archive directory.
" &


   fi


   ###################################################################
   ## 500. SHOW/PRINT the gnuplot messages file ---
   ##      $OUTLIST_PLOTMSGS --- if it is non-empty.
   ###################################################################

   if test -s "$OUTLIST_PLOTMSGS"
   then
      $TXTVIEWER  "$OUTLIST_PLOTMSGS"
      sleep 5
   fi


   ###################################################################
   ## 600. SHOW/PRINT the gnuplot commands file --- $OUTLIST_PLOTCMDS
   ##      if the user wants to see it.
   ###################################################################

  zenity  --question --title "View the plot commands fed to gnuplot?" \
          --text  "\
Do you want to see the gnuplot commands file
that was fed to the 'gnuplot' command?

File: $OUTLIST_PLOTCMDS

in Directory: $CURDIR

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
     $TXTVIEWER "$OUTLIST_PLOTCMDS"
     sleep 5
  fi 


  ####################################################################
  ## 700. A zenity OK/Cancel prompt for 'Another plot with this data?'.
  ####################################################################

   # sleep 6

  zenity  --question --title "Another plot?" \
          --text  "\
Do you want to edit the gnuplot parameters file
of this utility, again, for ANOTHER PLOT
iteration on the (default) data file?

   $PLOT_DATAFILE

Parameters file: $PARAMSFILE

in Directory: $CURDIR

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
   ## RETURN TO PLOT-DATAFILE-and-PLOT-PARMS PROMPT.
   ########################################################################

done
## END of while loop, prompting for plot parms.
