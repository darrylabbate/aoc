use v5.10;
no warnings;

while (<>) { @r = split(//); }

$x = 0;
$y = 0;
$h{$x,$y} = 1;

for $i (0..$#r) {
    given ($r[$i]) {
    ++$h{++$x,$y} when '>';
    ++$h{--$x,$y} when '<';
    ++$h{$x,++$y} when '^';
    ++$h{$x,--$y} when 'v';
    }
}

$s = keys %h;
print "$s\n"
