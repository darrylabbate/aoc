BEGIN {
    FS = ""
    ep = 0
    dp = 0
    delete q
}

{
    for (i = 1; i <= NF; i++)
        m[i "," NR] = $i
}

END {
    for (i in m) {
        if (m[i] ~ /[A-Z]/) {
            split(i,c,",")
            x = c[1]
            y = c[2]
            if (m[x "," y+1] ~ /[A-Z]/) {
                if (m[x "," y+2] == ".") {
                    m[x "," y+2] = m[i] m[x "," y+1]
                    m[x "," y+1] = m[i] = " "
                    if (y == 1) outer[x "," y+2] = 1
                    else        inner[x "," y+2] = 1
                } else if (m[x "," y-1] == ".") {
                    m[x "," y-1] = m[i] m[x "," y+1]
                    m[x "," y+1] = m[i] = " "
                    if (y == NR-1) outer[x "," y-1] = 1
                    else           inner[x "," y-1] = 1
                }
            } else if (m[x+1 "," y] ~ /[A-Z]/) {
                if (m[x+2 "," y] == ".") {
                    m[x+2 "," y] = m[i] m[x+1 "," y]
                    m[x+1 "," y] = m[i] = " "
                    if (x == 1) outer[x+2 "," y] = 1
                    else        inner[x+2 "," y] = 1
                } else if (m[x-1 "," y] == ".") {
                    m[x-1 "," y] = m[i] m[x+1 "," y]
                    m[x+1 "," y] = m[i] = " "
                    if (x == NF-1) outer[x-1 "," y] = 1
                    else           inner[x-1 "," y] = 1
                }
            }
        }
    }
    for (i in m) {
        if (m[i] ~ /[A-Z]/) {
            if (!p[m[i]]) {
                p[m[i]] = i
            } else {
                t = p[m[i]]
                m[t] = i
                m[i] = t
            }
        }
    }
    print traverse("AA","ZZ",0,0)
}

function traverse(a,b,l,lt,      c,coords,cx,cy,steps,s,n,i) {
    enqueue(p[a] "," l "," lt)
    steps[a] = 0
    while (length(q)) {
        c = dequeue()
        split(c,coords,",")
        cx = coords[1]
        cy = coords[2]
        l  = coords[3]
        lt = coords[4]
        if (cx "," cy == p[b] && !l) {
            return steps[cx "," cy] + lt
        } else {
            n[0] = cx+1 "," cy
            n[1] = cx-1 "," cy
            n[2] = cx   "," cy+1
            n[3] = cx   "," cy-1
            for (i in n) {
                if (!s[n[i] "," l] && m[n[i]] != "#" && m[n[i]] != " ") {
                    s[n[i] "," l] = 1
                    if (m[n[i]] ~ /[0-9]/) {
                        n[i] = m[n[i]]
                        if (outer[n[i]])
                            enqueue(n[i] "," l+1 "," lt+1)
                        else if (inner[n[i]] && l > 0)
                            enqueue(n[i] "," l-1 "," lt+1)
                        steps[n[i]] = steps[cx "," cy] + 1
                    } else {
                        steps[n[i]] = steps[cx "," cy] + 1
                        enqueue(n[i] "," l "," lt)
                    }
                }
            }
        }
    }
}

function enqueue(x) {
    q[ep++] = x
}

function dequeue() {
    if (!length(q))
        return 0
    else {
        ret = q[dp]
        delete q[dp++]
        return ret
    }
}

function empty_queue(i) {
    for (i in q)
        delete q[i]
    ep = 0
    dp = 0
}
