BEGIN { FS = "[ ,=>]" }

{
    p[$NF] = $(NF-1)
    for (i = NF-2; i > 1; i--) {
        if ($i ~ /^[A-Z]/) {
            str = $i ":" $(i-1)
            if (!r[$NF]) r[$NF] = str
            else         r[$NF] = r[$NF] "," str
        }
    }
}

function ceil(x,y) {
    y = int(x)
    return y + (x > y)
}

function cost(m, q,     n, eq, ore) {
    if (m == "ORE") return q
    if (m in s) q -= s[m]
    s[m] = 0
    eq   = ceil(q / p[m])
    split(r[m], n, ",")
    for (i in n) {
        split(n[i], c, ":")
        ore += cost(c[1], c[2] * eq)
    }
    s[m] += eq * p[m] - q
    return ore
}

function bsearch(i, v, l, h) {
    lc = cost(i, l)
    hc = cost(i, h)
    if (hc < lc) return h
    m  = int((l + h) / 2)
    mc = cost(i, m)
    if (mc == v || h - l <= 1) return l
    return (mc > v) ? bsearch(i, v, l, m) \
                    : bsearch(i, v, m, h)
}

END {
    u = int(10^12 / cost("FUEL", p["FUEL"])) * 2
    printf "%.f\n", bsearch("FUEL", 10^12, 0, u)
}
