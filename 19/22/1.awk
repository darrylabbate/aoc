BEGIN { n = 10007; c = 2019 }
/cut/ { c =  c - $2 % n + n }
/inc/ { c =  c * $4 % n     }
/new/ { c = -c -  1 % n + n }
END   { print c             }
