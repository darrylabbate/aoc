use Digest::MD5 qw(md5_hex);

chomp($k = <>);
while (1) {
    if (md5_hex($k . ++$x) =~ /^00000/) {
        print "$x\n";
        exit;
    }
}
