BEGIN { input = 2 }

{
    l = split($1,t,",")
    for (j = 0; j < l; j++)
        p[j] = t[j+1]
    os = 0
    i  = 0
    while (1) {
        op  = p[i]
        xm  = int(op/100)  % 10
        ym  = int(op/1000) % 10
        zm  = int(op/10000) % 10
        op %= 100
        x   = xm == 1 ? p[i+1] : xm == 2 ? p[p[i+1]+os] : p[p[i+1]]
        y   = ym == 1 ? p[i+2] : ym == 2 ? p[p[i+2]+os] : p[p[i+2]]
        rx  = xm ? p[i+1]+os : p[i+1]
        rz  = zm ? p[i+3]+os : p[i+3]
        if      (op == 1)  { p[rz] = x + y;              i += 4 }
        else if (op == 2)  { p[rz] = x * y;              i += 4 }
        else if (op == 3)  { p[rx] = input;              i += 2 }
        else if (op == 4)  { printf "%d\n",x; input = x; i += 2 }
        else if (op == 5)  { i =  x ? y :                i +  3 }
        else if (op == 6)  { i = !x ? y :                i +  3 }
        else if (op == 7)  { p[rz] = x <  y;             i += 4 }
        else if (op == 8)  { p[rz] = x == y;             i += 4 }
        else if (op == 9)  { os += x;                    i += 2 }
        else if (op == 99) {                             exit 0 }
        else               { print "Error";              exit 1 }       
    }
}
