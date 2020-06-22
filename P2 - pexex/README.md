# Project 2 - Program Execution Explorer

**Project Description**

Use GDB to examine a program's execution history and manually trace the effect of assembly-language instructions on memory and registers.

Compile a given function into assembly using different compilation flags and analyze how they affect the differences in the machine level instructions as they relate to integer overflow.

**Description of Files**

pexexlab.txt

- A lab-log file containing detailed steps taken to arrive at my answers.

gen-commands.sh

- Learning Assistant-provided shell script automating trace generation.

 trace_raw.tr

- The raw, unedited gdb trace file from part 1.

trace.tr

- Part 1 trace file containing the required memory and register annotations.

mem_changelog.txt

- Scratch file I used to note the memory and register changes, subsequently concatenating it columnally to the raw trace.

testovf.txt

- Comparison between the assembly instructions resulting from compilation differences in part 2.

answers.txt

- Answers to the 4 extension questions concerning how Emacs handles integer overflow in part 1.