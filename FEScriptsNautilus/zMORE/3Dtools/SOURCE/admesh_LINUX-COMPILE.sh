#! /bin/sh
##
## SCRIPT: admesh_LINUX-COMPILE.sh
##
## PURPOSE: To build admesh 0.95
##
## Created: 2011jan27
## Updated: 

## Show cmds as they execute.
set -x

# OBJS = admesh.o connect.o stl_io.o stlinit.o util.o normals.o shared.o

OBJMIDNAMES="admesh
connect
getopt
getopt1
normals
shared
stl_io
stlinit
util"

for OBJMIDNAME in $OBJMIDNAMES
do
   gcc -c ${OBJMIDNAME}.c \
        -I. \
        -o ${OBJMIDNAME}.o
done 

gcc -g -o admesh  -O2 -Wall  -lm \
    admesh.o connect.o getopt.o getopt1.o normals.o \
    shared.o stl_io.o stlinit.o util.o

## REMOVED:
#   -O                 // Redundant, with -O2?
#   -Wno-implicit      // I want to see implicit errors.

## To clean:
##	rm -f $(OBJ) admesh core admesh.core core.admesh
##	rm -f config.h config.log config.status\
##	      config.cache Makefile

