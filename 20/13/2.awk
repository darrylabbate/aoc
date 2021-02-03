BEGIN { FS = "," }

NF>1 {
    for (i = 1; i <= NF; ++i) {
        if ($i ~ /[0-9]/) {
            itvl[$i] = i-1
            bus[++j] = $i
        }
    }
    t = bus[1]
    s = 1
    while (s) {
        s = 0
        for (j in bus) {
            if ((t + itvl[bus[j]]) % bus[j]) {
                s = 1
                break
            }
        }
        t += bus[1]
    }
    printf "%.f\n", t - bus[1]
}
