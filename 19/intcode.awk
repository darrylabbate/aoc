# Intcode assembler, disassembler and interpreter
#
# USAGE:
#   awk -f intcode.awk file         | Interpret a program
#   awk -v d=1 -f intcode.awk file  | Disassemble (similar to objdump -d)
#   awk -v v=1 -f intcode.awk file  | Interpret in verbose mode

BEGIN {
    FS     = "[, \t]*"
    mode   = d ? "DUMP" : "INTERPRET"
    rb_str = "rb"
    split(i, inpv)
    split("add mul in out jt jf lt eq rel", opname)
    opname[99] = "halt"
    for (j in opname) opcode[opname[j]] = j
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
    else   c = (c ~ /rb/) ? 2 : (c !~ /^\*/)
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
    printf "\033[0m\n"
}

function print_nop(p1) {
    if (v) {
        if (rop == h) printf "\033[1;32m"
        printf "%*d:        ", l_digits, ip
        printf "%-8s\t", rop
    }
    printf "nop\t%s\033[0m\n", p1
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
}

function interpret(intcode) {
    init(intcode)
    while (op < 99) {
        opcount++
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
                if (!output_str) output_str = x
                else output_str = output_str "," x
            }
            else if (op == 5)  { print_ops(px,py);    }
            else if (op == 6)  { print_ops(px,py);    }
            else if (op == 7)  { print_ops(px,py,pz); }
            else if (op == 8)  { print_ops(px,py,pz); }
            else if (op == 9)  { print_ops(px);       }
            else if (op == 99) {
                print_ops()
                if (output_str)
                    printf "\nAll output: %s\n", output_str
                printf "Op count:   %d\n", opcount
            }
        }
        if      (op == 1) { p[rz] = x + y;           ip += 4 }
        else if (op == 2) { p[rz] = x * y;           ip += 4 }
        else if (op == 3) { p[rx] = inpv[++k];       ip += 2 }
        else if (op == 4) { if(!v) printf "%.f\n",x; ip += 2 }
        else if (op == 5) { ip =  x ? y :            ip +  3 }
        else if (op == 6) { ip = !x ? y :            ip +  3 }
        else if (op == 7) { p[rz] = x <  y;          ip += 4 }
        else if (op == 8) { p[rz] = x == y;          ip += 4 }
        else if (op == 9) { rb += x;                 ip += 2 }
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
