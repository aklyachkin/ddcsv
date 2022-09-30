#!/opt/homebrew/bin/gawk -f

function printvalues(a) {
    len = length(a)
    for (i in a) {
        sep = ","
        if (i == len) sep = ""
        sub(/^[ \t]+/, "", a[i])
        sub(/[ \t]+$/, "", a[i])
        printf "%s%s", a[i], sep
    }
    print ""
}

function getlengths(line, l) {
    split(line, s)
    for (i in s) {
        l[i] = length($i)
    }
}

function getvalues(line, lengths, values) {
    p = 1
    for (i in lengths) {
        values[i] = substr($0, p, lengths[i])
        p = p + lengths[i] + 3
    }
}

/^Group:/ {
    GroupName = $NF
}

/^Initiators:/ {
    getline # skip line
    getline # skip title
    getline # skip hashes
    while ($1 !~ /^---/) {
        print GroupName","$1","$2
        getline
    }
}

/^Devices:/ {
    getline # skip line
    getline # skip title
    getlengths($0, l)
    getline # skip hdr
    while ($1 !~ /^---/) {
        getvalues($0, l, v)
        printvalues(v)
        getline
    }
}
