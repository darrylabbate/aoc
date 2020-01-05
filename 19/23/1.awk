BEGIN {
    comps = 50
    delete q
}

function inp() {
    i += 2
    if (!ic[c]) {
        ic[c]++
        p[c","rx] = c
        transfer((c+1) % comps)
    } else {
        v = dequeue()
        p[c "," rx] = v
        if (v < 0)
            transfer((c+1) % comps)
    }
}

function out() {
    i += 2
    if (++oc % 3 == 1) {
        addr = x
    } else if (oc % 3 == 2) {
        enqueue(x)
    } else if (!(oc % 3)) {
        if (addr == 255) {
            print x
            exit 0
        }
        enqueue(x)
        transfer(addr)
    }
}

function enqueue(x) {
    q[addr "," ep[addr]++] = x
}

function dequeue() {
    if (ep[c] == dp[c]) {
        return -1
    } else {
        ret = q[c "," dp[c]]
        delete q[c "," dp[c]++]
        return ret
    }
}

function transfer(nxt) {
    ip[c] = i
    i     = ip[nxt]
    c     = nxt
}

{
    l = split($0,t,",")
    for (i = 0; i < comps; i++) {
        ip[i] = 0
        ic[i] = 0
        os[i] = 0
        ep[i] = 0
        dp[i] = 0
        for (j = 0; j < l; j++)
            p[i "," j] = t[j+1]
    }
    c  = 0
    i  = 0
    while (op < 99) {
        op  = p[c","i]
        xm  = int(op/100)   % 10
        ym  = int(op/1000)  % 10
        zm  = int(op/10000) % 10
        op %= 100
        x   = xm == 1 ? p[c","i+1]              \
            : xm == 2 ? p[c","p[c","i+1]+os[c]] \
            : p[c","p[c","i+1]]
        y   = ym == 1 ? p[c","i+2]              \
            : ym == 2 ? p[c","p[c","i+2]+os[c]] \
            : p[c","p[c","i+2]]
        rx  = xm ? p[c","i+1]+os[c] : p[c","i+1]
        rz  = zm ? p[c","i+3]+os[c] : p[c","i+3]
        if      (op == 1) { p[c","rz] = x + y;  i += 4 }
        else if (op == 2) { p[c","rz] = x * y;  i += 4 }
        else if (op == 3) { inp();                     }
        else if (op == 4) { out();                     }
        else if (op == 5) { i =  x ? y :        i +  3 }
        else if (op == 6) { i = !x ? y :        i +  3 }
        else if (op == 7) { p[c","rz] = x <  y; i += 4 }
        else if (op == 8) { p[c","rz] = x == y; i += 4 }
        else if (op == 9) { os[c] += x;         i += 2 }
    }
}
