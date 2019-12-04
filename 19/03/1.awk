function abs(x) {
    return x < 0 ? -x : x
}

function dist(p) {
    split(p,x,",")
    return abs(x[1]) + abs(x[2])
}

NR == 1 {
    al    = split($0,a,",")
    ac[1] = 0
    ac[2] = 0
    for (i = 1; i <= al; i++) {
        if (a[i] ~ /^U/) {
            for (j = 0; j < int(substr(a[i],2)); j++) {
                p = ac[1] "," ++ac[2]
                ap[p] = dist(p)
            }
        } else if (a[i] ~ /^D/) {
            for (j = 0; j < int(substr(a[i],2)); j++) {
                p = ac[1] "," --ac[2]
                ap[p] = dist(p)
            }
        } else if (a[i] ~ /^R/) {
            for (j = 0; j < int(substr(a[i],2)); j++) {
                p = ++ac[1] "," ac[2]
                ap[p] = dist(p)
            }
        } else if (a[i] ~ /^L/) {
            for (j = 0; j < int(substr(a[i],2)); j++) {
                p = --ac[1] "," ac[2]
                ap[p] = dist(p)
            }
        }
    }
}

NR == 2 {
    bl    = split($0,b,",")
    bc[1] = 0
    bc[2] = 0
    d     = 9999999
    for (i = 1; i <= bl; i++) {
        if (b[i] ~ /^U/) {
            for (j = 0; j < int(substr(b[i],2)); j++) {
                p = bc[1] "," ++bc[2]
                if (ap[p] ~ /^[0-9]/)
                    d = d < ap[p] ? d : ap[p]
            }
        } else if (b[i] ~ /^D/) {
            for (j = 0; j < int(substr(b[i],2)); j++) {
                p = bc[1] "," --bc[2]
                if (ap[p] ~ /^[0-9]/)
                    d = d < ap[p] ? d : ap[p]
            }
        } else if (b[i] ~ /^R/) {
            for (j = 0; j < int(substr(b[i],2)); j++) {
                p = ++bc[1] "," bc[2]
                if (ap[p] ~ /^[0-9]/)
                    d = d < ap[p] ? d : ap[p]
            }
        } else if (b[i] ~ /^L/) {
            for (j = 0; j < int(substr(b[i],2)); j++) {
                p = --bc[1] "," bc[2]
                if (ap[p] ~ /^[0-9]/)
                    d = d < ap[p] ? d : ap[p]
            }
        }
    }
    print d
}
