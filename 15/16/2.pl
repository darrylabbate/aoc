%sue = (
    children    => 3,
    cats        => 7,
    samoyeds    => 2,
    pomeranians => 3,
    akitas      => 0,
    vizslas     => 0,
    goldfish    => 5,
    trees       => 3,
    cars        => 2,
    perfumes    => 1,
);

while (<>) {
    /Sue \d+: (\w+): (\d+), (\w+): (\d+), (\w+): (\d+)/;
    $m = 1;
    for ($i = 1, $j = 2; $i < 6; $i += 2, $j += 2) {
        if (exists $sue{$$i}) {
            if ($$i eq 'trees' or $$i eq 'cats') {
                $m = 0 if ($sue{$$i} >= $$j);
            } elsif ($$i eq 'pomeranians' or $$i eq 'goldfish') {
                $m = 0 if ($sue{$$i} <= $$j);
            } elsif ($sue{$$i} != $$j) {
                $m = 0;
            }
        }
    }
    if ($m) {
        print "$.\n";
        exit;
    }
}
