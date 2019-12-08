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

    for (i = int(NF/(w*h)); i >= 0; i--)
        for (j = 1; j <= w*h; j++) {
            if      (substr(layer[i],j,1) == 0) image[j-1] = " "
            else if (substr(layer[i],j,1) == 1) image[j-1] = "#"
        }

    for (i = 0; i < w*h; i++) {
        printf "%s", image[i]
        if (!((i+1) % w))
            printf "\n"
    }
}
