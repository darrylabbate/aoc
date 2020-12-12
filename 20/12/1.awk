BEGIN { FS = ""; d = 1 }

{ n = substr($0, 2, NF-1) }

/N/ { y += n }
/E/ { x += n }
/S/ { y -= n }
/W/ { x -= n }

/L/ { d = ((d - (n/90)) + 4) % 4 }
/R/ { d =  (d + (n/90)) % 4      }

/F/ {
    if      (d == 0) y += n
    else if (d == 1) x += n
    else if (d == 2) y -= n
    else if (d == 3) x -= n
}

END {
    x = x < 0 ? -x : x
    y = y < 0 ? -y : y
    print x + y
}
