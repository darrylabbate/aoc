use List::Util qw(min);

$m = 0;
while (<>) {
    /^.*? (\d+) .*? (\d+) .*? (\d+) .*?/;
    $d = $1 * ((int(2503 / ($2 + $3)) * $2) + min($2, 2503 % ($2 + $3)));
    $m = $d if ($d > $m);
}
print "$m\n";
