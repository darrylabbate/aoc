BEGIN { FS = "[ :,x]" }

{
    x = $3
    y = $4
    w = $6
    h = $7
    
    o[NR] = 0

    for (i = y; i < h + y; i++) {
        for (j = x; j < w + x; j++) {
            idx = j "," i
            if (f[idx]) {
                o[NR]     = 1
                o[f[idx]] = 1
            }
            f[idx] = NR
        }
    }
}

END {
    for (i in o) {
        if (!o[i]) {
            print i
            exit 0
        }
    }
}
