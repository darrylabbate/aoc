{
    for (i = 6; i <= NF; i += 4) {
        bag[$1$2,$i$(i+1)] = $(i-1)
    }
}

!/^shiny gold/ && /shiny gold/ {
    gold[$1$2]++
}

END {
    for (x in bag) {
        for (y in bag) {
            split(y,t,SUBSEP)
            if (t[2] in gold)
                gold[t[1]]++
        }
    }
    for (i in gold)
        ++n
    print n
}
