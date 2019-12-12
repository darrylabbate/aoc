function abs(x) { return x < 0 ? -x : x }

BEGIN { FS = "[=,>]" }

{
    ox[NR] = $2
    oy[NR] = $4
    oz[NR] = $6
    px[NR] = $2
    py[NR] = $4
    pz[NR] = $6
    vx[NR] = 0
    vy[NR] = 0
    vz[NR] = 0
}

END {
    while (++s) {
        for (i in px) for (j in px) {
            if (j != i) {
                if      (px[i] > px[j]) --vx[i]
                else if (px[i] < px[j]) ++vx[i]
                if      (py[i] > py[j]) --vy[i]
                else if (py[i] < py[j]) ++vy[i]
                if      (pz[i] > pz[j]) --vz[i]
                else if (pz[i] < pz[j]) ++vz[i]
            }
        }
        for (i in px) {
            px[i] += vx[i]
            py[i] += vy[i]
            pz[i] += vz[i]
        }

        stop = 4
        for (i in px) {
            if (!(px[i] == ox[i] \
            &&  py[i] == oy[i] \
            &&  pz[i] == oz[i] \
            &&  vx[i] == 0     \
            &&  vy[i] == 0     \
            &&  vz[i] == 0))
                stop--
        }

        if (stop == 4) {
            print s
            exit 0
        }
    }
}
