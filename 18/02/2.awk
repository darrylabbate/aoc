BEGIN { FS = "" }

{ id[NR] = $0 }

END {
    for (i = 1; i <= NR; i++) {
        for (j = i + 1; j <= NR; j++) {
            for (k = 1; k <= NF; k++) {
                if (substr(id[i], k, 1) != substr(id[j], k, 1))
                    diff++
                else
                    boxid = boxid substr(id[i], k, 1)
            }
            if (diff == 1) {
                print boxid
                exit 0
            } else {
                boxid = ""
                diff  = 0
            }
        }
    }
}
