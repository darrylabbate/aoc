{
    l = split($0,t,"")
    o = substr($0,1,7)
    for (i in t)
        s[l-i] = t[i]
    rl = l * 10000 - o
    for (i = 0; i < rl; i++)
        s[i] = s[i % l]
    while (ph++ < 100) {
        for (i = 1; i < rl; i++) {
            s[i] += s[i-1]
            s[i] %= 10
        }
    }
    for (i = 1; i <= 8; i++)
        printf s[rl-i]
    printf "\n"
}
