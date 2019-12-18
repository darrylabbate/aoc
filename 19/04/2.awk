BEGIN { FS="-" }

function e(x,n) {
    for (i = 5; i > 0; i--)
        if ((int(x/10^i)%10) > (int(x/10^(i-1))%10))
            return 0
    for (i = 0; i < 6; i++)
        n[int(x/10^i)%10]++
    for (i in n)
        if (n[i] == 2)
            return 1
    return 0
}

{
    for (k = $1; k <= $2; k++)
        p += e(k)
    print p
}
