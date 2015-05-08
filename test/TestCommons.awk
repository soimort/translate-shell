BEGIN {
    START_TEST("Commons.awk")

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

    T("quote()", 4)
    {
        assertEqual(quote(""), "")
        assertEqual(quote("foo"), "foo")
        assertEqual(quote("foo bar"), "foo%20bar")
        assertEqual(quote("\"hello, world!\""), "%22hello%2C%20world%21%22")
    }

    T( "replicate()", 4)
    {
        assertEqual(replicate("", 0), "")
        assertEqual(replicate("", 2), "")
        assertEqual(replicate("foo bar", 1), "foo bar")
        assertEqual(replicate("foo bar", 3), "foo barfoo barfoo bar")
    }

    T("squeeze()", 4)
    {
        assertEqual(squeeze(""), "")
        assertEqual(squeeze(" "), "")
        assertEqual(squeeze("	"), "")
        assertEqual(squeeze("  foo = bar #comments"), "foo = bar")
    }

    T("anything()", 3)
    {
        assertFalse(anything(nothing))
        something[0] = 0; assertFalse(anything(something)) # edge case
        something[0] = 1; assertTrue(anything(something))
    }

    T("belongsTo()", 3)
    {
        array[0] = "foo"; array[1] = "bar"
        assertTrue(belongsTo("foo", array))
        assertTrue(belongsTo("bar", array))
        assertFalse(belongsTo("world", array))
    }

    T("startsWithAny()", 3)
    {
        substrings[0] = "A"; substrings[1] = "a"
        assertTrue(startsWithAny("absolute", substrings))
        assertTrue(startsWithAny("ABSOLUTE", substrings))
        assertFalse(startsWithAny("ZOO", substrings))
    }

    T("matchesAny()", 4)
    {
        patterns[0] = "[[:space:]]"; patterns[1] = "[0Oo]"
        assertTrue(matchesAny("  ", patterns))
        assertTrue(matchesAny("obsolete", patterns))
        assertTrue(matchesAny("0.0", patterns))
        assertFalse(matchesAny("1.0", patterns))
    }

    T("join()", 2)
    {
        array[0] = "foo"; array[1] = "bar"
        assertEqual(join(array, " "), "foo bar")
        assertEqual(join(array, ","), "foo,bar")
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

    T("detectProgram()", 2)
    {
        assertTrue(detectProgram("ls"))
        assertTrue(detectProgram("gawk", "--version"))
    }

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

    END_TEST()
}
