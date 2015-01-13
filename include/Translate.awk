####################################################################
# Translate.awk                                                    #
####################################################################

# Detect external audio player (mplayer, mpg123).
function initAudioPlayer() {
    AudioPlayer = !system("mplayer >/dev/null 2>/dev/null") ?
        "mplayer" :
        (!system("mpg123 >/dev/null 2>/dev/null") ?
         "mpg123" :
         "")
}

# Detect external speech synthesizer (say, espeak).
function initSpeechSynthesizer() {
    SpeechSynthesizer = !system("say '' >/dev/null 2>/dev/null") ?
        "say" :
        (!system("espeak '' >/dev/null 2>/dev/null") ?
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
function getResponse(text, sl, tl, hl,    content, url) {
    url = HttpPathPrefix "/translate_a/t?client=t"              \
        "&ie=UTF-8&oe=UTF-8"                                    \
        "&text=" preprocess(text) "&sl=" sl "&tl=" tl "&hl=" hl

    print "GET " url " HTTP/1.1\n"             \
          "Host: " HttpHost "\n"               \
          "Connection: close\n" |& HttpService
    while ((HttpService |& getline) > 0)
        content = $0
    close(HttpService)

    return assert(content, "[ERROR] Null response.")
}

# Play using Google Text-to-Speech engine.
function play(text, tl,    url) {
    url = HttpProtocol HttpHost "/translate_tts?ie=UTF-8"       \
        "&tl=" tl "&q=" preprocess(text)

    # Don't use getline from pipe here - the same pipe will be run only once for each AWK script!
    system(Option["player"] " '" url "' >/dev/null 2>/dev/null")
}

# Get the translation of a string.
function getTranslation(text, sl, tl, hl,
                        isVerbose, toSpeech, returnPlaylist,
                        ####
                        altTranslations, article, ast, content,
                        explanation, group, i, il, ils,
                        isPhonetic, j, original, phonetics,
                        r, rtl, saveSortedIn, segments,
                        temp, tokens, translation, translations,
                        word, words, wordClasses) {
    isPhonetic = match(tl, /^@/)
    tl = substr(tl, 1 + isPhonetic)

    if (!getCode(tl)) {
        # Check if target language is supported
        w("[WARNING] Unknown target language code: " tl)
    } else if (getCode(tl) != "auto" && rtl = Locale[getCode(tl)]["rtl"]) {
        # Check if target language is RTL
        if (!FriBidi)
            w("[WARNING] " Locale[getCode(tl)]["name"] " is a right-to-left language, but GNU FriBidi is not found on your system.\nText might be displayed incorrectly.")
    }

    content = getResponse(text, sl, tl, hl)

    plTokenize(tokens, content)
    plParse(ast, tokens)

    if (!anything(ast)) {
        e("[ERROR] Oops! Something went wrong and I can't translate it for you :(")
        ExitCode = 1
    }

    # Debug mode
    if (Option["debug"]) {
        d(sprintf("content='%s'", content))
        da(tokens, "tokens[%s]='%s'")
        da(ast, "ast[%s]='%s'")
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

        if (match(i, "^0" SUBSEP "1" SUBSEP "([[:digit:]]+)" SUBSEP "0$", group))
            wordClasses[group[1]] = literal(ast[i])

        if (match(i, "^0" SUBSEP "1" SUBSEP "([[:digit:]]+)" SUBSEP "2" SUBSEP "([[:digit:]]+)" SUBSEP "([[:digit:]]+)$", group))
            words[group[1]][group[2]][group[3]] = literal(ast[i])
        if (match(i, "^0" SUBSEP "1" SUBSEP "([[:digit:]]+)" SUBSEP "2" SUBSEP "([[:digit:]]+)" SUBSEP "1" SUBSEP "([[:digit:]]+)$", group))
            words[group[1]][group[2]]["1"][group[3]] = literal(ast[i])

        if (match(i, "^0" SUBSEP "5" SUBSEP "([[:digit:]]+)" SUBSEP "0$", group)) {
            segments[group[1]] = literal(ast[i])
            altTranslations[group[1]][0] = ""
        }

        if (match(i, "^0" SUBSEP "5" SUBSEP "([[:digit:]]+)" SUBSEP "2" SUBSEP "([[:digit:]]+)" SUBSEP "0$", group))
            altTranslations[group[1]][group[2]] = postprocess(literal(ast[i]))

        # Identified source languages
        if (i ~ "^0" SUBSEP "8" SUBSEP "0" SUBSEP "[[:digit:]]+$" ||
            i ~ "^0" SUBSEP "2$")
            append(ils, literal(ast[i]))
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

        r = AnsiCode["bold"] s(translation, tl) AnsiCode["no bold"] # target language
        if (anything(phonetics))
            r = r "\n" AnsiCode["bold"] join(phonetics) AnsiCode["no bold"] # phonetic transcription

        if (isarray(altTranslations[0]) && anything(altTranslations[0])) {
            # List alternative translations

            if (Locale[getCode(hl)]["rtl"] || Locale[getCode(il)]["rtl"])
                r = r "\n\n" s(sprintf(Locale[getCode(hl)]["message"], join(original))) # caution: mixed languages, BiDi invoked must be implemented correctly (i.e. FriBidi is required)
            else
                r = r "\n\n" sprintf(Locale[getCode(hl)]["message"], join(original))
            if (Locale[getCode(il)]["rtl"] || Locale[getCode(tl)]["rtl"])
                r = r "\n" s("(" Locale[getCode(il)]["endonym"] " ➔ " Locale[getCode(tl)]["endonym"] ")") # caution: mixed languages
            else
                r = r "\n" "(" Locale[getCode(il)]["endonym"] " ➔ " Locale[getCode(tl)]["endonym"] ")"

            temp = segments[0] "(" join(altTranslations[0], "/") ")"
            for (i = 1; i < length(altTranslations); i++)
                temp = temp " " segments[i] "(" join(altTranslations[i], "/") ")"
            if (Locale[getCode(il)]["rtl"] || Locale[getCode(tl)]["rtl"])
                r = r "\n" AnsiCode["bold"] s(temp) AnsiCode["no bold"] # caution: mixed languages
            else
                r = r "\n" AnsiCode["bold"] temp AnsiCode["no bold"]
        }

        if (isarray(wordClasses) && anything(wordClasses)) {
            # List dictionary entries

            for (i = 0; i < length(words); i++) {
                r = r "\n\n" s("[" wordClasses[i] "]", hl) # home language
                for (j = 0; j < length(words[i]); j++) {
                    word = words[i][j][0]
                    explanation = join(words[i][j][1], ", ")
                    article = words[i][j][4]

                    if (rtl) {
                        r = r "\n" AnsiCode["bold"] sprintf("%" Option["width"] - 4 "s", s((article ?
                                                                                            "(" article ")" :
                                                                                            "") " " word, tl, Option["width"] - 4)) AnsiCode["no bold"] # target language
                        r = r "\n" s(explanation, il, Option["width"] - 8) # identified source language
                    } else {
                        r = r "\n" "    " AnsiCode["bold"] show((article ?
                                                                 "(" article ") " :
                                                                 "") word, tl) AnsiCode["no bold"] # target language
                        r = r "\n" "        " s(explanation, il, Option["width"] - 8) # identified source language
                    }
                }
            }
        }

        if (toSpeech) {
            if (index(Locale[getCode(hl)]["message"], "%s") > 2) {
                returnPlaylist[0]["text"] = sprintf(Locale[getCode(hl)]["message"], "")
                returnPlaylist[0]["tl"] = hl
                returnPlaylist[1]["text"] = join(original)
                returnPlaylist[1]["tl"] = il
            } else {
                returnPlaylist[0]["text"] = join(original)
                returnPlaylist[0]["tl"] = il
                returnPlaylist[1]["text"] = sprintf(Locale[getCode(hl)]["message"], "")
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
    } else if (getCode(Option["hl"]) != "auto" && Locale[getCode(Option["hl"])]["rtl"]) {
        # Check if home language is RTL
        if (!FriBidi)
            w("[WARNING] " Locale[getCode(Option["hl"])]["name"] " is a right-to-left language, but GNU FriBidi is not found on your system.\nText might be displayed incorrectly.")
    }

    if (!getCode(Option["sl"])) {
        # Check if source language is supported
        w("[WARNING] Unknown source language code: " Option["sl"])
    } else if (getCode(Option["sl"]) != "auto" && Locale[getCode(Option["sl"])]["rtl"]) {
        # Check if source language is RTL
        if (!FriBidi)
            w("[WARNING] " Locale[getCode(Option["sl"])]["name"] " is a right-to-left language, but GNU FriBidi is not found on your system.\nText might be displayed incorrectly.")
    }

    saveSortedIn = PROCINFO["sorted_in"]
    PROCINFO["sorted_in"] = "@ind_num_asc"
    for (i in Option["tl"]) {
        # Non-interactive verbose mode: separator between targets
        if (!Option["interactive"])
            if (Option["verbose"] && i > 1)
                print replicate("─", Option["width"])

        if (inline &&
            startsWithAny(text, UriSchemes) == "file://") {
            fileTranslation(text)
        } else if (inline &&
                   startsWithAny(text, UriSchemes) == "http://" ||
                   startsWithAny(text, UriSchemes) == "https://") {
            webTranslation(text, Option["sl"], Option["tl"][i], Option["hl"])
        } else {
            print getTranslation(text, Option["sl"], Option["tl"][i], Option["hl"], Option["verbose"], Option["play"], playlist) > Option["output"]

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
                print replicate("═", Option["width"])

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
                if (Option["verbose"]) printf "\n"
            }

            prompt()
        } else
            translate(line)
    }
}
