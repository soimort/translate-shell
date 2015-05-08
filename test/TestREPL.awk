BEGIN {
    START_TEST("REPL.awk")

    T("Rlwrap", 1)
    {
        initRlwrap()
        assertEqual(Rlwrap, "rlwrap")
    }

    END_TEST()
}
