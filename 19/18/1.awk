BEGIN { 
    FS = ""
    ep = 0
    dp = 0
    delete q
    delete cache
}

{
    for (i = 1; i <= NF; i++) {
        v[i "," NR] = $i
        if ($i ~ /[a-z]/)
            k[$i]  = i "," NR
        # else if ($i ~ /[A-Z]/) 
        #     d[tolower($i)]  = i "," NR
        else if ($i == "@") 
            origin = i "," NR
    }
}

END {
    # for (y = 1; y <= NF; y++) {
    #     for (x = 1; x <= NR; x++) {
    #         printf v[x "," y]
    #     }
    #     printf "\n"
    # }
    for (i in k)
        all_keys = all_keys i
    all_keys = isort(all_keys)
    print collect("@", all_keys)
}

function collect(c,keys,cidx,rk,i,d,nk,res) {
    if (!keys) return 0

    cidx = c "," keys
    if (cidx in cache) return cache[cidx]

    res = 0
    split(reachable(c,keys),rk,"")
    for (i in rk) {
        nk = keys
        sub(rk[i],"",nk)
        d = distance(c,rk[i]) + collect(rk[i],nk)
        res = res > d ? res : d
    }
    cache[cidx] = res
    return res
}

function isort(str,     arr,i,j,l,t,rstr) {
    l = split(str,arr,"")
    for (i = 2; i <= l; i++) {
        for (j = i; j > 1 && arr[j-1] > arr[j]; j--) {
            t = arr[j-1];
            arr[j-1] = arr[j];
            arr[j] = t
        }
    }
    for (i = 1; i <= l; i++)
        rstr = rstr arr[i]
    return rstr
}

function distance(a,b) {
    if (dist[a "," b] == "")
        map_distance(a == "@" ? origin : k[a], \
                     b == "@" ? origin : k[b])
    return dist[a "," b]
}

function reachable(o,keys,    c,coords,cx,cy,s,n,i) {
    if (r[keys]) return r[keys]
    enqueue(o == "@" ? origin : k[o])
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
                } else if (v[n[i]] ~ /[a-z]/ && keys ~ v[n[i]]) {
                    r[keys] = r[keys] v[n[i]]
                    enqueue(n[i])
                } else if (v[n[i]] == ".") {
                    enqueue(n[i])
                }
            }
        }
    }
    empty_queue()
    r[keys] = isort(r[keys])
    return r[keys]
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
    for (i = dp; i <= ep; i++)
        delete q[i]
    ep = 0
    dp = 0
}
