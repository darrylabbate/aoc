while (<>) { $n += eval(join("+", /-?\d+/g)); }
print "$n\n";
