BEGIN { FS = "" }

{
    for (i = 1; i <= NF; i++)
        eris[i-1,NR-1] = ($i == "#") * 2^((i-1) + ((NR-1) * NF))
}

END {
    while (1) {
        bs = b_score()
        for (i in seen) {
            if (bs == seen[i]) {
                print bs
                exit 0
            }
        }
        seen[s++] = bs
        elapse()
    }
}

function elapse(    i,a,x,y) {
    for (y = 0; y < NR; y++) {
        for (x = 0; x < NF; x++) {
            a = 0
            if (eris[x+1,y]) a++
            if (eris[x-1,y]) a++
            if (eris[x,y+1]) a++
            if (eris[x,y-1]) a++
            if (eris[x,y] && a != 1)
                new[x,y] = 0
            else if (!eris[x,y] && (a == 1 || a == 2))
                new[x,y] = 1 * 2^(x + (y * NF))
            else
                new[x,y] = eris[x,y]
        }
    }
    for (i in eris)
        eris[i] = new[i]
}

function b_score(    i,b) {
    for (i in eris)
        b += eris[i]
    return b
}
