BEGIN { FS="-" }

function e(x) {
    for (i = 1; i < 6; i++)
        if (substr(x,i,1) > substr(x,i+1,1))
            return 0
    for (i = 1; i < 10; i++)
        n[i] = 0
    for (i = 1; i <= 6; i++)
        n[substr(x,i,1)]++
    for (i = 1; i < 10; i++)
        if (n[i] == 2)
            return 1
    return 0
}

{
    for (k = $1; k <= $2; k++)
        p += e(k)
    print p
}
