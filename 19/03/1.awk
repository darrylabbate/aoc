function abs(x) {
    return x < 0 ? -x : x
}

function dist(c) {
    split(c,p,",")
    return abs(p[1]) + abs(p[2])
}

NR == 1 {
    al = split($0,a,",")
    ac[1] = 0
    ac[2] = 0
    k = 0
    for (i = 1; i <= al; i++) {
        if (a[i] ~ /^U/) {
            for (j = 0; j < int(substr(a[i],2)); j++) {
                ap[k++] = ac[1] "," ++ac[2]
            }
        }
        else if (a[i] ~ /^D/) {
            for (j = 0; j < int(substr(a[i],2)); j++) {
                ap[k++] = ac[1] "," --ac[2]
            }
        }
        else if (a[i] ~ /^R/) {
            for (j = 0; j < int(substr(a[i],2)); j++) {
                ap[k++] = ++ac[1] "," ac[2]
            }
        }
        else if (a[i] ~ /^L/) {
            for (j = 0; j < int(substr(a[i],2)); j++) {
                ap[k++] = --ac[1] "," ac[2]
            }
        }
    }
}

NR == 2 {
    bl = split($0,b,",")
    bc[1] = 0
    bc[2] = 0
    m = 0
    for (i = 1; i <= bl; i++) {
        if (b[i] ~ /^U/) {
            for (j = 0; j < int(substr(b[i],2)); j++) {
                bp[m++] = bc[1] "," ++bc[2]
            }
        }
        else if (b[i] ~ /^D/) {
            for (j = 0; j < int(substr(b[i],2)); j++) {
                bp[m++] = bc[1] "," --bc[2]
            }
        }
        else if (b[i] ~ /^R/) {
            for (j = 0; j < int(substr(b[i],2)); j++) {
                bp[m++] = ++bc[1] "," bc[2]
            }
        }
        else if (b[i] ~ /^L/) {
            for (j = 0; j < int(substr(b[i],2)); j++) {
                bp[m++] = --bc[1] "," bc[2]
            }
        }
    }
}

END {
    d = 9999999
    for (i = 0; i < k; i++)
        for (j = 0; j < m; j++)
            if (ap[i] == bp[j])
                d = d > dist(bp[j]) ? dist(bp[j]) : d
    print d
}
