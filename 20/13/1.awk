BEGIN { FS = ",(x,)*" }

NR == 1 { e = $0 }

NR == 2 {
    min = 10000000
    for (i = 1; i <= NF; ++i)
        b[$i] = $i - (e % $i)

    for (i in b)
        if (b[i] < min) {
            min = b[i]
            bus = i
        }
    print min * bus
}
