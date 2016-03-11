####################################################################
# YandexTranslate.awk                                              #
####################################################################
#
# Last Updated: 11 Mar 2016
BEGIN { provides("yandex") }

function genSID(    content, group, temp) {
    content = curl("http://translate.yandex.com")

    match(content, /SID:[[:space:]]*'([^']+)'/, group)
    if (group[1]) {
        split(group[1], temp, ".")
        SID = reverse(temp[1]) "." reverse(temp[2]) "." reverse(temp[3])
    } else {
        e("[ERROR] Oops! Something went wrong and I can't translate it for you :(")
        exit 1
    }
}

function yandexInit() {
    genSID() # generate a one-time key
    YandexWebTranslate = "z5h64q92x9.net" # host for web translation

    HttpProtocol = "http://"
    HttpHost = "translate.yandex.net"
    HttpPort = 80
}

function yandexRequestUrl(text, sl, tl, hl,    group) {
    # Quick hack: Yandex doesn't support digraphia code (yet)
    split(sl, group, "-"); sl = group[1]
    split(tl, group, "-"); tl = group[1]

    return HttpPathPrefix "/api/v1/tr.json/translate?"                  \
        "id=" SID "&srv=tr-text"                                        \
        "&text=" preprocess(text) "&lang=" (sl == "auto" ? tl : sl "-" tl)
}

function yandexTTSUrl(text, tl) {
    switch (tl) { # List of available TTS language codes
    case "ar": tl = "ar_AE"; break
    case "cs": tl = "cs_CZ"; break
    case "da": tl = "da_DK"; break
    case "de": tl = "de_DE"; break
    case "el": tl = "el_GR"; break
    case "en": tl = "en_GB"; break
    case "es": tl = "es_ES"; break
    case "fi": tl = "fi_FI"; break
    case "fr": tl = "fr_FR"; break
    case "it": tl = "it_IT"; break
    case "nl": tl = "nl_NL"; break
    case "no": tl = "no_NO"; break
    case "pl": tl = "pl_PL"; break
    case "pt": tl = "pt_PT"; break
    case "ru": tl = "ru_RU"; break
    case "sv": tl = "sv_SE"; break
    case "tr": tl = "tr_TR"; break
    default: tl = NULLSTR
    }
    return HttpProtocol "tts.voicetech.yandex.net" "/tts?"              \
        "text=" preprocess(text) (tl ? "&lang=" tl : tl)                \
        "&format=mp3" "&quality=hi"
}

function yandexWebTranslateUrl(uri, sl, tl, hl) {
    gsub(/:\/\//, "/", uri)
    return HttpProtocol YandexWebTranslate "/proxy_u/"  \
        (sl == "auto" ? tl : sl "-" tl)"/" uri
}

# Get the translation of a string.
function yandexTranslate(text, sl, tl, hl,
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
    if (ast[0 SUBSEP "code"] != "200") {
        e("[ERROR] " unparameterize(ast[0 SUBSEP "message"]))
        ExitCode = 1
        return
    }

    translation = unparameterize(ast[0 SUBSEP "text" SUBSEP 0])

    split(unparameterize(ast[0 SUBSEP "lang"]), group, "-")
    returnIl[0] = il = group[1]
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
