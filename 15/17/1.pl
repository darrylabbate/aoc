while (<>) { chomp; $c{$.-1} = $_; }
$n = keys %c;
for $i (1..1<<$n) {
    $cur = 0;
    for $j (0..$n) {
        $cur += $c{$j} if ($i & (1 << $j));
    }
    $count++ if ($cur == 150);
}

print "$count\n";
