{
    m[NR] = $1
    o[NR] = $2
}



END {
    i = 1
    while (i <= NR) {
        while (++j <= NR)
            t[j] = m[j]
        if      (t[i] ~ /jmp/) t[i] = "nop"
        else if (t[i] ~ /nop/) t[i] = "jmp"
        a = run()
        if (a) {
            print a
            exit
        }
        ++i
        j = 0
    }
}

function run(   i,a,r) {
    delete r
    i = 1
    while (i <= NR) {
        if (i in r) return 0
        r[i]++
        if      (t[i] ~ /acc/) a += o[i++]
        else if (t[i] ~ /jmp/) i += o[i]
        else ++i
    }
    return a
}
