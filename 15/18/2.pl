while (<>) {
    @x_axis = split //;
    $l{$_+1,$.} = $x_axis[$_] eq '#' for (0..99);
}

$l{1,1}     = 1;
$l{1,100}   = 1;
$l{100,1}   = 1;
$l{100,100} = 1;

for (1..100) {
    for $y (1..100) {
        for $x (1..100) {
            $n = 0;
            if (exists $l{$x-1,$y-1} and $l{$x-1,$y-1}) { $n++; }
            if (exists $l{$x  ,$y-1} and $l{$x  ,$y-1}) { $n++; }
            if (exists $l{$x+1,$y-1} and $l{$x+1,$y-1}) { $n++; }
            if (exists $l{$x-1,$y  } and $l{$x-1,$y  }) { $n++; }
            if (exists $l{$x+1,$y  } and $l{$x+1,$y  }) { $n++; }
            if (exists $l{$x-1,$y+1} and $l{$x-1,$y+1}) { $n++; }
            if (exists $l{$x  ,$y+1} and $l{$x  ,$y+1}) { $n++; }
            if (exists $l{$x+1,$y+1} and $l{$x+1,$y+1}) { $n++; }

            if ($l{$x,$y}) {
                $new{$x,$y} = ($n == 2 || $n == 3);
            } else {
                $new{$x,$y} = $n == 3;
            }
        }
    }
    $l{$_} = $new{$_} for (keys %l);
    $l{1,1}     = 1;
    $l{1,100}   = 1;
    $l{100,1}   = 1;
    $l{100,100} = 1;
}

$c += $l{$_} for (keys %l);
print "$c\n";
