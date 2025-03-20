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

#nasm -f elf64 -g -Wall $1.asm 
#ld -m elf_x86_64 -s -o $1 $1.o

nasm -f elf64 -g -F dwarf $1.asm -o $1.o
ld -o $1 $1.o


chmod 744 $1
