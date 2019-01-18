#!/bin/sh
##
## Nautilus
## SCRIPT: .bc_calcline.sh
##
## PURPOSE: Calculates formulas entered by user ... line by line.
##
## CALLED BY: The Nautilus script '00_bc_calc_inXterm.sh' which
##            executes this command in a Xterm with the '-hold' option.
##
## MAINTENANCE HISTORY:
## Created: 1995jun08 on SGI-IRIX
## Changed: 2010may27 Changed to execute as a Nautilus script on Linux.

####################################################
## Set variables to be used to control text-terminal
## high-lighting.
####################################################

HIbold='[1m'
HIdim='[2m'
HIreset='[m'

# HIdimul='[2;4m'  
# HIdimrv='[2;7m'


################################################
## Show examples of how this calculator is used.
## Then wait for user input.
################################################

echo "\
.............................................................................
${HIbold}calcAline:   Calculate expressions entered ... line by line.

     EXAMPLES:${HIreset}
                (30 * 3.1 + 25.7) / 83.2   ${HIdim}OR${HIreset}   (30*3.1+25.7)/83.2 
                4^3    
                sqrt(83)    
                c(3.14159)             [ the cosine of pi ]
                4.0 * a(1)             [ a(1) = arctan 1 = pi/4 ]
                s(4.0 * a(1))          [ sine of pi ]
                3.0 * e(-2.5 * 1.1)
                l(e(1))                [ the natural log of e, which is one ]
                scale=0;4%3
                scale = 0 ; 3 % 4  
${HIdim}
     Command used:   echo 'scale = 10; <expression>' | bc -l
${HIbold}
                   Categories of  'bc' OPERATORS: 
                   -------------  ----------------------------------------------
                   Arithmetic:    +   -   *   /      ^            %
                                                    (^ is power ; % is remainder)
                   Functions:     sqrt(x)    square root
                                  s(x)       sine
                                  c(x)       cosine
                                  e(x)       exponential
                                  l(x)       log
                                  a(x)       arctangent
                   Comparison:    ==   <=   >=   !=    <    >
                   Assignment:    =    =+   =-   =*    =/   =%    =^
                   Concatenate:   ++   --   (prefix and postfix; apply to names)
${HIbold}
     NOTE: You may mouse-paste input or results from previous lines at the
           current prompt.  Try pasting the examples above (or parts of them).
${HIreset}
............................................................................"                                                 

#########################################################################
## Here is the prompting loop that waits for line-by-line of user input.
## A null entry exits the loop.
#########################################################################

xpress="something"
while test ! "${xpress}" = ""
do 

   echo "                                                 
${HIbold}Enter an expression. ==>${HIreset} \c"
read xpress

   if test "${xpress}" = ""
   then
      echo "
If you want to exit, make a null entry again.
Otherwise, enter an expression  ==>${HIreset} \c"
      read xpress
      if test "${xpress}" = ""
      then
         exit
      fi
   fi

   ## FOR TESTING:
   #  set -x
 
   echo "scale = 10; $xpress" | bc -l

   ## FOR TESTING:
   #  set -

done
## END of prompting loop.

