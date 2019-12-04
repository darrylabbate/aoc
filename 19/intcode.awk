# basic intcode intepreter
# opcodes 1, 2, 99
# prints value in position 0

{
    l = split($0,m,",")
    for (i = 1; i < l; i += 4) {
        if (m[i] == "1")
            m[m[i+3]+1] = m[m[i+1]+1] + m[m[i+2]+1]
        else if (m[i] == "2")
            m[m[i+3]+1] = m[m[i+1]+1] * m[m[i+2]+1]
        else if (m[i] == "99")
            break
    }
}

END {
    print m[1]
}
