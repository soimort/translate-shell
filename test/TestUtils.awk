@include "include/Utils"

BEGIN {
    START_TEST("Utils.awk")

    T("GawkVersion", 1)
    {
        initGawk()
        assertTrue(GawkVersion ~ "^(4|5).")
    }

    T("Rlwrap", 1)
    {
        initRlwrap()
        assertEqual(Rlwrap, "rlwrap")
    }

    T("Emacs", 1)
    {
        initEmacs()
        assertEqual(Emacs, "emacs")
    }

    T("newerVersion()", 5)
    {
        assertTrue(newerVersion("0.9", "0.8"))
        assertTrue(newerVersion("0.9.0.1", "0.9.0"))
        assertTrue(newerVersion("1.0", "0.9.9999"))
        assertTrue(newerVersion("1.9.9999", "1.9.10"))
        assertTrue(newerVersion("2", "1.9.9999"))
    }

    if (yn(ENVIRON["NETWORK_ACCESS"])) { # if network access enabled
        T("curl()", 1)
        {
            delete tokens; delete ast
            tokenize(tokens, curl("https://httpbin.org/get"))
            parseJson(ast, tokens)
            assertEqual(unparameterize(ast[0 SUBSEP "url"]),
                        "https://httpbin.org/get")
        }

        T("curlPost()", 1)
        {
            delete tokens; delete ast
            tokenize(tokens, curlPost("https://httpbin.org/post", "fizz=buzz"))
            parseJson(ast, tokens)
            assertEqual(unparameterize(ast[0 SUBSEP "url"]),
                        "https://httpbin.org/post")
        }
    }

    T("dump()", 3)
    {
        delete group
        assertEqual(dump("a", group), 1)

        delete group
        assertEqual(dump("Århus", group), 6)

        delete group
        assertEqual(dump("안녕하세요 세계", group), 22)
    }

    T("dumpX()", 2)
    {
        delete group
        assertEqual(dumpX("a", group), 1)

        delete group
        assertEqual(dumpX("你好", group), 6)
    }

    T("base64()", 1)
    {
        assertEqual(base64("ninja"), "bmluamE=")
        assertEqual(base64("ninjaninjaninjaninjaninjaninjaninjaninjaninjaninjaninjaninjaninjaninjaninjaninjaninjaninjaninjaninjaninjaninjaninjaninja"), "bmluamFuaW5qYW5pbmphbmluamFuaW5qYW5pbmphbmluamFuaW5qYW5pbmphbmluamFuaW5qYW5pbmphbmluamFuaW5qYW5pbmphbmluamFuaW5qYW5pbmphbmluamFuaW5qYW5pbmphbmluamFuaW5qYW5pbmph")
    }

    T("uprintf", 1)
    {
        assertEqual(uprintf("Ma\\u00f1ana"), "Mañana")
    }

    END_TEST()
}
