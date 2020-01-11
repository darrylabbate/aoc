BEGIN { FS = "," }

function c(m,n,v,   o,i) {
    split(m,p)
    p[2] = n
    p[3] = v
    while (o < 3) {
        o = p[++i]
        x = p[p[++i]+1]
        y = p[p[++i]+1]
        p[p[++i]+1] = o < 2 ? x + y : x * y
    }
    return p[1]
}

END {
    for (n = 1; n < 99; n++)
        for (v = 1; v < 99; v++)
            if (c($0,n,v) == "19690720") {
                print 100 * n + v
                exit
            }
}
