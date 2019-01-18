#!/bin/sh
##
## SCRIPT: htm00_multi-movie-files_GENvidLinksDownHTMLpage_echo_for-loop.sh
##
## PURPOSE: Generate an HTML file with links to movie/video files down the page,
##          in table cells, using the selected video files 
##          ('.mpg' and/or '.wmv' and/or '.flv' and/or etc.).
##
## METHOD:  Builds the HTML page using the 'echo' command and the '>>'
##          concatenation operator.
##
##          In a 'for' loop on the user-selected filenames, links to
##          the movie files are put down the HTML page.
##
##          Shows the HTML file in $HTMLVIEWER (a web browser of the user's
##          choice), and brings up the HTML file in $TEXTEDITOR (a GUI
##          text editor of the user's choice).
##
##
## HOW TO USE: In Nautilus, select one or more movie/video files.
##             (Can use the Ctl or Shift keys to select multiple files.)
##             Then right-click and choose this script to run (name above).
##
##          This script puts the '.htm' HTML file in the directory
##          with the video files.
##
###########################################################################
## Started: 2011dec08
## Changed: 2012may24 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
##############################################################################

## FOR TESTING: (show statements as they execute)
# set -x


###################################
## Set the htm output file name.
###################################

  HTMFILE="00_temp_movieLinks_downPage.htm"
# HTMFILE="temp.htm"

if test -f "$HTMFILE"
then
   rm "$HTMFILE"
fi

#######################################
## Put the 'head', 'title', and 'intro'
## sections in the HTML file.
#######################################

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

<!-- ######### END of HEAD.   START of BODY. ############# -->

<body background=\"./tiles/tile_ripple_gray_320x200.jpg\"
      bgcolor=\"#ccccff\"
      style=\"margin-top:0px;margin-left:0px;margin-right:0px\">

<a name=\"above_TOP\"></a>

<!-- ######### TITLE BLOCK ############# -->

<table align=\"center\" border=\"3\" cellpadding=\"9\" cellspacing=\"0\"
       width=\"100%\">
<tr>

<td align=\"left\" bgcolor=\"#ffffff\" style=\"border-style: none\">
<a
onmouseover=\"document['picpair0'].src='./decopics/'\"; 
onmouseout=\"document['picpair0'].src='./decopics/'\";
>
<img name=\"picpair0\" src=\"./decopics/\">
</a>
</td>

<td align=\"center\" bgcolor=\"#ffffff\" style=\"border-style: none\">
<h1 align=\"center\">
Title Goes Here
</h1>
<h3 align=\"center\">
subtitle goes here
</h3>
</td>

<td align=\"right\" bgcolor=\"#ffffff\" style=\"border-style: none\">
<a
onmouseover=\"document['picpair1'].src='./decopics/'\"; 
onmouseout=\"document['picpair1'].src='./decopics/'\";
>
<img name=\"picpair1\" src=\"./decopics/\">
</a>
</td>

</tr>
</table>

<p align=\"center\">
A few more notes or links may be added.

<!-- ################### INTRODUCTION ########################## -->

<p align=\"center\">
<table border=\"3\" cellpadding=\"9\" cellspacing=\"0\" width=\"80%\"
       bgcolor=\"#ececec\">
<tr>
<td>

<p>
<b>Introduction :</b>

<p align=\"justify\">


</td>
</tr>
</table>

<!-- ############################################################ -->
<!-- ##########      END OF HEADING SECTION.   ################## -->
<!-- ############################################################ -->
<!-- ############################################################ -->
<!-- #########        START OF VIDEOS SECTION.         ########## -->
<!-- ############################################################ -->

<a name=\"above_VIDS\"></a>

<ul>
<p>
<b>START of VIDEOS :</b>
</ul>

<p align=\"center\">
<table border=\"3\" cellpadding=\"0\" cellspacing=\"0\" width=\"85%\"
       bgcolor=\"#ececec\" rules=\"none\">

<!-- ## FOR POSSIBLE FUTURE USE in table/tr/td. ##
       bordercolor=\"#666666\" 
       bordercolordark=\"#999999\"
       bordercolorlight=\"#333333\"
-->

<tr border=\"0\">
<td valign=\"middle\" border=\"0\">

" > "$HTMFILE"


###################################
## START THE LOOP on the filenames.
###################################

FILECNT=0

for FILENAME
do

   FILECNT=`expr $FILECNT + 1`
   
   # FILEEXT=`echo "$FILENAME" | cut -d'.' -f2`
   # if test "$FILEEXT" -ne "mpg" -a "$FILEEXT" -ne "flv" -a
   #         "$FILEEXT" -ne "wmv" -a "$FILEEXT" -ne "avi" -a
   #         "$FILEEXT" -ne "mp4" -a "$FILEEXT" -ne "mkv"
   # then
   #    continue
   # fi


   ########################################
   ## Write out video-display statement ---
   ## in a table cell.
   ########################################

   echo "
<!-- ######################### VIDEO $FILECNT ####################### -->

<p align=\"left\">
$FILECNT \
<a href=\"./$FILENAME\"
    title=\"$FILENAME\">
$FILENAME</a>


" >>  "$HTMFILE"

done
## END OF 'for FILENAME' loop.


####################################################
## END OF FILES LOOP. Write out bottom of HTML file.
####################################################

echo "

</td>
</tr>
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
<a href=\"#above_VIDS\">&lt; Go to Start of Videos, above. &gt;</a><br>
<a href=\"#above_TOP\">&lt; Go to Top of Page, above. &gt;</a><br>
</h5>

<p>
Page created 2011 xxx 00.

</tr>
</td>
</table>


<p align=\"center\">
<img src=\"./decopics/yyyyyyyy.jpg\">


</body>
</html>
" >>  "$HTMFILE"


###################################
## SHOW HTML FILE in a web browser.
###################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$HTMLVIEWER "$HTMFILE" &


##################################
## Put HTML FILE in a text editor.
##################################

$TEXTEDITOR "$HTMFILE"
