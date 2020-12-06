BEGIN { RS = ""; FS = "" }

{
    p = 1
    for (i = 1; i <= NF; ++i) {
        if ($i ~ /[a-z]/)
            y[NR,$i]++
        p += $i ~ "\n"
    } for (i = 1; i <= NF; ++i) {
        n += y[NR,$i] == p
        y[NR,$i] = 0
    }
}

END { print n }
