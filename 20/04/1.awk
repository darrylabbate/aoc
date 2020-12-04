BEGIN{ RS = "\n\n" }

/byr/ && /iyr/ && /eyr/ && /hgt/ && /hcl/ && /ecl/ && /pid/ {
    n++
}

END { print n }
