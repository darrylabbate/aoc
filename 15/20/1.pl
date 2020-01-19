chomp($p = <>);

for $i (1..$p/10) {
    for ($j = $i; $j <= $p/10; $j += $i) {
        $h{$j} += $i * 10;
    }
}

$house = 9999999999;
for (keys %h) {
    $house = $_ if ($h{$_} >= $p and $_ < $house);
}

print "$house\n";
