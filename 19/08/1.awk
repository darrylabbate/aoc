BEGIN {
    w = 25
    h = 6
    FS = ""
}

{
    k = 1
    for (i = 0; i < int(NF/(w*h)); i++)
        for (j = 1; j <= w*h; j++)
            layer[i] = layer[i] $(k++)

    for (i = 0; i < int(NF/(w*h)); i++)
        for (j = 1; j <= w*h; j++) {
            if      (substr(layer[i],j,1) == 0) zeros[i]++
            else if (substr(layer[i],j,1) == 1)  ones[i]++
            else if (substr(layer[i],j,1) == 2)  twos[i]++
        }

    z = 99
    for (i = 0; i < int(NF/(w*h)); i++)
        if (zeros[i] < z) {
            zi = i
            z  = zeros[i]
        }
    print ones[zi] * twos[zi]
}
