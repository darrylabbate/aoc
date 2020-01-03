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
                    m[x "," y+1] = m[i] m[x "," y+1]
                    m[i] = " "
                } else if (m[x "," y-1] == ".") {
                    m[i] = m[i] m[x "," y+1]
                    m[x "," y+1] = " "
                }
            } else if (m[x+1 "," y] ~ /[A-Z]/) {
                if (m[x+2 "," y] == ".") {
                    m[x+1 "," y] = m[i] m[x+1 "," y]
                    m[i] = " "
                } else if (m[x-1 "," y] == ".") {
                    m[i] = m[i] m[x+1 "," y]
                    m[x+1 "," y] = " "
                }
            }
        }
    }
    for (i in m) {
        if (m[i] ~ /[A-Z]/) {
            if (!p[m[i]]) {
                p[m[i]] = i
                # print i,m[i],p[m[i]]
            } else {
                print i,m[i],p[m[i]]
                t = m[i]
                m[i] = p[m[i]]
                p[m[t]] = i
                print i,m[i],p[m[i]]
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
