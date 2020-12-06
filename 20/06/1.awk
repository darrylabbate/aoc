BEGIN { RS = ""; FS = "" }

{
    for (i = 1; i <= NF; ++i)
        if ($i ~ /[a-z]/)
            y[NR,$i]++
}

END {
    for (i in y)
        ++n
    print n
}
