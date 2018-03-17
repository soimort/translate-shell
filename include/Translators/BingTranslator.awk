####################################################################
# BingTranslator.awk                                               #
####################################################################
#
# Last Updated: 17 Mar 2018
BEGIN { provides("bing") }

function bingInit() {
    HttpProtocol = "http://"
    HttpHost = "www.bing.com"
    HttpPort = 80
}

# Retrieve the Cookie and set IG.
function bingSetCookie(    content, cookie, group, header, isBody, url) {
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
            content = content ? content "\r\n" $0 : $0
        else if (length($0) <= 1)
            isBody = 1
        l(sprintf("%4s bytes > %s", length($0), length($0) < 1024 ? $0 : "..."))
    }
    close(HttpService)

    Cookie = cookie
    match(content, /IG:"([^"]+)"/, group)
    if (group[1]) {
        IG = group[1]
    } else {
        e("[ERROR] Oops! Something went wrong and I can't translate it for you :(")
        exit 1
    }
}

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
    else if (tl == "ar") tl = tl "-EG" # FIXME: sometimes doesn't work. Why?
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

    header = "GET " "/translator/api/language/Speak?"                   \
        "locale=" tl "&text=" preprocess(text)                          \
        "&gender=" gender "&media=audio/mp3" " HTTP/1.1\r\n"              \
        "Host: " HttpHost "\r\n"                                          \
        "Connection: close\r\n"
    if (Option["user-agent"])
        header = header "User-Agent: " Option["user-agent"] "\r\n"
    if (Cookie)
        header = header "Cookie: " Cookie "\r\n" # must!

    content = NULLSTR; isBody = 0
    print header |& HttpService
    while ((HttpService |& getline) > 0) {
        if (isBody)
            content = content ? content "\r\n" $0 : $0
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

function bingWebTranslateUrl(uri, sl, tl, hl) {
    return "http://www.microsofttranslator.com/bv.aspx?"        \
        "from=" sl "&to=" tl "&a=" uri
}

# Dictionary API (via HTTP GET).
function bingRequestUrl(text, sl, tl, hl) {
    return HttpPathPrefix "/translator/api/Dictionary/Lookup?"  \
        "from=" sl "&to=" tl "&text=" preprocess(text)
}

function bingPostRequestUrl(text, sl, tl, hl, type) {
    if (type == "translate")
        return HttpPathPrefix "/ttranslate?&IG=" IG "&IID=translator.5032.2"
    else if (type == "translationlookup")
        return HttpPathPrefix "/ttranslationlookup?&IG=" IG "&IID=translator.5032.2"
    else if (type == "transliterate")
        return HttpPathPrefix "/ttransliterate?&IG=" IG "&IID=translator.5032.1"
    else # type == "detect"
        return HttpPathPrefix "/tdetect?&IG=" IG "&IID=translator.5032.2"
}

function bingPostRequestContentType(text, sl, tl, hl, type) {
    return "application/x-www-form-urlencoded"
}

function bingPostRequestBody(text, sl, tl, hl, type) {
    if (type == "translate")
        return "&text=" quote(text) "&from=" sl "&to=" tl
    else if (type == "translationlookup")
        return "&text=" quote(text) "&from=" sl "&to=" tl
    else if (type == "transliterate")
        return "&text=" quote(text) "&language=" sl "&toScript=" "latn"
    else # type == "detect"
        return "&text=" quote(text)
}

# Get the translation of a string.
function bingTranslate(text, sl, tl, hl,
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

    bingSetCookie() # set IG

    # Language identification
    il = postResponse(text, _sl, _tl, _hl, "detect")
    if (!il) {
        e("[ERROR] Oops! Something went wrong and I can't translate it for you :(")
        ExitCode = 1
        return
    }
    returnIl[0] = il
    if (Option["verbose"] < -1)
        return il
    if (Option["verbose"] < 0)
        return getList(il)

    # Hot-patches for Bing's own translator language codes
    # See: <https://msdn.microsoft.com/en-us/library/hh456380.aspx>
    if (_sl == "auto")  _sl = il
    if (_sl == "bs")    _sl = "bs-Latn" # 'bs' is not recognized as valid code
    if (_sl == "zh-CN") _sl = "zh-CHS"
    if (_sl == "zh-TW") _sl = "zh-CHT"
    if (_tl == "bs")    _tl = "bs-Latn"
    if (_tl == "zh-CN") _tl = "zh-CHS"
    if (_tl == "zh-TW") _tl = "zh-CHT"

    # Translation
    content = postResponse(text, _sl, _tl, _hl, "translate")
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
    } else if (ast[0 SUBSEP "statusCode"] != "200") {
        e("[ERROR] statusCode: " ast[0 SUBSEP "statusCode"])
        ExitCode = 1
        return
    }

    translation = unparameterize(ast[0 SUBSEP "translationResponse"])

    # Generate output
    if (!isVerbose) {
        # Brief mode
        r = translation

    } else {
        # Verbose mode

        wShowOriginal = Option["show-original"]
        wShowTranslation = Option["show-translation"]
        wShowLanguages = Option["show-languages"]
        wShowDictionary = Option["show-dictionary"]

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

        if (wShowDictionary && false) { # FIXME!
            # Dictionary API
            # Note: source language must be identified
            dicContent = getResponse(text, il, _tl, _hl)
            tokenize(dicTokens, dicContent)
            parseJson(dicAst, dicTokens) # FIXME: inefficient parser

            if (anything(dicAst)) {
                # Display: dictionary entries
                if (r) r = r RS
                r = r m("-- display dictionary entries")

                # TODO
            }
        }
    }

    if (toSpeech) {
        returnPlaylist[0]["text"] = translation
        returnPlaylist[0]["tl"] = tl
    }

    return r
}
