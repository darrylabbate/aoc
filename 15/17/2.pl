while (<>) { chomp; $c{$.-1} = $_; }
$n = keys %c;
for $i (1..1<<$n) {
    $cur = 0;
    $c1  = 0;
    for $j (0..$n) {
        if ($i & (1 << $j)) {
            $cur += $c{$j};
            $c1++;
        }
    }
    $count{$c1}++ if ($cur == 150);
}

$min = 9999;
for (keys %count) {
    $min = $_ if ($_ < $min);
}

print "$count{$min}\n";
