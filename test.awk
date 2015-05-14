#!/usr/bin/gawk -f
@include "include/Commons"

function pass(name, message, ansiCode,    string) {
    if (!name) name = TEST
    if (!ansiCode) ansiCode = "green"

    G_COUNTER++; COUNTER++; G_SUCCESS++
    string = sprintf("(%2s/%-2s) TESTING %s", COUNTER, TOTAL, name)
    if (message) string = string "\n       " message
    print(ansi(ansiCode, ansi("bold", "[PASS] " string)))
}

function fail(name, message, ansiCode,    string) {
    if (!name) name = TEST
    if (!ansiCode) ansiCode = "red"

    G_COUNTER++; COUNTER++
    string = sprintf("(%2s/%-2s) TESTING %s", COUNTER, TOTAL, name)
    if (message) string = string "\n       " message
    print(ansi(ansiCode, ansi("bold", "[FAIL] " string)))
}

function assertTrue(x, name, message, ansiCode) {
    if (x)
        pass(name, "", ansiCode)
    else {
        if (!message) message = "assertTrue: FALSE"
        fail(name, message, ansiCode)
    }
}

function assertFalse(x, name, message, ansiCode) {
    if (!message) message = "assertFalse: TRUE"
    assertTrue(!x, name, message, ansiCode)
}

function assertEqual(x, y, name, message, ansiCode,    i) {
    if (!message)
        message = "assertEqual: " ansi("underline", toString(x, 1))     \
            " IS NOT EQUAL TO " ansi("underline", toString(y, 1))
    assertTrue(identical(x, y), name, message, ansiCode)
}

function assertNotEqual(x, y, name, message, ansiCode,    i) {
    if (!message)
        message = "assertNotEqual: " ansi("underline", toString(x, 1))  \
            " IS EQUAL TO " ansi("underline", toString(y, 1))
    assertFalse(identical(x, y), name, message, ansiCode)
}

function T(test, total) {
    TEST = test
    TOTAL = total
    COUNTER = 0
}

function START_TEST(name) {
    print(ansi("negative", ansi("bold", "====== TESTING FOR "           \
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

@include "test/Test"
