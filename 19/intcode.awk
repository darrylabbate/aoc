# basic intcode intepreter
# opcodes 1, 2, 99
# the value in position 0 at the time of termination gets printed only
# if the program properly halts with opcode 99

{
    l = split($0,m,",")
    for (i = 1; i <= l; i += 4) {
        if (m[i] == "1")
            m[m[i+3]+1] = m[m[i+1]+1] + m[m[i+2]+1]
        else if (m[i] == "2")
            m[m[i+3]+1] = m[m[i+1]+1] * m[m[i+2]+1]
        else if (m[i] == "99") {
            print m[1]
            exit 0
        } else
            exit 1
    }
}
