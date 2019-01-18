#!/bin/sh
##
## SCRIPT: htm00_multi-img-files_imgsDownHTMLpage_withsLink2larger_echo_for-loop.sh
##
## PURPOSE: Generate an HTML file showing image files down the page,
##          in table cells, one cell per row, using the selected image files
##          --- '.jpg', '.png', '.gif' or whatever files.
##
## METHOD:  The 'echo' command is used to put HTML statements in a '.htm' file.
##
##          This script shows the HTML file in an html-viewer of the user's choice
##          ($HTMLVIEWER), and puts the user in edit mode on the HTML file
##          using a text-editor of the user's choice ($TEXTEDITOR).
##
##          Under each image, there is to be a link to a larger version
##          of the image file shown. The larger version is in a subdirectory
##          with a name like 'images_MMMxNNN'. The images in that directory
##          have the same names as the selected files, but with a
##          '_XXXxYYY.jpg' suffix stripped and the '_MMMxNNN.jpg' suffix added,
##          where XXX, YYY, MMM, NNN are actual integers, not characters.
##
##          The 'MMMxNNN' *character* string in the subdirectory name
##          in the '.htm' file --- or the entire subdirectory name
##          'images_MMMxNNN' character string --- can be
##          globally changed in the text editor to match the subdirectory
##          name that is actually used.
##
##          Similarly the '_MMMxNNN.jpg' suffix in the linked-to filenames
##          can be globally changed in the text editor to match the name
##          actually used. That is, the characters 'MMMxNNN' can be changed
##          to two integers separated by the lower-case letter 'x'.
##
## HOW TO USE: In Nautilus, select one or more image files in a directory.
##             Then right-click and select this script to run (name above).
##
##          It is assumed that you have created a subdirectory, called
##          something like 'images_MMMxNNN', in the directory of
##          'main' (medium-sized) images. Typically, the 'images_MMMxNNN'
##          subdirectory would contain larger scale images of the 'medium-sized'
##          image files.
##
##          And it is assumed that the images in the 'images_MMMxNNN'
##          subdirectory have names with suffixes like '_MMMxNNN.jpg' ---
##          where MMMxNNN are the same two integers for all the 'larger scale'
##          image files.
##
##          Example:
##                    yada_yada_yada_700x550.jpg
##                          has a corresponding file
##           ./images_1600x1200/yada_yada_yada_1600x1200.jpg
##                          in the subdirectory 'images_1600x1200'
##           and
##                    wada_wada_wada_640x480.jpg
##                          has a corresponding file
##           ./images_1600x1200/wada_wada_wada_1600x1200.jpg
##                          in the subdirectory 'images_1600x1200'.
##
##          If necessary, edit any of the filenames in the '.htm' file
##          to work as intended.
##
##############################################################################
## Started: 2009aug18
## Updated: 2010jul21
## Updated: 2011apr12 Converted to a Nautilus script, to gather selected files.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012feb22 Changed the name of the script, above.
##                    Fixed the $TEXTEDITOR var to be $TXTEDITOR.
##                    Added 'target="_blank"' to the anchor-link lines.
## Changed: 2012may14 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x


###################################
## Set the htm output file name.
###################################

  HTMFILE="00_temp_imgCells_downPage_withLinks2largerImgs.htm"
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

<!-- ############################################################ -->
<!-- #########     END of HEAD.   START of BODY.    ############# -->
<!-- ############################################################ -->

<body background=\"./tiles/tile_ripple_gray_320x200.jpg\"
      bgcolor=\"#ccccff\"
      style=\"margin-top:0px;margin-left:0px;margin-right:0px\">

<a name=\"above_TOP\"></a>


<!-- ############################################################ -->
<!-- #########     START of TITLE BLOCK SECTION     ############# -->
<!-- ############################################################ -->

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

<!-- ############################################################ -->
<!-- #########       END of TITLE BLOCK SECTION     ############# -->
<!-- ############################################################ -->


<p align=\"center\">
A few more notes or links may be added.


<!-- ############################################################ -->
<!-- ##########    START OF INTRO SECTION.     ################## -->
<!-- ############################################################ -->

<p align=\"center\">
<table border=\"3\" cellpadding=\"9\" cellspacing=\"0\" width=\"80%\"
       bgcolor=\"#ececec\">
<tr>
<td>

<p>
<b>Introduction :</b>

<p align=\"justify\">
There is a link under each of the images below. Click on the link to
see a larger version of the smaller image.

</td>
</tr>
</table>

<!-- ############################################################ -->
<!-- ##########      END OF INTRO SECTION.     ################## -->
<!-- ############################################################ -->


<!-- ############################################################ -->
<!-- #########        START OF IMAGES SECTION.         ########## -->
<!-- ############################################################ -->

<a name=\"above_IMGS\"></a>

<ul>
<p>
<b>START of IMAGES :</b>
</ul>

<p align=\"center\">
<table border=\"3\" cellpadding=\"9\" cellspacing=\"0\" width=\"85%\"
       bgcolor=\"#ececec\">
" > "$HTMFILE"


###################################
## START THE LOOP on the filenames.
###################################

FILECNT=0

for FILENAME
do

   FILECNT=`expr $FILECNT + 1`

   ######################################################
   ## 'Crop' filename.
   ######################################################
   ## Strip off suffix like _123...x123..._yadayada.jpg
   ##                    OR _XXXxYYY_yadayada.jpg
   ##                    OR _XXXx123..._yadayada.jpg
   ######################################################
   
   # FILENAMECROP=`echo "$FILENAME" | sed 's|\.jpg$||'`
   # FILENAMECROP=`echo "$FILENAME" | sed 's|\.jpg$||' | sed 's|\.gif$||'`
   # FILENAMECROP=`echo "$FILENAME" | sed 's|_[0-9X][0-9X]*x[0-9Y][0-9Y]*.*\.jpg$||'`
 
   FILENAMECROP=`echo "$FILENAME" | sed 's|_[0-9X][0-9X]*x[0-9Y][0-9Y]*.*\..*$||'`

   ########################################
   ## Write out image-display statement ---
   ## in a table cell.
   ########################################

   echo "
   
   <!-- #############    IMAGE $FILECNT     ############## -->
   
<tr>
<td align=\"middle\">
<img src=\"./$FILENAME\"
     title=\"$FILENAME\">
<p align=\"center\">
<a href=\"./images_MMMxNNN/${FILENAMECROP}_MMMxNNN.jpg\"
 target="_blank">
MMMxNNN</a>
</td>
</tr>
" >>  "$HTMFILE"

done


####################################################
## END OF FILES LOOP. Write out bottom of HTML file.
####################################################

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
<a href=\"#above_IMGS\">&lt; Go to Start of Images, above. &gt;</a><br>
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


########################################################
## SHOW HTML FILE in a web browser of the user's choice.
########################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$HTMLVIEWER "$HTMFILE" &


#########################################################
## Put HTML FILE in a text editor of the user's choice.
#########################################################

$TXTEDITOR "$HTMFILE"
