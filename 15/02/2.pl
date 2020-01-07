use List::Util qw(min);

while (<>) {
    @d = split(/x/);
    $t += $d[0] * $d[1] * $d[2]
       +  2 * min $d[0] + $d[1],
                  $d[1] + $d[2],
                  $d[0] + $d[2];
}

print "$t\n";
