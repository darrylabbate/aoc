BEGIN {
    FS = ""
    wx = 10
    wy = 1
}

{ v = substr($0,2,NF-1) }

/N/ { wy += v }
/E/ { wx += v }
/S/ { wy -= v }
/W/ { wx -= v }

/L/ {
    if (v == 90) {
        wy1 = wx
        wx1 = -wy
    } else if (v == 180) {
        wy1 = -wy
        wx1 = -wx
    } else if (v == 270) {
        wy1 = -wx
        wx1 = wy
    }
    wx = wx1
    wy = wy1
}

/R/ {
    if (v == 90) {
        wy1 = -wx
        wx1 = wy
    } else if (v == 180) {
        wy1 = -wy
        wx1 = -wx
    } else if (v == 270) {
        wy1 = wx
        wx1 = -wy
    }
    wx = wx1
    wy = wy1
}

/F/ {
    x += wx * v
    y += wy * v
}

END {
    x = x < 0 ? -x : x
    y = y < 0 ? -y : y
    print x+y
}
