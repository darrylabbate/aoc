function c(d,n,v) {
    l    = split(d,a,",")
    a[2] = n
    a[3] = v
    i    = 1
    while (i < l) {
        if (a[i] == "1")
            a[a[i+3]+1] = a[a[i+1]+1] + a[a[i+2]+1]
        if (a[i] == "2")
            a[a[i+3]+1] = a[a[i+1]+1] * a[a[i+2]+1]
        if (a[i] == "99")
            return a[1]
        i+=4
    }
}

END {
    for (n=1; n<100; n++)
        for (v=1; v<100; v++)
            if (c($0,n,v) == "19690720") {
                print (100 * n + v)
                break
            }
}
