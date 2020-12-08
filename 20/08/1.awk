{
    m[NR] = $1
    o[NR] = $2
}



END {
    i = 1
    while (1) {
        if (i in r) {
            print a
            exit
        }
        r[i]++
        if (m[i]~/acc/)
            a+=o[i++]
        else if (m[i]~/jmp/)
            i+=o[i]
        else ++i
    }
}
