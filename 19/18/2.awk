BEGIN { 
    FS = ""
    ep = 0
    dp = 0
    delete q
}

{
    for (i = 1; i <= NF; i++) {
        v[i "," NR] = $i
        if ($i ~ /[a-z]/)
            k[$i]  = i "," NR
        else if ($i == "@") { 
            ox = i 
            oy = NR
        }
    }
}

END {
    for (i in k) {
        split(k[i],kc,",")
        if (kc[1] < ox) {
            if (kc[2] < oy) keys[1] = keys[1] i
            else            keys[3] = keys[3] i
        } else {
            if (kc[2] < oy) keys[2] = keys[2] i
            else            keys[4] = keys[4] i
        }
    }
    v[ox-1 "," oy-1] = 1
    v[ox   "," oy-1] = "#"
    v[ox+1 "," oy-1] = 2
    v[ox-1 "," oy]   = "#"
    v[ox   "," oy]   = "#"
    v[ox+1 "," oy]   = "#"
    v[ox-1 "," oy+1] = 3
    v[ox   "," oy+1] = "#"
    v[ox+1 "," oy+1] = 4
    k[1] = ox-1 "," oy-1
    k[2] = ox+1 "," oy-1
    k[3] = ox-1 "," oy+1
    k[4] = ox+1 "," oy+1
    for (i = 1; i <= 4; i++)
        d += collect(i, keys[i])
    print d
}

function collect(c,keys,    cidx,rk,i,d,nk,res) {
    if (!keys) return 0
    cidx = c "," keys
    if (cidx in cache) return cache[cidx]
    res = 9999
    split(reachable(c,keys),rk,"")
    for (i in rk) {
        nk = keys
        sub(rk[i],"",nk)
        d = distance(c,rk[i]) + collect(rk[i],nk)
        res = res > d ? d : res
    }
    cache[cidx] = res
    return res
}

function distance(a,b) {
    if (!(a "," b in dist))
        map_distance(k[a], k[b])
    return dist[a "," b]
}

function reachable(o,keys,      idx,c,coords,cx,cy,s,n,i) {
    idx = o "," keys
    if (idx in r) return r[idx]
    enqueue(k[o])
    while (length(q)) {
        c = dequeue()
        split(c,coords,",")
        cx = coords[1]
        cy = coords[2]
        n[0] = cx+1 "," cy
        n[1] = cx-1 "," cy
        n[2] = cx   "," cy+1
        n[3] = cx   "," cy-1
        for (i in n) {
            if (!s[n[i]] && v[n[i]] != "#") {
                s[n[i]] = 1
                if (v[n[i]] ~ /[A-Z]/ && keys !~ tolower(v[n[i]])) {
                    enqueue(n[i])
                } else if (v[n[i]] ~ /[a-z]/) {
                    if (keys ~ v[n[i]])
                        r[idx] = r[idx] v[n[i]]
                    else
                        enqueue(n[i])
                } else if (v[n[i]] ~ /\.|[1-4]/) {
                    enqueue(n[i])
                }
            }
        }
    }
    empty_queue()
    return r[idx]
}

function map_distance(a,b,     c,coords,cx,cy,steps,s,n,i) {
    if (a == b) {
        dist[v[a] "," v[b]] = 0
        dist[v[b] "," v[a]] = 0
        return
    }
    enqueue(a)
    steps[a] = 0
    while (length(q)) {
        c = dequeue()
        if (c == b) {
            dist[v[a] "," v[b]] = steps[b]
            dist[v[b] "," v[a]] = steps[b]
            empty_queue()
        } else {
            split(c,coords,",")
            cx = coords[1]
            cy = coords[2]
            n[0] = cx+1 "," cy
            n[1] = cx-1 "," cy
            n[2] = cx   "," cy+1
            n[3] = cx   "," cy-1
            for (i in n) {
                if (!s[n[i]] && v[n[i]] != "#") {
                    s[n[i]] = 1
                    steps[n[i]] = steps[c] + 1
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
