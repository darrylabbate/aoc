BEGIN {
    FS = "[ ,]"
    ip = 1
    r["a"] = 1
}

{
    p[NR] = $0
}

END {
    while (ip <= NR) {
        split(p[ip], i)
        if      (i[1] ~ /hlf/) { r[i[2]] /= 2; ip++              }
        else if (i[1] ~ /tpl/) { r[i[2]] *= 3; ip++              }
        else if (i[1] ~ /inc/) { r[i[2]]++;    ip++              }
        else if (i[1] ~ /jmp/) { ip += i[2]                      }
        else if (i[1] ~ /jie/) { ip += (r[i[2]] %  2) ? 1 : i[4] }
        else if (i[1] ~ /jio/) { ip += (r[i[2]] == 1) ? i[4] : 1 }
    }
    print r["b"]
}
