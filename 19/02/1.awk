BEGIN { FS = "," }

{
    $2 = 12
    $3 = 2
    while (o < 3) {
        o = $++i
        x = $($++i+1)
        y = $($++i+1)
        $($++i+1) = o < 2 ? x + y : x * y
    }
    print $1
}
