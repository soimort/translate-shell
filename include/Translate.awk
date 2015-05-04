####################################################################
# Translate.awk                                                    #
####################################################################

# Detect external terminal pager (less, more, most).
function initPager() {
    Pager = !system("less -V" SUPOUT SUPERR) ?
        "less" :
        (!system("more -V" SUPOUT SUPERR) ?
         "more" :
         (!system("most" SUPOUT SUPERR) ?
          "most" :
          ""))
}

# Detect external audio player (mplayer, mpv, mpg123).
function initAudioPlayer() {
    AudioPlayer = !system("mplayer" SUPOUT SUPERR) ?
        "mplayer" :
        (!system("mpv" SUPOUT SUPERR) ?
         "mpv" :
         (!system("mpg123 --version" SUPOUT SUPERR) ?
          "mpg123" :
          ""))
}

# Detect external speech synthesizer (say, espeak).
function initSpeechSynthesizer() {
    SpeechSynthesizer = !system("say ''" SUPOUT SUPERR) ?
        "say" :
        (!system("espeak ''" SUPOUT SUPERR) ?
         "espeak" :
         "")
}

# Initialize `HttpService`.
function initHttpService() {
    HttpProtocol = "http://"
    HttpHost = "translate.google.com"
    HttpPort = 80
    if (Option["proxy"]) {
        match(Option["proxy"], /^(http:\/*)?([^\/]*):([^\/:]*)/, HttpProxySpec)
        HttpService = "/inet/tcp/0/" HttpProxySpec[2] "/" HttpProxySpec[3]
        HttpPathPrefix = HttpProtocol HttpHost
    } else {
        HttpService = "/inet/tcp/0/" HttpHost "/" HttpPort
        HttpPathPrefix = ""
    }
}

# Return a message for debugging.
function m(string) {
    if (Option["debug"])
        return ansi("blue", string) RS
}

# Pre-process string (URL-encode before send).
function preprocess(text) {
    return quote(text)
}

# Post-process string (remove any redundant whitespace).
function postprocess(text) {
    text = gensub(/ ([.,;:?!"])/, "\\1", "g", text)
    text = gensub(/(["]) /, "\\1", "g", text)
    return text
}

# Send an HTTP request and get response from Google Translate.
function getResponse(text, sl, tl, hl,    content, header, url) {
    url = HttpPathPrefix "/translate_a/single?client=t"                 \
        "&ie=UTF-8&oe=UTF-8"                                            \
        "&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&dt=at"  \
        "&q=" preprocess(text) "&sl=" sl "&tl=" tl "&hl=" hl
    header = "GET " url " HTTP/1.1\n"           \
        "Host: " HttpHost "\n"                  \
        "Connection: close\n"
    if (Option["user-agent"])
        header = header "User-Agent: " Option["user-agent"] "\n"

    print header |& HttpService
    while ((HttpService |& getline) > 0)
        content = $0
    close(HttpService)

    return assert(content, "[ERROR] Null response.")
}

# Print a string (to output file or terminal pager).
function p(string) {
    if (Option["view"])
        print string | Option["pager"]
    else
        print string > Option["output"]
}

# Play using Google Text-to-Speech engine.
function play(text, tl,    url) {
    url = HttpProtocol HttpHost "/translate_tts?ie=UTF-8"       \
        "&tl=" tl "&q=" preprocess(text)

    # Don't use getline from pipe here - the same pipe will be run only once for each AWK script!
    system(Option["player"] " " parameterize(url) SUPOUT SUPERR)
}

# Get the translation of a string.
function getTranslation(text, sl, tl, hl,
                        isVerbose, toSpeech, returnPlaylist,
                        ####
                        r,
                        content, tokens, ast,
                        il, ils, isPhonetic,
                        article, example, explanation, ref, word,
                        translation, translations, phonetics,
                        wordClasses, words, segments, altTranslations,
                        original, oPhonetics, oWordClasses, oWords,
                        oRefs, oSynonymClasses, oSynonyms,
                        oExamples, oSeeAlso,
                        wShowOriginal, wShowOriginalPhonetics,
                        wShowTranslation, wShowTranslationPhonetics,
                        wShowPromptMessage, wShowLanguages,
                        wShowOriginalDictionary, wShowDictionary,
                        wShowAlternatives,
                        hasWordClasses, hasAltTranslations,
                        i, j, k, group, temp, saveSortedIn) {
    isPhonetic = match(tl, /^@/)
    tl = substr(tl, 1 + isPhonetic)

    if (!getCode(tl)) {
        # Check if target language is supported
        w("[WARNING] Unknown target language code: " tl)
    } else if (isRTL(tl)) {
        # Check if target language is R-to-L
        if (!FriBidi)
            w("[WARNING] " getName(tl) " is a right-to-left language, but FriBidi cannot be found.")
    }

    content = getResponse(text, sl, tl, hl)
    tokenize(tokens, content)
    parseJsonArray(ast, tokens)

    # Debug mode
    if (Option["debug"]) {
        d(content)
        da(tokens, "tokens[%s]='%s'")
        da(ast, "ast[%s]='%s'")
    }

    if (!anything(ast)) {
        e("[ERROR] Oops! Something went wrong and I can't translate it for you :(")
        ExitCode = 1
        return
    }

    saveSortedIn = PROCINFO["sorted_in"]
    PROCINFO["sorted_in"] = "@ind_num_asc"
    for (i in ast) {
        if (i ~ "^0" SUBSEP "0" SUBSEP "[[:digit:]]+" SUBSEP "0$")
            append(translations, postprocess(literal(ast[i])))
        if (i ~ "^0" SUBSEP "0" SUBSEP "[[:digit:]]+" SUBSEP "1$")
            append(original, literal(ast[i]))
        if (i ~ "^0" SUBSEP "0" SUBSEP "[[:digit:]]+" SUBSEP "2$")
            append(phonetics, literal(ast[i]))
        if (i ~ "^0" SUBSEP "0" SUBSEP "[[:digit:]]+" SUBSEP "3$")
            append(oPhonetics, literal(ast[i]))

        # 1 - word classes and explanations
        if (match(i, "^0" SUBSEP "1" SUBSEP "([[:digit:]]+)" SUBSEP "0$", group))
            wordClasses[group[1]] = literal(ast[i])
        if (match(i, "^0" SUBSEP "1" SUBSEP "([[:digit:]]+)" SUBSEP "2" SUBSEP "([[:digit:]]+)" SUBSEP "([[:digit:]]+)$", group))
            words[group[1]][group[2]][group[3]] = literal(ast[i])
        if (match(i, "^0" SUBSEP "1" SUBSEP "([[:digit:]]+)" SUBSEP "2" SUBSEP "([[:digit:]]+)" SUBSEP "1" SUBSEP "([[:digit:]]+)$", group))
            words[group[1]][group[2]]["1"][group[3]] = literal(ast[i])

        # 5 - alternative translations
        if (match(i, "^0" SUBSEP "5" SUBSEP "([[:digit:]]+)" SUBSEP "0$", group)) {
            segments[group[1]] = literal(ast[i])
            altTranslations[group[1]][0] = ""
        }
        if (match(i, "^0" SUBSEP "5" SUBSEP "([[:digit:]]+)" SUBSEP "2" SUBSEP "([[:digit:]]+)" SUBSEP "0$", group))
            altTranslations[group[1]][group[2]] = postprocess(literal(ast[i]))

        # 8 - identified source languages
        if (i ~ "^0" SUBSEP "8" SUBSEP "0" SUBSEP "[[:digit:]]+$" ||
            i ~ "^0" SUBSEP "2$")
            append(ils, literal(ast[i]))

        # 11 - (original) word classes and synonyms
        if (match(i, "^0" SUBSEP "11" SUBSEP "([[:digit:]]+)" SUBSEP "0$", group))
            oSynonymClasses[group[1]] = literal(ast[i])
        if (match(i, "^0" SUBSEP "11" SUBSEP "([[:digit:]]+)" SUBSEP "1" SUBSEP "([[:digit:]]+)" SUBSEP "1$", group))
            if (ast[i]) {
                oRefs[literal(ast[i])][1] = group[1]
                oRefs[literal(ast[i])][2] = group[2]
            }
        if (match(i, "^0" SUBSEP "11" SUBSEP "([[:digit:]]+)" SUBSEP "1" SUBSEP "([[:digit:]]+)" SUBSEP "0" SUBSEP "([[:digit:]]+)$", group))
            oSynonyms[group[1]][group[2]][group[3]] = literal(ast[i])

        # 12 - (original) word classes and explanations
        if (match(i, "^0" SUBSEP "12" SUBSEP "([[:digit:]]+)" SUBSEP "0$", group))
            oWordClasses[group[1]] = literal(ast[i])
        if (match(i, "^0" SUBSEP "12" SUBSEP "([[:digit:]]+)" SUBSEP "1" SUBSEP "([[:digit:]]+)" SUBSEP "0$", group))
            oWords[group[1]][group[2]][0] = literal(ast[i])
        if (match(i, "^0" SUBSEP "12" SUBSEP "([[:digit:]]+)" SUBSEP "1" SUBSEP "([[:digit:]]+)" SUBSEP "1$", group))
            oWords[group[1]][group[2]][1] = literal(ast[i])
        if (match(i, "^0" SUBSEP "12" SUBSEP "([[:digit:]]+)" SUBSEP "1" SUBSEP "([[:digit:]]+)" SUBSEP "2$", group))
            oWords[group[1]][group[2]][2] = postprocess(literal(ast[i]))

        # 13 - (original) examples
        if (match(i, "^0" SUBSEP "13" SUBSEP "0" SUBSEP "([[:digit:]]+)" SUBSEP "0$", group))
            oExamples[group[1]] = postprocess(literal(ast[i]))

        # 14 - (original) see also
        if (match(i, "^0" SUBSEP "14" SUBSEP "0" SUBSEP "([[:digit:]]+)$", group))
            oSeeAlso[group[1]] = literal(ast[i])
    }
    PROCINFO["sorted_in"] = saveSortedIn

    translation = join(translations)

    il = !anything(ils) || belongsTo(sl, ils) ? sl : ils[0]

    # Generate output
    if (!isVerbose) {
        # Brief mode

        r = isPhonetic && anything(phonetics) ?
            join(phonetics) :  # phonetic transcription
            s(translation, tl) # target language

        if (toSpeech) {
            returnPlaylist[0]["text"] = translation
            returnPlaylist[0]["tl"] = tl
        }

    } else {
        # Verbose mode

        wShowOriginal = Option["show-original"]
        wShowOriginalPhonetics = Option["show-original-phonetics"]
        wShowTranslation = Option["show-translation"]
        wShowTranslationPhonetics = Option["show-translation-phonetics"]
        wShowPromptMessage = Option["show-prompt-message"]
        wShowLanguages = Option["show-languages"]
        wShowOriginalDictionary = Option["show-original-dictionary"]
        wShowDictionary = Option["show-dictionary"]
        wShowAlternatives = Option["show-alternatives"]

        if (!anything(oPhonetics)) wShowOriginalPhonetics = 0
        if (!anything(phonetics)) wShowTranslationPhonetics = 0
        if (il == tl && (isarray(oWordClasses) || isarray(oSynonymClasses))) {
            wShowOriginalDictionary = 1
            wShowTranslation = 0
        }
        hasWordClasses = isarray(wordClasses) && anything(wordClasses)
        hasAltTranslations = isarray(altTranslations[0]) && anything(altTranslations[0])
        if (!hasWordClasses && !hasAltTranslations)
            wShowPromptMessage = wShowLanguages = 0
        if (!hasWordClasses) wShowDictionary = 0
        if (hasWordClasses || !hasAltTranslations) wShowAlternatives = 0

        if (wShowOriginal) {
            # Display: original text & phonetics
            if (r) r = r RS RS
            r = r m("-- display original text & phonetics")
            r = r ansi("negative", ansi("bold", s(join(original), il)))
            if (wShowOriginalPhonetics)
                r = r RS showPhonetics(join(oPhonetics), il)
        }

        if (wShowTranslation) {
            # Display: major translation & phonetics
            if (r) r = r RS RS
            r = r m("-- display major translation & phonetics")
            r = r ansi("bold", s(translation, tl))
            if (wShowTranslationPhonetics)
                r = r RS showPhonetics(join(phonetics), tl)
        }

        if (wShowPromptMessage || wShowLanguages)
            if (r) r = r RS
        if (wShowPromptMessage) {
            if (hasWordClasses) {
                # Display: prompt message (Definitions of ...)
                if (r) r = r RS
                r = r m("-- display prompt message (Definitions of ...)")
                if (isRTL(hl)) # home language is R-to-L
                    r = r s(showDefinitionsOf(hl, join(original)))
                else # home language is L-to-R
                    r = r showDefinitionsOf(hl, ansi("underline", show(join(original), il)))
            } else if (hasAltTranslations) {
                # Display: prompt message (Translations of ...)
                if (r) r = r RS
                r = r m("-- display prompt message (Translations of ...)")
                if (isRTL(hl)) # home language is R-to-L
                    r = r s(showTranslationsOf(hl, join(original)))
                else # home language is L-to-R
                    r = r showTranslationsOf(hl, ansi("underline", show(join(original), il)))
            }
        }
        if (wShowLanguages) {
            # Display: source language -> target language
            if (r) r = r RS
            r = r m("-- display source language -> target language")
            r = r s(sprintf("[ %s -> %s ]", getEndonym(il), getEndonym(tl)))
        }

        if (wShowOriginalDictionary) {
            # Display: original dictionary
            if (isarray(oWordClasses) && anything(oWordClasses)) {
                # Detailed explanations
                if (r) r = r RS
                r = r m("-- display original dictionary (detailed explanations)")
                for (i = 0; i < length(oWordClasses); i++) {
                    r = (i > 0 ? r RS : r) RS s(oWordClasses[i], hl)
                    for (j = 0; j < length(oWords[i]); j++) {
                        explanation = oWords[i][j][0]
                        ref = oWords[i][j][1]
                        example = oWords[i][j][2]

                        r = (j > 0 ? r RS : r) RS ansi("bold", ins(1, explanation, il))
                        if (example)
                            r = r RS ins(2, "- \"" example "\"", il)
                        if (ref && isarray(oRefs[ref])) {
                            temp = showSynonyms(hl) ": " oSynonyms[oRefs[ref][1]][oRefs[ref][2]][0]
                            for (k = 1; k < length(oSynonyms[oRefs[ref][1]][oRefs[ref][2]]); k++)
                                temp = temp ", " oSynonyms[oRefs[ref][1]][oRefs[ref][2]][k]
                            r = r RS ins(1, temp)
                        }
                    }
                }
            }
            if (isarray(oSynonymClasses) && anything(oSynonymClasses)) {
                # Synonyms
                r = r RS RS
                r = r m("-- display original dictionary (synonyms)")
                r = r s(showSynonyms(hl), hl)
                for (i = 0; i < length(oSynonymClasses); i++) {
                    r = (i > 0 ? r RS : r) RS ins(1, oSynonymClasses[i], hl)
                    for (j = 0; j < length(oSynonyms[i]); j++) {
                        temp = "* " oSynonyms[i][j][0]
                        for (k = 1; k < length(oSynonyms[i][j]); k++)
                            temp = temp ", " oSynonyms[i][j][k]
                        r = r RS ins(2, temp)
                    }
                }
            }
            if (isarray(oExamples) && anything(oExamples)) {
                # Examples
                r = r RS RS
                r = r m("-- display original dictionary (examples)")
                r = r s(showExamples(hl), hl)
                for (i = 0; i < length(oExamples); i++) {
                    example = oExamples[i]

                    if (isRTL(il)) { # target language is R-to-L
                        sub(/\u003cb\u003e/, "", example)
                        sub(/\u003c\/b\u003e/, "", example)
                    } else { # target language is L-to-R
                        sub(/\u003cb\u003e/, AnsiCode["negative"] AnsiCode["bold"], example)
                        sub(/\u003c\/b\u003e/, AnsiCode["positive"] AnsiCode["no bold"], example)
                    }
                    r = (i > 0 ? r RS : r) RS ins(1, "- " example, il)
                }
            }
            if (isarray(oSeeAlso) && anything(oSeeAlso)) {
                # See also
                r = r RS RS
                r = r m("-- display original dictionary (see also)")
                r = r s(showSeeAlso(hl), hl)
                temp = isRTL(il) ? oSeeAlso[0] : ansi("underline", oSeeAlso[0])
                for (k = 1; k < length(oSeeAlso); k++)
                    temp = temp ", " (isRTL(il) ? oSeeAlso[k] : ansi("underline", oSeeAlso[k]))
                r = r RS ins(1, temp, il)
            }
        }

        if (wShowDictionary) {
            # Display: dictionary entries
            if (r) r = r RS
            r = r m("-- display dictionary entries")
            for (i = 0; i < length(wordClasses); i++) {
                r = (i > 0 ? r RS : r) RS s(wordClasses[i], hl)
                for (j = 0; j < length(words[i]); j++) {
                    word = words[i][j][0]
                    explanation = join(words[i][j][1], ", ")
                    article = words[i][j][4]

                    r = r RS ansi("bold", ins(1, (article ? "(" article ") " : "") word, tl))
                    r = r RS ins(2, explanation, il)
                }
            }
        }

        if (wShowAlternatives) {
            # Display: alternative translations
            if (r) r = r RS RS
            r = r m("-- display alternative translations")
            for (i = 0; i < length(altTranslations); i++) {
                r = (i > 0 ? r RS : r) ansi("underline", show(segments[i]))
                temp = isRTL(tl) ? altTranslations[i][0] : ansi("bold", altTranslations[i][0])
                for (j = 1; j < length(altTranslations[i]); j++)
                    temp = temp ", " (isRTL(tl) ? altTranslations[i][j] : ansi("bold", altTranslations[i][j]))
                r = r RS ins(1, temp)
            }
        }

        if (toSpeech) {
            if (index(showTranslationsOf(hl, "%s"), "%s") > 2) {
                returnPlaylist[0]["text"] = showTranslationsOf(hl)
                returnPlaylist[0]["tl"] = hl
                returnPlaylist[1]["text"] = join(original)
                returnPlaylist[1]["tl"] = il
            } else {
                returnPlaylist[0]["text"] = join(original)
                returnPlaylist[0]["tl"] = il
                returnPlaylist[1]["text"] = showTranslationsOf(hl)
                returnPlaylist[1]["tl"] = hl
            }
            returnPlaylist[2]["text"] = translation
            returnPlaylist[2]["tl"] = tl
        }
    }

    return r
}

# Translate a file.
function fileTranslation(uri,    group, temp1, temp2) {
    temp1 = Option["input"]
    temp2 = Option["verbose"]

    match(uri, /^file:\/\/(.*)/, group)
    Option["input"] = group[1]
    Option["verbose"] = 0

    translateMain()

    Option["input"] = temp1
    Option["verbose"] = temp2
}

# Start a browser session and translate a web page.
function webTranslation(uri, sl, tl, hl) {
    system(Option["browser"] " " parameterize("https://translate.google.com/translate?" \
                                              "hl=" hl "&sl=" sl "&tl=" tl "&u=" uri) "&")
}

# Translate the source text (into all target languages).
function translate(text, inline,
                   ####
                   i, j, playlist, saveSortedIn) {

    if (!getCode(Option["hl"])) {
        # Check if home language is supported
        w("[WARNING] Unknown language code: " Option["hl"] ", fallback to English: en")
        Option["hl"] = "en" # fallback to English
    } else if (isRTL(Option["hl"])) {
        # Check if home language is R-to-L
        if (!FriBidi)
            w("[WARNING] " getName(Option["hl"]) " is a right-to-left language, but FriBidi cannot be found.")
    }

    if (!getCode(Option["sl"])) {
        # Check if source language is supported
        w("[WARNING] Unknown source language code: " Option["sl"])
    } else if (isRTL(Option["sl"])) {
        # Check if source language is R-to-L
        if (!FriBidi)
            w("[WARNING] " getName(Option["sl"]) " is a right-to-left language, but FriBidi cannot be found.")
    }

    saveSortedIn = PROCINFO["sorted_in"]
    PROCINFO["sorted_in"] = "@ind_num_asc"
    for (i in Option["tl"]) {
        # Non-interactive verbose mode: separator between targets
        if (!Option["interactive"])
            if (Option["verbose"] && i > 1)
                p(replicate("─", Option["width"]))

        if (inline &&
            startsWithAny(text, UriSchemes) == "file://") {
            # translate URL only from command-line parameters (inline)
            fileTranslation(text)
        } else if (inline &&
                   startsWithAny(text, UriSchemes) == "http://" ||
                   startsWithAny(text, UriSchemes) == "https://") {
            # translate URL only from command-line parameters (inline)
            webTranslation(text, Option["sl"], Option["tl"][i], Option["hl"])
        } else {
            p(getTranslation(text, Option["sl"], Option["tl"][i], Option["hl"], Option["verbose"], Option["play"], playlist))

            if (Option["play"])
                if (Option["player"])
                    for (j in playlist)
                        play(playlist[j]["text"], playlist[j]["tl"])
                else if (SpeechSynthesizer)
                    for (j in playlist)
                        print playlist[j]["text"] | SpeechSynthesizer
        }
    }
    PROCINFO["sorted_in"] = saveSortedIn
}

# Read from input and translate each line.
function translateMain(    i, line) {
    if (Option["interactive"])
        prompt()

    i = 0
    while (getline line < Option["input"]) {
        # Non-interactive verbose mode: separator between sources
        if (!Option["interactive"])
            if (Option["verbose"] && i++ > 0)
                p(replicate("═", Option["width"]))

        if (Option["interactive"]) {
            if (line ~ /:(q|quit)/)
                exit
            else if (line ~ /:(s|source)/)
                print Option["sl"]
            else if (line ~ /:(t|target)/) {
                printf "(" Option["tl"][1]
                for (i = 2; i <= length(Option["tl"]); i++)
                    printf ", " Option["tl"][i]
                print ")"
            }

            else {
                translate(line)

                # Interactive verbose mode: newline after each translation
                if (Option["verbose"]) printf RS
            }

            prompt()
        } else
            translate(line)
    }
}
