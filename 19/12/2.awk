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

BEGIN { FS = "[=,>]" }

{
    px[NR] = $2; ox[NR] = px[NR]
    py[NR] = $4; oy[NR] = py[NR]
    pz[NR] = $6; oz[NR] = pz[NR]
}

END {
    while (xs += 2) {
        for (i in px) for (j in px) {
            if (j != i) {
                if      (px[i] > px[j]) --vx[i]
                else if (px[i] < px[j]) ++vx[i]
            }
        }
        for (i in px) px[i] += vx[i]
        stop = 1
        for (i in px)
            if (vx[i]) stop = 0
        if (stop) break
    }

    while (ys += 2) {
        for (i in py) for (j in py) {
            if (j != i) {
                if      (py[i] > py[j]) --vy[i]
                else if (py[i] < py[j]) ++vy[i]
            }
        }
        for (i in py) py[i] += vy[i]
        stop = 1
        for (i in py)
            if (vy[i]) stop = 0
        if (stop) break
    }

    while (zs += 2) {
        for (i in pz) for (j in pz) {
            if (j != i) {
                if      (pz[i] > pz[j]) --vz[i]
                else if (pz[i] < pz[j]) ++vz[i]
            }
        }
        for (i in pz) pz[i] += vz[i]
        stop = 1
        for (i in pz)
            if (vz[i]) stop = 0
        if (stop) break
    }

    printf "%.f\n", lcm(xs,lcm(ys,zs))
}
