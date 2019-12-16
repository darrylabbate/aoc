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

function collect(m, q,     n, eq, ore) {
    if (m == "ORE") return q
    if (m in s) q -= s[m]
    s[m] = 0
    eq   = ceil(q / p[m])
    split(r[m], n, ",")
    for (i in n) {
        split(n[i], c, ":")
        ore += collect(c[1], c[2] * eq)
    }
    s[m] += eq * p[m] - q
    return ore
}

END { print collect("FUEL", p["FUEL"]) }
