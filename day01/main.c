#include <stdbool.h>
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
