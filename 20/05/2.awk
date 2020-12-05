BEGIN {
    FS = ""
    l = 1000
}

{
    x = 0
    y = 127
    a = 0
    b = 7
    for (i = 1; i < NF - 2; ++i) {
        if ($i ~ /F/)
            y = int((x+y)/2)
        else if ($i ~ /B/)
            x = int((x+y)/2) + 1
    }
    for (i = NF-2; i <= NF; ++i) {
        if ($i ~ /L/)
            b = int((a+b)/2)
        else if ($i ~ /R/)
            a = int((a+b)/2) + 1
    }
    s  = x < y ? x * 8 : y * 8
    s += a < b ? b : a
    h  = h < s ? s : h
    l  = l < s ? l : s
    seats[s]++
}

END { 
    for (i = l; i <= h; ++i)
        if (!seats[i])
            print i
}
