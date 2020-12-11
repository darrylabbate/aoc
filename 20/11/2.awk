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
                c = 0
                for (yy = y-1; yy >= 1; --yy) {
                    c += s1[x,yy] ~ /#/
                    if (s1[x,yy] ~/#|L/) break
                }
                for (yy = y+1; yy <= NR; ++yy) {
                    c += s1[x,yy] ~ /#/
                    if (s1[x,yy] ~/#|L/) break
                }
                for (xx = x-1; xx >= 1; --xx) {
                    c += s1[xx,y] ~ /#/
                    if (s1[xx,y] ~/#|L/) break
                }
                for (xx = x+1; xx <= NF; ++xx) {
                    c += s1[xx,y] ~ /#/
                    if (s1[xx,y] ~/#|L/) break
                }
                xx = x-1; yy = y-1
                while (xx >= 1 && yy >= 1) {
                    c += s1[xx,yy] ~ /#/
                    if (s1[xx,yy] ~/#|L/) break
                    --xx
                    --yy
                }
                xx = x+1; yy = y-1
                while (xx <= NF && yy >= 1) {
                    c += s1[xx,yy] ~ /#/
                    if (s1[xx,yy] ~/#|L/) break
                    ++xx
                    --yy
                }
                xx = x+1; yy = y+1
                while (xx <= NF && yy <= NR) {
                    c += s1[xx,yy] ~ /#/
                    if (s1[xx,yy] ~/#|L/) break
                    ++xx
                    ++yy
                }
                xx = x-1; yy = y+1
                while (xx >= 1 && yy <= NR) {
                    c += s1[xx,yy] ~ /#/
                    if (s1[xx,yy] ~/#|L/) break
                    --xx
                    ++yy
                }
                if (s1[x,y] == "L") {
                    if (!c) {
                        s2[x,y] = "#"
                        change = 1
                    }
                } else if (s1[x,y] == "#") {
                    if (c >= 5) {
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
