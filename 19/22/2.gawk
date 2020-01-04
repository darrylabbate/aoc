# NOTE: Must be invoked with GNU AWK's [-M|--bignum] option

BEGIN {
    m = 101741582076661
    n = 119315717514047
    p = 2020
    a = 1
    b = 0
}

/cut/ {
    b = mod(b-$2,n)
}

/inc/ {
    a = mod(a*$4,n)
    b = mod(b*$4,n)
}

/new/ {
    a = mod(-a,n)
    b = mod(-b-1,n)
}

END {
    printf "%.f\n", shuf(n-1-m)
}

function mod(x,n) {
    if (x < 0) {
        x %= n
        x += n
    } else {
        x %= n
    }
    return x
}

function shuf(l) {
    ra = a
    rb = b
    tc = 1
    while (tc < l) {
        aa = a
        bb = b
        c  = 1
        while ((2*c) <= (l-tc)) {
            bb = mod(aa*bb+bb,n)
            aa = mod(aa^2,n)
            c *= 2
        }
        rb = mod(aa*rb+bb,n)
        ra = mod(aa*ra,n)
        tc += c
    }
    return mod(ra*p+rb,n)
}
