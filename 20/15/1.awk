BEGIN { FS = "," }

{
    for (i = 1; i <= NF; ++i) {
        num[$i]++
        spoken[i] = $i
    }
}

END {
    for (t = NF+1; t <= 2020; ++t) {
        if (num[spoken[t-1]] == 1) {
            num[0]++
            spoken[t] = 0
        } else {
            for (i = t-2; i >= 1; --i) {
                if (spoken[i] == spoken[t-1]) {
                    diff = t - i - 1
                    num[diff]++
                    spoken[t] = diff
                    break
                }
            }
        }
    }
    print spoken[2020]
}
