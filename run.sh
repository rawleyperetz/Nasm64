#!/bin/bash
# Simple assemble/link script

if [ -z $1 ]; then 
  echo "Usage: ./asm 64 <asmMainFile> (no extension)"
  exit
fi 

# Verify no extensions were entered

if [ ! -e "$1.asm" ]; then 
  echo "Error, $1.asm not found."
  echo "Note, do not enter file extensions."
  exit 
fi 

# Compile, assemble, and link 

output="$(cat $1.asm | grep extern)"


nasm -f elf64 -g -F dwarf $1.asm -o $1.o

if [[ -n $output ]]; then
  ld $1.o -o $1 -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2
else
  ld -o $1 $1.o
fi

chmod 744 $1
