#include <stdio.h>

#define SIZE 32

int char_count(char *id, char c)
{
  int count = 0;
  while(*id)
    if(*(id++) == c)
      count++;
  return count;
}

int quick_checksum(FILE *input)
{
  char box_id[SIZE];
  char c;
  int has2, n2 = 0;
  int has3, n3 = 0;
  int cm;

  while (fgets(box_id, SIZE, input) != NULL) {
    has2 = 0;
    has3 = 0;
    for (c = 'a'; c <= 'z'; c++) {
      cm = char_count(box_id, c);
      if      (cm >= 3) has3 = 1;
      else if (cm == 2) has2 = 1;
    }
    if (has2) n2++;
    if (has3) n3++;
  }
  return n2 * n3;
}

int main(void)
{
  FILE *input = fopen("input", "r");
  printf("Part 1: %d\n", quick_checksum(input));
  return 0;
}
