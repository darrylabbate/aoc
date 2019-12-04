NR == 1 {
    al    = split($0,a,",")
    ac[1] = 0
    ac[2] = 0
    as    = 0
    for (i = 1; i <= al; i++) {
        if (a[i] ~ /^U/) {
            for (j = 0; j < int(substr(a[i],2)); j++) {
                ap[ac[1] "," ++ac[2]] = ++as
            }
        } else if (a[i] ~ /^D/) {
            for (j = 0; j < int(substr(a[i],2)); j++) {
                ap[ac[1] "," --ac[2]] = ++as
            }
        } else if (a[i] ~ /^R/) {
            for (j = 0; j < int(substr(a[i],2)); j++) {
                ap[++ac[1] "," ac[2]] = ++as
            }
        } else if (a[i] ~ /^L/) {
            for (j = 0; j < int(substr(a[i],2)); j++) {
                ap[--ac[1] "," ac[2]] = ++as
            }
        }
    }
}

NR == 2 {
    bl    = split($0,b,",")
    bc[1] = 0
    bc[2] = 0
    bs    = 0
    l     = 9999999
    for (i = 1; i <= bl; i++) {
        if (b[i] ~ /^U/) {
            for (j = 0; j < int(substr(b[i],2)); j++) {
                ++bs
                p = bc[1] "," ++bc[2]
                if (ap[p]  ~ /^[0-9]/)
                    l = l > bs + ap[p] ? bs + ap[p] : l
            }
        } else if (b[i] ~ /^D/) {
            for (j = 0; j < int(substr(b[i],2)); j++) {
                ++bs
                p = bc[1] "," --bc[2]
                if (ap[p]  ~ /^[0-9]/)
                    l = l > bs + ap[p] ? bs + ap[p] : l
            }
        } else if (b[i] ~ /^R/) {
            for (j = 0; j < int(substr(b[i],2)); j++) {
                ++bs
                p = ++bc[1] "," bc[2]
                if (ap[p]  ~ /^[0-9]/)
                    l = l > bs + ap[p] ? bs + ap[p] : l
            }
        } else if (b[i] ~ /^L/) {
            for (j = 0; j < int(substr(b[i],2)); j++) {
                ++bs
                p = --bc[1] "," bc[2]
                if (ap[p]  ~ /^[0-9]/)
                    l = l > bs + ap[p] ? bs + ap[p] : l
            }
        }
    }
    print l
}
