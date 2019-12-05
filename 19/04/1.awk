BEGIN { FS="-" }

function e(x) {
    for (i = 1; i < 6; i++)
        if (substr(x,i,1) > substr(x,i+1,1))
            return 0
    for (i = 1; i < 6; i++)
        if (substr(x,i,1) == substr(x,i+1,1))
            return 1
    return 0
}

{
    for (k = $1; k <= $2; k++)
        p += e(k)
    print p
}
