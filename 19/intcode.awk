# Intcode assembler, disassembler and interpreter
#
# USAGE:
#   awk -f intcode.awk file         | Interpret a program
#   awk -v d=1 -f intcode.awk file  | Disassemble (similar to objdump -d)
#   awk -v v=1 -f intcode.awk file  | Interpret in verbose mode

BEGIN {
    FS     = "[, ]*"
    d      = d ? d : 0
    v      = v ? v : 0
    mode   = d ? "DUMP" : "INTERPRET"
    rb_str = "rb"
    inp    = inp ? inp : 0
    split(inp, inpv)
    split("add mul in out jt jf lt eq rel", opname)
    opname[99] = "halt"
    for (i in opname)
        opcode[opname[i]] = i
}

/^[0-9]/ {
    format = "Intcode"
    prog   = $0
}

/nop/ { prog = prog "," $2 }

opcode[$1] {
    format = "asm"
    if (!prog) prog =          full_op(opcode[$1],$2,$3,$4)
    else       prog = prog "," full_op(opcode[$1],$2,$3,$4)
    if ($2 != "") prog = prog "," param($2)
    if ($3 != "") prog = prog "," param($3)
    if ($4 != "") prog = prog "," param($4)
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
        printf "%*d:  ", l_digits, i
        printf "%5d ", rop
        if (p1 != "") p_str = p[i+1]
        if (p2 != "") p_str = p_str " " p[i+2]
        if (p3 != "") p_str = p_str " " p[i+3]
        printf "%-8s\t", p_str
    }
    printf "%-6s", opname[op]
    if (p1 != "") printf "%s", p1
    if (p2 != "") printf ", %s", p2
    if (p3 != "") printf ", %s", p3
    printf "\n"
}

function print_nop(p1) {
    if (v) {
        printf "%*d:        ", l_digits, i
        printf "%-8s\t", rop
    }
    printf "nop   %s\n", p1
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
    i  = 0
    if (v)
        printf "\n%s (%d ints, %s) %s\n\n", FILENAME, l, format, mode
}

function interpret(intcode) {
    init(intcode)
    while (op < 99) {
        opcount++
        rop = op = p[i]
        xm  = int(op/100)   % 10
        ym  = int(op/1000)  % 10
        zm  = int(op/10000) % 10
        op %= 100
        x   = xm == 1 ? p[i+1] : xm == 2 ? p[p[i+1]+rb] : p[p[i+1]]
        y   = ym == 1 ? p[i+2] : ym == 2 ? p[p[i+2]+rb] : p[p[i+2]]
        rx  = xm ? p[i+1]+rb : p[i+1]
        rz  = zm ? p[i+3]+rb : p[i+3]
        p[rz] = p[rz] == "" ? 0 : p[rz]
        if (v) {
            px  = xm == 1 ? x                         \
                : xm == 2 ? rel_str(p[i+1],rb) "->" x \
                : "*" p[i+1] "->" x
            py  = ym == 1 ? y                         \
                : ym == 2 ? rel_str(p[i+2],rb) "->" y \
                : "*" p[i+2] "->" y
            pz  = zm ? rel_str(p[i+3],rb) "->" p[rz]  \
                : "*" p[i+3] "->" p[rz]
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
        if      (op == 1) { p[rz] = x + y;           i += 4 }
        else if (op == 2) { p[rz] = x * y;           i += 4 }
        else if (op == 3) { p[rx] = inpv[++k];       i += 2 }
        else if (op == 4) { if(!v) printf "%.f\n",x; i += 2 }
        else if (op == 5) { i =  x ? y :             i +  3 }
        else if (op == 6) { i = !x ? y :             i +  3 }
        else if (op == 7) { p[rz] = x <  y;          i += 4 }
        else if (op == 8) { p[rz] = x == y;          i += 4 }
        else if (op == 9) { rb += x;                 i += 2 }
        i = i == "" ? 0 : i
    }
}

function dump(intcode) {
    init(intcode)
    while (i < l) {
        rop = op = p[i]
        xm  = int(op/100)   % 10
        ym  = int(op/1000)  % 10
        zm  = int(op/10000) % 10
        op %= 100
        px  = xm == 1 ? p[i+1]                  \
            : xm == 2 ? rel_str(p[i+1], rb_str) \
            : "*" p[i+1]
        py  = ym == 1 ? p[i+2]                  \
            : ym == 2 ? rel_str(p[i+2], rb_str) \
            : "*" p[i+2]
        pz  = zm ? rel_str(p[i+3], rb_str)      \
            : "*" p[i+3]
        if      (op == 1)  { print_ops(px,py,pz); i += 4 }
        else if (op == 2)  { print_ops(px,py,pz); i += 4 }
        else if (op == 3)  { print_ops(px);       i += 2 }
        else if (op == 4)  { print_ops(px);       i += 2 }
        else if (op == 5)  { print_ops(px,py);    i += 3 }
        else if (op == 6)  { print_ops(px,py);    i += 3 }
        else if (op == 7)  { print_ops(px,py,pz); i += 4 }
        else if (op == 8)  { print_ops(px,py,pz); i += 4 }
        else if (op == 9)  { print_ops(px);       i += 2 }
        else if (op == 99) { print_ops();         i++    }
        else               { print_nop(rop);      i++    }
    }
}
