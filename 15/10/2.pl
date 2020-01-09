while (<>) {
    chomp;
    while ($n++ < 50) {
        $_ =~ s/(\d)\1*/length($&) . $1/eg;
    }
    print length($_), "\n";
}
