while (<>) {
    /(.*) -> (.*)/;
    $w{$2} = $1;
}

print _eval('a'), "\n";

sub _eval {
    my $idx = shift;
    return $s{$idx} if ($s{$idx});
    return $idx     if ($idx =~ /^\d+$/);
    my $exp = $w{$idx};
    if ($exp =~ /^(\w+)$/) {
        $s{$idx} = _eval($1);
    } elsif ($exp =~ /NOT (\w+)/) {
        $s{$idx} = ~_eval($1);
    } else {
        $exp =~ /(.*) (.*) (.*)/;
        my $x  = $1;
        my $op = $2;
        my $y  = $3;
        $x = _eval($x);
        $y = _eval($y);
        if    ($op eq 'AND'   ) { $s{$idx} = $x &  $y; }
        elsif ($op eq 'OR'    ) { $s{$idx} = $x |  $y; }
        elsif ($op eq 'RSHIFT') { $s{$idx} = $x >> $y; }
        elsif ($op eq 'LSHIFT') { $s{$idx} = $x << $y; }
    }
    return $s{$idx};
}
