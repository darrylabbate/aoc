while (<>) {
    last if /^$/;
    /^(\w+) => (\w+)$/;
    $str{$1} = 1;
}
chomp($m = <>);

$t += count($_) for (keys %str);
$t -= count(Y);
print "$t\n";

sub count {
    my $n;
    my ($s) = @_;
    for $i (0..length($m)) {
        $n++ if ($s eq substr($m, $i, length($s)));
    }
    return $n;
}
