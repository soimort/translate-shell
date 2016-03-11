####################################################################
# Commons.awk                                                      #
####################################################################

# Initialize constants.
function initConst() {
    NULLSTR = ""
    TRUE = 1

    STDIN  = "/dev/stdin"
    STDOUT = "/dev/stdout"
    STDERR = "/dev/stderr"

    SUPOUT = " > /dev/null "  # suppress output
    SUPERR = " 2> /dev/null " # suppress error
    PIPE = " | "
}



## Arrays:

# Return 1 if the array contains anything; otherwise return 0.
function anything(array,
                  ####
                  i) {
    for (i in array)
        if (array[i]) return 1
    return 0
}

# Return 1 if the value is non-empty or an array that contains anything;
# Otherwise, return 0.
function exists(value) {
    if (isarray(value))
        return anything(value)
    else
        return value ? 1 : 0
}

# Return an element if it belongs to the array;
# Otherwise, return a null string.
function belongsTo(element, array,
                   ####
                   i) {
    for (i in array)
        if (element == array[i]) return element
    return NULLSTR
}

# Return non-zero if two values are identical;
# Otherwise, return 0.
function identical(x, y,
                   ####
                   i) {
    if (!isarray(x) && !isarray(y))
        return x == y
    else if (isarray(x) && isarray(y)) {
        if (length(x) != length(y)) return 0
        for (i in x)
            if (!identical(x[i], y[i])) return 0
        return 1
    } else
        return 0
}

# Append an element into an array (zero-based).
function append(array, element) {
    array[anything(array) ? length(array) : 0] = element
}



## Strings:

# Return non-zero if the string represents a numeral;
# Otherwise, return 0.
function isnum(string) {
    return string == string + 0
}

# Return one of the substrings if the string starts with it;
# Otherwise, return a null string.
function startsWithAny(string, substrings,
                       ####
                       i) {
    for (i in substrings)
        if (index(string, substrings[i]) == 1) return substrings[i]
    return NULLSTR
}

# Return one of the patterns if the string matches this pattern at the beginning;
# Otherwise, return a null string.
function matchesAny(string, patterns,
                    ####
                    i) {
    for (i in patterns)
        if (string ~ "^" patterns[i]) return patterns[i]
    return NULLSTR
}

# Replicate a string.
function replicate(string, len,
                   ####
                   i, temp) {
    temp = NULLSTR
    for (i = 0; i < len; i++)
        temp = temp string
    return temp
}

# Reverse a string.
function reverse(string,
                 ####
                 i, temp) {
    temp = NULLSTR
    for (i = length(string); i > 0; i--)
        temp = temp substr(string, i, 1);
    return temp
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

    temp = NULLSTR
    j = 0
    if (isarray(array)) {
        saveSortedIn = PROCINFO["sorted_in"]
        PROCINFO["sorted_in"] = sortedIn
        for (i in array)
            if (preserveNull || array[i] != NULLSTR)
                temp = j++ ? temp separator array[i] : array[i]
        PROCINFO["sorted_in"] = saveSortedIn
    } else
        temp = array

    return temp
}

# Split a string into characters.
function explode(string, array) {
    split(string, array, NULLSTR)
}

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
    case "u0026":
        return "&" # Unicode Character 'AMPERSAND'
    default:
        return char
    }
}

# Convert a literal-formatted string into its original string.
function literal(string,
                 ####
                 c, cc, escaping, i, s) {
    if (string !~ /^".*"$/)
        return string

    explode(string, s)
    string = NULLSTR
    escaping = 0
    for (i = 2; i < length(s); i++) {
        c = s[i]
        if (escaping) {
            if (cc) {
                cc = cc c
                if (length(cc) == 5) {
                    string = string escapeChar(cc)
                    escaping = 0 # escape ends
                    cc = NULLSTR
                }
            } else if (c == "u") {
                cc = c
            } else {
                string = string escapeChar(c)
                escaping = 0 # escape ends
            }
        } else {
            if (c == "\\")
                escaping = 1 # escape begins
            else
                string = string c
        }
    }
    return string
}

# Return the escaped string.
function escape(string) {
    gsub(/\\/, "\\\\", string) # substitute backslashes first
    gsub(/"/, "\\\"", string)

    return string
}

# Reverse of escape(string).
function unescape(string) {
    gsub(/\\\"/, "\"", string)
    gsub(/\\\\/, "\\", string) # substitute backslashes last

    return string
}

# Return the escaped, quoted string.
function parameterize(string, quotationMark) {
    if (!quotationMark)
        quotationMark = "'"

    if (quotationMark == "'") {
        gsub(/'/, "'\\''", string)
        return "'" string "'"
    } else {
        return "\"" escape(string) "\""
    }
}

# Reverse of parameterize(string, quotationMark).
function unparameterize(string,    temp) {
    match(string, /^'(.*)'$/, temp)
    if (temp[0]) { # use temp[0] (there IS a match for quoted empty string)
        string = temp[1]
        gsub(/'\\''/, "'", string)
        return string
    }
    match(string, /^"(.*)"$/, temp)
    if (temp[0]) {
        string = temp[1]
        return unescape(string)
    }
    return string
}

# Convert any value to human-readable string.
function toString(value, inline, heredoc, valOnly, numSub, level, sortedIn,
                  ####
                  i, items, j, k, p, saveSortedIn, temp, v) {
    if (!level) level = 0
    if (!sortedIn)
        sortedIn = "@ind_num_asc"

    if (isarray(value)) {
        saveSortedIn = PROCINFO["sorted_in"]
        PROCINFO["sorted_in"] = sortedIn
        p = 0
        for (i in value) {
            split(i, j, SUBSEP); k = join(j, ",")
            if (!numSub || !isnum(k)) k = parameterize(k, "\"")
            v = toString(value[i], inline, heredoc, valOnly, numSub, level + 1, sortedIn)
            if (!isarray(value[i])) v = parameterize(v, "\"")
            if (valOnly)
                items[p++] = inline ? v : (replicate("\t", level) v)
            else
                items[p++] = inline ? (k ": " v) :
                    (replicate("\t", level) k "\t" v)
        }
        PROCINFO["sorted_in"] = saveSortedIn
        temp = inline ? join(items, ", ") :
            ("\n" join(items, "\n") "\n" replicate("\t", level))
        temp = valOnly ? ("[" temp "]") : ("{" temp "}")
        return temp
    } else {
        if (heredoc)
            return "'''\n" value "\n'''"
        else
            return value
    }
}

# Squeeze a source line of AWK code.
function squeeze(line, preserveIndent) {
    # Remove preceding spaces if indentation not preserved
    if (!preserveIndent)
        gsub(/^[[:space:]]+/, NULLSTR, line)
    # Remove comment
    gsub(/^[[:space:]]*#.*$/, NULLSTR, line)
    # Remove in-line comment
    gsub(/#[^"/]*$/, NULLSTR, line)
    # Remove trailing spaces
    gsub(/[[:space:]]+$/, NULLSTR, line)
    gsub(/[[:space:]]+\\$/, "\\", line)

    return line
}

# Return 0 if the string starts with '0', 'f', 'n' or 'off';
# Otherwise, return 1.
function yn(string) {
    return (tolower(string) ~ /^([0fn]|off)/) ? 0 : 1
}



## Display & Debugging:

# Initialize ANSI escape codes for SGR (Select Graphic Rendition).
# (ANSI X3.64 Standard Control Sequences)
# See: <https://en.wikipedia.org/wiki/ANSI_escape_code>
function initAnsiCode() {
    # Dumb terminal: no ANSI escape code whatsoever
    if (ENVIRON["TERM"] == "dumb") return

    AnsiCode["reset"]         = AnsiCode[0] = "\33[0m"

    AnsiCode["bold"]          = "\33[1m"
    AnsiCode["underline"]     = "\33[4m"
    AnsiCode["negative"]      = "\33[7m"
    AnsiCode["no bold"]       = "\33[22m" # SGR code 21 (bold off) not widely supported
    AnsiCode["no underline"]  = "\33[24m"
    AnsiCode["positive"]      = "\33[27m"

    AnsiCode["black"]         = "\33[30m"
    AnsiCode["red"]           = "\33[31m"
    AnsiCode["green"]         = "\33[32m"
    AnsiCode["yellow"]        = "\33[33m"
    AnsiCode["blue"]          = "\33[34m"
    AnsiCode["magenta"]       = "\33[35m"
    AnsiCode["cyan"]          = "\33[36m"
    AnsiCode["gray"]          = "\33[37m"

    AnsiCode["default"]       = "\33[39m"

    AnsiCode["dark gray"]     = "\33[90m"
    AnsiCode["light red"]     = "\33[91m"
    AnsiCode["light green"]   = "\33[92m"
    AnsiCode["light yellow"]  = "\33[93m"
    AnsiCode["light blue"]    = "\33[94m"
    AnsiCode["light magenta"] = "\33[95m"
    AnsiCode["light cyan"]    = "\33[96m"
    AnsiCode["white"]         = "\33[97m"
}

# Return ANSI escaped string.
function ansi(code, text) {
    switch (code) {
    case "bold":
        return AnsiCode[code] text AnsiCode["no bold"]
    case "underline":
        return AnsiCode[code] text AnsiCode["no underline"]
    case "negative":
        return AnsiCode[code] text AnsiCode["positive"]
    default:
        return AnsiCode[code] text AnsiCode[0]
    }
}

# Print warning message.
function w(text) {
    print ansi("yellow", text) > STDERR
}

# Print error message.
function e(text) {
    print ansi("bold", ansi("yellow", text)) > STDERR
}

# What a terrible failure.
function wtf(text) {
    print ansi("bold", ansi("red", text)) > STDERR
}

# Print debugging message.
function d(text) {
    print ansi("gray", text) > STDERR
}

# Debug any value.
function da(value, name, inline, heredoc, valOnly, numSub, sortedIn,
            ####
            i, j, saveSortedIn) {
    # Default parameters
    if (!name)
        name = "_"
    if (!sortedIn)
        sortedIn = "@ind_num_asc"

    d(name " = " toString(value, inline, heredoc, valOnly, numSub, 0, sortedIn))
    #if (isarray(value)) {
    #    saveSortedIn = PROCINFO["sorted_in"]
    #    PROCINFO["sorted_in"] = sortedIn
    #    for (i in value) {
    #        split(i, j, SUBSEP)
    #        da(value[i], sprintf(name "[%s]", join(j, ",")), sortedIn)
    #    }
    #    PROCINFO["sorted_in"] = saveSortedIn
    #} else
    #    d(name " = " value)
}

# Naive assertion.
function assert(x, message) {
    if (!message)
        message = "[ERROR] Assertion failed."

    if (x)
        return x
    else
        e(message)
}



## URLs:

# Initialize `UrlEncoding`.
# See: <https://en.wikipedia.org/wiki/Percent-encoding>
function initUrlEncoding() {
    UrlEncoding["\t"] = "%09"
    UrlEncoding["\n"] = "%0A"
    UrlEncoding[" "]  = "%20"
    UrlEncoding["!"]  = "%21"
    UrlEncoding["\""] = "%22"
    UrlEncoding["#"]  = "%23"
    UrlEncoding["$"]  = "%24"
    UrlEncoding["%"]  = "%25"
    UrlEncoding["&"]  = "%26"
    UrlEncoding["'"]  = "%27"
    UrlEncoding["("]  = "%28"
    UrlEncoding[")"]  = "%29"
    UrlEncoding["*"]  = "%2A"
    UrlEncoding["+"]  = "%2B"
    UrlEncoding[","]  = "%2C"
    UrlEncoding["-"]  = "%2D"
    UrlEncoding["."]  = "%2E"
    UrlEncoding["/"]  = "%2F"
    UrlEncoding[":"]  = "%3A"
    UrlEncoding[";"]  = "%3B"
    UrlEncoding["<"]  = "%3C"
    UrlEncoding["="]  = "%3D"
    UrlEncoding[">"]  = "%3E"
    UrlEncoding["?"]  = "%3F"
    UrlEncoding["@"]  = "%40"
    UrlEncoding["["]  = "%5B"
    UrlEncoding["\\"] = "%5C"
    UrlEncoding["]"]  = "%5D"
    UrlEncoding["^"]  = "%5E"
    UrlEncoding["_"]  = "%5F"
    UrlEncoding["`"]  = "%60"
    UrlEncoding["{"]  = "%7B"
    UrlEncoding["|"]  = "%7C"
    UrlEncoding["}"]  = "%7D"
    UrlEncoding["~"]  = "%7E"
}

# Return the URL-encoded string.
function quote(string,    i, r, s) {
    r = NULLSTR
    explode(string, s)
    for (i = 1; i <= length(s); i++)
        r = r (s[i] in UrlEncoding ? UrlEncoding[s[i]] : s[i])
    return r
}

# Initialize `UriSchemes`.
function initUriSchemes() {
    UriSchemes[0] = "file://"
    UriSchemes[1] = "http://"
    UriSchemes[2] = "https://"
}



## System:

# Read from a file and return its content.
function readFrom(file,    line, text) {
    if (!file) file = "/dev/stdin"
    text = NULLSTR
    while (getline line < file)
        text = (text ? text "\n" : NULLSTR) line
    return text
}

# Write text to file.
function writeTo(text, file) {
    if (!file) file = "/dev/stdout"
    print text > file
}

# Return the output of a command.
function getOutput(command,    content, line) {
    content = NULLSTR
    while ((command |& getline line) > 0)
        content = (content ? content "\n" : NULLSTR) line
    return content
}

# Return non-zero if file exists; otherwise return 0.
function fileExists(file) {
    return !system("test -f " parameterize(file))
}

# Return non-zero if file exists and is a directory; otherwise return 0.
function dirExists(file) {
    return !system("test -d " parameterize(file))
}

# Detect whether a program exists in path.
# Return the name (or output) if the program call writes anything to stdout;
# Otherwise, return a null string.
function detectProgram(prog, arg, returnOutput,    temp) {
    if (returnOutput) {
        prog " " arg SUPERR | getline temp
        return temp
    } else
        return (prog " " arg SUPERR | getline) ? prog : NULLSTR
}

# Return the HEAD revision if the current directory is a git repo;
# Otherwise return a null string.
function getGitHead(    line, group) {
    if (fileExists(".git/HEAD")) {
        getline line < ".git/HEAD"
        match(line, /^ref: (.*)$/, group)
        if (fileExists(".git/" group[1])) {
            getline line < (".git/" group[1])
            return substr(line, 1, 7)
        } else
            return NULLSTR
    } else
        return NULLSTR
}



BEGIN {
    initConst()
    initAnsiCode()
    initUrlEncoding()
    initUriSchemes()
}
