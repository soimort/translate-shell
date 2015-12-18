####################################################################
# GenTK.awk                                                        #
####################################################################
#
# Last Updated: 18 Dec 2015
# https://translate.google.com/translate/releases/twsfe_w_20151214_RC03/r/js/desktop_module_main.js

function genRL(a, x,
               ####
               b, c, d, i, y) {
    tokenize(y, x)
    parseList(b, y)
    i = SUBSEP 0
    for (c = 0; c < length(b[i]) - 2; c += 3) {
        d = b[i][c + 2]
        d = d >= 97 ? d - 87 :
            d - 48 # convert to number
        d = b[i][c + 1] == 43 ? rshift(a, d) : lshift(a, d)
        a = b[i][c] == 43 ? and(a + d, 4294967295) : xor(a, d)
    }
    return a
}

function genTK(text,
               ####
               a, d, dLen, e, tkk, ub, vb) {
    tkk = systime() / 3600
    ub = "[43,45,51,94,43,98,43,45,102]"
    vb = "[43,45,97,94,43,54]"

    dLen = dump(text, d) # convert to byte array
    a = tkk
    for (e = 1; e <= dLen; e++)
        a = genRL(a + d[e], vb)
    a = genRL(a, ub)
    0 > a && (a = and(a, 2147483647) + 2147483648)
    a %= 1e6
    return a "." xor(a, tkk)
}
