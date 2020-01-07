use v5.10;
no warnings;

while (<>) { @r = split(//); }

$sx = 0;
$sy = 0;
$rx = 0;
$ry = 0;
$h{$sx,$sy} = 2;

for $i (0..$#r) {
    if (!($i % 2)) {
        given ($r[$i]) {
        ++$h{++$sx,$sy} when '>';
        ++$h{--$sx,$sy} when '<';
        ++$h{$sx,++$sy} when '^';
        ++$h{$sx,--$sy} when 'v';
        }
    } else {
        given ($r[$i]) {
        ++$h{++$rx,$ry} when '>';
        ++$h{--$rx,$ry} when '<';
        ++$h{$rx,++$ry} when '^';
        ++$h{$rx,--$ry} when 'v';
        }
    }
}

$s = keys %h;
print "$s\n"
