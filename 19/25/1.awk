# This program allows you to play the text-adventure game manually for
# a given puzzle input from day 25 (2019); enhanced with a few keyboard
# shortcuts:
#
#   [n,e,w,s] | [north,east,west,south]
#   i         | inv
#   t <item>  | take <item>
#   d <item>  | drop <item>
#   q         | Exit the program

BEGIN {
    printf "\033[2J\033[1;1H"
    for (i = 0; i <= 127; i++)
        ascii[sprintf("%c",i)] = i
    k  = 1
    sl = 0
}

function build_input(str) {
    if (str == "q") {
        print "Exit"
        exit 0
    }
    else if (str == "n") str = "north"
    else if (str == "e") str = "east"
    else if (str == "w") str = "west"
    else if (str == "s") str = "south"
    else if (str == "i") str = "inv"
    else if (str ~ /^t/) sub("t","take",str)
    else if (str ~ /^d/) sub("d","drop",str)

    for (a in ascii_in)
        delete ascii_in[a]
    sl = split(str,arr,"")
    for (j = 1; j <= sl; j++)
        ascii_in[j] = ascii[arr[j]]
    ascii_in[++sl] = 10
    k = 1
}

function inp() {
    if (k > sl) {
        getline str < "-"
        build_input(str)
        printf "\033[2J\033[1;1H"
    }
    p[rx] = ascii_in[k++]
}

function out() {
    printf "%c", x
}

{
    l = split($0,t,",")
    for (j = 0; j < l; j++)
        p[j] = t[j+1]
    os = 0
    i  = 0
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
        else if (op == 3) { inp();          i += 2 }
        else if (op == 4) { out();          i += 2 }
        else if (op == 5) { i =  x ? y :    i +  3 }
        else if (op == 6) { i = !x ? y :    i +  3 }
        else if (op == 7) { p[rz] = x <  y; i += 4 }
        else if (op == 8) { p[rz] = x == y; i += 4 }
        else if (op == 9) { os += x;        i += 2 }
        i = i == "" ? 0 : i
    }
}
