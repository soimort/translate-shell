BEGIN {
    START_TEST("Utils.awk")

    T("GawkVersion", 1)
    {
        initGawk()
        assertTrue(GawkVersion ~ "^4\.")
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

    END_TEST()
}
