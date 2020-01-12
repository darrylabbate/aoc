# Intcode interpreter/disassembler

BEGIN {
    FS      = "[, ]"
    dump    = d ? d : 0
    verbose = v ? v : 0
    inp     = inp ? inp : 0

    split("add mul in out jt jf lt eq rel", opcode)
    opcode[99] = "halt"
}

function print_info() {
    printf "\n"
    printf "Program: %s\n", FILENAME
    printf "Size:    %d\n", l
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
}

function print_1() {
    print_ip()
    print_ops()
    printf "%s\n", px
}

function print_2() {
    print_ip()
    print_ops()
    printf "%s, %s\n", px, py
}

function print_3() {
    print_ip()
    print_ops()
    printf "%s, %s, %s\n", px, py, pz
}

function add() {
    if (!dump)
        p[rx] = x + y
    if (dump || verbose)
        print_3()
    i += 4
}

function mul() {
    if (!dump)
        p[rx] = x * y
    if (dump || verbose)
        print_3()
    i += 4
}

function input() {
    p[rx] = inp
    if (dump || verbose)
        print_1()
    i += 2
}

function output() {
    if (!(dump || verbose)) {
        printf "%.f\n", inp = x
    } else {
        print_1()
        if (!output_str)
            output_str = x
        else
            output_str = output_str "," x
    }
    i += 2
}

function jt() {
    if (dump || verbose)
        print_2()
    if (!dump)
        i = x ? y : i + 3
    else
        i += 3
}

function jf() {
    if (dump || verbose)
        print_2()
    if (!dump)
        i = !x ? y : i + 3
    else
        i += 3
}

function lt() {
    if (!dump)
        p[rz] = x < y
    else
        print_3()
    i += 4
}

function eq() {
    if (!dump)
        p[rz] = x == y
    else
        print_3()
    i += 4
}

function rel() {
    os += x
    if (dump || verbose)
        print_1()
    i += 2
}

function halt() {
    if (dump || verbose) {
        print_0()
        if (output_str)
            printf "Output: %s\n", output_str
        i++
    } else if (!dump) {
        exit 0
    }
}

# Interpreter/disassembler

/^-?[0-9]/ {
    l = split($0,t)
    for (j = 0; j < l; j++)
        p[j] = t[j+1]
    os = 0
    i  = 0
    if (dump || verbose) print_info()
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
        if (verbose) {
            px  = xm == 1 ? p[i+1]                 \
                : xm == 2 ? "*(" p[i+1] "+" os ")->" p[p[i+1]+os] \
                : "*" p[i+1] "->" p[p[i+1]]
            py  = ym == 1 ? p[i+2]                 \
                : ym == 2 ? "*(" p[i+2] "+" os ")->" p[p[i+2]+os] \
                : "*" p[i+2] "->" p[p[i+2]]
            pz  = zm ? "*(" p[i+3] "+" os ")->" p[p[i+3]+os]      \
                : "*" p[i+3] "->" p[p[i+3]]
        } else if (dump) {
            px  = xm == 1 ? p[i+1]                 \
                : xm == 2 ? "*(" p[i+1] "+OFFSET)" \
                : "*" p[i+1]
            py  = ym == 1 ? p[i+2]                 \
                : ym == 2 ? "*(" p[i+2] "+OFFSET)" \
                : "*" p[i+2]
            pz  = zm ? "*(" p[i+3] "+OFFSET)"      \
                : "*" p[i+3]
        }
        if      (op == 1)  add()
        else if (op == 2)  mul()
        else if (op == 3)  input()
        else if (op == 4)  output()
        else if (op == 5)  jt()
        else if (op == 6)  jf()
        else if (op == 7)  lt()
        else if (op == 8)  eq()
        else if (op == 9)  rel()
        else if (op == 99) halt()

        else if (dump)
            i++
        if (!dump)
            i = i == "" ? 0 : i
    }
}
