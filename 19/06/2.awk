BEGIN { FS = ")" }

{ o[$2] = $1 }

END {
    for (i = "SAN"; i != "COM"; i = o[i])
        p[o[i]] = s++
    for (i = "YOU"; !p[o[i]]; i = o[i])
        y++
    y+=p[o[i]]
    print y
}
