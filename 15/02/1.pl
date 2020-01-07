use List::Util qw(min);

while (<>) {
    @d = split(/x/);
    $t += 2 * $d[0] * $d[1]
       +  2 * $d[1] * $d[2]
       +  2 * $d[0] * $d[2]
       +  min $d[0] * $d[1],
              $d[1] * $d[2],
              $d[0] * $d[2];
}

print "$t\n";
