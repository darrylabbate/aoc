BEGIN { FS = ")" }

{ o[$2] = $1 }

END {
    for (i in o)
        while (i && i != "COM") {
            n++
            i = o[i]
        }
    print n
}
