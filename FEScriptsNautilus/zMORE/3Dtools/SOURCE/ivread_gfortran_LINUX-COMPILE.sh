#!/bin/bash
#

FILEIN="ivread.f90"

set -x

gfortran $FILEIN

if test $? != 0 
then
  set -
  echo "Errors compiling $FILEIN"
  exit
fi

chmod ugo+x a.out

echo "Executable is in a.out --- ready to test."

