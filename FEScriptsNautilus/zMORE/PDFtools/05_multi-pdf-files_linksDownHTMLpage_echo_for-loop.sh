#!/bin/sh
##
## SCRIPT: 00_multi-pdf-files_linksDownHTMLpage_echo_for-loop.sh
##
## PURPOSE: Generate an HTML file providing links to a set of
##          user-selected '.pdf' files in the current directory.
##
##          NOTE:
##          Many old texts, such as math texts from the 1800's, are
##          available on line via projects such as the Gutenberg project.
##
##          This utility makes it easy to make a collection of such
##          'ebooks' available via an HTML page.
##
## METHOD:  Uses the 'echo' command to build the HTML statments.
##
##          Shows the HTML file in HTML-viewer $HTMLVIEWER, and
##          starts-up the HTML file in the editor $TXTEDITOR.
##
##          $HTMLVIEWER and $TXTEDITOR can be set by the user.
##
##          This script puts the '.htm' HTML file in the directory
##          with the '.pdf' files.
##
## HOW TO USE: Using the Nautilus file manager, navigate to a
##             directory and select a set of '.pdf' files.
##             Right-click and choose this script to run (name above).
##
###########################################################################
## Script
## Created: 2012feb28 Based on a similar script in the 'IMAGEtools' group.
## Changed: 2012mar04 Put the <a ...>...</a> string on 2 lines.
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments.
#######################################################################

## FOR TESTING: (show statements as they execute)
# set -x


###################################
## Set the htm output file name.
###################################

# HTMFILE="temp.htm"
HTMFILE="00_temp_PDFfileLINKS_downThePage.htm"

if test -f "$HTMFILE"
then
   rm "$HTMFILE"
fi

#######################################
## Get the current directory.
#######################################

CURDIR="`pwd`"

#######################################
## Put the 'head', 'title', and 'intro'
## sections in the HTML file.
#######################################

echo "

<!-- This HTML code is for file
     ${CURDIR}/$HTMFILE
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
Title Goes Here - PDF Files
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
<!-- #################### START OF TITLE BLOCK ################## -->
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
Title Goes Here - PDF Files
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
<!-- ##########        END OF TITLE BLOCK      ################## -->
<!-- ############################################################ -->


<p align=\"center\">
More links may be added in the future.


<!-- ############################################################ -->
<!-- ###################  INTRODUCTION ########################## -->
<!-- ############################################################ -->

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
<!-- ##########      END OF INTRODUCTION SECTION.   ############# -->
<!-- ############################################################ -->

<!-- ############################################################ -->
<!-- #########        START OF PDF LINKS SECTION.        ######## -->
<!-- ############################################################ -->


<a name=\"above_PDFS\"></a>

<ul>
<p>
<b>START of PDF LINKS :</b>
</ul>

<p align=\"center\">
<table border=\"3\" cellpadding=\"9\" cellspacing=\"0\" width=\"85%\"
       bgcolor=\"#ececec\" rules=\"none\">
<tr>
<td>

<!-- ## FOR POSSIBLE FUTURE USE in table/tr/td. ##
       bordercolor=\"#666666\" 
       bordercolordark=\"#999999\"
       bordercolorlight=\"#333333\"
-->

<ul>
" > "$HTMFILE"


###################################
## START THE LOOP on the filenames.
###################################

FILECNT=0

for FILENAME
do

   FILECNT=`expr $FILECNT + 1`
   
   #############################################################
   ## Get the file extension and check that it is for a PDF file.
   ##   (Assumes one period in the filename, at the extension.)
   ## COMMENTED, for now.
   #############################################################

   # FILEEXT=`echo "$FILENAME" | cut -d'.' -f2`
   # if test "$FILEEXT" -ne "pdf" -a "$FILEEXT" -ne "PDF"
   # then
   #    continue
   # fi


   ################################################################
   ## Write out the line-item and anchor-link tags for the PDF file.
   ################################################################

   echo "
<li> <p align=\"justify\">
<a href=\"./$FILENAME\">
           $FILENAME</a>
" >>  "$HTMFILE"

done
## END OF LOOP: for FILENAME

####################################################
## END OF FILES LOOP. Write out bottom of HTML file.
####################################################

echo "
</ul>

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
<b>Bottom</b> of the <b>Title Goes Here - PDF Files</b> page.

<p>
To return to a previously visited web page location, click on the<br>
Back button of your web browser, a sufficient number of times.<br>
OR, use the History-list option of your web browser.<br>
OR ...

<p>
<h5 align=\"center\">
<a href=\"#above_PDFS\">&lt; Go to Start of PDF links, above. &gt;</a><br>
<a href=\"#above_TOP\">&lt; Go to Top of Page, above. &gt;</a><br>
</h5>

<p>
Page created 2012 xxx 00.

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

$TXTEDITOR "$HTMFILE"
