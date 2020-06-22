# Project 4 - OpenMP Parallelization

**Project Description**

Given code that performs filtering algorithm on a media file, optimize the given code and extract parallelism from each function using OpenMP. The grade for this assignment is proportional to the amount of speedup achieved. For full credit, a 3.5× speedup must be attained. Extra credit will be awarded for speedup beyond that amount. To get any credit, the code must produce the same output as the original code. In addition, for each memory leak, the overall grade will be reduced by 1%. A memory leak is defined as a region of memory that was allocated but never freed.

The solution here reached a final speed of about 5x but was penalized heavily for inconsistent (incorrect) output that was mysteriously not visible to my student-privileged account when testing on the servers. According to the TA, this was due to not protecting certain variables when using the OpenMP library which caused race conditions. I ended up receiving partial credit back upon submitting a video showing that the correctness check had not flagged anything.

Of note, running a memory leak check on the solution will show a consistent few chunks that were never freed. These were apparently caused by the OpenMP library itself and was not something that an end-user could actively resolve, so these specific leaks were not penalized.

**Description of Files**

func.c

- The edited file containing my solution's OpenMP optimizations.

openmplab.txt

- A lab-log file containing the approach and detailed steps I took to achieve my solution.