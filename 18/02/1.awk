BEGIN {
    FS = ""
}

{
    for (i = 1; i <= NF; i++)
        n[$i]++
    for (i in n) {
        if (n[i] == 2) has2[NR] = 1
        if (n[i] == 3) has3[NR] = 1
    }
    n2 += has2[NR]
    n3 += has3[NR]
    for (i = 1; i <= NF; i++)
        n[$i] = 0
}

END {
    print n2 * n3
}
