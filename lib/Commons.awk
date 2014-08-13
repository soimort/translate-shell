#!/usr/bin/gawk -f

# Append an element into an array (zero-based).
function append(array, element) {
    array[length(array)] = element
}

# Return an element if it belongs to the array;
# Otherwise, return a null string.
function belongsTo(element, array,
                   ####
                   i) {
    for (i in array)
        if (element == array[i]) return element
    return ""
}

# Return one of the substrings if the string starts with it;
# Otherwise, return a null string.
function startsWithAny(string, substrings,
                       ####
                       i) {
    for (i in substrings)
        if (index(string, substrings[i]) == 1) return substrings[i]
    return ""
}

# Return one of the patterns if the string matches this pattern at the beginning;
# Otherwise, return a null string.
function matchesAny(string, patterns,
                    ####
                    i) {
    for (i in patterns)
        if (string ~ "^" patterns[i]) return patterns[i]
    return ""
}

# Join an array into one string;
# Return the string.
function join(array, separator, sortedIn,
              ####
              i, j, saveSortedIn, temp) {
    # Default parameters
    if (!separator)
        separator = " "
    if (!sortedIn)
        sortedIn = "@ind_num_asc"

    temp = ""
    j = 0
    saveSortedIn = PROCINFO["sorted_in"]
    PROCINFO["sorted_in"] = sortedIn
    for (i in array)
        temp = j++ ? temp separator array[i] : array[i]
    PROCINFO["sorted_in"] = saveSortedIn

    return temp
}

# Debug an array.
function da(array, formatString, sortedIn,
                ####
                i, j, saveSortedIn) {
    # Default parameters
    if (!formatString)
        formatString = "_[%s]='%s'"
    if (!sortedIn)
        sortedIn = "@ind_num_asc"

    saveSortedIn = PROCINFO["sorted_in"]
    PROCINFO["sorted_in"] = sortedIn
    for (i in array) {
        split(i, j, SUBSEP)
        d(sprintf(formatString, join(j, ","), array[i]))
    }
    PROCINFO["sorted_in"] = saveSortedIn
}
