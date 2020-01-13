# Intcode assembler, disassembler and interpreter
#
# USAGE:
#   awk -f intcode.awk file         | Interpret a program
#   awk -v d=1 -f intcode.awk file  | Disassemble (similar to objdump -d)
#   awk -v v=1 -f intcode.awk file  | Interpret in verbose mode

BEGIN {
    FS      = "[, ]*"
    dump    = d ? d : 0
    verbose = v ? v : 0
    mode    = dump ? "DUMP" : "VERBOSE"
    inp     = inp ? inp : 0
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
    if ($2) prog = prog "," param($2)
    if ($3) prog = prog "," param($3)
    if ($4) prog = prog "," param($4)
}

END { interpret(prog) }

function param(p) {
    gsub("[^[:digit:]-]+", "", p)
    return p
}

function full_op(op,c,b,a) {
    if (!c) return op
    else   c = (c ~ /OFF/) ? 2 : (c !~ /^\*/)
    if (b) b = (b ~ /OFF/) ? 2 : (b !~ /^\*/)
    if (a) a = (a ~ /OFF/) ? 2 : (a !~ /^\*/)

    if (c) op = c 0 op
    if (b) op = c ? b op : b 0 0 op
    if (a) op = b ? a op : c ? a op : a 0 op

    return op
}

function print_ops(p1,p2,p3) {
    if      (l < 10)    printf "%1d:  ", i
    else if (l < 100)   printf "%2d:  ", i
    else if (l < 1000)  printf "%3d:  ", i
    else if (l < 10000) printf "%4d:  ", i
    else                printf "%5d:  ", i
    printf "%5d    %-6s", rop, opname[op]
    if (p1) printf "%s", p1
    if (p2) printf ", %s", p2
    if (p3) printf ", %s", p3
    printf "\n"
}

function interpret(intcode) {
    l = split(intcode,t)
    for (j = 0; j < l; j++)
        p[j] = t[j+1]
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
        if (verbose) {
            px  = xm == 1 ? p[i+1]                                \
                : xm == 2 ? "*(" p[i+1] "+" os ")->" p[p[i+1]+os] \
                : "*" p[i+1] "->" p[p[i+1]]
            py  = ym == 1 ? p[i+2]                                \
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
        if (op == 1) {
            if (!dump)
                p[rx] = x + y
            if (dump || verbose)
                print_ops(px,py,pz)
            i += 4
        } else if (op == 2) {
            if (!dump)
                p[rx] = x * y
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
                printf "%.f\n", inp = x
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
                    printf "\nOutput: %s\n", output_str
            }
            i++
            if (verbose)
                printf "Op count: %d\n", opcount
            if (!dump) exit 0
        } else if (dump) {
            i++
            opcount--
        }
        if (!dump)
            i = i == "" ? 0 : i
    }
}
