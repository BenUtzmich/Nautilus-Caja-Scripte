#!/bin/csh
#
g++ -c ivcon.C >& compiler.txt
if ( $status != 0 ) then
  echo "Errors compiling ivcon.C"
  exit
endif
rm compiler.txt
#
g++ ivcon.o -lm
if ( $status != 0 ) then
  ercho "Errors linking and loading ivcon.o"
  exit
endif
#
rm ivcon.o
#
chmod ugo+x a.out
mv a.out ~/bincpp/$ARCH/ivcon
#
echo "Executable installed as ~/bincpp/$ARCH/ivcon"
