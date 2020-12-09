{ n[NR] = $0 }

END {
    for (i = 26; i <= NR; ++i) {
        for (j = i-1; j > i-25; --j) {
            for (k = j-1; k > i-26; --k) {
                if (n[j] + n[k] == n[i]) {
                    p = 1
                    break
                }
            }
        }
        if (!p) {
            invalid = n[i]
            break
        }
        p = 0
    }
    min = n[NR]
    max = 0
    for (i = 1; i <= NR; ++i) {
        for (j = i; j <= NR; ++j) {
            min = n[j] < min ? n[j] : min
            max = n[j] > max ? n[j] : max
            w += n[j]
            if (w == invalid) {
                print min+ max
                exit
            } else if (w > invalid) {
                min = n[NR]
                max = 0
                w = 0
                break
            }
        }
    }
}
