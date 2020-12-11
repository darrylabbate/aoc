{ j[$0]++ }

END {
    one   = 1 in j
    three = 3 in j
    for (i in j) {
        if (i+1 in j)
            one++
        else if (i+3 in j)
            three++
    }
    print one * three
}
