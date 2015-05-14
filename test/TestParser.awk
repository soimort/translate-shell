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
