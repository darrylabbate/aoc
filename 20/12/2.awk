BEGIN {
    FS = ""
    wx = 10
    wy = 1
}

{ n = substr($0, 2, NF-1) }

/N/ { wy += n }
/E/ { wx += n }
/S/ { wy -= n }
/W/ { wx -= n }

/L/ {
    if (n == 90) {
        wy1 =  wx
        wx1 = -wy
    } else if (n == 180) {
        wy1 = -wy
        wx1 = -wx
    } else if (n == 270) {
        wy1 = -wx
        wx1 =  wy
    }
    wx = wx1
    wy = wy1
}

/R/ {
    if (n == 90) {
        wy1 = -wx
        wx1 =  wy
    } else if (n == 180) {
        wy1 = -wy
        wx1 = -wx
    } else if (n == 270) {
        wy1 =  wx
        wx1 = -wy
    }
    wx = wx1
    wy = wy1
}

/F/ {
    x += wx * n
    y += wy * n
}

END {
    x = x < 0 ? -x : x
    y = y < 0 ? -y : y
    print x + y
}
