####################################################################
# PLTokenizer.awk                                                  #
####################################################################

# Tokenize a string.
function plTokenize(returnTokens, string,
                    delimiters,
                    newlines,
                    quotes,
                    escapeChars,
                    leftBlockComments,
                    rightBlockComments,
                    lineComments,
                    reservedOperators,
                    reservedPatterns,
                    ####
                    blockCommenting,
                    c,
                    currentToken,
                    escaping,
                    i,
                    lineCommenting,
                    p,
                    quoting,
                    r,
                    s,
                    tempGroup,
                    tempPattern,
                    tempString) {
    # Default parameters
    if (!delimiters[0]) {
        delimiters[0] = " "  # whitespace
        delimiters[1] = "\t" # horizontal tab
        delimiters[2] = "\v" # vertical tab
    }
    if (!newlines[0]) {
        newlines[0] = "\n" # line feed
        newlines[1] = "\r" # carriage return
    }
    if (!quotes[0]) {
        quotes[0] = "\"" # double quote
    }
    if (!escapeChars[0]) {
        escapeChars[0] = "\\" # backslash
    }
    if (!leftBlockComments[0]) {
        leftBlockComments[0] = "#|" # Lisp-style extended comment (open)
        leftBlockComments[1] = "/*" # C-style comment (open)
        leftBlockComments[2] = "(*" # ML-style comment (open)
    }
    if (!rightBlockComments[0]) {
        rightBlockComments[0] = "|#" # Lisp-style extended comment (close)
        rightBlockComments[1] = "*/" # C-style comment (close)
        rightBlockComments[2] = "*)" # ML-style comment (close)
    }
    if (!lineComments[0]) {
        lineComments[0] = ";"  # Lisp-style line comment
        lineComments[1] = "//" # C++-style line comment
        lineComments[2] = "#"  # hash comment
    }
    if (!reservedOperators[0]) {
        reservedOperators[0] = "(" #  left parenthesis
        reservedOperators[1] = ")" # right parenthesis
        reservedOperators[2] = "[" #  left bracket
        reservedOperators[3] = "]" # right bracket
        reservedOperators[4] = "{" #  left brace
        reservedOperators[5] = "}" # right brace
        reservedOperators[6] = "," # comma
    }
    if (!reservedPatterns[0]) {
        reservedPatterns[0] = "[+-]?((0|[1-9][0-9]*)|[.][0-9]*|(0|[1-9][0-9]*)[.][0-9]*)([Ee][+-]?[0-9]+)?" # numeric literal (scientific notation possible)
        reservedPatterns[1] = "[+-]?0[0-7]+([.][0-7]*)?" # numeric literal (octal)
        reservedPatterns[2] = "[+-]?0[Xx][0-9A-Fa-f]+([.][0-9A-Fa-f]*)?" # numeric literal (hexadecimal)
    }

    split(string, s, "")
    currentToken = ""
    quoting = escaping = blockCommenting = lineCommenting = 0
    p = 0
    i = 1
    while (i <= length(s)) {
        c = s[i]
        r = substr(string, i)

        if (blockCommenting) {
            if (tempString = startsWithAny(r, rightBlockComments))
                blockCommenting = 0 # block comment ends

            i++

        } else if (lineCommenting) {
            if (belongsTo(c, newlines))
                lineCommenting = 0 # line comment ends

            i++

        } else if (quoting) {
            currentToken = currentToken c

            if (escaping) {
                escaping = 0 # escape ends

            } else {
                if (belongsTo(c, quotes)) {
                    # Finish the current token
                    if (currentToken) {
                        returnTokens[p++] = currentToken
                        currentToken = ""
                    }

                    quoting = 0 # quotation ends

                } else if (belongsTo(c, escapeChars)) {
                    escaping = 1 # escape begins

                } else {
                    # Continue
                }
            }

            i++

        } else {
            if (belongsTo(c, delimiters) || belongsTo(c, newlines)) {
                # Finish the current token
                if (currentToken) {
                    returnTokens[p++] = currentToken
                    currentToken = ""
                }

                i++

            } else if (belongsTo(c, quotes)) {
                # Finish the current token
                if (currentToken) {
                    returnTokens[p++] = currentToken
                }

                currentToken = c

                quoting = 1 # quotation begins

                i++

            } else if (tempString = startsWithAny(r, leftBlockComments)) {
                # Finish the current token
                if (currentToken) {
                    returnTokens[p++] = currentToken
                    currentToken = ""
                }

                blockCommenting = 1 # block comment begins

                i += length(tempString)

            } else if (tempString = startsWithAny(r, lineComments)) {
                # Finish the current token
                if (currentToken) {
                    returnTokens[p++] = currentToken
                    currentToken = ""
                }

                lineCommenting = 1 # line comment begins

                i += length(tempString)

            } else if (tempString = startsWithAny(r, reservedOperators)) {
                # Finish the current token
                if (currentToken) {
                    returnTokens[p++] = currentToken
                    currentToken = ""
                }

                # Reserve token
                returnTokens[p++] = tempString

                i += length(tempString)

            } else if (tempPattern = matchesAny(r, reservedPatterns)) {
                # Finish the current token
                if (currentToken) {
                    returnTokens[p++] = currentToken
                    currentToken = ""
                }

                # Reserve token
                match(r, "^" tempPattern, tempGroup)
                returnTokens[p++] = tempGroup[0]

                i += length(tempGroup[0])

            } else {
                # Continue with the current token
                currentToken = currentToken c

                i++
            }
        }
    }

    # Finish the last token
    if (currentToken)
        returnTokens[p++] = currentToken

}
