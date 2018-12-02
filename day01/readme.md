# [Day 1: Chronal Calibration](https://adventofcode.com/2018/day/1)

## Part One

This is pretty straightforward. I enjoyed reading all the simple solutions people used (including one guy who literally pasted his input into Google).

Here's a bash one-liner which worked for me on macOS 10.14:

```bash
$ bc <<< "0 $(paste -s input)"
```

My first solution was written in C. I poked around in the standard header files and found `atoi()` in `stdlib.h` and it worked perfectly:

```c
#include <stdio.h>
#include <stdlib.h>

#define SIZE 20

int find_freq(int starting_freq, FILE *input)
{
  int freq = starting_freq;
  char change[SIZE];
  while(fgets(change, SIZE, input) != NULL)
    freq += atoi(change);
  return freq;
}

int main(void)
{
  FILE *input;
  input = fopen("input", "r");
  printf("Part 1: %d\n", find_freq(0, input));
  return 0;
}
```
