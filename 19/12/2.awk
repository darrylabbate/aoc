BEGIN { FS = "[=,>]"                                      }
      { x[NR] = $2; y[NR] = $4; z[NR] = $6                }
END   { printf "%.f\n", lcm(step(x),lcm(step(y),step(z))) }

function gcd(x,y,t) {
    while (y > 0) {
        t = x
        x = y
        y = t % y
    }
    return x
}

function lcm(x,y,r) {
    if (!x || !y) return 0
    r = x * y / gcd(x,y)
    return r < 0 ? -r : r
}

function step(a,v,s) {
    while (s += 2) {
        for (i in a) for (j in a) {
            if (j != i) {
                if      (a[i] > a[j]) --v[i]
                else if (a[i] < a[j]) ++v[i]
            }
        }
        for (i in a) a[i] += v[i]
        stop = 1
        for (i in a)
            if (v[i]) stop = 0
        if (stop) break
    }
    return s
}
