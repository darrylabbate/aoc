BEGIN { FS = "" }

{ a[NR] = $0 }

END {
    printf "%.f\n", t(1,1) * t(3,1) * t(5,1) * t(7,1) * t(1,2)
}

function t(r,d,   i,j,n) {
    i = 1
    while (i <= NR) {
        n += substr(a[i],(j%NF)+1,1) ~ "#"
        i += d
        j += r
    }
    return n
}
