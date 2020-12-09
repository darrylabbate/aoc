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
            print n[i]
            exit
        }
        p = 0
    }
}
