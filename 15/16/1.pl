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
        if (exists $sue{$$i} and $sue{$$i} != $$j) {
            $m = 0;
            break;
        }
    }
    if ($m) {
        print "$.\n";
        exit;
    }
}
