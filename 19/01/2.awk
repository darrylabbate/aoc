function calc(x, y) {
    x = int(x/3)-2
    return x > 0 ? calc(x, x+y) : y
}

{ f += calc($0, 0) }

END { print f }
