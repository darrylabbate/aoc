while (<>) { $t += length($_) - length(eval "\$n = $_") - 1; }
print "$t\n"
