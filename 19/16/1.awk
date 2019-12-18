BEGIN { p[0] = 0; p[1] = 1; p[2] = 0; p[3] = -1 }

function abs(x) { return x < 0 ? -x : x }

{
    l = split($0,s,"")
    while (ph++ < 100) {
        for (i = 1; i <= l; i++) {
            t = 0
            for (j = i; j <= l; j++)
                t += p[int(j/i) % 4] * s[j]
            ns[i] = abs(t % 10)
        }
        for (i = 1; i <= l; i++)
            s[i] = ns[i]
    }
    for (i = 1; i <= 8; i++)
        printf s[i]
    printf "\n"
}
