function add(x,y) { p[p[i+3]] = x + y; i += 4 }
function mul(x,y) { p[p[i+3]] = x * y; i += 4 }
function inp()    { p[p[i+1]] = input; i += 2 }
function out(x)   { input = x;         i += 2 }
function halt()   { print input;       exit 0 }

{
    l  = split($0,t,",")
    for (j = 0; j < l; j++)
        p[j] = t[j+1]
    input = 1
    for (i = 0; i < l;) {
        op  = p[i]
        xm  = int(op/100)  % 10
        ym  = int(op/1000) % 10
        op %= 100
        p1  = xm ? p[i+1] : p[p[i+1]]
        p2  = ym ? p[i+2] : p[p[i+2]]
        if      (op == 1)  add(p1, p2)
        else if (op == 2)  mul(p1, p2)
        else if (op == 3)  inp()
        else if (op == 4)  out(p1)
        else if (op == 99) halt()
        else exit 1
    }
}
