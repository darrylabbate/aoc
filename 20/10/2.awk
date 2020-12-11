{
    j[$0]++
    max = max < $0 ? $0 : max
}

END {
    j[0]++
    n[max+3] = 1
    for (i = max; i >= 0; --i) {
        if (i in j)
            n[i] += n[i+1] + n[i+2] + n[i+3]
    }
    printf "%.f\n", n[0]
}
