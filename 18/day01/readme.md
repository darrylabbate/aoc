# [Day 1: Chronal Calibration](https://adventofcode.com/2018/day/1)

Originally I wrote my solution in C (which I've left up), but I've since decided to try and solve these puzzles using AWK.

## Part 1

```bash
$ awk '{f+=$0} END{print f}' input
```

## Part 2

```awk
{ freq[NR] = $1 } 

END { 
  while (1) {
    for (change in freq) {
      current += freq[change]
      if (prev[current]++ > 0) { 
        print current
        exit 
      }
    }
  }
}
```
```bash
$ awk -f part2.awk < input
```
