function abs(x) { return x < 0 ? -x : x }

BEGIN { FS = "[=,>]" }

{
    px[NR] = $2
    py[NR] = $4
    pz[NR] = $6
    vx[NR] = 0
    vy[NR] = 0
    vz[NR] = 0
}

END {
    while (t++ < 1000) {
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
    }

    for (i in px) {
        p += abs(px[i]) \
          +  abs(py[i]) \
          +  abs(pz[i])
        k += abs(vx[i]) \
          +  abs(vy[i]) \
          +  abs(vz[i]) 
        total += p * k
        p = 0; k = 0
    }
    print total
}
