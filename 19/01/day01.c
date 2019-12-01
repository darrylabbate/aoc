#include <stdio.h>

int part1(FILE *input) {
    int req = 0;
    rewind(input);
}

// int part2(FILE *input) {
// }

int main(void) {
    FILE *input = fopen("input", "r");
    printf("Part 1: %d\n", part1(input));
    // printf("Part 2: %d\n", part2(input));
    return 0;
}
