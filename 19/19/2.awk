BEGIN {
    xc = 0
    yc = 1000
}

function inp() {
    if (++input % 2) p[rx] = xc
    else             p[rx] = yc
}

function out() {
    if (!x && beam) {
        m1 = yc / xc
        x2 = ((m1 * 99) + 99) / (m2 - m1)
        y1 = m2 * x2 - 99
        print int(x2) * 10000 + int(y1)
        exit 0
    } else if (x && !beam) {
        m2 = yc / xc
        beam++
    }
    xc++
}

function init() {
    for (j = 0; j < l; j++)
        p[j] = t[j+1]
    os = 0
    i  = 0
}

{
    l = split($0,t,",")
    init()
    while (1) {
        op  = p[i]
        xm  = int(op/100)   % 10
        ym  = int(op/1000)  % 10
        zm  = int(op/10000) % 10
        op %= 100
        x   = xm == 1 ? p[i+1] : xm == 2 ? p[p[i+1]+os] : p[p[i+1]]
        y   = ym == 1 ? p[i+2] : ym == 2 ? p[p[i+2]+os] : p[p[i+2]]
        rx  = xm ? p[i+1]+os : p[i+1]
        rz  = zm ? p[i+3]+os : p[i+3]
        if      (op == 1) { p[rz] = x + y;  i += 4 }
        else if (op == 2) { p[rz] = x * y;  i += 4 }
        else if (op == 3) { inp();          i += 2 }
        else if (op == 4) { out();          i += 2 }
        else if (op == 5) { i =  x ? y :    i +  3 }
        else if (op == 6) { i = !x ? y :    i +  3 }
        else if (op == 7) { p[rz] = x <  y; i += 4 }
        else if (op == 8) { p[rz] = x == y; i += 4 }
        else if (op == 9) { os += x;        i += 2 }
        else init()
    }
}
