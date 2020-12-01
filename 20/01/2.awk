{ a[$0]++ }

END {
    for (i in a)
        for (j in a)
            for (k in a)
                if (i + j + k == 2020) {
                    print i * j * k
                    exit
                }
}
