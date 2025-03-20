# Nasm64

I am in a dark place in my life currently and decided to write a todolist app using nasm 64. Turns out, I didn't want this level of darkness. Twilight is fine.

Anyways, the nasm64 code, todolist.asm is my first nasm project. It runs on linux and the bash script (run.sh) is used to assemble and link the program.

The todolist.asm performs the 'crud' and exit operations.
The 'u' or update, writes all characters to a new file called temp.txt and adds the modified line then continues writing.
The files are closed and the temp.txt is renamed as todolist.txt and the initial todolist.txt is deleted.
The same idea goes for the delete.

The nasm program probably can be optimized. Any suggestions and requests will be greatly appreciated. 
