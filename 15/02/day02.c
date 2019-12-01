#include <stdio.h>

int part1(FILE *input) {
    rewind(input);
    char c;
    while (c = fgetc(input) != EOF) {
    }
}

int part2(FILE *input) {
    rewind(input);
    return 0;
}

int main(void) {
    FILE *input = fopen("input", "r");
    printf("Part 1: %d\n", part1(input));
    printf("Part 2: %d\n", part2(input));
    fclose(input);
    return 0;
}
