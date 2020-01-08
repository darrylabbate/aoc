while (<>) {
    @f = split('[ ,]');
    if (/(on|off)/) { toggle($f[1], $f[2], $f[3], $f[5], $f[6]); }
    else            { toggle($f[1], $f[2], $f[4], $f[5]);        }
}

sub toggle {
    $t = (@_ == 4);
    $m = (@_ >  4) ? shift : 0;
    for $y ($_[1]..$_[3]) {
        for $x ($_[0]..$_[2]) {
            if ($t) { $l{$x,$y} += 2; }
            else    { $l{$x,$y} += ($m =~ /on/) ? 1 : -1; }
            if ($l{$x,$y} < 0) { $l{$x,$y} = 0; }
        }
    }
}

for $v (values %l) { $o += $v; }
print "$o\n"
