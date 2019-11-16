#include <stdio.h>

int part1(FILE *input) {
    int floor = 0;
    char c;
    while ((c = fgetc(input)) != EOF) {
        switch(c) {
        case '(': floor++; break;
        case ')': floor--; break;
        default: break;
        }
    }
    return floor;
}

int part2(FILE *input) {
    int floor = 0;
    int pos   = 0;
    char c;
    while ((c = fgetc(input)) != EOF) {
        pos++;
        switch(c) {
        case '(': floor++; break;
        case ')': floor--; break;
        default: break;
        }

        if (floor < 0)
            printf("%d\n", pos);
    }
    return pos;
}

int main(void) {
    FILE *input = fopen("input", "r");
    printf("Part 1: %d\n", part1(input));
    printf("Part 2: %d\n", part2(input));
    fclose(input);
    return 0;
}
