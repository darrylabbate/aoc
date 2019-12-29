BEGIN { 
    FS = ""
    delete q
    qe = 0
    qd = 0
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
    bfs(origin, k["a"])
}

function bfs(a,b,     c,coords,cx,cy,steps) {
    enqueue(a)
    while (length(q)) {
        c = dequeue()
        steps++
        if (c == b) {
            printf "Found node %s (%s) at %s\n", v[b], steps, c
            break
        } else {
            split(c,coords,",")
            cx = coords[1]
            cy = coords[2]
            n[0] = cx+1 "," cy
            n[1] = cx-1 "," cy
            n[2] = cx "," cy+1
            n[3] = cx "," cy-1

            for (i in n) {
                if (v[n[i]] == "#")
                    s[n[i]] = 2
                if (s[n[i]] < 2) {
                    # printf "At node %s: %s\n", n[i], v[n[i]]
                    s[n[i]] = 1
                    enqueue(n[i])
                }
            }
            s[c] = 2
        }
    }
}

function enqueue(x) {
    q[qe++] = x
}

function dequeue() {
    if (!length(q))
        return 0
    else {
        r = q[qd]
        delete q[qd++]
        return r
    }
}
