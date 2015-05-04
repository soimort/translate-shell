#!/usr/bin/gawk -f
@include "include/Commons"

function pass(string, ansiCode) {
    if (!ansiCode) ansiCode = "green"
    print(ansi(ansiCode, ansi("bold", "[PASS] " string)))
}

function fail(string, ansiCode) {
    if (!ansiCode) ansiCode = "red"
    print(ansi(ansiCode, ansi("bold", "[FAIL] " string)))
}

function assertTrue(x, name, message, ansiCode) {
    if (!message) message = "assertTrue: FALSE"
    if (!name) name = TEST
    G_COUNTER++; COUNTER++
    string = "(" COUNTER "/" TOTAL ") TESTING " name
    if (x) {
        G_SUCCESS++
        pass(string, ansiCode)
    } else fail(string "\n       " message, ansiCode)
}

function assertFalse(x, name, message, ansiCode) {
    if (!message) message = "assertFalse: TRUE"
    assertTrue(!x, name, message, ansiCode)
}

function assertEqual(x, y, name, message, ansiCode) {
    if (!message)
        message = "assertEqual: " ansi("underline", x)  \
            " IS NOT EQUAL TO " ansi("underline", y)
    assertTrue(x == y, name, message, ansiCode)
}

function assertNotEqual(x, y, name, message, ansiCode) {
    if (!message)
        message = "assertNotEqual: " ansi("underline", x)       \
            " IS EQUAL TO " ansi("underline", y)
    assertFalse(x == y, name, message, ansiCode)
}

function START_TEST(name) {
    print(ansi("negative", ansi("bold", "====== TESTING FOR "   \
                                ansi("underline", name) " STARTED")))
    G_COUNTER = G_SUCCESS = 0
}

function END_TEST() {
    TOTAL = G_COUNTER; COUNTER = G_SUCCESS - 1
    G_FAILURE = G_COUNTER - G_SUCCESS
    if (G_FAILURE) {
        assertEqual(G_COUNTER, G_SUCCESS, "COMPLETED",                  \
                    G_SUCCESS " PASSED, " G_FAILURE " FAILED", "yellow")
        exit 1
    } else
        assertEqual(G_COUNTER, G_SUCCESS, "COMPLETED. PERFECT!")
}

@include "test/TestCommons"
