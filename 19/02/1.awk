{
    l    = split($0, a,",")
    a[2] = 12
    a[3] = 2
    i    = 1
    while (i < l) {
        if (a[i] == "1")
            a[a[i+3]+1] = a[a[i+1]+1] + a[a[i+2]+1]
        if (a[i] == "2")
            a[a[i+3]+1] = a[a[i+1]+1] * a[a[i+2]+1]
        if (a[i] == "99")
            break
        i += 4
    }
}

END {
    print a[1]
}
