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
        else if ($i ~ /[A-Z]/) 
            d[tolower($i)]  = i "," NR
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
        keys = keys i
    print keys
}

function distance(a,b) {
    if (dist[a "," b] == "")
        map_distance(a == "@" ? origin : k[a] , \
                     b == "@" ? origin : k[b])
    return dist[a "," b]
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
        r = q[dp]
        delete q[dp++]
        return r
    }
}

function empty_queue(i) {
    for (i = dp; i <= ep; i++)
        delete q[i]
    ep = 0
    dp = 0
}
