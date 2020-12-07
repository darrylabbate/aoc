!/no other/ {
    for (i = 6; i <= NF; i += 4) {
        bag[$1$2,$i$(i+1)] = $(i-1)
    }
}

{
    all[$1$2]++
}

END {
    print cost("shinygold")
}

function cost(c,    n) {
    for (x in all) {
        if((c,x) in bag) {
            n += bag[c,x]
            n += bag[c,x] * cost(x)
        }
    }
    return n
}
