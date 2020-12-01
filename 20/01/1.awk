{ a[$0]++ }

END {
    for (i in a)
        for (j in a)
            if (i + j == 2020) {
                print i * j
                exit
            }
}
