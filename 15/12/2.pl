use JSON::PP;

$json = decode_json((<>));
print sum($json), "\n";

sub sum {
    my $json = shift;
    my $n    = 0;
    if (ref($json) eq 'HASH') {
        return 0 if grep /red/, %$json;
        $n += sum($_) for %$json;
    } elsif (ref($json) eq 'ARRAY') {
        $n += sum($_) for @$json;
    } elsif (ref($json) eq '') {
        $n = $json;
    }
    return $n;
}
