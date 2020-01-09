BEGIN { inp = 1 }

function print_hull() {
    for (y = 0; y >= -5; y--) {
        for (x = 1; x <= 40; x++) {
            printf "%s", hull[x,y]
        }
        printf "\n"
    }
}

function out() {
    if (++c % 2 == 1) {
        if (x) color = "#"
        else   color = " "
    } else {
        hull[x1,y1] = color
        if (d == 0) {
            if (x) { d = 1; ++x1 }
            else   { d = 3; --x1 }
        } else if (d == 1) {
            if (x) { d = 2; --y1 }
            else   { d = 0; ++y1 }
        } else if (d == 2) {
            if (x) { d = 3; --x1 }
            else   { d = 1; ++x1 }
        } else if (d == 3) {
            if (x) { d = 0; ++y1 }
            else   { d = 2; --y1 }
        }
    }
    inp = hull[x1,y1] == "#"
}

{
    l = split($0,t,",")
    for (j = 0; j < l; j++)
        p[j] = t[j+1]
    os = 0
    i  = 0
    x1 = 0
    y1 = 0
    d  = 0
    while (op < 99) {
        op  = p[i]
        xm  = int(op/100)   % 10
        ym  = int(op/1000)  % 10
        zm  = int(op/10000) % 10
        op %= 100
        x   = xm == 1 ? p[i+1] : xm == 2 ? p[p[i+1]+os] : p[p[i+1]]
        y   = ym == 1 ? p[i+2] : ym == 2 ? p[p[i+2]+os] : p[p[i+2]]
        rx  = xm ? p[i+1]+os : p[i+1]
        rz  = zm ? p[i+3]+os : p[i+3]
        if      (op == 1)  { p[rz] = x + y;  i += 4 }
        else if (op == 2)  { p[rz] = x * y;  i += 4 }
        else if (op == 3)  { p[rx] = inp;    i += 2 }
        else if (op == 4)  { out();          i += 2 }
        else if (op == 5)  { i =  x ? y :    i +  3 }
        else if (op == 6)  { i = !x ? y :    i +  3 }
        else if (op == 7)  { p[rz] = x <  y; i += 4 }
        else if (op == 8)  { p[rz] = x == y; i += 4 }
        else if (op == 9)  { os += x;        i += 2 }
    }
    print_hull()
}
