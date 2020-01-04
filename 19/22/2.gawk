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

function comb(a1,b1,a2,b2) {
    bb = mod(a1*b2+b1,n)
    aa = mod(a1*a2,n)
}

function fcomb(a1,b1,a2,b2) {
    fb = mod(a1*b2+b1,n)
    fa = mod(a1*a2,n)
}

function shuf(l) {
    fa = a
    fb = b
    tc = 1
    while (tc < l) {
        aa = a
        bb = b
        c  = 1
        while ((2*c) <= (l-tc)) {
            comb(aa,bb,aa,bb)
            c *= 2
        }
        fcomb(aa,bb,fa,fb)
        tc += c
    }
    return mod(fa*p+fb,n)
}
