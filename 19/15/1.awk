BEGIN { inp = 1 }

function out() {
    if (!x) {
        if (d == 1) {
            o[dx,dy+1]--
            if (!o[dx-1,dy]) d = 3
            else             d = 4
        } else if (d == 2) {
            o[dx,dy-1]--
            if (!o[dx+1,dy]) d = 4
            else             d = 3
        } else if (d == 3) {
            o[dx-1,dy]--
            if (!o[dx,dy-1]) d = 2
            else             d = 1
        } else {
            o[dx+1,dy]--
            if (!o[dx,dy+1]) d = 1
            else             d = 2
        }
    } else if (x == 1) {
        if      (d == 1) ++dy
        else if (d == 2) --dy
        else if (d == 3) --dx
        else             ++dx

        d += d < 3 ? 2 : -((d * 2) % 5)

        if (!o[dx,dy]) ++c
        else           --c

        o[dx,dy]++
    } else if (x == 2) {
        print ++c
        exit 0
    }
    inp = d
}

{
    l = split($0,t,",")
    for (j = 0; j < l; j++)
        p[j] = t[j+1]
    os = 0
    i  = 0
    d  = inp
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
        if      (op == 1) { p[rz] = x + y;  i += 4 }
        else if (op == 2) { p[rz] = x * y;  i += 4 }
        else if (op == 3) { p[rx] = inp;    i += 2 }
        else if (op == 4) { out();          i += 2 }
        else if (op == 5) { i =  x ? y :    i +  3 }
        else if (op == 6) { i = !x ? y :    i +  3 }
        else if (op == 7) { p[rz] = x <  y; i += 4 }
        else if (op == 8) { p[rz] = x == y; i += 4 }
        else if (op == 9) { os += x;        i += 2 }
    }
}
