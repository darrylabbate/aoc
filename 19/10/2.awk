BEGIN {FS = ""}

{
    for (i = 1; i <= NF; i++)
        c[i-1 "," NR-1] = $i == "#"
}

function isort(arr,n,i,j,t) { 
    for (i = 0; i < n; i++) {
        for (j = i; j > 0 && arr[j-1] > arr[j]; j--) {
            t = arr[j-1];
            arr[j-1] = arr[j];
            arr[j] = t
        }
    }
}

function remove_dupes(arr,n,i,k) {
    for (i = 0; i < n; i++) {
        while (arr[i] == arr[i+1]) {
            for (k = i + 1; k < n; k++) {
                arr[k] = arr[k+1]
            }
            n--
        }
    }
    return n
}

function add_asteroid(x,y,sl) {
    if (!(as[sl]))
        as[sl] = x "," y
    else {
        temp = as[sl]
        as[sl] = x "," y
        as[x "," y] = temp
    }
}

END {
    max = 0
    for (y = 0; y < NR; y++) {
    for (x = 0; x < NF; x++) {
        if (c[x "," y]) {
            for (b = 0; b < NR; b++) {
            for (a = 0; a < NF; a++) {
                if (c[a "," b]) {
                    sl = atan2(y-b,x-a)
                    if (!(s[sl])) {
                        s[sl] = a "," b
                        d[x "," y]++
                    }
                }
            }}
            if (d[x "," y] > max) {
                max = d[x "," y]
                ax  = x
                ay  = y
            }
            for (i in s)
                s[i] = 0
        }
    }}
    j = 0
    for (y = 0; y <= ay; y++) {
    for (x = ax; x < NF; x++) {
        if ((x != ax || y != ay) && c[x "," y]) {
            sl = atan2(ay-y,ax-x)
            r[j++] = sl
            add_asteroid(x,y,sl)
        }
    }}
    isort(r,j)
    j = remove_dupes(r,j)
    k = 0
    for (y = NR; y > ay; y--) {
    for (x = NF; x > ax; x--) {
        if ((x != ax || y != ay) && c[x "," y]) {
            sl = atan2(ay-y,ax-x)
            q[k++] = sl
            add_asteroid(x,y,sl)
        }
    }}
    for (y = NR; y > ay; y--) {
    for (x = 0; x <= ax; x++) {
        if ((x != ax || y != ay) && c[x "," y]) {
            sl = atan2(ay-y,ax-x)
            q[k++] = sl
            add_asteroid(x,y,sl)
        }
    }}
    for (y = 0; y <= ay; y++) {
    for (x = 0; x < ax; x++) {
        if ((x != ax || y != ay) && c[x "," y]) {
            sl = atan2(ay-y,ax-x)
            q[k++] = sl
            add_asteroid(x,y,sl)
        }
    }}
    isort(q,k)
    k = remove_dupes(q,k)
    for (i = 0; i < j; i++)
        arr[i] = r[i]
    for (j = 0; j < k; i++)
        arr[i] = q[j++]
    split(as[arr[199]],t,",")
    print t[1] * 100 + t[2]
}
