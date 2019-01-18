#!/bin/csh
#
F90 -c -g ivread.f90 >& compiler.txt
if ( $status != 0 ) then
  echo "Errors compiling ivread.f90"
  exit
endif
rm compiler.txt
#
F90 ivread.o
if ( $status != 0 ) then
  echo "Errors linking and loading ivread.o"
  exit
endif
#
rm ivread.o
#
chmod ugo+x a.out
mv a.out ~/bin/$ARCH/ivread
#
echo "Executable installed as ~/bin/$ARCH/ivread"
