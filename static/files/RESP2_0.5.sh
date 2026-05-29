#!/bin/bash

read -p "Enter gas phase CHG file path:" file1
read -p "Enter solvent phase CHG file path: " file2

if [ ! -f "$file1" ]; then
    echo "Error: File '$file1' does not exist"
    exit 1
fi
if [ ! -f "$file2" ]; then
    echo "Error: File '$file2' does not exist"
    exit 1
fi

awk '
    NR == FNR {
        name[NR]  = $1
        x[NR]     = $2
        y[NR]     = $3
        z[NR]     = $4
        charge1[NR] = $5
        lines1 = NR
        next
    }

    {
        if (FNR <= lines1) {
            avg = (charge1[FNR] + $5) / 2.0
            printf "%-12s %12.6f %12.6f %12.6f %12.10f\n", name[FNR], x[FNR], y[FNR], z[FNR], avg
        } else {
            print "Warning: Extra line " FNR " in second file, ignored" > "/dev/stderr"
        }
    }

    END {
        if (NR - lines1 < lines1) {
            print "Warning: Second file has fewer lines than first, possible data loss" > "/dev/stderr"
        } else if (NR - lines1 > lines1) {
            print "Warning: Second file has more lines than first, extra lines ignored" > "/dev/stderr"
        }
    }
' "$file1" "$file2" > mol.chg

echo "Merge completed, result written to mol.chg"
