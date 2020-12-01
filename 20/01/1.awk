{ a[NR] = $0 }

END {
    for (i in a)
        for (j in a)
            if (a[i] + a[j] == 2020) {
                print a[i] * a[j]
                exit
            }
}
