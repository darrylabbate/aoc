while (<>) {
    @b = split("");
    foreach $i (@b) {
        $c++;
        $f += ($i eq '(');
        $f -= ($i eq ')');
        if ($f == -1 && !$r) {
            $r = $c;
        }
    }
}

print "$r\n";
