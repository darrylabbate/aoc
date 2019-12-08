function add(x,y) { p[p[i+3]] = x + y;      i += 4 }
function mul(x,y) { p[p[i+3]] = x * y;      i += 4 }
function inp(x)   { p[p[i+1]] = x;          i += 2 }
function out(x)   { input = x;              i += 2 }
function jit(x,y) { i =  x ? y :            i +  3 }
function jif(x,y) { i = !x ? y :            i +  3 }
function lt(x,y)  { p[p[i+3]] = x < y;      i += 4 }
function eq(x,y)  { p[p[i+3]] = x == y;     i += 4 }
function halt()   { if (!(++s % 5)) loop(); i  = 0 }
function quit()   { print max;              exit 0 }
function err()    { print "input error";    exit 1 }

function loop() {
    max   = input > max ? input : max
    input = 0
    if (++seq > perms)
        quit()
}

BEGIN {
    pa = 0
    pb = 4
    for (a = pa; a <= pb; a++)
    for (b = pa; b <= pb; b++)
    for (c = pa; c <= pb; c++)
    for (d = pa; d <= pb; d++)
    for (e = pa; e <= pb; e++) {
        cand = a b c d e
        if (cand~/0/ && cand~/1/ && cand~/2/ && cand~/3/ && cand~/4/)
            phases = phases cand
    }
}

{
    l = split($1,p,",")
    for (j = 0; j < l; j++)
        p[j] = p[j+1]
    input = input ? input : 0
    sl = split(phases,ph,"")
    for (k = 0; k < sl; k++)
        ph[k] = ph[k+1]
    s     = 0
    max   = 0
    seq   = 1
    perms = int(length(phases)/5)
    for (i = 0; i < l;) {
        op  = p[i]
        xm  = int(op/100)  % 10
        ym  = int(op/1000) % 10
        op %= 100
        p1  = xm ? p[i+1] : p[p[i+1]]
        p2  = ym ? p[i+2] : p[p[i+2]]
        i1   = i ? input : ph[s]
        if      (op == 1)  add(p1, p2)
        else if (op == 2)  mul(p1, p2)
        else if (op == 3)  inp(i1)
        else if (op == 4)  out(p1)
        else if (op == 5)  jit(p1, p2)
        else if (op == 6)  jif(p1, p2)
        else if (op == 7)  lt(p1, p2)
        else if (op == 8)  eq(p1, p2)
        else if (op == 99) halt()
        else               err()
    }
}
