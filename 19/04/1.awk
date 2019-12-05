function e(x) {
    for (i = 1; i < 6; i++)
        if (int(substr(x,i,1)) > int(substr(x,i+1,1)))
            return 0
    for (i = 1; i < 6; i++)
        if (int(substr(x,i,1)) == int(substr(x,i+1,1)))
            return 1
    return 0
}

BEGIN {
    FS="-"
}

{
    for (k = $1; k <= $2; k++)
        p += e(k)
    print p
}
