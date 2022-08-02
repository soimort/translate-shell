####################################################################
# BingTranslator.awk                                               #
####################################################################
#
# Last Updated: 8 Jun 2022
BEGIN { provides("bing") }

function bingInit() {
    HttpProtocol = "http://"
    HttpHost = "www.bing.com"
    HttpPort = 80
}

# Set IG, IID, and BingTokenKey (a URL-encoded string containing token and key).
function bingSetup(    ast, content, cookie, group, header, isBody, key,
                       location, status, token, tokens, url) {
    url = HttpPathPrefix "/translator"

    header = "GET " url " HTTP/1.1\r\n"                                 \
        "Host: " HttpHost "\r\n"                                        \
        "Connection: close\r\n"
    if (Option["user-agent"])
        header = header "User-Agent: " Option["user-agent"] "\r\n"

    cookie = NULLSTR
    print header |& HttpService
    while ((HttpService |& getline) > 0) {
        match($0, /Set-Cookie: ([^;]*);/, group)
        if (group[1]) {
            cookie = cookie (cookie ?  "; " : NULLSTR) group[1]
        }
        if (isBody)
            content = content ? content "\n" $0 : $0
        else if (length($0) <= 1)
            isBody = 1
        else { # interesting fields in header
            match($0, /^HTTP[^ ]* ([^ ]*)/, group)
            if (RSTART) status = group[1]
            match($0, /^Location: (.*)/, group)
            if (RSTART) location = squeeze(group[1]) # squeeze the URL!
        }
        l(sprintf("%4s bytes > %s", length($0), length($0) < 1024 ? $0 : "..."))
    }
    close(HttpService)

    if ((status == "301" || status == "302") && location)
        content = curl(location)
    # FIXME: cookie
    Cookie = cookie

    match(content, /IG:"([^"]+)"/, group)
    if (group[1]) {
        IG = group[1]
        l(IG, "IG")
    } else {
        e("[ERROR] Failed to extract IG.")
        exit 1
    }

    match(content, /data-iid="([^"]+)"/, group)
    if (group[1]) {
        IID = group[1]
        l(IID, "IID")
    } else {
        e("[ERROR] Failed to extract IID.")
        exit 1
    }

    match(content, /params_RichTranslateHelper = ([^;]+);/, group)
    if (group[1]) {
        tokenize(tokens, group[1])
        parseJson(ast, tokens)
        key = ast[0 SUBSEP 0]
        token = unparameterize(ast[0 SUBSEP 1])
        BingTokenKey = sprintf("&token=%s&key=%s", quote(token), quote(key))
        l(BingTokenKey, "BingTokenKey")
    } else {
        e("[ERROR] Failed to extract token & key.")
        exit 1
    }
}

# FIXME!
function bingTTSUrl(text, tl,
                    ####
                    country, gender, i, group,
                    header, content, isBody) {
    gender = "female"
    country = NULLSTR
    split(Option["narrator"], group, ",")
    for (i in group) {
        if (group[i] ~ /^(f(emale)?|w(oman)?)$/)
            gender = "female"
        else if (group[i] ~ /^m(ale|an)?$/)
            gender = "male"
        else
            country = group[i]
    }

    # Automatic ISO country code
    if (country) tl = tl "-" country
    else if (tl == "ar") tl = tl "-EG" # sometimes doesn't work. Why?
    else if (tl == "da") tl = tl "-DK"
    else if (tl == "de") tl = tl "-DE"
    else if (tl == "en") tl = tl "-US"
    else if (tl == "es") tl = tl "-ES"
    else if (tl == "fi") tl = tl "-FI"
    else if (tl == "fr") tl = tl "-FR"
    else if (tl == "it") tl = tl "-IT"
    else if (tl == "ja") tl = tl "-JP"
    else if (tl == "ko") tl = tl "-KR"
    else if (tl == "nl") tl = tl "-NL"
    else if (tl == "nb") tl = tl "-NO" # Norwegian Bokmål
    else if (tl == "pl") tl = tl "-PL"
    else if (tl == "pt") tl = tl "-PT"
    else if (tl == "ru") tl = tl "-RU"
    else if (tl == "sv") tl = tl "-SE"
    else if (tl == "yue") ;
    else if (tl == "zh") tl = tl "-CN"

    header = "GET " "/tspeak?"                                          \
        "&language=" tl "&text=" preprocess(text)                       \
        "&options=" gender "&format=audio%2Fmp3" " HTTP/1.1\r\n"        \
        "Host: " HttpHost "\r\n"                                        \
        "Connection: close\r\n"
    if (Option["user-agent"])
        header = header "User-Agent: " Option["user-agent"] "\r\n"
    if (Cookie)
        header = header "Cookie: " Cookie "\r\n"

    content = NULLSTR; isBody = 0
    print header |& HttpService
    while ((HttpService |& getline) > 0) {
        if (isBody)
            content = content ? content "\n" $0 : $0
        else if (length($0) <= 1)
            isBody = 1
        #l(sprintf("%4s bytes > %s", length($0), $0))
    }
    close(HttpService)

    if (!TempFile)
        TempFile = getOutput("mktemp")
    printf("%s", content) > TempFile
    close(TempFile)
    return TempFile
}

function bingWebTranslateUrl(uri, sl, tl, hl,    _sl, _tl) {
    # Hot-patches for language codes
    _sl = sl; _tl = tl
    if (_sl == "zh")    _sl = "zh-CHS" # still old format
    if (_sl == "zh-CN") _sl = "zh-CHS"
    if (_sl == "zh-TW") _sl = "zh-CHT"
    if (_tl == "zh")    _tl = "zh-CHS"
    if (_tl == "zh-CN") _tl = "zh-CHS"
    if (_tl == "zh-TW") _tl = "zh-CHT"

    return "https://www.translatetheweb.com/?" "from=" _sl "&to=" _tl "&a=" uri
}

# [OBSOLETE?] Old dictionary API (via HTTP GET).
function bingRequestUrl(text, sl, tl, hl) {
    return HttpPathPrefix "/translator/api/Dictionary/Lookup?"  \
        "from=" sl "&to=" tl "&text=" preprocess(text)
}

# Main Bing Translator API (via HTTP POST).
function bingPostRequestUrl(text, sl, tl, hl, type) {
    if (type == "lookup")
        return HttpPathPrefix "/tlookupv3"
    #else if (type == "transliterate")
    #    return HttpPathPrefix "/ttransliteratev3"
    else # type == "translate"
        return HttpPathPrefix "/ttranslatev3" sprintf("?IG=%s&IID=%s", IG, IID)
}

function bingPostRequestContentType(text, sl, tl, hl, type) {
    return "application/x-www-form-urlencoded"
}

function bingPostRequestUserAgent(text, sl, tl, hl, type) {
    return ""
}

function bingPostRequestBody(text, sl, tl, hl, type) {
    if (type == "lookup")
        return "&text=" quote(text) "&from=" sl "&to=" tl
    #else if (type == "transliterate")
    #    return "&text=" quote(text) "&language=" sl "&toScript=" "latn"
    else # type == "translate"
        return "&text=" quote(text) "&fromLang=" sl "&to=" tl BingTokenKey
}

# Get the translation of a string.
function bingTranslate(text, sl, tl, hl,
                       isVerbose, toSpeech, returnPlaylist, returnIl,
                       ####
                       r,
                       content, tokens, ast, dicContent, dicTokens, dicAst,
                       _sl, _tl, _hl, il, isPhonetic,
                       translation, phonetics, oPhonetics,
                       wordClasses, words, wordBackTranslations,
                       wShowOriginal, wShowOriginalPhonetics,
                       wShowTranslation, wShowTranslationPhonetics,
                       wShowLanguages, wShowDictionary,
                       i, j, k, group, temp, saveSortedIn) {
    isPhonetic = match(tl, /^@/)
    tl = substr(tl, 1 + isPhonetic)

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

    bingSetup()

    # Hot-patches for Bing's own translator language codes
    # See: <https://docs.microsoft.com/en-us/azure/cognitive-services/Translator/language-support>
    if (_sl == "auto")  _sl = "auto-detect"
    if (_sl == "tl")    _sl = "fil" # Bing uses 'fil' for Filipino
    if (_sl == "hmn")   _sl = "mww" # Bing uses 'mww' for Hmong Daw
    if (_sl == "ku")    _sl = "kmr" # Bing uses 'kmr' for Northern Kurdish
    else if (_sl == "ckb") _sl = "ku" # and 'ku' for Central Kurdish
    if (_sl == "no")    _sl = "nb"  # Bing uses Norwegian Bokmål
    # Bing uses 'pt' or 'pt-br' for Brazilian Portuguese, 'pt-pt' for European Portuguese
    if (_sl == "pt-BR") _sl = "pt" # just pt-br
    else if (_sl == "pt-PT") _sl = "pt" # FIXME: support pt-pt
    if (_sl == "zh-CN") _sl = "zh-Hans"
    if (_sl == "zh-TW") _sl = "zh-Hant"
    if (_tl == "tl")    _tl = "fil"
    if (_tl == "hmn")   _tl = "mww"
    if (_tl == "ku")    _tl = "kmr"
    else if (_tl == "ckb") _tl = "ku"
    if (_tl == "no")    _tl = "nb"
    if (_tl == "pt-BR") _tl = "pt"
    else if (_tl == "pt-PT") _tl = "pt-pt"
    if (_tl == "zh-CN") _tl = "zh-Hans"
    if (_tl == "zh-TW") _tl = "zh-Hant"

    # Translation
    content = postResponse(text, _sl, _tl, _hl, "translate")
    if (content == "") {
        # Empty content. Assume "301 Moved Permanently" and use cn.bing.com
        HttpHost = "cn.bing.com"
        # Just dirty hack
        if (Option["proxy"]) {
            HttpPathPrefix = HttpProtocol HttpHost
        } else {
            HttpService = "/" "inet" "/tcp/0/" HttpHost "/" HttpPort  # FIXME: inet version
        }

        # Try again
        content = postResponse(text, _sl, _tl, _hl, "translate")
    }
    if (Option["dump"])
        return content
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

    translation = unparameterize(ast[0 SUBSEP 0 SUBSEP "translations" SUBSEP 0 SUBSEP "text"])

    returnIl[0] = il = _sl == "auto-detect" ?
        unparameterize(ast[0 SUBSEP 0 SUBSEP "detectedLanguage" SUBSEP "language"]) : _sl
    if (Option["verbose"] < -1)
        return il
    if (Option["verbose"] < 0)
        return getList(il)

    # Transliteration
    wShowTranslationPhonetics = Option["show-translation-phonetics"]
    if (wShowTranslationPhonetics) {
        split(_tl, group, "-")
        #content = postResponse(translation, group[1], group[1], _hl, "transliterate")
        #phonetics = unparameterize(content)
        phonetics = unparameterize(ast[0 SUBSEP 0 SUBSEP "translations" SUBSEP 0 SUBSEP "transliteration" \
                                       SUBSEP "text"])
        if (phonetics == translation) phonetics = ""
    }

    # Generate output
    if (!isVerbose) {
        # Brief mode

        r = isPhonetic && phonetics ?
            prettify("brief-translation-phonetics", join(phonetics, " ")) :
            prettify("brief-translation", s(translation, tl))

    } else {
        # Verbose mode

        wShowOriginal = Option["show-original"]
        wShowTranslation = Option["show-translation"]
        wShowLanguages = Option["show-languages"]
        wShowDictionary = Option["show-dictionary"]

        # Transliteration (original)
        wShowOriginalPhonetics = Option["show-original-phonetics"]
        if (wShowOriginalPhonetics) {
            split(_sl, group, "-")
            #content = postResponse(text, group[1], group[1], _hl, "transliterate")
            #oPhonetics = unparameterize(content)
            delete ast  # purge old AST
            content = postResponse(text, il, il, _hl, "translate")
            tokenize(tokens, content)
            parseJson(ast, tokens)
            oPhonetics = unparameterize(ast[0 SUBSEP 0 SUBSEP "translations" SUBSEP 0 \
                                            SUBSEP "transliteration" SUBSEP "text"])
            if (oPhonetics == text) oPhonetics = ""
        }

        if (!oPhonetics) wShowOriginalPhonetics = 0
        if (!phonetics) wShowTranslationPhonetics = 0

        if (wShowOriginal) {
            # Display: original text & phonetics
            if (r) r = r RS RS
            r = r m("-- display original text")
            r = r prettify("original", s(text, _sl))
            if (wShowOriginalPhonetics)
                r = r RS prettify("original-phonetics", showPhonetics(join(oPhonetics, " "), _sl))
        }

        if (wShowTranslation) {
            # Display: major translation & phonetics
            if (r) r = r RS RS
            r = r m("-- display major translation")
            r = r prettify("translation", s(translation, tl))
            if (wShowTranslationPhonetics)
                r = r RS prettify("translation-phonetics", showPhonetics(join(phonetics, " "), tl))
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

        if (wShowDictionary) {
            # Dictionary API
            dicContent = postResponse(text, il, _tl, _hl, "lookup")
            if (dicContent != "") {
                tokenize(dicTokens, dicContent)
                parseJson(dicAst, dicTokens)

                l(dicContent, "dicContent", 1, 1)
                l(dicTokens, "dicTokens", 1, 0, 1)
                l(dicAst, "dicAst")

                saveSortedIn = PROCINFO["sorted_in"]
                PROCINFO["sorted_in"] = "compareByIndexFields"
                for (i in dicAst) {
                    if (match(i, "^0" SUBSEP "0" SUBSEP "translations" SUBSEP "([[:digit:]]+)" SUBSEP \
                              "posTag$", group))
                        wordClasses[group[1]] = tolower(literal(dicAst[i]))
                }
                for (i in dicAst) {
                    if (match(i, "^0" SUBSEP "0" SUBSEP "translations" SUBSEP "([[:digit:]]+)" SUBSEP \
                              "displayTarget$", group))
                        words[wordClasses[group[1]]][group[1]] = literal(dicAst[i])
                    if (match(i, "^0" SUBSEP "0" SUBSEP "translations" SUBSEP "([[:digit:]]+)" SUBSEP \
                              "backTranslations" SUBSEP "([[:digit:]]+)" SUBSEP "displayText$", group))
                        wordBackTranslations[wordClasses[group[1]]][group[1]][group[2]] = literal(dicAst[i])
                }
                PROCINFO["sorted_in"] = saveSortedIn

                # Display: dictionary entries
                if (r) r = r RS
                r = r m("-- display dictionary entries")
                for (i = 0; i < length(words); i++) {
                    r = (i > 0 ? r RS : r) RS prettify("dictionary-word-class", s(wordClasses[i], hl))

                    for (j in words[wordClasses[i]]) {
                        r = r RS prettify("dictionary-word", ins(1, words[wordClasses[i]][j], tl))

                        if (isRTL(il))
                            explanation = join(wordBackTranslations[wordClasses[i]][j], ", ")
                        else {
                            explanation = prettify("dictionary-explanation-item",
                                                   wordBackTranslations[wordClasses[i]][j][0])
                            for (k = 1; k < length(wordBackTranslations[wordClasses[i]][j]); k++)
                                explanation = explanation prettify("dictionary-explanation", ", ") \
                                    prettify("dictionary-explanation-item",
                                             wordBackTranslations[wordClasses[i]][j][k])
                        }

                        if (isRTL(il))
                            r = r RS prettify("dictionary-explanation-item", ins(2, explanation, il))
                        else
                            r = r RS ins(2, explanation)
                    }
                }
            }
        }
    }

    if (toSpeech) {
        returnPlaylist[0]["text"] = translation
        returnPlaylist[0]["tl"] = _tl
    }

    return r
}
