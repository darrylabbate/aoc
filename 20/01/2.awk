{ a[NR] = $0 }

END {
    for (i in a)
        for (j in a)
            for (k in a)
                if (a[i] + a[j] + a[k] == 2020) {
                    print a[i] * a[j] * a[k]
                    exit
                }
}
