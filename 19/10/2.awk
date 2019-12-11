BEGIN {FS = ""}

{
    for (i = 1; i <= NF; i++) {
        idx = i-1 "," NR-1
        c[idx] = $i == "#"
    }
}

function add_asteroid(x,y) {
    sl = atan2(y-ay,x-ax)
    if (!(s[sl]))
        s[sl] = x "," y
    else {
        temp = s[sl]
        s[sl] = x "," y
        s[x "," y] = temp
    }
}

END {
    max = 0
    for (y = 0; y < NR; y++) {
    for (x = 0; x < NF; x++) {
        if (c[x "," y]) {
            for (b = 0; b < NR; b++) {
            for (a = 0; a < NF; a++) {
                if (c[a "," b]) {
                    sl = atan2(y-b,x-a)
                    if (!(s[sl])) {
                        s[sl] = a "," b
                        d[x "," y]++
                    }
                }
            }
            }
            if (d[x "," y] > max) {
                max = d[x "," y]
                ax  = x
                ay  = y
            }
            for (i in s)
                s[i] = 0
        }
    }
    }
    for (y = 0; y <= ay; y++) {
    for (x = 0; x <= ax; x++) {
        if ((x != ax || y != ay) && c[x "," y]) {
            n++
            add_asteroid(x,y)
            # printf "(%2d,%2d) \n", x,y
        }
    }
    }
    for (y = 0; y <= ay; y++) {
    for (x = NF; x > ax; x--) {
        if ((x != ax || y != ay) && c[x "," y]) {
            n++
            add_asteroid(x,y)
            # printf "(%2d,%2d) \n", x,y
        }
    }
    }
    for (y = NR; y > ay; y--) {
    for (x = 0; x < ax; x++) {
        if ((x != ax || y != ay) && c[x "," y]) {
            n++
            add_asteroid(x,y)
            printf "(%2d,%2d) \n", x,y
        }
    }
    }
    for (y = NR; y > ay; y--) {
    for (x = NF; x > ax; x--) {
        if ((x != ax || y != ay) && c[x "," y]) {
            n++
            add_asteroid(x,y)
            printf "(%2d,%2d) \n", x,y
        }
    }
    }
    # for (i in c)
    #     n += c[i]
    print n
}
