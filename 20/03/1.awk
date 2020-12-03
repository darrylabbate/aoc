BEGIN { FS = "" }

{ a[NR] = $0 }

END {
    while (++i <= NR) {
        n += substr(a[i],(j%NF)+1,1) ~ "#"
        j += 3
    }
    print n
}
