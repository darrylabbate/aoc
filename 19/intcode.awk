# Intcode assembler, disassembler and interpreter
#
# USAGE:
#   awk -f intcode.awk file             | Interpret a program
#   awk -v x=1 -f intcode.awk file      | Enable option `x`
#   awk -v i=1,2,3 -f intcode.awk file  | Pass a series of inputs
#
# AVAILABLE SWITCHES:
#   a  | [1] ASCII mode (converts input vector and outputs to ASCII)
#   db | [1] Invoke interactive debugging session
#   d  | [1] Dump disassembly
#   i  | [n,m,...] The input vector the program reads from
#   v  | [1] Print disassembly verbosely

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
        error(3, "Control reached input instruction with empty input vector")
    ip += 2
}

function output() {
    if (!v) {
        if (a && x >= 0 && x <= 127)
            printf "%c", x
        else 
            printf "%.f\n", x
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
    if (db) {
        brk = "─"
        "tput lines" | getline height
        close("tput lines")
        hsize = int(height/2) - 4
        "tput cols" | getline width
        close("tput cols")
        lfile = length(ARGV[1])
        delete bp
        db_sep     = _db_build_sep()
        db_mem_sep = _db_build_sep("memory")
    }
}

/^[0-9]/ {
    format     = "Intcode"
    db_asm_sep = _db_build_sep("disassembly")
    prog       = $0
}

opcode[$1] {
    asm_ln_count++
    format     = "asm"
    db_asm_sep = _db_build_sep(sprintf("source:%s", FILENAME))
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
    init(prog)
    if (db) _db_init()

    if (d)  disas(0, 0, l)
    else    interpret()
}

function _db_init() {
    if (asm_ln_count <= (height - 7))
        full_disas = 1
    for (j in p)
        mdigits += length(p[j]) + 1
    if (mdigits <= width)
        full_mem = 1
    _db_parse_inp()
}

function print_ops(pp,rop,op,p1,p2,p3,    ln) {
    if (db) {
        if (pp == ip)
            printf "\033[32m-> "
        else
            printf "   "
    } 
    ln = build_ins_ln(pp,rop,op,p1,p2,p3)
    printf "%.*s\n", width - 3, ln
    if (db && pp == ip)
        printf "\033[0m"
    return ln
}

function build_ins_ln(pp,rop,op,p1,p2,p3,    ln,p_str) {
    ln = sprintf("%*d:  ", ldigits, pp)
    if (v || (db && width > 70)) {
        if (p1 != "") p_str = p[pp+1]
        if (p2 != "") p_str = p_str " " p[pp+2]
        if (p3 != "") p_str = p_str " " p[pp+3]
        if (!opname[op])
            p_str = sprintf("      %-16s", rop)
        else
            p_str = sprintf("%5d %-16s", rop, p_str)
        ln = ln p_str
    }
    ln = ln sprintf("%-6s", opname[op] ? opname[op] : "nop")
    if (!opname[op]) {
        ln = ln sprintf("%s", rop)
    } else {
        if (p1 != "") ln = ln sprintf("%s", p1)
        if (p2 != "") ln = ln sprintf(", %s", p2)
        if (p3 != "") ln = ln sprintf(", %s", p3)
    }
    return ln
}

function rel_str(p,rb) {
    rb_op = p >= 0 ? "+" : ""
    return p == 0 ? "*" rb : "*(" rb rb_op p ")"
}

function init(prog) {
    init_mem_len = split(prog,ref)
    for (j = 0; j < init_mem_len; j++)
        p[j] = ref[j+1]
    ldigits = length(init_mem_len)
    rb = 0
    ip = 0
    if (v)
        printf "\n%s (%d ints, %s) %s\n\n", FILENAME, init_mem_len, format, mode
    before()
}

function _db_print_mem(    memstr) {
    if (full_mem) {
        for (j = 0; j < ip; j++)
            memstr = memstr sprintf("\033[90m%s ", p[j])
        memstr = memstr sprintf("\033[32m%s\033[0m", p[ip])
        for (j = ip+1; j < init_mem_len; j++)
            memstr = memstr " " p[j]
    } else {
        memstr = "[" p[ip] "]"
        for (j = ip+1; length(memstr) < width; j++) {
            memstr = memstr " " p[j]
        }
    }
    printf "%.*s\n", width, memstr
}

function _db_print_disas(   offset,cur) {
    if (full_disas) {
        for (j = 0; j < ip; j++) {
            if (hist[j]) {
                printf "\033[90m   %s\n", hist[j]
                offset++
            }
        }
        split(disas(ip,rb,1),cur,SUBSEP)
        hist[ip] = cur[2]
        disas(cur[1], rb, asm_ln_count - offset)
    } else {
        for (j = hsize; j > 0; j--) {
            if (hist[j]) printf "\033[90m   %s\n", hist[j]
            else offset++
        }
        printf "\033[0m"
        for (j = hsize; j > 0; j--)
            hist[j] = hist[j-1]
        split(disas(ip,rb,1),cur,SUBSEP)
        hist[1] = cur[2]
        disas(cur[1], rb, hsize + offset + 1)
    }
}

function _db_output() {
    printf "\033[2J\033[1;1H\033[0m"
    printf "RB => %d\n", rb
    printf "%s\n", db_mem_sep
    _db_print_mem()
    printf "%s\n", db_asm_sep
    _db_print_disas()
    printf "%s\n", db_sep
    printf "[\033[1;36m#%d\033[0m] ", icount
}

function _db_eval() {
    if (ip in bp) {
        _db_output()
        printf "\033[1;31mstopped\033[0m, reason: \033[1;33mBREAKPOINT\033[0m\n"
        _db_parse_inp()
    } else if (!--stepc) {
        _db_output()
        printf "\033[1;31mstopped\033[0m, reason: \033[1;33mSINGLE STEP\033[0m\n"
        _db_parse_inp()
    }
}

function _db_parse_inp(str) {
    printf "idb> "
    getline str < "-"
    if (str == "q") {
        print "Exit"
        exit 0
    } else if (str == "d") {
        v = 1
        disas(0, init_mem_len)
        v = 0
        _db_parse_inp()
    } else if (str == "r" && !ip) {
        printf "Starting program:\n"
        interpret()
    } else if (str ~ /^b/) {
        sub("b ","",str)
        if (!bp[str]) {
            printf "Breakpoint #%d set at memory location %d\n", ++bpc, str
            bp[str] = bpc
        } else {
            printf "Breakpoint already set at memory location %d\n", str
        }
        _db_parse_inp()
    } else if (str ~ /^[0-9]/) {
        stepc = str
    } else if (str == "s") {
        stepc = 1
    } else {
        printf "Unknown command: %s\n", str
        _db_parse_inp()
    }
    return
}

function interpret() {
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
        if (db) {
            _db_eval()
        } else if (v) {
            px  = xm == 1 ? x                          \
                : xm == 2 ? rel_str(p[ip+1],rb) "->" x \
                : "*" p[ip+1] "->" x
            py  = ym == 1 ? y                          \
                : ym == 2 ? rel_str(p[ip+2],rb) "->" y \
                : "*" p[ip+2] "->" y
            pz  = zm ? rel_str(p[ip+3],rb) "->" p[rz]  \
                : "*" p[ip+3] "->" p[rz]
            if      (op == 1)  { print_ops(ip,rop,op,px,py,pz) }
            else if (op == 2)  { print_ops(ip,rop,op,px,py,pz) }
            else if (op == 3)  { print_ops(ip,rop,op,px)       }
            else if (op == 4)  {
                print_ops(ip,rop,op,px)
                x = x == "" ? 0 : x
                outv[++outc] = x
            }
            else if (op == 5)  { print_ops(ip,rop,op,px,py)    }
            else if (op == 6)  { print_ops(ip,rop,op,px,py)    }
            else if (op == 7)  { print_ops(ip,rop,op,px,py,pz) }
            else if (op == 8)  { print_ops(ip,rop,op,px,py,pz) }
            else if (op == 9)  { print_ops(ip,rop,op,px)       }
            else if (op == 99) {
                print_ops(ip,rop,op)
                printf "\nHalted successfully\n"
                printf "Instruction count: %d\n", icount
                if (outv[1] != "") flush_output()
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

function disas(dp, rb, steps,    dc,rop,op,xm,ym,zm,x,y,rz) {
    dp = (dp == "" || dp < 0) ? 0 : dp
    if (!steps) steps =init_mem_len
    while (dc++ < steps && dp < init_mem_len) {
        rop = op = p[dp]
        xm  = int(op/100)   % 10
        ym  = int(op/1000)  % 10
        zm  = int(op/10000) % 10
        op %= 100
        x   = xm == 1 ? p[dp+1] : xm == 2 ? p[p[dp+1]+rb] : p[p[dp+1]]
        y   = ym == 1 ? p[dp+2] : ym == 2 ? p[p[dp+2]+rb] : p[p[dp+2]]
        rz  = zm ? p[ip+3]+rb : p[ip+3]
        p[rz] = p[rz] == "" ? 0 : p[rz]
        if (db) {
            x  = xm == 1 ? x                          \
               : xm == 2 ? rel_str(p[dp+1],rb) "->" x \
               : "*" p[dp+1] "->" x
            y  = ym == 1 ? y                          \
               : ym == 2 ? rel_str(p[dp+2],rb) "->" y \
               : "*" p[ip+2] "->" y
            z  = zm ? rel_str(p[dp+3],rb) "->" p[rz]  \
               : "*" p[ip+3] "->" p[rz]
        } else {
            x  = xm == 1 ? p[dp+1]                  \
               : xm == 2 ? rel_str(p[dp+1], rb_str) \
               : "*" p[dp+1]
            y  = ym == 1 ? p[dp+2]                  \
               : ym == 2 ? rel_str(p[dp+2], rb_str) \
               : "*" p[dp+2]
            z  = zm ? rel_str(p[dp+3], rb_str)      \
               : "*" p[dp+3]
        }
        if      (op == 1)  { ln = print_ops(dp,rop,op,x,y,z); dp += 4 }
        else if (op == 2)  { ln = print_ops(dp,rop,op,x,y,z); dp += 4 }
        else if (op == 3)  { ln = print_ops(dp,rop,op,x);     dp += 2 }
        else if (op == 4)  { ln = print_ops(dp,rop,op,x);     dp += 2 }
        else if (op == 5)  { ln = print_ops(dp,rop,op,x,y);   dp += 3 }
        else if (op == 6)  { ln = print_ops(dp,rop,op,x,y);   dp += 3 }
        else if (op == 7)  { ln = print_ops(dp,rop,op,x,y,z); dp += 4 }
        else if (op == 8)  { ln = print_ops(dp,rop,op,x,y,z); dp += 4 }
        else if (op == 9)  { ln = print_ops(dp,rop,op,x);     dp += 2 }
        else if (op == 99) { ln = print_ops(dp,rop,op);       dp ++   }
        else               { ln = print_ops(dp,rop);          dp ++   }
    }
    return dp SUBSEP ln
}

function error(code, msg) {
    printf "\n\033[31merror:\033[0m %s\n"            \
           "  at memory location %.f (Opcode %.f)\n" \
           "  instruction #%d\n", msg, ip, p[ip], icount
    if (v) flush_output()
    exit code
}

function flush_output() {
    printf "\n--- BEGIN OUTPUT ---\n"
    for (j = 1; j <= length(outv); j++) {
        if (a && outv[j] >= 0 && outv[j] <= 127)
            printf "%c", outv[j]
        else
            printf "%.f ", outv[j]
    }
    printf "\n--- END OUTPUT ---\n"
}

function _db_build_sep(txt,    sep) {
    if (!txt) {
        sep = sprintf("\033[90m")
        for (j = 0; j < width; j++)
            sep = sep sprintf("%s", brk)
        sep = sep sprintf("\033[0m")
    } else {
        sep = sprintf("\033[90m")
        for (j = 0; j < width - 5 - length(txt); j++)
            sep = sep sprintf("%s", brk)
        sep = sep sprintf("\033[1;34m %s \033[90m", txt)
        for (j = 0; j < 3; j++)
            sep = sep sprintf("%s", brk)
        sep = sep sprintf("\033[0m")
    }
    return sep
}
