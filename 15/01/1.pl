while (<>) { @b = split //; }

for (values @b) {
    $f += $_ eq '(';
    $f -= $_ eq ')';
}

print "$f\n";
