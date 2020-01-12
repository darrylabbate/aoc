while (<>) {
    /(toggle|turn on|turn off) (\d+),(\d+) through (\d+),(\d+)/;
    toggle($1, $2, $3, $4, $5);
}

sub toggle {
    my ($c, $x1, $y1, $x2, $y2) = @_;
    if ($c =~ m/^tog/) {
        $c = 2;
    } else {
        $c = ($c =~ m/on/);
    }
    for $y ($y1..$y2) {
        for $x ($x1..$x2) {
            $l{$x,$y} += $c > 1 ? 2 : $c ? 1 : -1;
            $l{$x,$y}  = 0 if $l{$x,$y} < 0;
        }
    }
}

$o += $_ for (values %l);
print "$o\n"
