BEGIN {
    FS = ""
    ep = 0
    dp = 0
    delete q
}

{
    for (i = 1; i <= NF; i++)
        m[i,NR] = $i
}

END {
    for (i in m) {
        if (m[i] ~ /[A-Z]/) {
            split(i,c,SUBSEP)
            x = c[1]
            y = c[2]
            if (m[x,y+1] ~ /[A-Z]/) {
                if (m[x,y+2] == ".") {
                    m[x,y+2] = m[i] m[x,y+1]
                    m[x,y+1] = m[i] = " "
                } else if (m[x,y-1] == ".") {
                    m[x,y-1] = m[i] m[x,y+1]
                    m[x,y+1] = m[i] = " "
                }
            } else if (m[x+1,y] ~ /[A-Z]/) {
                if (m[x+2,y] == ".") {
                    m[x+2,y] = m[i] m[x+1,y]
                    m[x+1,y] = m[i] = " "
                } else if (m[x-1,y] == ".") {
                    m[x-1,y] = m[i] m[x+1,y]
                    m[x+1,y] = m[i] = " "
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
    print traverse("AA","ZZ")
}

function traverse(a,b,      c,coords,cx,cy,steps,s,n,i) {
    enqueue(p[a])
    steps[a] = 0
    while (length(q)) {
        c = dequeue()
        if (c == p[b]) {
            return steps[c]
        } else {
            split(c,coords,SUBSEP)
            cx = coords[1]
            cy = coords[2]
            n[0] = cx+1 SUBSEP cy
            n[1] = cx-1 SUBSEP cy
            n[2] = cx   SUBSEP cy+1
            n[3] = cx   SUBSEP cy-1
            for (i in n) {
                if (!s[n[i]] && m[n[i]] != "#" && m[n[i]] != " ") {
                    s[n[i]] = 1
                    if (m[n[i]] ~ /[0-9]/) {
                        n[i] = m[n[i]]
                        steps[n[i]] = steps[c] + 2
                    } else {
                        steps[n[i]] = steps[c] + 1
                    }
                    enqueue(n[i])
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
