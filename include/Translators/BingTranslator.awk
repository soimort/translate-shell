####################################################################
# BingTranslator.awk                                               #
####################################################################
#
# Last Updated: 26 Dec 2015
# https://www.bing.com/translator/dynamic/226010/js/LandingPage.js

function genRTTAppId(    content, group, header, isBody) {
    HttpProtocol = "http://"
    HttpHost = "www.bing.com"
    HttpPort = 80
    LandingPage = "/translator/dynamic/226010/js/LandingPage.js"

    if (Option["proxy"]) {
        match(Option["proxy"], /^(http:\/*)?([^\/]*):([^\/:]*)/, HttpProxySpec)
        HttpService = "/inet/tcp/0/" HttpProxySpec[2] "/" HttpProxySpec[3]
        HttpPathPrefix = HttpProtocol HttpHost
    } else {
        HttpService = "/inet/tcp/0/" HttpHost "/" HttpPort
        HttpPathPrefix = ""
    }

    header = "GET " LandingPage " HTTP/1.1\n"                           \
        "Host: " HttpHost "\n"                                          \
        "Connection: close\n"
    if (Option["user-agent"])
        header = header "User-Agent: " Option["user-agent"] "\n"

    content = NULLSTR; isBody = 0
    print header |& HttpService
    while ((HttpService |& getline) > 0) {
        if (isBody)
            content = content ? content "\n" $0 : $0
        else if (length($0) <= 1)
            isBody = 1
        l(sprintf("%4s bytes > %s", length($0), length($0) < 1024 ? $0 : "..."))
    }
    close(HttpService)

    match(content, /rttAppId:"([^"]+)"/, group)
    if (group[1]) {
        RTTAppId = group[1]
    } else {
        e("[ERROR] Oops! Something went wrong and I can't translate it for you :(")
        exit 1
    }
}

function bingInit() {
    genRTTAppId() # generate a one-time key

    HttpProtocol = "http://"
    HttpHost = "api.microsofttranslator.com"
    HttpPort = 80
}

function bingRequestUrl(text, sl, tl, hl,
                        ####
                        appId) {
    # Quick hack: Bing doesn't have an "auto" language code
    if (sl == "auto") sl = NULLSTR

    return HttpPathPrefix "/v2/ajax.svc/TranslateArray2?"               \
        "appId="  preprocess(parameterize(RTTAppId, "\""))              \
        "&from="  preprocess(parameterize(sl, "\""))                    \
        "&to="    preprocess(parameterize(tl, "\""))                    \
        "&texts=" preprocess("[" parameterize(text, "\"") "]")
}

function bingTTSUrl(text, tl) {
    return HttpProtocol HttpHost "/v2/http.svc/speak?" "appId=" RTTAppId \
        "&language=" tl "&text=" preprocess(text)                       \
        "&format=audio/mp3" "&options=MinSize|male"
}

function bingWebTranslateUrl(uri, sl, tl, hl) {
    return "http://www.microsofttranslator.com/bv.aspx?"        \
        "from=" sl "&to=" tl "&a=" uri
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

    content = getResponse(text, _sl, _tl, _hl)
    # Strip the content and get a valid JSON string
    match(content, /(\[.*\])$/, group)
    if (!group[0]) {
        e("[ERROR] " content)
        ExitCode = 1
        return
    }
    content = group[1]
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

    translation = unparameterize(ast[0 SUBSEP 0 SUBSEP "TranslatedText"])

    returnIl[0] = il = unparameterize(ast[0 SUBSEP 0 SUBSEP "From"])
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
