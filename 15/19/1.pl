while (<>) {
    last if /^$/;
    /^(\w+) => (\w+)$/;
    push @repl, [$1,$2];
}
chomp($m = <>);

for (@repl) {
    ($k, $v) = @$_;
    for $i (0..(length($m)-length($k))) {
        if ($k eq substr $m, $i, length($k)) {
            $s{substr($m, 0, $i) . $v . substr($m, $i + length($k))} = 1;
        }
    }
}

$n = keys %s;
print "$n\n";
