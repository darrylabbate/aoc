BEGIN { FS="[ \-:]*" }

{
    for (i = 1; i < length($4) + 1; ++i)
        a[NR,substr($4, i, 1)]++
    if (a[NR,$3] <= $2 && a[NR,$3] >= $1)
        n++
}

END { print n }
