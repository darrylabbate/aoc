BEGIN { FS = "" }

{
    for (i = 1; i <= NF; i++)
        eris[0,i-1,NR-1] = $i == "#"
}

END {
    m = 0
    while (m++ < 200) {
        for (y = 0; y < NR; y++) {
            for (x = 0; x < NF; x++) {
                eris[ m,x,y] = 0
                eris[-m,x,y] = 0
            }
        }
        for (i = m; i >= -m; i--) {
            for (y = 0; y < NR; y++) {
                for (x = 0; x < NF; x++) {
                    if (eris[i,x+1,y]) a[i,x,y]++
                    if (eris[i,x-1,y]) a[i,x,y]++
                    if (eris[i,x,y+1]) a[i,x,y]++
                    if (eris[i,x,y-1]) a[i,x,y]++

                    if (x == 0) {
                        if (eris[i-1,1,2]) a[i,x,y]++
                        if (eris[i,x,y]) a[i-1,1,2]++
                    } else if (x == 4) {
                        if (eris[i-1,3,2]) a[i,x,y]++
                        if (eris[i,x,y]) a[i-1,3,2]++
                    }

                    if (y == 0) {
                        if (eris[i-1,2,1]) a[i,x,y]++
                        if (eris[i,x,y]) a[i-1,2,1]++
                    } else if (y == 4) {
                        if (eris[i-1,2,3]) a[i,x,y]++
                        if (eris[i,x,y]) a[i-1,2,3]++
                    }
                    
                    if (eris[i,x,y] && a[i,x,y] != 1)
                        new[i,x,y] = 0
                    else if (!eris[i,x,y] && (a[i,x,y] == 1 || a[i,x,y] == 2))
                        new[i,x,y] = 1
                    else
                        new[i,x,y] = eris[i,x,y]
                    new[i,2,2] = 0
                }
            }
        }
        for (i in eris)
            eris[i] = new[i]
        for (i in a)
            a[i] = 0
    }
    for (i in eris)
        b += eris[i]
    print b
}
