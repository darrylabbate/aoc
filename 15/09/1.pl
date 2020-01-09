while (<>) {
    /(.*) to (.*) = (.*)/;
    $e{$1}{$2} = $3;
    $e{$2}{$1} = $3;
    $shortest += $3;
}

$vertices = keys %e;
traverse($_, 0, $vertices - 1) for (keys %e);
print "$shortest\n";

sub traverse {
    my ($l, $c, $n) = @_;
    if (!$n) {
        $shortest = $c if ($c < $shortest);
    } else {
        $v{$l} = 1;
        for (keys %e) {
            traverse($_, $c + $e{$l}{$_}, $n - 1) if (!$v{$_});
        }
        $v{$l} = 0;
    }
}
