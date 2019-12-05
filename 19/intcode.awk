# basic intcode interpreter
# opcodes 1, 2, 3, 4, 5, 6, 7, 8, 99
# supports paramter modes (immediate, positional)
# prints the value at position 0 upon successful termination (halt)

function add(x,y) { p[p[i+3]] = x + y;  i += 4 }
function mul(x,y) { p[p[i+3]] = x * y;  i += 4 }
function inp()    { p[p[i+1]] = id;     i += 2 }
function out()    { id = p[p[i+1]];     i += 2 }
function jnz(x,y) { i =  x ? y :        i +  3 }
function jz(x,y)  { i = !x ? y :        i +  3 }
function lt(x,y)  { p[p[i+3]] = x < y;  i += 4 }
function eq(x,y)  { p[p[i+3]] = x == y; i += 4 }
function halt()   { print p[0];         exit 0 }

{
    l  = split($0,t,",")
    for (j = 0; j < l; j++)
        p[j] = t[j+1]
    id = 1
    for (i = 0; i < l;) {
        op  = p[i]
        xm  = int(op/100)  % 10
        ym  = int(op/1000) % 10
        op %= 100
        if (op == 1)
            add(xm ? p[i+1] : p[p[i+1]], ym ? p[i+2] : p[p[i+2]])
        else if (op == 2)
            mul(xm ? p[i+1] : p[p[i+1]], ym ? p[i+2] : p[p[i+2]])
        else if (op == 3)
            inp()
        else if (op == 4)
            out()
        else if (op == 5)
            jnz(xm ? p[i+1] : p[p[i+1]], ym ? p[i+2] : p[p[i+2]])
        else if (op == 6)
            jz(xm ? p[i+1] : p[p[i+1]], ym ? p[i+2] : p[p[i+2]])
        else if (op == 7)
            lt(xm ? p[i+1] : p[p[i+1]], ym ? p[i+2] : p[p[i+2]])
        else if (op == 8)
            eq(xm ? p[i+1] : p[p[i+1]], ym ? p[i+2] : p[p[i+2]])
        else if (op == 99)
            halt()
        else
            exit 1
    }
}
