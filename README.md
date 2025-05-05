## Todolist

I am in a dark place in my life currently and decided to write a todolist app using nasm 64. Turns out, I didn't want this level of darkness. Twilight is fine.

Anyways, the nasm64 code, todolist.asm is my first nasm project. It runs on linux and the bash script (run.sh) is used to assemble and link the program.

The todolist.asm performs the 'crud' and exit operations.
The 'u' or update, writes all characters to a new file called temp.txt and adds the modified line then continues writing.
The files are closed and the temp.txt is renamed as todolist.txt and the initial todolist.txt is deleted.
The same idea goes for the delete.

The nasm program probably can be optimized. Any suggestions and requests will be greatly appreciated. 


## Toggle

Toggle.asm aims to toggle elements of a string into its upperCase or lowerCase. For example, input is 'Hello World', then the output is 'hELLO wORLD'
The nasm code accepts user input, then runs through the user input element by element until a newline character is met then exit. As it runs through the alphabets are toggled and other characters
remain the same. 
I hope project helps out another beginner like myself.

## TempConverter
TempConverter aims to convert between Celsius and Fahrenheit. The nasm code takes two inputs. The first being the temperature, and the second is whether or not to convert to celsius or fahrenheit.
When (c) (where c is celsius) is the input for the second prompt, then it is assumed that the initial temperature prompt's value is the temperature in fahrenheit. Then the code calculates accordingly.

## Reverse command line argument
The reverse command line argument is my first nasm project using command line arguments. run.sh is used to assemble and link the program. To run the program, type "program argv1" eg. ./reversecmdarg hello.
The output is 'olleh' , a reverse of the command line argument.

## Stackbased
This program aims to push (see what I did there) my understanding of stack through the polish notation. Use 'run.sh ./stackbased' to assemble and link the program and './stackbased' to run the program. If one wishes to solve (5 + 4) * 3, then one inputs, 5 4 + 3 * . A counter runs through all bytes or characters present and places them on a stack for computation. Division by zero has also been accounted for. I hope you like this project.

## Macros
Apparently macros make your life much easier. For example, instead of writing the following for print everytime
mov rax, 1
mov rdi, 1
mov rsi, SomeVariable
mov rdx, lengthOfSomeVariable
syscall
We can simply use macros and make the call to the nasm 64 code using '%include "mymacros.inc" '. Think of it like header files in C or some libraries/modules in Python that need to be called

## Palindrome
What is a palindrome? A palindrome refers to a string or a word (not meant as a discrete unit) whose reverse is the same as the word. For example, "madam" when reversed is "madam". Likewise "racecar", "rotator" But not "hello", "computer" etc. 
The Palindrome nasm code takes the string as input, find its length, subtract two from the length (why? because of the newline and null-terminator). This length is stored in say register 'A' and register 'B' is also initialized from zero. So as 'A' decreases, 'B' increases and the corresponding stringelement should be the same. Think of it like "string[i] == string[j]" in python

## Factorial

## Mod

