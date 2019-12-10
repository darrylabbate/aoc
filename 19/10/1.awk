BEGIN {FS = ""}

{
    for (i = 1; i <= NF; i++) {
        idx = i-1 "," NR-1
        c[idx] = $i == "#"
    }
}

END {
    max = 0
    for (y = 0; y < NR; y++) {
    for (x = 0; x < NF; x++) {
        if (c[x "," y]) {
            for (b = 0; b < NR; b++) {
            for (a = 0; a < NF; a++) {
                if (c[a "," b]) {
                    sl = atan2(y-b,x-a)
                    if (!(s[sl])) {
                        s[sl] = a "," b
                        d[x "," y]++
                    }
                }
            }
            }
            max = d[x "," y] > max ? d[x "," y] : max
            for (i in s)
                s[i] = 0
        }
    }
    }
    print max
}
