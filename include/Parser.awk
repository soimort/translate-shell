####################################################################
# Parser.awk                                                       #
####################################################################

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
