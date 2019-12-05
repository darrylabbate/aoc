function add(x,y) { p[p[i+3]+1] = x + y;  i += 4 }
function mul(x,y) { p[p[i+3]+1] = x * y;  i += 4 }
function inp()    { p[p[i+1]+1] = id;     i += 2 }
function out(x)   { id = x;               i += 2 }
function jnz(x,y) { i =  x ? y + 1 :      i +  3 }
function jz(x,y)  { i = !x ? y + 1 :      i +  3 }
function lt(x,y)  { p[p[i+3]+1] = x < y;  i += 4 }
function eq(x,y)  { p[p[i+3]+1] = x == y; i += 4 }
function halt()   { print id;             exit 0 }

{
    l  = split($0,p,",")
    id = 5
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
        else if (op == 5)
            jnz(xm ? p[i+1] : p[p[i+1]+1], ym ? p[i+2] : p[p[i+2]+1])
        else if (op == 6)
            jz(xm ? p[i+1] : p[p[i+1]+1], ym ? p[i+2] : p[p[i+2]+1])
        else if (op == 7)
            lt(xm ? p[i+1] : p[p[i+1]+1], ym ? p[i+2] : p[p[i+2]+1])
        else if (op == 8)
            eq(xm ? p[i+1] : p[p[i+1]+1], ym ? p[i+2] : p[p[i+2]+1])
        else if (op == 99)
            halt()
        else
            exit 1
    }
}
