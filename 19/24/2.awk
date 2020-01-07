BEGIN { FS = "" }

{
    for (i = 1; i <= NF; i++) {
        idx = 0 "," i-1 "," NR-1
        eris[idx] = $i == "#"
    }
}

END {
    m = 0
    while (m++ < 200) {
        for (y = 0; y < NR; y++) {
            for (x = 0; x < NF; x++) {
                eris[ m "," x "," y] = 0
                eris[-m "," x "," y] = 0
            }
        }
        for (i = m; i >= -m; i--) {
            for (y = 0; y < NR; y++) {
                for (x = 0; x < NF; x++) {
                    idx = i "," x "," y
                    if (eris[i "," x+1 "," y  ]) a[idx]++
                    if (eris[i "," x-1 "," y  ]) a[idx]++
                    if (eris[i "," x   "," y+1]) a[idx]++
                    if (eris[i "," x   "," y-1]) a[idx]++

                    if (x == 0) {
                        ridx = i-1 "," 1 "," 2
                        if (eris[ridx]) a[idx]++
                        if (eris[idx]) a[ridx]++
                    } else if (x == 4) {
                        ridx = i-1 "," 3 "," 2
                        if (eris[ridx]) a[idx]++
                        if (eris[idx]) a[ridx]++
                    }

                    if (y == 0) {
                        ridx = i-1 "," 2 "," 1
                        if (eris[ridx]) a[idx]++
                        if (eris[idx]) a[ridx]++
                    } else if (y == 4) {
                        ridx = i-1 "," 2 "," 3
                        if (eris[ridx]) a[idx]++
                        if (eris[idx]) a[ridx]++
                    }
                    
                    if (eris[idx] && a[idx] != 1)
                        new[idx] = 0
                    else if (!eris[idx] && (a[idx] == 1 || a[idx] == 2))
                        new[idx] = 1
                    else
                        new[idx] = eris[idx]
                    new[i "," 2 "," 2] = 0
                }
            }
        }
        for (i in eris)
            eris[i] = new[i]
        for (i in a)
            a[i] = 0
    }
    for (i in eris)
        b += eris[i]
    print b
}
