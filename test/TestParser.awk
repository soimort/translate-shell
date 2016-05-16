@include "include/Parser"

BEGIN {
    START_TEST("Parser.awk")

    T("tokenize()", 8)
    {
        delete tokens
        tokenize(tokens, "0")
        delete expected
        expected[0] = "0"
        assertEqual(tokens, expected)

        delete tokens
        tokenize(tokens, "3.14")
        delete expected
        expected[0] = "3.14"
        assertEqual(tokens, expected)

        delete tokens
        tokenize(tokens, "Atom")
        delete expected
        expected[0] = "Atom"
        assertEqual(tokens, expected)

        delete tokens
        tokenize(tokens, "\"foo bar\"")
        delete expected
        expected[0] = "\"foo bar\""
        assertEqual(tokens, expected)

        delete tokens
        tokenize(tokens, "\"\\\"\"")
        delete expected
        expected[0] = "\"\\\"\""
        assertEqual(tokens, expected)

        delete tokens
        tokenize(tokens, "(QUOTE A)")
        delete expected
        expected[0] = "("
        expected[1] = "QUOTE"
        expected[2] = "A"
        expected[3] = ")"
        assertEqual(tokens, expected)

        delete tokens
        tokenize(tokens, "1 + 2 * 3")
        delete expected
        expected[0] = "1"
        expected[1] = "+"
        expected[2] = "2"
        expected[3] = "*"
        expected[4] = "3"
        assertEqual(tokens, expected)

        delete tokens
        tokenize(tokens, "[42, \"hello, world\", [Foo, bar]]")
        delete expected
        expected[0] = "["
        expected[1] = "42"
        expected[2] = ","
        expected[3] = "\"hello, world\""
        expected[4] = ","
        expected[5] = "["
        expected[6] = "Foo"
        expected[7] = ","
        expected[8] = "bar"
        expected[9] = "]"
        expected[10] = "]"
        assertEqual(tokens, expected)
    }

    T("parseJson()", 10)
    {
        delete tokens; delete ast; delete expected
        tokenize(tokens, "0")
        parseJson(ast, tokens)
        expected[0] = "0"
        assertEqual(ast, expected)

        delete tokens; delete ast; delete expected
        tokenize(tokens, "null")
        parseJson(ast, tokens)
        expected[0] = "null"
        assertEqual(ast, expected)

        delete tokens; delete ast; delete expected
        tokenize(tokens, "[42]")
        parseJson(ast, tokens)
        expected[0 SUBSEP 0] = "42"
        assertEqual(ast, expected)

        delete tokens; delete ast; delete expected
        tokenize(tokens, "[42, \"answer\", null]")
        parseJson(ast, tokens)
        expected[0 SUBSEP 0] = "42"
        expected[0 SUBSEP 1] = "\"answer\""
        expected[0 SUBSEP 2] = "null"
        assertEqual(ast, expected)

        delete tokens; delete ast; delete expected
        tokenize(tokens, "{\"answer\": [42], \"Answer\": null}")
        parseJson(ast, tokens)
        expected[0 SUBSEP "answer" SUBSEP 0] = 42
        expected[0 SUBSEP "Answer"] = "null"
        assertEqual(ast, expected)

        delete tokens; delete ast; delete expected
        tokenize(tokens, "{\"answer\": {42}, \"Answer\": null}")
        parseJson(ast, tokens)
        expected[0 SUBSEP "answer" SUBSEP] = 42
        expected[0 SUBSEP "Answer"] = "null"
        assertEqual(ast, expected)

        delete tokens; delete ast; delete expected
        tokenize(tokens, "{\"answer\": {[42]}, \"Answer\": null}")
        parseJson(ast, tokens)
        expected[0 SUBSEP "answer" SUBSEP SUBSEP 0] = 42
        expected[0 SUBSEP "Answer"] = "null"
        assertEqual(ast, expected)

        # empty object - what is the "correct" parsing result?

        delete tokens; delete ast; delete expected
        tokenize(tokens, "{}")
        parseJson(ast, tokens)
        assertEqual(ast, expected)

        delete tokens; delete ast; delete expected
        tokenize(tokens, "{\"answer\": {}}")
        parseJson(ast, tokens)
        assertEqual(ast, expected)

        delete tokens; delete ast; delete expected
        tokenize(tokens, "{\"answer\": {}, \"Answer\": null}")
        parseJson(ast, tokens)
        expected[0 SUBSEP "Answer"] = "null"
        assertEqual(ast, expected)
    }

    T("parseList()", 1)
    {
        delete tokens; delete ast; delete expected
        tokenize(tokens, "0")
        parseList(ast, tokens)
        expected[NULLSTR][0] = "0"
        assertEqual(ast, expected)
    }

    END_TEST()
}
