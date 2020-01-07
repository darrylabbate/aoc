while (<>) {
    @b = split("");
    foreach $i (@b) {
        $f += ($i eq '(');
        $f -= ($i eq ')');
    }
}

print "$f\n";
