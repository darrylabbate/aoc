BEGIN {
    RS = ""
    FS = "[ :\n]"
}

/byr/ && /iyr/ && /eyr/ && /hgt/ && /hcl/ && /ecl/ && /amb|blu|brn|grn|gry|hzl|oth/ && /pid/ {
    for (i=1;i<=NF;i+=2) {
        if ($i~/byr/) {
            if ($(i+1) < 1920 || $(i+1) > 2002)
                next
        } else if ($i ~ /iyr/) {
            if ($(i+1) < 2010 || $(i+1) > 2020)
                next
        } else if ($i ~ /eyr/) {
            if ($(i+1) < 2020 || $(i+1) > 2030)
                next
        } else if ($i ~ /hcl/) {
            if ($(i+1) !~ /#[[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]]/)
                next
        } else if ($i ~ /hgt/ && $(i+1) ~/cm/) {
            if ($(i+1) < 150 || $(i+1) >= 194)
                next
        } else if ($i ~ /hgt/ && $(i+1) ~ /in/) {
            if ($(i+1) < 59 || $(i+1) > 76)
                next
        } else if ($i ~ /pid/) {
            if ($(i+1)!~/^\d\d\d\d\d\d\d\d\d/ && (length($(i+1)) != 9))
                next
        }
    }
    n++
}

END { print n }
