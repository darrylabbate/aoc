while (<>) { chomp; $pw = $_; }
until (valid($pw)) { ++$pw; }
print "$pw\n";

sub valid {
    $str = shift;
    return !($str =~ /[ilo]/)                      &&
            ($str =~ /(.)\1.*?(.)\2/g && $1 ne $2) &&
            ($str =~ /.*(abc|bcd|cde|def|efg|fgh|pqr|qrs|rst|stu|tuv|uvw|vwx|wxy|xyz).*/);
}
