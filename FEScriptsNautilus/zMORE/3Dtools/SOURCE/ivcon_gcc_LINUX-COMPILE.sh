#!/bin/bash
#

set -x

g++ -c ivcon.C >& compiler.txt

if test $? != 0 
then
  echo "Errors compiling ivcon.C"
  exit
fi

rm compiler.txt

g++ ivcon.o -lm

if test $? != 0
then
  echo "Errors linking and loading ivcon.o"
  exit
fi

rm ivcon.o

chmod ugo+x a.out

## mv a.out ~/bincpp/$ARCH/ivcon
##
## echo "Executable installed as ~/bincpp/$ARCH/ivcon"

echo "Executable is in a.out --- ready to test."

