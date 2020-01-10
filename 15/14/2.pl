while (<>) {
    /^(\w+) .*? (\d+) .*? (\d+) .*? (\d+) .*?/;
    $r{$1} = { speed  => $2
             , travel => $3
             , total  => $3 + $4
             };
}

while ($t++ < 2503) {
    for (keys %r) {
        if ((($t-1) % $r{$_}->{total}) < $r{$_}->{travel}) {
            $r{$_}->{dist} += $r{$_}->{speed};
            $max = $r{$_}->{dist} if ($max < $r{$_}->{dist});
        }
    }
    for (keys %r) {
        $r{$_}->{points}++ if ($r{$_}->{dist} == $max);
    }
}

for (keys %r) {
    $w = $r{$_}->{points} if ($w < $r{$_}->{points});
}

print "$w\n";
