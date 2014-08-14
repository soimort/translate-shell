#!/usr/bin/gawk -f

# Return the real character represented by an escape sequence.
# Example: escapeChar("n") returns "\n".
# See: <https://en.wikipedia.org/wiki/Escape_character>
#      <https://en.wikipedia.org/wiki/Escape_sequences_in_C>
function escapeChar(char) {
    switch (char) {
    case "b":
        return "\b" # Backspace
    case "f":
        return "\f" # Formfeed
    case "n":
        return "\n" # Newline (Line Feed)
    case "r":
        return "\r" # Carriage Return
    case "t":
        return "\t" # Horizontal Tab
    case "v":
        return "\v" # Vertical Tab
    default:
        return char
    }
}

# Convert a literal-formatted string into its original string.
function literal(string,
                 ####
                 c, escaping, i, s) {
    if (string !~ /^".*"$/)
        return string

    split(string, s, "")
    string = ""
    escaping = 0
    for (i = 2; i < length(s); i++) {
        c = s[i]
        if (escaping) {
            string = string escapeChar(c)
            escaping = 0 # escape ends
        } else {
            if (c == "\\")
                escaping = 1 # escape begins
            else
                string = string c
        }
    }
    return string
}

# Replicate a string.
function replicate(string, len,
                   ####
                   i, temp) {
    temp = ""
    for (i = 0; i < len; i++)
        temp = temp string
    return temp
}

# Return 1 if the array contains anything; otherwise return 0.
function anything(array,
                  ####
                  i) {
    for (i in array)
        if (array[i]) return 1
    return 0
}

# Append an element into an array (zero-based).
function append(array, element) {
    array[anything(array) ? length(array) : 0] = element
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
function join(array, separator, sortedIn, preserveNull,
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
        if (preserveNull || array[i] != "")
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
