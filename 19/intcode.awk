# Intcode assembler, disassembler and interpreter
#
# USAGE:
#   awk -f intcode.awk file             | Interpret a program
#   awk -v x=1 -f intcode.awk file      | Enable option `x`
#   awk -v i=1,2,3 -f intcode.awk file  | Pass a series of inputs
#
# AVAILABLE SWITCHES:
#   a | [1] ASCII mode (converts input vector and outputs to ASCII)
#   d | [1] Dump disassembly
#   i | [n,m,...] The input vector the program reads from
#   h | [n] Highlight lines where opcode == n (parameterized or not)
#   v | [1] Print disassembly verbosely

# input() and output() are provided here to be modified as necessary
# for a given puzzle
#
# Notes:
# - The instruction pointer must increment by two
# - Output is suppressed by default in verbose (v) mode and printed
#   upon halting

function input() {
    if (inpv[++inpc] != "")
        p[rx] = inpv[inpc]
    else
        error(3, "Control flow reached input instruction with empty input vector")
    ip += 2
}

function output() {
    if (!v) {
        if (a) printf "%c",    x
        else   printf "%.f\n", x
    }
    ip += 2
}

function before() {
    # before() is called by init(), which initializes the Intcode
    # program into the global associative array `p`. Supply
    # instructions here to modify memory or assign any needed values
    # before interpreting.
}

BEGIN {
    FS     = "[, \t]*"
    mode   = d ? "DUMP" : "INTERPRET"
    rb_str = "rb"
    split("add mul in out jt jf lt eq rel", opname)
    opname[99] = "halt"
    for (j in opname)
        opcode[opname[j]] = j
    if (a) {
        split(i, inpv,"")
        for (j = 0; j <= 127; j++)
            ascii[sprintf("%c",j)] = j
        for (j in inpv)
            inpv[j] = ascii[inpv[j]]
    } else {
        split(i, inpv)
    }
}

/^[0-9]/ {
    format = "Intcode"
    prog   = $0
}

opcode[$1] {
    format = "asm"
    if (!prog) prog =          full_op(opcode[$1],$2,$3,$4)
    else       prog = prog "," full_op(opcode[$1],$2,$3,$4)
    if ($2 != "") prog = prog "," param($2)
    if ($3 != "") prog = prog "," param($3)
    if ($4 != "") prog = prog "," param($4)
}

/nop/ {
    if (!prog) prog = $2
    else       prog = prog "," $2
}

function param(p) {
    gsub("[^[:digit:]-]+", "", p)
    return p == "" ? 0 : p
}

function full_op(op,c,b,a) {
    if (c == "") return op
    else         c = (c ~ /rb/) ? 2 : (c !~ /^\*/)
    if (b != "") b = (b ~ /rb/) ? 2 : (b !~ /^\*/)
    if (a != "") a = (a ~ /rb/) ? 2 : (a !~ /^\*/)
    if (c) op = c 0 op
    if (b) op = c ? b op : b 0 0 op
    if (a) op = c ? b ? a op : a 0 op : b ? a op : a 0 0 0 op
    return op
}

END {
    if (d) dump(prog)
    else   interpret(prog)
}

function print_ops(p1,p2,p3,    p_str) {
    if (v) {
        if (op == h || rop == h) printf "\033[1;32m"
        printf "%*d:  ", l_digits, ip
        printf "%5d ", rop
        if (p1 != "") p_str = p[ip+1]
        if (p2 != "") p_str = p_str " " p[ip+2]
        if (p3 != "") p_str = p_str " " p[ip+3]
        printf "%-8s\t", p_str
    }
    printf "%s", opname[op]
    if (p1 != "") printf "\t%s", p1
    if (p2 != "") printf ", %s", p2
    if (p3 != "") printf ", %s", p3
    if (op == h || rop == h) printf "\033[0m"
    printf "\n"
}

function print_nop(p1) {
    if (v) {
        printf "%*d:        ", l_digits, ip
        printf "%-8s\t", rop
    }
    printf "nop\t%s\n", p1
}

function rel_str(p,rb) {
    rb_op = p >= 0 ? "+" : ""
    return p == 0 ? "*" rb : "*(" rb rb_op p ")"
}

function init(intcode) {
    l = split(intcode,t)
    for (j = 0; j < l; j++)
        p[j] = t[j+1]
    l_digits = length(l)
    rb = 0
    ip = 0
    if (v)
        printf "\n%s (%d ints, %s) %s\n\n", FILENAME, l, format, mode
    before()
}

function interpret(intcode) {
    init(intcode)
    while (op < 99) {
        icount++
        rop = op = p[ip]
        xm  = int(op/100)   % 10
        ym  = int(op/1000)  % 10
        zm  = int(op/10000) % 10
        op %= 100
        x   = xm == 1 ? p[ip+1] : xm == 2 ? p[p[ip+1]+rb] : p[p[ip+1]]
        y   = ym == 1 ? p[ip+2] : ym == 2 ? p[p[ip+2]+rb] : p[p[ip+2]]
        rx  = xm ? p[ip+1]+rb : p[ip+1]
        rz  = zm ? p[ip+3]+rb : p[ip+3]
        p[rz] = p[rz] == "" ? 0 : p[rz]
        if (v) {
            px  = xm == 1 ? x                         \
                : xm == 2 ? rel_str(p[ip+1],rb) "->" x \
                : "*" p[ip+1] "->" x
            py  = ym == 1 ? y                         \
                : ym == 2 ? rel_str(p[ip+2],rb) "->" y \
                : "*" p[ip+2] "->" y
            pz  = zm ? rel_str(p[ip+3],rb) "->" p[rz]  \
                : "*" p[ip+3] "->" p[rz]
            if      (op == 1)  { print_ops(px,py,pz); }
            else if (op == 2)  { print_ops(px,py,pz); }
            else if (op == 3)  { print_ops(px);       }
            else if (op == 4)  {
                print_ops(px)
                x = x == "" ? 0 : x
                outv[++outc] = x
            }
            else if (op == 5)  { print_ops(px,py);    }
            else if (op == 6)  { print_ops(px,py);    }
            else if (op == 7)  { print_ops(px,py,pz); }
            else if (op == 8)  { print_ops(px,py,pz); }
            else if (op == 9)  { print_ops(px);       }
            else if (op == 99) {
                print_ops()
                printf "\nHalted successfully\n"
                if (outv[1] != "") {
                    printf "\n--- BEGIN OUTPUT ---\n"
                    flush_output()
                    printf "\n--- END OUTPUT ---\n\n"
                }
                printf "Instruction count: %d\n", icount
            }
        }
        if      (op == 1) { p[rz] = x + y;  ip += 4 }
        else if (op == 2) { p[rz] = x * y;  ip += 4 }
        else if (op == 3) { input()                 }
        else if (op == 4) { output()                }
        else if (op == 5) { ip =  x ? y :   ip +  3 }
        else if (op == 6) { ip = !x ? y :   ip +  3 }
        else if (op == 7) { p[rz] = x <  y; ip += 4 }
        else if (op == 8) { p[rz] = x == y; ip += 4 }
        else if (op == 9) { rb += x;        ip += 2 }
        ip = ip == "" ? 0 : ip
    }
}

function dump(intcode) {
    init(intcode)
    while (ip < l) {
        rop = op = p[ip]
        xm  = int(op/100)   % 10
        ym  = int(op/1000)  % 10
        zm  = int(op/10000) % 10
        op %= 100
        px  = xm == 1 ? p[ip+1]                  \
            : xm == 2 ? rel_str(p[ip+1], rb_str) \
            : "*" p[ip+1]
        py  = ym == 1 ? p[ip+2]                  \
            : ym == 2 ? rel_str(p[ip+2], rb_str) \
            : "*" p[ip+2]
        pz  = zm ? rel_str(p[ip+3], rb_str)      \
            : "*" p[ip+3]
        if      (op == 1)  { print_ops(px,py,pz); ip += 4 }
        else if (op == 2)  { print_ops(px,py,pz); ip += 4 }
        else if (op == 3)  { print_ops(px);       ip += 2 }
        else if (op == 4)  { print_ops(px);       ip += 2 }
        else if (op == 5)  { print_ops(px,py);    ip += 3 }
        else if (op == 6)  { print_ops(px,py);    ip += 3 }
        else if (op == 7)  { print_ops(px,py,pz); ip += 4 }
        else if (op == 8)  { print_ops(px,py,pz); ip += 4 }
        else if (op == 9)  { print_ops(px);       ip += 2 }
        else if (op == 99) { print_ops();         ip++    }
        else               { print_nop(rop);      ip++    }
    }
}

function error(code, msg) {
    printf "\n\033[31merror:\033[0m %s\n" \
                     "  at memory location %.f (Opcode %.f)\n" \
                     "  instruction #%d\n", msg, ip, p[ip], icount
    if (v) {
        printf "\n--- BEGIN FLUSHED OUTPUT VECTOR ---\n"
        flush_output()
        printf "\n--- END OUTPUT ---\n"
    }
    exit code
}

function flush_output() {
    for (j = 1; j <= length(outv); j++) {
        if (a && outv[j] >= 0 && outv[j] <= 127)
            printf "%c", outv[j]
        else
            printf "%.f ", outv[j]
    }
}
