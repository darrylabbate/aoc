# basic intcode intepreter
# opcodes 1, 2, 99
# prints value in position 0

{
    l = split($0,m,",")
    i = 1
    while (i < l) {
        if (m[i] == "1")
            m[m[i+3]+1] = m[m[i+1]+1] + m[m[i+2]+1]
        else if (m[i] == "2")
            m[m[i+3]+1] = m[m[i+1]+1] * m[m[i+2]+1]
        else if (m[i] == "99")
            break
        i += 4
    }
}

END {
    print m[1]
}
