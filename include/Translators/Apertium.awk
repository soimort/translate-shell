####################################################################
# Apertium.awk                                                     #
####################################################################
#
# Last Updated: 14 Mar 2016
BEGIN { provides("apertium") }

function apertiumInit() {
    HttpProtocol = "http://"
    HttpHost = "www.apertium.org"
    HttpPort = 80
}

function apertiumRequestUrl(text, sl, tl, hl) {
    return HttpPathPrefix "/apy/translate?"                             \
        "langpair=" preprocess(sl) "|" preprocess(tl)                   \
        "&q=" preprocess(text)
}

function apertiumTTSUrl(text, tl,    narrator) {
    # Not implemented
}

function apertiumWebTranslateUrl(uri, sl, tl, hl) {
    # Not implemented
}

# Get the translation of a string.
function apertiumTranslate(text, sl, tl, hl,
                           isVerbose, toSpeech, returnPlaylist, returnIl,
                           ####
                           r,
                           content, tokens, ast,
                           _sl, _tl, _hl, il,
                           translation,
                           wShowOriginal, wShowTranslation, wShowLanguages,
                           group, temp) {
    if (!getCode(tl)) {
        # Check if target language is supported
        w("[WARNING] Unknown target language code: " tl)
    } else if (isRTL(tl)) {
        # Check if target language is R-to-L
        if (!FriBidi)
            w("[WARNING] " getName(tl) " is a right-to-left language, but FriBidi is not found.")
    }
    _sl = getCode(sl); if (!_sl) _sl = sl
    _tl = getCode(tl); if (!_tl) _tl = tl
    _hl = getCode(hl); if (!_hl) _hl = hl

    # Quick hack: Apertium doesn't have an "auto" language code
    _sl = "auto" == _sl ? "en" : _sl

    content = getResponse(text, _sl, _tl, _hl)
    tokenize(tokens, content)
    parseJson(ast, tokens)

    l(content, "content", 1, 1)
    l(tokens, "tokens", 1, 0, 1)
    l(ast, "ast")
    if (!isarray(ast) || !anything(ast)) {
        e("[ERROR] Oops! Something went wrong and I can't translate it for you :(")
        ExitCode = 1
        return
    }

    translation = unparameterize(ast[0 SUBSEP "responseData" SUBSEP])

    returnIl[0] = il = _sl
    if (Option["verbose"] < 0)
        return getList(il)

    # Generate output
    if (!isVerbose) {
        # Brief mode
        r = translation

    } else {
        # Verbose mode
        wShowOriginal = Option["show-original"]
        wShowTranslation = Option["show-translation"]
        wShowLanguages = Option["show-languages"]

        if (wShowOriginal) {
            # Display: original text
            if (r) r = r RS RS
            r = r m("-- display original text")
            r = r prettify("original", s(text, il))
        }

        if (wShowTranslation) {
            # Display: major translation
            if (r) r = r RS RS
            r = r m("-- display major translation")
            r = r prettify("translation", s(translation, tl))
        }

        if (wShowLanguages) {
            # Display: source language -> target language
            if (r) r = r RS RS
            r = r m("-- display source language -> target language")
            temp = Option["fmt-languages"]
            if (!temp) temp = "[ %s -> %t ]"
            split(temp, group, /(%s|%S|%t|%T)/)
            r = r prettify("languages", group[1])
            if (temp ~ /%s/)
                r = r prettify("languages-sl", getDisplay(il))
            if (temp ~ /%S/)
                r = r prettify("languages-sl", getName(il))
            r = r prettify("languages", group[2])
            if (temp ~ /%t/)
                r = r prettify("languages-tl", getDisplay(tl))
            if (temp ~ /%T/)
                r = r prettify("languages-tl", getName(tl))
            r = r prettify("languages", group[3])
        }
    }

    if (toSpeech) {
        returnPlaylist[0]["text"] = translation
        returnPlaylist[0]["tl"] = tl
    }

    return r
}
