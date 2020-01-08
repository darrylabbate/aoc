while (<>) { $t += length(quotemeta($_)) - length($_) + 1; }
print "$t\n";
