while (<>) {
    /(.*) would (gain|lose) (.*) happiness units by sitting next to (.*)\./;
    if ($2 eq 'lose') {
        $h{$1}{$4} = -$3;
    } else {
        $h{$1}{$4} = $3;
    }
}

for (keys %h) {
    $h{'Darryl'}{$_} = 0;
    $h{$_}{'Darryl'} = 0;
}

$people = keys %h;
arrange($_, $_, 0, $people - 1) for (keys %h);
print "$optimal\n";

sub arrange {
    my ($p0, $p, $t, $n) = @_;
    if (!$n) {
        $t += $h{$p0}{$p} + $h{$p}{$p0};
        $optimal = $t if ($t > $optimal);
    } else {
        $s{$p} = 1;
        for (keys %h) {
            arrange($p0, $_, $t + $h{$p}{$_} + $h{$_}{$p}, $n - 1) if (!$s{$_});
        }
        $s{$p} = 0;
    }
}
