# basic intcode interpreter
# opcodes 1, 2, 3, 4, 5, 6, 7, 8, 99
# supports parameter modes (immediate, positional)
# prints the value calculated from the input instruction upon
# successful termination (halt)
#
# usage:
#   awk -f intcode.awk <program file>
#   awk -f intcode.awk <<< '<program>'
#   awk -f intcode.awk <<< '<program> <input instruction>'

function add(x,y) { p[p[i+3]] = x + y;  i += 4 }
function mul(x,y) { p[p[i+3]] = x * y;  i += 4 }
function inp()    { p[p[i+1]] = input;  i += 2 }
function out(x)   { input = x;          i += 2 }
function jit(x,y) { i =  x ? y :        i +  3 }
function jif(x,y) { i = !x ? y :        i +  3 }
function lt(x,y)  { p[p[i+3]] = x < y;  i += 4 }
function eq(x,y)  { p[p[i+3]] = x == y; i += 4 }
function halt()   { print input;        exit 0 }

{
    l  = split($1,t,",")
    for (j = 0; j < l; j++)
        p[j] = t[j+1]
    input = $2 ? $2 : 5
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
        else if (op == 5)  jit(p1, p2)
        else if (op == 6)  jif(p1, p2)
        else if (op == 7)  lt(p1, p2)
        else if (op == 8)  eq(p1, p2)
        else if (op == 99) halt()
        else exit 1
    }
}
