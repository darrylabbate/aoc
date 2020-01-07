use Digest::MD5 qw(md5_hex);

while (<>) {
    chomp;
    while (1) {
        if (md5_hex($_ . ++$x) =~ /^000000/) {
            print "$x\n";
            exit;
        }
    }
}
