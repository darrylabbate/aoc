while (<>) {
    /(\w+): capacity (-?\d+), durability (-?\d+), flavor (-?\d+), texture (-?\d+), calories (-?\d+)/;
    $cap{$.} = $2;
    $dur{$.} = $3;
    $flv{$.} = $4;
    $txt{$.} = $5;
}

for $a (0..100) {
for $b (0..100-$a) {
for $c (0..100-$a-$b) {
    $d = 100 - $a - $b - $c;
    $e = $cap{1}*$a + $cap{2}*$b + $cap{3}*$c + $cap{4}*$d;
    $f = $dur{1}*$a + $dur{2}*$b + $dur{3}*$c + $dur{4}*$d;
    $g = $flv{1}*$a + $flv{2}*$b + $flv{3}*$c + $flv{4}*$d;
    $h = $txt{1}*$a + $txt{2}*$b + $txt{3}*$c + $txt{4}*$d;

    if ($e <= 0 || $f <= 0 || $g <= 0 || $h <= 0) {
        $score = 0;
    } else {
        $score = $e * $f * $g * $h;
        $max   = $score if ($max < $score);
    }
}}}

print "$max\n";
