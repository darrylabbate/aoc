while (<>) { @b = split //; }

for (values @b) {
    $c++;
    $f += ($_ eq '(');
    $f -= ($_ eq ')');
    if ($f == -1) {
        print "$c\n";
        exit;
    }
}
