#!/bin/sh
##
## SCRIPT: htm00_multi-img-files_small-img-TableCELLS_NperRow_echo_for-loop.sh
##
## PURPOSE: Generate an HTML file showing small (less than 160 pixels high/wide)
##          image files IN ROWS down the page --- in table rows, N cells per row
##          --- using the selected image files ('.jpg' , '.gif' or whatever).
##
## METHOD:  Uses 'zenity --entry' to prompt for N (the number of cells per row).
##
##          Uses 'echo' to generate the lines of the HTML file.
##
##          This script shows the HTML file in an html-viewer of the user's choice
##          ($HTMLVIEWER), and puts the user in edit mode on the HTML file
##          using a text-editor of the user's choice ($TEXTEDITOR).
##
## HOW TO USE: In Nautilus, select one or more image files in a directory.
##             Then right-click and select this script to run (name above).
##
##             This script puts the '.htm' HTML file in the directory
##             with the image files.
##              
#############################################################################
## Started: 2011nov21 Based on 00_GENpage_thumbTableCells_SELimgFiles_NperRow.sh
## Changed: 2012may14 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (show statements as they execute)
#  set -x


##################################################
## Set the HTMLVIEWER and TXTEDITOR env vars. 
##################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi


##################################################
## Get N, the number of image-cells per row. 
##################################################

CELLSperROW=""

CELLSperROW=$(zenity --entry \
   --title "N - number of image-cells per row" \
   --text "\
ENTER the desired NUMBER of image-cells PER ROW :
      Typically use 4, 5, or 6 --- depending on the 'small' image sizes.

A '.htm' file will be created in the current directory ---
and it will be shown in an HTMLVIEWER: $HTMLVIEWER
and it will be shown in a TXTEDITOR: $TXTEDITOR" \
   --entry-text "6")

if test "$CELLSperROW" = ""
then
   exit
fi


###################################
## Set the HTML output file name.
###################################

HTMFILE="00_temp_imgTableCells_smallImages_${CELLSperROW}perRow.htm"

if test -f "$HTMFILE"
then
   rm "$HTMFILE"
fi


#####################################################
## Put the (skeleton) 'head', 'title', and 'intro'
## sections in the HTML file.
#####################################################

echo "

<!-- This file is for
     .../WebPics/xxxxxx/xxxxxx/xxxxxx/
         xxxxxx.htm
-->

<html>

<!-- 
<meta name=\"robots\" content=\"noindex, nofollow\">
-->

<meta name=\"description\" content=\"
\">

<meta name=\"keywords\" content=\"
\">

<head>

<title>
Title Goes Here
</title>

</head>

<!-- ############################################################ -->
<!-- #########     END of HEAD.   START of BODY.    ############# -->
<!-- ############################################################ -->

<body background=\"./tiles/tile_ripple_gray_320x200.jpg\"
      bgcolor=\"#ccccff\"
      style=\"margin-top:0px;margin-left:0px;margin-right:0px\">

<a name=\"above_TOP\"></a>


<!-- ############################################################ -->
<!-- ##########   START of TITLE BLOCK SECTION     ############## -->
<!-- ############################################################ -->

<table align=\"center\" border=\"3\" cellpadding=\"9\" cellspacing=\"0\"
       width=\"100%\">
<tr>

<!--
<td align=\"left\" bgcolor=\"#ffffff\" style=\"border-style: none\">
<a
onmouseover=\"document['picpair0'].src='./decopics/'\"; 
onmouseout=\"document['picpair0'].src='./decopics/'\";
>
<img name=\"picpair0\" src=\"./decopics/\">
</a>
</td>
-->

<td align=\"center\" bgcolor=\"#ffffff\" style=\"border-style: none\">
<h1 align=\"center\">
Title Goes Here
</h1>
<h3 align=\"center\">
subtitle goes here
</h3>
</td>

<!--
<td align=\"right\" bgcolor=\"#ffffff\" style=\"border-style: none\">
<a
onmouseover=\"document['picpair1'].src='./decopics/'\"; 
onmouseout=\"document['picpair1'].src='./decopics/'\";
>
<img name=\"picpair1\" src=\"./decopics/\">
</a>
</td>
-->

</tr>
</table>

<!-- ############################################################ -->
<!-- ##########     END of TITLE BLOCK SECTION     ############## -->
<!-- ############################################################ -->


<!-- ############################################################ -->
<!-- ##########     START OF INTRO SECTION     ################## -->
<!-- ############################################################ -->

<p align=\"center\">
<table border=\"3\" cellpadding=\"9\" cellspacing=\"0\" width=\"80%\"
       bgcolor=\"#ececec\">
<tr>
<td>

<p align=\"justify\">
To download an image, you can right-click on an image and use an option
like 'Save Image As ...' in the popup menu of your web browser. 

</td>
</tr>
</table>

<!-- ############################################################ -->
<!-- ##########       END OF INTRO SECTION     ################## -->
<!-- ############################################################ -->


<!-- ############################################################ -->
<!-- #########        START OF IMAGES SECTION.         ########## -->
<!-- ############################################################ -->

<a name=\"above_IMAGES\"></a>

<ul>
<p>
<b>START of IMAGES :</b>
</ul>

<p align=\"center\">
<table border=\"3\" cellpadding=\"9\" cellspacing=\"0\" width=\"85%\"
       bgcolor=\"#ececec\">
" > "$HTMFILE"



#########################################
## START THE LOOP on the filenames.
#########################################

FILECNT=0
ROWCNT=0

for FILENAME
do

   FILECNT=`expr $FILECNT + 1`

   ROWID="&nbsp;"

   ####################################################################
   ## IF AT START of ROW, set ROWCNT and ROWID and
   ## write start-of-row HTML indicators (row-number-comment and <tr>).
   ####################################################################

   if test `expr $FILECNT % $CELLSperROW` = 1
   then
       
       ROWCNT=`expr $ROWCNT + 1`
       ROWID="row $ROWCNT"
   
       echo "
<!-- ######################### ROW $ROWCNT ####################### -->

<tr>" >>  "$HTMFILE"


   fi
   

   ######################################################
   ## Crop suffix (like '.jpg' or '.gif') from filename,
   ## for use in naming the '_thumb.jpg' files.
   ##   (Assumes only one dot, at extension in filename.)
   ######################################################

   # FILENAMECROP=`echo "$FILENAME" | sed 's|\.jpg$||'`
   # FILENAMECROP=`echo "$FILENAME" | sed 's|\.jpg$||' | sed 's|\.gif$||'`
   
   # FILENAMECROP=`echo "$FILENAME" | sed 's|\..*$||'`

   ###################################
   ## Write out table cell definition.
   ###################################

   echo "
<td align=\"center\">
<img src=\"./$FILENAME\"></a>
<br>
$ROWID
</td>" >>  "$HTMFILE"

   ###############################################################
   ## IF exactly AT END OF ROW, write out table-row-end indicator.
   ###############################################################

   if test `expr $FILECNT % $CELLSperROW` = 0
   then
       
       echo "
</tr>
" >>  "$HTMFILE" 

   fi

done

########################################################
########################################################
## END OF FILES LOOP. Write out bottom of the HTML file.
########################################################
########################################################

################################################
## Write out remaining cells (empty, if any)
## in the last row.
################################################

if test `expr $FILECNT % $CELLSperROW` != 0
then

  while test `expr $FILECNT % $CELLSperROW` != 0
  do
   
    echo "
<td align=\"center\">
&nbsp;
<br>
&nbsp;
</td>" >>  "$HTMFILE"

    FILECNT=`expr $FILECNT + 1`

  done
        
  echo "
</tr>
" >>  "$HTMFILE"

fi


###################################################
## After writing out remaining cells (empty, if any)
## in the last row, write the bottom-of-page block.
###################################################

echo "
</table>

<!-- ################################################### -->
<!-- ########## BOTTOM OF PAGE.  END of BODY. ########## -->
<!-- ################################################### -->

<p align=\"center\" style=\"page-break-before: always\">
<table border=\"3\" cellpadding=\"9\" cellspacing=\"0\" width=\"65%\">
<tr>
<td bgcolor=\"#cccccc\">

<p align=\"justify\">
<b>Bottom</b> of the <b>Title Goes Here</b> page.

<p>
To return to a previously visited web page location, click on the<br>
Back button of your web browser, a sufficient number of times.<br>
OR, use the History-list option of your web browser.<br>
OR ...

<p>
<h5 align=\"center\">
<a href=\"#above_IMAGES\">&lt; Go to Start of Images, above. &gt;</a><br>
<a href=\"#above_TOP\">&lt; Go to Top of Page, above. &gt;</a><br>
</h5>

<p>
Page created 2010 xxx 00.

</tr>
</td>
</table>


<!--
<p align=\"center\">
<img src=\"./decopics/yyyyyyyy.jpg\">
-->


</body>
</html>
" >>  "$HTMFILE"


###################################
## SHOW HTML FILE in a web browser.
###################################

$HTMLVIEWER "$HTMFILE" &


##################################
## Put HTML FILE in a text editor.
##################################

$TXTEDITOR "$HTMFILE"
