BEGIN { FS="-" }

function e(x) {
    for (i = 5; i > 0; i--)
        if ((int(x/10^i)%10) > (int(x/10^(i-1))%10)) 
            return 0
    for (i = 5; i > 0; i--)
        if ((int(x/10^i)%10) == (int(x/10^(i-1))%10)) 
            return 1
    return 0
}

{
    for (k = $1; k <= $2; k++)
        p += e(k)
    print p
}
