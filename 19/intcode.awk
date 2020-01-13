# Intcode assembler, disassembler and interpreter
#
# USAGE:
#   awk -f intcode.awk file         | Interpret a program
#   awk -v d=1 -f intcode.awk file  | Disassemble (similar to objdump -d)
#   awk -v v=1 -f intcode.awk file  | Interpret in verbose mode

BEGIN {
    FS      = "[, ]*"
    OFMT    = "%.f"
    dump    = d ? d : 0
    verbose = v ? v : 0
    mode    = dump ? "DUMP" : "VERBOSE"
    inp     = inp ? inp : 0
    os_str  = "OFFSET"
    split("add mul in out jt jf lt eq rel", opname)
    opname[99] = "halt"
    for (i in opname)
        opcode[opname[i]] = i
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

function param(p) {
    gsub("[^[:digit:]-]+", "", p)
    return p
}

function full_op(op,c,b,a) {
    if (c == "") return op
    else   c = (c ~ /OFF/) ? 2 : (c !~ /^\*/)
    if (b != "") b = (b ~ /OFF/) ? 2 : (b !~ /^\*/)
    if (a != "") a = (a ~ /OFF/) ? 2 : (a !~ /^\*/)

    if (c) op = c 0 op
    if (b) op = c ? b op : b 0 0 op
    if (a) op = b ? a op : c ? a op : a 0 op

    return op
}

END { interpret(prog) }

function print_ops(p1,p2,p3,    p_str) {
    printf "%*d:  ", l_digits, i
    printf "%5d ", rop
    if (p1 != "") p_str = p[i+1]
    if (p2 != "") p_str = p_str " " p[i+2]
    if (p3 != "") p_str = p_str " " p[i+3]
    printf "%-16s ", p_str
    printf "%-6s", opname[op]
    if (p1 != "") printf "%s", p1
    if (p2 != "") printf ", %s", p2
    if (p3 != "") printf ", %s", p3
    printf "\n"
}

function rel_str(p,os) {
    os_op = p >= 0 ? "+" : ""
    return "*(" os os_op p ")"
}

function interpret(intcode) {
    l = split(intcode,t)
    for (j = 0; j < l; j++)
        p[j] = t[j+1]
    l_digits = length(l)
    os = 0
    i  = 0
    if (dump || verbose)
        printf "\n%s (%d ints, %s) %s\n\n", FILENAME, l, format, mode
    while (i < l) {
        opcount++
        rop = op = p[i]
        xm  = int(op/100)   % 10
        ym  = int(op/1000)  % 10
        zm  = int(op/10000) % 10
        op %= 100
        x   = xm == 1 ? p[i+1] : xm == 2 ? p[p[i+1]+os] : p[p[i+1]]
        y   = ym == 1 ? p[i+2] : ym == 2 ? p[p[i+2]+os] : p[p[i+2]]
        rx  = xm ? p[i+1]+os : p[i+1]
        rz  = zm ? p[i+3]+os : p[i+3]
        p[rz] = p[rz] == "" ? 0 : p[rz]
        if (verbose) {
            px  = xm == 1 ? x                         \
                : xm == 2 ? rel_str(p[i+1],os) "->" x \
                : "*" p[i+1] "->" x
            py  = ym == 1 ? y                         \
                : ym == 2 ? rel_str(p[i+2],os) "->" y \
                : "*" p[i+2] "->" y
            pz  = zm ? rel_str(p[i+3],os) "->" p[rz]  \
                : "*" p[i+3] "->" p[rz]
        } else if (dump) {
            px  = xm == 1 ? x                       \
                : xm == 2 ? rel_str(p[i+1], os_str) \
                : "*" p[i+1]
            py  = ym == 1 ? y                       \
                : ym == 2 ? rel_str(p[i+2], os_str) \
                : "*" p[i+2]
            pz  = zm ? rel_str(p[i+3], os_str)      \
                : "*" p[i+3]
        }
        if (op == 1) {
            if (!dump)
                p[rz] = x + y
            if (dump || verbose)
                print_ops(px,py,pz)
            i += 4
        } else if (op == 2) {
            if (!dump)
                p[rz] = x * y
            if (dump || verbose)
                print_ops(px,py,pz)
            i += 4
        } else if (op == 3) {
            p[rx] = inp
            if (dump || verbose)
                print_ops(px)
            i += 2
        } else if (op == 4) {
            if (!(dump || verbose)) {
                printf "%.f\n", x
            } else {
                print_ops(px)
                if (!dump) {
                    x = x == "" ? 0 : x
                    if (!output_str)
                        output_str = x
                    else
                        output_str = output_str "," x
                }
            }
            i += 2
        } else if (op == 5) {
            if (dump || verbose)
                print_ops(px,py)
            if (!dump)
                i = x ? y : i + 3
            else
                i += 3
        } else if (op == 6) {
            if (dump || verbose)
                print_ops(px,py)
            if (!dump)
                i = !x ? y : i + 3
            else
                i += 3
        } else if (op == 7) {
            if (!dump) p[rz] = x < y
            else       print_ops(px,py,pz)
            i += 4
        } else if (op == 8) {
            if (!dump) p[rz] = x == y
            else       print_ops(px,py,pz)
            i += 4
        } else if (op == 9) {
            os += x
            if (dump || verbose)
                print_ops(px)
            i += 2
        } else if (op == 99) {
            if (dump || verbose) {
                print_ops()
                if (output_str)
                    printf "\nAll output: %s\n", output_str
            }
            i++
            if (verbose)
                printf "Op count:   %d\n", opcount
            if (!dump) exit 0
        } else if (dump) {
            i++
            opcount--
        }
        if (!dump)
            i = i == "" ? 0 : i
    }
}
