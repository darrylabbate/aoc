#!/usr/bin/awk -f

    { freq += $0 }

END { print freq }
