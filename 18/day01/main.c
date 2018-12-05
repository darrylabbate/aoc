#include <stdio.h>
#include <stdlib.h>

#define SIZE 10

int find_freq(FILE *input)
{
  int freq = 0;
  char change[SIZE];
  while(fgets(change, SIZE, input) != NULL)
    freq += atoi(change);
  return freq;
}

int find_repeat_freq(FILE *input)
{
  int freq = 0;
  int hist[200000];
  char change[SIZE];
  int i = 0;
  while (i < 200000) {
    rewind(input);
    while (fgets(change, SIZE, input)) {
      hist[i] = freq;
      freq += atoi(change);
      int j;
      for(j = i+1; j >= 0; j--)
        if (freq == hist[j])
          return freq;
    i++;
    }
  }
  return freq;
}

int main(void)
{
  FILE *input = fopen("input", "r");
  printf("Part 1: %d\n", find_freq(input));
  printf("Part 2: %d\n", find_repeat_freq(input));
  return 0;
}
