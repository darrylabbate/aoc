function add(x,y) { p[p[i+3]+1] = x + y; i += 4 }
function mul(x,y) { p[p[i+3]+1] = x * y; i += 4 }
function inp()    { p[p[i+1]+1] = id;    i += 2 }
function out(x)   { id = x;              i += 2 }
function halt()   { print id;            exit 0 }

{
    l  = split($0,p,",")
    id = 1
    for (i = 1; i <= l;) {
        op  = p[i]
        xm  = int(op/100)  % 10
        ym  = int(op/1000) % 10
        op %= 100
        if (op == 1)
            add(xm ? p[i+1] : p[p[i+1]+1], ym ? p[i+2] : p[p[i+2]+1])
        else if (op == 2)
            mul(xm ? p[i+1] : p[p[i+1]+1], ym ? p[i+2] : p[p[i+2]+1])
        else if (op == 3)
            inp()
        else if (op == 4)
            out(xm ? p[i+1] : p[p[i+1]+1])
        else if (op == 99)
            halt()
        else
            exit 1
    }
}
