function abs(x) { return x < 0 ? -x : x }

BEGIN { FS = "[=,>]" }

{
    x[NR] = $2
    y[NR] = $4
    z[NR] = $6
}

END {
    while (t++ < 1000) {
        for (i in x) for (j in x) {
            if (j != i) {
                if      (x[i] > x[j]) --vx[i]
                else if (x[i] < x[j]) ++vx[i]
                if      (y[i] > y[j]) --vy[i]
                else if (y[i] < y[j]) ++vy[i]
                if      (z[i] > z[j]) --vz[i]
                else if (z[i] < z[j]) ++vz[i]
            }
        }
        for (i in x) {
            x[i] += vx[i]
            y[i] += vy[i]
            z[i] += vz[i]
        }
    }

    for (i in x) {
        p += abs(x[i])  \
          +  abs(y[i])  \
          +  abs(z[i])
        k += abs(vx[i]) \
          +  abs(vy[i]) \
          +  abs(vz[i]) 
        total += p * k
        p = 0; k = 0
    }
    print total
}
