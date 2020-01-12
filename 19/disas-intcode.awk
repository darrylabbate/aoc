# Intcode disassembler

BEGIN {
    FS = ","
    dump = d ? d : 0
    split("add mul in out jt jf lt eq rel", opcode, " ")
    opcode[99] = "halt"
}

function print_info() {
    printf "\n"
    printf "%s: file-format intcode-aoc19\n", FILENAME
    printf "Program size: %d\n", l
    printf "\n"
}

function print_ip() {
    if      (l < 10)    printf "%1d:  ", i
    else if (l < 100)   printf "%2d:  ", i
    else if (l < 1000)  printf "%3d:  ", i
    else if (l < 10000) printf "%4d:  ", i
    else                printf "%5d:  ", i
}

function print_ops() {
    printf "%5d    %-6s ", rop, opcode[op]
}

function print_0() {
    print_ip()
    print_ops()
    printf "\n"
    i++
}

function print_1() {
    print_ip()
    print_ops()
    printf "%s\n", px
    i += 2
}

function print_2() {
    print_ip()
    print_ops()
    printf "%s,%s\n", px, py
    if (!dump) {
        if (op == 5) i =  x ? y : i + 3
        else         i = !x ? y : i + 3
    } else {
        i += 3
    }
}

function print_3() {
    print_ip()
    print_ops()
    printf "%s,%s,%s\n", px, py, pz
    i += 4
}

function output() {
    if (!output_str)
        output_str = x
    else
        output_str = output_str FS x
}

function halt() {
    if (output_str)
        printf "Output: %s\n", output_str
    exit 0
}

{
    l = split($0,t)
    for (j = 0; j < l; j++)
        p[j] = t[j+1]
    os = 0
    i  = 0
    print_info()
    while (i < l) {
        rop = op = p[i]
        xm  = int(op/100)   % 10
        ym  = int(op/1000)  % 10
        zm  = int(op/10000) % 10
        op %= 100
        x   = xm == 1 ? p[i+1] : xm == 2 ? p[p[i+1]+os] : p[p[i+1]]
        y   = ym == 1 ? p[i+2] : ym == 2 ? p[p[i+2]+os] : p[p[i+2]]
        rx  = xm ? p[i+1]+os : p[i+1]
        rz  = zm ? p[i+3]+os : p[i+3]
        if (!dump) {
            px  = xm == 1 ? p[i+1]                 \
                : xm == 2 ? "*(" p[i+1] "+" os ")->" p[p[i+1]+os] \
                : "*" p[i+1] "->" p[p[i+1]]
            py  = ym == 1 ? p[i+2]                 \
                : ym == 2 ? "*(" p[i+2] "+" os ")->" p[p[i+2]+os] \
                : "*" p[i+2] "->" p[p[i+2]]
            pz  = zm ? "*(" p[i+3] "+" os ")->" p[p[i+3]+os]      \
                : "*" p[i+3] "->" p[p[i+3]]
            if      (op == 1)  { p[rz] = x + y; print_3() }
            else if (op == 2)  { p[rz] = x * y; print_3() }
            else if (op == 3)  { print_1() }
            else if (op == 4)  { print_1(); output() }
            else if (op == 5)  { print_2() }
            else if (op == 6)  { print_2() }
            else if (op == 7)  { p[rz] = x <  y; print_3() }
            else if (op == 8)  { p[rz] = x == y; print_3() }
            else if (op == 9)  { os += x; print_1() }
            else if (op == 99) { print_0(); halt() }
            i = i == "" ? 0 : i
        } else {
            px  = xm == 1 ? p[i+1]                 \
                : xm == 2 ? "*(" p[i+1] "+OFFSET)" \
                : "*" p[i+1]
            py  = ym == 1 ? p[i+2]                 \
                : ym == 2 ? "*(" p[i+2] "+OFFSET)" \
                : "*" p[i+2]
            pz  = zm ? "*(" p[i+3] "+OFFSET)"      \
                : "*" p[i+3]
            if      (op == 1)  print_3()
            else if (op == 2)  print_3()
            else if (op == 3)  print_1()
            else if (op == 4)  print_1()
            else if (op == 5)  print_2()
            else if (op == 6)  print_2()
            else if (op == 7)  print_3()
            else if (op == 8)  print_3()
            else if (op == 9)  print_1()
            else if (op == 99) print_0()
            else i++
        }
    }
}
