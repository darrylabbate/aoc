BEGIN { FS = ""; d = 1 }

{ v = substr($0,2,NF-1) }

/N/ { y += v }
/E/ { x += v }
/S/ { y -= v }
/W/ { x -= v }

/L/ { d = ((d - (v/90)) + 4) % 4 }
/R/ { d =  (d + (v/90)) % 4      }

/F/ {
    if      (d == 0) y+=v
    else if (d == 1) x+=v
    else if (d == 2) y-=v
    else if (d == 3) x-=v
}

END {
    x = x < 0 ? -x : x
    y = y < 0 ? -y : y
    print x+y
}
