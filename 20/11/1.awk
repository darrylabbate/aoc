BEGIN { FS = "" }

{
    for (i = 1; i <= NF; ++i) {
        s1[i,NR] = $i
        s2[i,NR] = $i
    }
}

END {
    while (1) {
        change = 0
        for (y = 1; y <= NR; ++y) {
            for (x = 1; x <= NF; ++x) {
                if (s1[x,y] == ".") continue
                c  = s1[x-1,y-1] == "#"
                c += s1[x-1,y]   == "#"
                c += s1[x-1,y+1] == "#"
                c += s1[x  ,y-1] == "#"
                c += s1[x  ,y+1] == "#"
                c += s1[x+1,y-1] == "#"
                c += s1[x+1,y]   == "#"
                c += s1[x+1,y+1] == "#"
                if (s1[x,y] == "L") {
                    if (!c) {
                        s2[x,y] = "#"
                        change = 1
                    }
                } else if (s1[x,y] == "#") {
                    if (c >= 4) {
                        s2[x,y] = "L"
                        change = 1
                    }
                }
            }
        }
        if (!change) break
        for (y = 1; y <= NR; ++y)
            for (x = 1; x <= NF; ++x)
                s1[x,y] = s2[x,y]
    }
    for (y = 1; y <= NR; ++y)
        for (x = 1; x <= NF; ++x)
            n += s2[x,y] == "#"
    print n
}
