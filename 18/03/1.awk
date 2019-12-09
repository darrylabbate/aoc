BEGIN { FS = "[ :,x]" }

{
    x = $3
    y = $4
    w = $6
    h = $7

    for (i = y; i < h + y; i++) {
        for (j = x; j < w + x; j++) {
            idx = j "," i
            if (f[idx]) {
                if (f[idx] > 0) {
                    f[idx] = -1
                    overlap++
                }
            } else {
                f[idx] = NR
            }
        }
    }
}

END { print overlap }
