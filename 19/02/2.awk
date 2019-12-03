function c(p,n,v) {
    l    = split(p,m,",")
    m[2] = n
    m[3] = v
    for (i = 1; i < l; i += 4) {
        if (m[i] == "1")
            m[m[i+3]+1] = m[m[i+1]+1] + m[m[i+2]+1]
        else if (m[i] == "2")
            m[m[i+3]+1] = m[m[i+1]+1] * m[m[i+2]+1]
        else if (m[i] == "99")
            return m[1]
    }
}

END {
    for (n = 1; n < 99; n++)
        for (v = 1; v < 99; v++)
            if (c($0,n,v) == "19690720") {
                print (100 * n + v)
                exit
            }
}
