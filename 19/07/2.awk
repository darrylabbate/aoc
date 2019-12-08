function add(x,y) { p[p[i+3]+os] = x + y;  i += 4 }
function mul(x,y) { p[p[i+3]+os] = x * y;  i += 4 }
function inp(x)   { p[p[i+1]+os] = x;      i += 2 }
function out(x)   { input = x;             i += 2 ; transfer() }
function jit(x,y) { i =  x ? y+os :        i +  3 }
function jif(x,y) { i = !x ? y+os :        i +  3 }
function lt(x,y)  { p[p[i+3]+os] = x < y;  i += 4 }
function eq(x,y)  { p[p[i+3]+os] = x == y; i += 4 }
function quit()   { print max;              exit 0 }
function err()    { print "input error";    exit 1 }

function transfer() {
    if      (os == 0)   { A = i; i = B; os = l   }
    else if (os == l)   { B = i; i = C; os = l*2 }
    else if (os == l*2) { C = i; i = D; os = l*3 }
    else if (os == l*3) { D = i; i = E; os = l*4 }
    else if (os == l*4) { E = i; i = A; os = 0   }
}

function halt() {
    max = input > max ? input : max
    if (++seq > perms)
        quit()
    init()
}

function init() {
    input = 0
    z = 0
    for (n = 0; n < 5; n++)
    for (j = 0; j < l; j++) {
        p[z++] = t[j+1]
    }

    A  = 0
    B  = l
    C  = l * 2
    D  = l * 3
    E  = l * 4
    os = A
    i  = 0
}

BEGIN {
    pa = 5
    pb = 9
    for (a = pa; a <= pb; a++)
    for (b = pa; b <= pb; b++)
    for (c = pa; c <= pb; c++)
    for (d = pa; d <= pb; d++)
    for (e = pa; e <= pb; e++) {
        cand = a b c d e
        if (cand~/5/ && cand~/6/ && cand~/7/ && cand~/8/ && cand~/9/)
            phases = phases cand
    }
}

{
    l = split($1,t,",")
    init()
    input = input ? input : 0
    sl = split(phases,ph,"")
    for (k = 0; k < sl; k++)
        ph[k] = ph[k+1]
    s     = 0
    max   = 0
    seq   = 1
    perms = int(length(phases)/5)
    for (i = 0; i < l*5;) {
        op  = p[i]
        xm  = int(op/100)  % 10
        ym  = int(op/1000) % 10
        op %= 100
        p1  = xm ? p[i+1] : p[p[i+1]+os]
        p2  = ym ? p[i+2] : p[p[i+2]+os]
        i1  = i - os ? input : ph[s++]
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
