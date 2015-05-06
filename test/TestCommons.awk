BEGIN {
    START_TEST("Commons.awk")

    TEST = "escapeChar()"; TOTAL = 8; COUNTER = 0; {
        assertEqual(escapeChar("b"), "\b")
        assertEqual(escapeChar("f"), "\f")
        assertEqual(escapeChar("n"), "\n")
        assertEqual(escapeChar("r"), "\r")
        assertEqual(escapeChar("t"), "\t")
        assertEqual(escapeChar("v"), "\v")
        assertEqual(escapeChar("_"), "_")
        assertNotEqual(escapeChar("_"), "\\_")
    }

    TEST = "literal()"; TOTAL = 4; COUNTER = 0; {
        assertEqual(literal(""), "")
        assertEqual(literal("foo"), "foo")
        assertEqual(literal("\"foo\""), "foo")
        assertEqual(literal("\"\\\"foo\\\"\""), "\"foo\"")
    }

    TEST = "escape()"; TOTAL = 4; COUNTER = 0; {
        assertEqual(escape(""), "")
        assertEqual(escape("foo"), "foo")
        assertEqual(escape("\""), "\\\\\"")
        assertEqual(escape("\"foo\""), "\\\\\"foo\\\\\"")
    }

    TEST = "parameterize()"; TOTAL = 10; COUNTER = 0; {
        assertEqual(parameterize(""), "''")
        assertEqual(parameterize("foo"), "'foo'")
        assertEqual(parameterize("foo bar"), "'foo bar'")
        assertEqual(parameterize("foo 'bar"), "'foo '\\''bar'")
        assertEqual(parameterize("foo \"bar\""), "'foo \"bar\"'")
        assertEqual(parameterize("", "\""), "\"\"")
        assertEqual(parameterize("foo", "\""), "\"foo\"")
        assertEqual(parameterize("foo bar", "\""), "\"foo bar\"")
        assertEqual(parameterize("foo 'bar", "\""), "\"foo 'bar\"")
        assertEqual(parameterize("foo \"bar\"", "\""), "\"foo \\\\\"bar\\\\\"\"")
    }

    TEST = "quote()"; TOTAL = 4; COUNTER = 0; {
        assertEqual(quote(""), "")
        assertEqual(quote("foo"), "foo")
        assertEqual(quote("foo bar"), "foo%20bar")
        assertEqual(quote("\"hello, world!\""), "%22hello%2C%20world%21%22")
    }

    TEST = "replicate()"; TOTAL = 4; COUNTER = 0; {
        assertEqual(replicate("", 0), "")
        assertEqual(replicate("", 2), "")
        assertEqual(replicate("foo bar", 1), "foo bar")
        assertEqual(replicate("foo bar", 3), "foo barfoo barfoo bar")
    }

    TEST = "squeeze()"; TOTAL = 4; COUNTER = 0; {
        assertEqual(squeeze(""), "")
        assertEqual(squeeze(" "), "")
        assertEqual(squeeze("	"), "")
        assertEqual(squeeze("  foo = bar #comments"), "foo = bar")
    }

    TEST = "anything()"; TOTAL = 3; COUNTER = 0; {
        assertFalse(anything(nothing))
        something[0] = 0; assertFalse(anything(something)) # edge case
        something[0] = 1; assertTrue(anything(something))
    }

    TEST = "belongsTo()"; TOTAL = 3; COUNTER = 0; {
        array[0] = "foo"; array[1] = "bar"
        assertTrue(belongsTo("foo", array))
        assertTrue(belongsTo("bar", array))
        assertFalse(belongsTo("world", array))
    }

    TEST = "startsWithAny()"; TOTAL = 3; COUNTER = 0; {
        substrings[0] = "A"; substrings[1] = "a"
        assertTrue(startsWithAny("absolute", substrings))
        assertTrue(startsWithAny("ABSOLUTE", substrings))
        assertFalse(startsWithAny("ZOO", substrings))
    }

    TEST = "matchesAny()"; TOTAL = 4; COUNTER = 0; {
        patterns[0] = "[[:space:]]"; patterns[1] = "[0Oo]"
        assertTrue(matchesAny("  ", patterns))
        assertTrue(matchesAny("obsolete", patterns))
        assertTrue(matchesAny("0.0", patterns))
        assertFalse(matchesAny("1.0", patterns))
    }

    TEST = "join()"; TOTAL = 2; COUNTER = 0; {
        array[0] = "foo"; array[1] = "bar"
        assertEqual(join(array, " "), "foo bar")
        assertEqual(join(array, ","), "foo,bar")
    }

    TEST = "yn()"; TOTAL = 12; COUNTER = 0; {
        assertFalse(yn(0))
        assertFalse(yn("0"))
        assertFalse(yn("false"))
        assertFalse(yn("no"))
        assertFalse(yn("off"))
        assertFalse(yn("OFF"))
        assertTrue(yn(1))
        assertTrue(yn("1"))
        assertTrue(yn("true"))
        assertTrue(yn("yes"))
        assertTrue(yn("on"))
        assertTrue(yn("ON"))
    }

    TEST = "fileExists()"; TOTAL = 3; COUNTER = 0; {
        assertFalse(fileExists("README"))
        assertFalse(fileExists("README .md"))
        assertTrue(fileExists("README.md"))
    }

    TEST = "dirExists()"; TOTAL = 2; COUNTER = 0; {
        assertFalse(dirExists("README.md"))
        assertTrue(dirExists("."))
    }

    END_TEST()
}
