####################################################################
# YandexTranslate.awk                                              #
####################################################################
#
# Last Updated: 16 May 2016
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
        "id=" SID "-0-0&srv=tr-text"                                    \
        "&text=" preprocess(text) "&lang=" (sl == "auto" ? tl : sl "-" tl)
}

function yandexPostRequestBody(text, sl, tl, hl, type) {
    # type == "translit"
    return "text=" quote(text) "&lang=" sl
}

function yandexGetDictionaryResponse(text, sl, tl, hl,    content, header, isBody, url) {
    # Quick hack: Yandex doesn't support digraphia code (yet)
    split(sl, group, "-"); sl = group[1]
    split(tl, group, "-"); tl = group[1]

    url = HttpPathPrefix "/dicservice.json/lookup?"                     \
        "sid=" SID                                                      \
        "&text=" preprocess(text) "&lang=" (sl == "auto" ? tl : sl "-" tl)

    header = "GET " url " HTTP/1.1\r\n"           \
        "Host: " "dictionary.yandex.net" "\r\n"   \
        "Connection: close\r\n"
    if (Option["user-agent"])
        header = header "User-Agent: " Option["user-agent"] "\r\n"

    content = NULLSTR; isBody = 0
    print header |& HttpService
    while ((HttpService |& getline) > 0) {
        if (isBody)
            content = content ? content "\r\n" $0 : $0
        else if (length($0) <= 1)
            isBody = 1
        l(sprintf("%4s bytes > %s", length($0), $0))
    }
    close(HttpService)

    return assert(content, "[ERROR] Null response.")
}

function yandexTTSUrl(text, tl,
                      ####
                      speaker, emotion, i, group) {
    speaker = NULLSTR
    emotion = NULLSTR
    split(Option["narrator"], group, ",")
    for (i in group) {
        if (group[i] ~ /^(g(ood)?|n(eutral)?|e(vil)?)$/)
            emotion = group[i]
        else if (group[i] ~ /^(f(emale)?|w(oman)?)$/)
            speaker = "alyss"
        else if (group[i] ~ /^m(ale|an)?$/)
            speaker = "zahar"
        else
            speaker = group[i]
    }

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
        (speaker ? "&speaker=" speaker : speaker)                       \
        (emotion ? "&emotion=" emotion : emotion)                       \
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
                         _sl, _tl, _hl, il, isPhonetic,
                         translation,
                         wShowOriginal, wShowTranslation, wShowLanguages,
                         wShowDictionary, dicContent, dicTokens, dicAst,
                         i, syn, mean,
                         group, temp) {
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

    content = getResponse(text, _sl, _tl, _hl)
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
    if (ast[0 SUBSEP "code"] != "200") {
        e("[ERROR] " unparameterize(ast[0 SUBSEP "message"]))
        ExitCode = 1
        return
    }

    translation = unparameterize(ast[0 SUBSEP "text" SUBSEP 0])

    # Transliteration
    wShowTranslationPhonetics = Option["show-translation-phonetics"]
    if (wShowTranslationPhonetics) {
        split(_tl, group, "-")
        data = yandexPostRequestBody(translation, group[1], group[1], _hl, "translit")
        content = curlPost("https://translate.yandex.net/translit/translit", data)
        phonetics = (content ~ /not supported$/) ? "" : unparameterize(content)
    }

    split(unparameterize(ast[0 SUBSEP "lang"]), group, "-")
    returnIl[0] = il = group[1]
    if (Option["verbose"] < -1)
        return il
    else if (Option["verbose"] < 0)
        return getList(il)

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

        if (!phonetics) wShowTranslationPhonetics = 0

        if (wShowOriginal) {
            # Display: original text
            if (r) r = r RS RS
            r = r m("-- display original text")
            r = r prettify("original", s(text, il))
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

        if (wShowDictionary && false) { # FIXME!
            # Dictionary API
            dicContent = yandexGetDictionaryResponse(text, _sl, _tl, _hl)
            tokenize(dicTokens, dicContent)
            parseJson(dicAst, dicTokens)

            if (anything(dicAst)) {
                # Display: dictionary entries
                if (r) r = r RS
                r = r m("-- display dictionary entries")

                saveSortedIn = PROCINFO["sorted_in"]
                PROCINFO["sorted_in"] = "@ind_num_asc"
                for (i in dicAst) {
                    if (i ~ "^0" SUBSEP "def" SUBSEP "[[:digit:]]+" SUBSEP \
                        "pos$") {
                        r = r RS prettify("dictionary-word-class", s((literal(dicAst[i])), hl))
                        syn = mean = ""
                    }

                    # TODO: ex, gen, ...

                    if (i ~ "^0" SUBSEP "def" SUBSEP "[[:digit:]]+" SUBSEP \
                        "tr" SUBSEP "[[:digit:]]+" SUBSEP               \
                        "mean" SUBSEP "[[:digit:]]+" SUBSEP "text") {
                        if (mean) {
                            mean = mean prettify("dictionary-explanation", ", ") \
                                prettify("dictionary-explanation-item", s((literal(dicAst[i])), sl))
                        } else {
                            mean = prettify("dictionary-explanation-item", s((literal(dicAst[i])), sl))
                        }
                    }

                    if (i ~ "^0" SUBSEP "def" SUBSEP "[[:digit:]]+" SUBSEP \
                        "tr" SUBSEP "[[:digit:]]+" SUBSEP               \
                        "syn" SUBSEP "[[:digit:]]+" SUBSEP "text") {
                        if (syn) {
                            syn = syn prettify("dictionary-explanation", ", ") \
                                prettify("dictionary-word", s((literal(dicAst[i])), il))
                        } else {
                            syn = prettify("dictionary-word", s((literal(dicAst[i])), il))
                        }
                    }

                    if (i ~ "^0" SUBSEP "def" SUBSEP "[[:digit:]]+" SUBSEP \
                        "tr" SUBSEP "[[:digit:]]+" SUBSEP "text$") {
                        text = prettify("dictionary-word", s((literal(dicAst[i])), il))
                        if (syn) {
                            r = r RS ins(1, text prettify("dictionary-explanation", ", ") syn)
                        } else {
                            r = r RS ins(1, text)
                        }
                        r = r RS ins(2, mean)
                        syn = mean = ""
                    }
                }
                PROCINFO["sorted_in"] = saveSortedIn
            }
        }
    }

    if (toSpeech) {
        returnPlaylist[0]["text"] = translation
        returnPlaylist[0]["tl"] = tl
    }

    return r
}
