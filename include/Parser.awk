####################################################################
# Parser.awk                                                       #
####################################################################

# Tokenize a string and return a token list.
function tokenize(returnTokens, string,
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

# Parse a token list of JSON array and return an AST.
function parseJsonArray(returnAST, tokens,
                        leftBrackets,
                        rightBrackets,
                        separators,
                        ####
                        i, j, key, p, stack, token) {
    # Default parameters
    if (!leftBrackets[0]) {
        leftBrackets[0] = "(" # left parenthesis
        leftBrackets[1] = "[" # left bracket
        leftBrackets[2] = "{" # left brace
    }
    if (!rightBrackets[0]) {
        rightBrackets[0] = ")" # right parenthesis
        rightBrackets[1] = "]" # right bracket
        rightBrackets[2] = "}" # right brace
    }
    if (!separators[0]) {
        separators[0] = "," # comma
    }

    stack[p = 0] = 0
    for (i = 0; i < length(tokens); i++) {
        token = tokens[i]

        if (belongsTo(token, leftBrackets))
            stack[++p] = 0
        else if (belongsTo(token, rightBrackets))
            --p
        else if (belongsTo(token, separators))
            stack[p]++
        else {
            key = stack[0]
            for (j = 1; j <= p; j++)
                key = key SUBSEP stack[j]
            returnAST[key] = token
        }
    }
}

# JSON parser.
function parseJson(returnAST, tokens,
                   arrayStartTokens, arrayEndTokens,
                   objectStartTokens, objectEndTokens,
                   commas, colons,
                   ####
                   flag, i, j, key, name, p, stack, token) {
    # Default parameters
    if (!arrayStartTokens[0])  arrayStartTokens[0]  = "["
    if (!arrayEndTokens[0])    arrayEndTokens[0]    = "]"
    if (!objectStartTokens[0]) objectStartTokens[0] = "{"
    if (!objectEndTokens[0])   objectEndTokens[0]   = "}"
    if (!commas[0])            commas[0]            = ","
    if (!colons[0])            colons[0]            = ":"

    stack[p = 0] = 0
    flag = 0 # ready to read key
    for (i = 0; i < length(tokens); i++) {
        token = tokens[i]

        if (belongsTo(token, arrayStartTokens)) {
            stack[++p] = 0
        } else if (belongsTo(token, objectStartTokens)) {
            stack[++p] = NULLSTR
            flag = 0 # ready to read key
        } else if (belongsTo(token, objectEndTokens) ||
                   belongsTo(token, arrayEndTokens)) {
            --p
        } else if (belongsTo(token, commas)) {
            if (isnum(stack[p])) # array
                stack[p]++ # increase index
            else # object
                flag = 0 # ready to read key
        } else if (belongsTo(token, colons)) {
            flag = 1 # ready to read value
        } else if (isnum(stack[p]) || flag) {
            # Read a value
            key = stack[0]
            for (j = 1; j <= p; j++)
                key = key SUBSEP stack[j]
            returnAST[key] = token
            flag = 0 # ready to read key
        } else {
            # Read a key
            stack[p] = unparameterize(token)
        }
    }
}

# S-expr parser.
function parseList(returnAST, tokens,
                   leftBrackets,
                   rightBrackets,
                   separators,
                   ####
                   i, j, key, p, stack, token) {
    # Default parameters
    if (!leftBrackets[0]) {
        leftBrackets[0] = "(" # left parenthesis
        leftBrackets[1] = "[" # left bracket
        leftBrackets[2] = "{" # left brace
    }
    if (!rightBrackets[0]) {
        rightBrackets[0] = ")" # right parenthesis
        rightBrackets[1] = "]" # right bracket
        rightBrackets[2] = "}" # right brace
    }
    if (!separators[0]) {
        separators[0] = "," # comma
    }

    stack[p = 0] = 0
    for (i = 0; i < length(tokens); i++) {
        token = tokens[i]

        if (belongsTo(token, leftBrackets)) {
            stack[++p] = 0
        } else if (belongsTo(token, rightBrackets)) {
            stack[--p]++
        } else if (belongsTo(token, separators)) {
            # skip
        } else {
            key = NULLSTR
            if (p > 0) {
                for (j = 0; j < p - 1; j++)
                    key = key SUBSEP stack[j]
                returnAST[key][stack[p - 1]] = NULLSTR
                key = key SUBSEP stack[p - 1]
            }
            returnAST[key][stack[p]] = token
            stack[p]++
        }
    }
}
