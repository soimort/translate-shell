BEGIN {
    START_TEST("Commons.awk")

    # Arrays
    T("anything()", 3)
    {
        delete something
        assertFalse(anything(nothing))
        something[0] = 0; assertFalse(anything(something)) # edge case
        something[0] = 1; assertTrue(anything(something))
    }
    T("exists()", 4)
    {
        delete something
        assertFalse(exists(something))
        something[0] = 0; assertFalse(exists(something)) # edge case
        something[0] = 1; assertTrue(exists(something))
        assertTrue(exists(something[0]))
    }
    T("belongsTo()", 3)
    {
        delete array; array[0] = "foo"; array[1] = "bar"
        assertTrue(belongsTo("foo", array))
        assertTrue(belongsTo("bar", array))
        assertFalse(belongsTo("world", array))
    }
    T("identical()", 4)
    {
        delete x; x[0] = 42
        delete y; y[0][0] = 42
        assertFalse(identical(x, y))
        assertTrue(identical(x, y[0]))
        assertFalse(identical(x[0], y[0]))
        assertTrue(identical(x[0], y[0][0]))
    }
    T("append()", 1)
    {
        delete array; array[0] = "foo"
        delete expected; expected[0] = "foo"; expected[1] = "bar"
        append(array, "bar")
        assertTrue(identical(array, expected))
    }

    # Strings
    T("startsWithAny()", 3)
    {
        delete substrings; substrings[0] = "A"; substrings[1] = "a"
        assertTrue(startsWithAny("absolute", substrings))
        assertTrue(startsWithAny("ABSOLUTE", substrings))
        assertFalse(startsWithAny("ZOO", substrings))
    }
    T("matchesAny()", 4)
    {
        delete patterns; patterns[0] = "[[:space:]]"; patterns[1] = "[0Oo]"
        assertTrue(matchesAny("  ", patterns))
        assertTrue(matchesAny("obsolete", patterns))
        assertTrue(matchesAny("0.0", patterns))
        assertFalse(matchesAny("1.0", patterns))
    }
    T("replicate()", 4)
    {
        assertEqual(replicate("", 0), "")
        assertEqual(replicate("", 2), "")
        assertEqual(replicate("foo bar", 1), "foo bar")
        assertEqual(replicate("foo bar", 3), "foo barfoo barfoo bar")
    }
    T("join()", 4)
    {
        assertEqual(join("", "-"), "")
        delete array; array[0]
        assertEqual(join(array, "-"), "")
        delete array; array[0] = "foo"; array[1] = "bar"
        assertEqual(join(array, " "), "foo bar")
        assertEqual(join(array, ","), "foo,bar")
    }
    T("escapeChar()", 8)
    {
        assertEqual(escapeChar("b"), "\b")
        assertEqual(escapeChar("f"), "\f")
        assertEqual(escapeChar("n"), "\n")
        assertEqual(escapeChar("r"), "\r")
        assertEqual(escapeChar("t"), "\t")
        assertEqual(escapeChar("v"), "\v")
        assertEqual(escapeChar("_"), "_")
        assertNotEqual(escapeChar("_"), "\\_")
    }
    T("literal()", 4)
    {
        assertEqual(literal(""), "")
        assertEqual(literal("foo"), "foo")
        assertEqual(literal("\"foo\""), "foo")
        assertEqual(literal("\"\\\"foo\\\"\""), "\"foo\"")
    }
    T("escape()", 4)
    {
        assertEqual(escape(""), "")
        assertEqual(escape("foo"), "foo")
        assertEqual(escape("\""), "\\\\\"")
        assertEqual(escape("\"foo\""), "\\\\\"foo\\\\\"")
    }
    T("parameterize()", 10)
    {
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
    T("squeeze()", 4)
    {
        assertEqual(squeeze(""), "")
        assertEqual(squeeze(" "), "")
        assertEqual(squeeze("	"), "")
        assertEqual(squeeze("  foo = bar #comments"), "foo = bar")
    }
    T("yn()", 12)
    {
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

    # URLs
    T("quote()", 4)
    {
        assertEqual(quote(""), "")
        assertEqual(quote("foo"), "foo")
        assertEqual(quote("foo bar"), "foo%20bar")
        assertEqual(quote("\"hello, world!\""), "%22hello%2C%20world%21%22")
    }

    # System
    T("fileExists()", 4)
    {
        assertFalse(fileExists("README"))
        assertFalse(fileExists("README .md"))
        assertTrue(fileExists("README.md"))
        assertFalse(fileExists("."))
    }
    T("dirExists()", 4)
    {
        assertFalse(dirExists("README"))
        assertFalse(dirExists("README.md"))
        assertTrue(dirExists("."))
        assertFalse(dirExists(" ."))
    }
    T("detectProgram()", 2)
    {
        assertTrue(detectProgram("ls"))
        assertTrue(detectProgram("gawk", "--version"))
    }

    END_TEST()
}
