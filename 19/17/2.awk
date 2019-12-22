function to_ascii(c) {
    if      (c == "A") return "65"
    else if (c == "B") return "66"
    else if (c == "C") return "67"
    else if (c == "L") return "76"
    else if (c == "R") return "82"
    else if (c == ",") return "44"
    else               return c + 48
}

function build_ascii(arr, i) {
    al = split(arr, as, "")
    i = 1
    while (as[i] != "")
        ascii = ascii to_ascii(as[i++]) " "
    ascii = ascii "10 "
}

function compress(str,      i, j, k) {
    j = 0
    for (sz = 10; sz <= 20; sz++) {
        cand_a = substr(str, 1, sz)
        for (i = sz + 1; i < length(str) - sz; i++) {
            if (cand_a ~ /[0-9]$/ && cand_a == substr(str, i, sz)) {
                a_cands[j++] = cand_a
            }
        }
    }
    str_a = ""
    for (a in a_cands)
        if (length(a_cands[a]) > length(str_a))
            str_a = a_cands[a]
    gsub(str_a, "A", str)
    j = 0
    for (sz = 10; sz <= 20; sz++) {
        cand_b = substr(str, length(str) - sz + 1, sz)
        for (i = 2; i < length(str); i++) {
            if (cand_b ~ /^[R|L]..*[0-9]$/ \
            &&  cand_b == substr(str, i, sz))
                b_cands[j++] = cand_b
        }
    }
    str_b = ""
    for (b in b_cands)
        if (length(b_cands[b]) > length(str_b))
            str_b = b_cands[b]
    gsub(str_b, "B", str)
    j = 0
    for (k = 2; k < length(str) - sz; k++) {
        for (sz = 10; sz <= 20; sz++) {
            cand_c = substr(str, k, sz)
            for (i = 2; i < length(str); i++) {
                if (cand_c ~ /^[R|L]..*[0-9]$/ \
                &&  cand_c == substr(str, i, sz))
                    c_cands[j++] = cand_c
            }
        }
    }
    str_c = ""
    for (c in c_cands)
        if (length(c_cands[c]) > length(str_c))
            str_c = c_cands[c]
    gsub(str_c, "C", str)
    paths[0] = str
    paths[1] = str_a
    paths[2] = str_b
    paths[3] = str_c
}

function map_path() {
    tx = sx
    ty = sy
    if (s[tx-1 "," ty]) { bp = "L"; dir = 4 }
    else                { bp = "R"; dir = 2 }
    while (!eop) {
        st = 0
        if (dir == 1) {
            if (s[tx "," ty-1]) {
                for (; s[tx "," ty-1]; ty--) st++
                bp = bp "," st
            } else if (s[tx-1 "," ty]) {
                bp = bp ",L"
                dir = 4
            } else if (s[tx+1 "," ty]) {
                bp = bp ",R"
                dir = 2
            } else {
                eop = 1
            }
        } else if (dir == 2) {
            if (s[tx+1 "," ty]) {
                for (; s[tx+1 "," ty]; tx++) st++
                bp = bp "," st
            } else if (s[tx "," ty-1]) {
                bp = bp ",L"
                dir = 1
            } else if (s[tx "," ty+1]) {
                bp = bp ",R"
                dir = 3
            } else {
                eop = 1
            }
        } else if (dir == 3) {
            if (s[tx "," ty+1]) {
                for (; s[tx "," ty+1]; ty++) st++
                bp = bp "," st
            } else if (s[tx-1 "," ty]) {
                bp = bp ",R"
                dir = 4
            } else if (s[tx+1 "," ty]) {
                bp = bp ",L"
                dir = 2
            } else {
                eop = 1
            }
        } else if (dir == 4) {
            if (s[tx-1 "," ty]) {
                for (; s[tx-1 "," ty]; tx--) st++
                bp = bp "," st
            } else if (s[tx "," ty-1]) {
                bp = bp ",R"
                dir = 1
            } else if (s[tx "," ty+1]) {
                bp = bp ",L"
                dir = 3
            } else {
                eop = 1
            }
        }
    }
    return bp
}

function print_map() {
    for (y = 0; y <= my; y++) {
        for (x = 0; x <= mx; x++) {
            printf s[x "," y] ? s[x "," y] : " "
        }
        printf "\n"
    }
}

function inp() {
    p[rx] = ascii_seq[k++]
}

function out() {
    if (x == 10 && prev == 10 && !mapped) {
        mapped = 1
        compress(map_path())
        build_ascii(paths[0])
        build_ascii(paths[1])
        build_ascii(paths[2])
        build_ascii(paths[3])
        ascii = ascii "110 10"
        split(ascii,ascii_seq," ")
        k = 1
    }

    if (!mapped) {
        if (x == 10) {
            my = ++vy
            mx = vx > mx ? vx : mx
            vx = 0
        } else if (x == 94) {
            sx = vx
            sy = vy
            s[vx++ "," vy] = 2
        } else {
            s[vx++ "," vy] = x == 35
        }
    } else {
        if (x > 255) {
            printf "%.f\n", x
            exit 0
        }
    }
    prev = x
}

{
    l = split($0,t,",")
    for (j = 0; j < l; j++)
        p[j] = t[j+1]
    os   = 0
    i    = 0
    vx   = 0
    vy   = 0
    p[0] = 2
    mapped = 0
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
    }
}
