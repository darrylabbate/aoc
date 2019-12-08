{ c[NR] = $0 }

END {
    while (1) {
        for (i = 1; i <= NR; i++) {
            f += c[i]
            if (seen[f]++) {
                print f
                exit 0
            }
        }
    }
}
