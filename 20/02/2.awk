BEGIN { FS="[ \-:]*" }

{
    if ((substr($4,$1,1)  ~ $3 && substr($4,$2,1) !~ $3)
    ||  (substr($4,$1,1) !~ $3 && substr($4,$2,1)  ~ $3))
        n++
}

END { print n }
