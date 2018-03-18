####################################################################
# Translate.awk                                                    #
####################################################################

function provides(engineName) {
    Translator[tolower(engineName)] = TRUE
}

function engineMethod(methodName,    engine, translator) {
    if (!Translator[Option["engine"]]) {
        # case-insensitive match engine name
        engine = tolower(Option["engine"])
        if (!Translator[engine]) # fuzzy match engine name
            for (translator in Translator)
                if (Translator[translator] && # there IS such a translator
                    translator ~ "^"engine) {
                    engine = translator
                    break
                }
        if (!Translator[engine]) {
            e("[ERROR] Translator not found: " Option["engine"] "\n"    \
              "        Run '-list-engines / -S' to see a list of available engines.")
            exit 1
        }
        Option["engine"] = engine
    }
    return Option["engine"] methodName
}

# Detect external audio player (mplayer, mpv, mpg123).
function initAudioPlayer() {
    AudioPlayer = !system("mpv" SUPOUT SUPERR) ?
        "mpv --loop-file=no" :
        (!system("mplayer" SUPOUT SUPERR) ?
         "mplayer" :
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

# Initialize `HttpService`.
function initHttpService() {
    _Init()

    if (Option["proxy"]) {
        match(Option["proxy"], /^(http:\/*)?(([^:]+):([^@]+)@)?([^\/]*):([^\/:]*)/, HttpProxySpec)
        HttpAuthUser = HttpProxySpec[3]
        HttpAuthPass = HttpProxySpec[4]
        HttpAuthCredentials = base64(unquote(HttpAuthUser) ":" HttpAuthPass)
        HttpService = "/inet/tcp/0/" HttpProxySpec[5] "/" HttpProxySpec[6]
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

# [OBSOLETE] Is this function still relevant?
# Post-process string (remove any redundant whitespace).
function postprocess(text) {
    text = gensub(/ ([.,;:?!"])/, "\\1", "g", text)
    text = gensub(/(["]) /, "\\1", "g", text)
    return text
}

# Send an HTTP GET request and get response from an online translator.
function getResponse(text, sl, tl, hl,
                     ####
                     content, header, isBody, url, group, status, location) {
    url = _RequestUrl(text, sl, tl, hl)

    header = "GET " url " HTTP/1.1\r\n"           \
        "Host: " HttpHost "\r\n"                  \
        "Connection: close\r\n"
    if (Option["user-agent"])
        header = header "User-Agent: " Option["user-agent"] "\r\n"
    if (Cookie)
        header = header "Cookie: " Cookie "\r\n"
    if (HttpAuthUser && HttpAuthPass)
        # TODO: digest auth
        header = header "Proxy-Authorization: Basic " HttpAuthCredentials "\r\n"

    content = NULLSTR; isBody = 0
    print header |& HttpService
    while ((HttpService |& getline) > 0) {
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
        l(sprintf("%4s bytes > %s", length($0), $0))
    }
    close(HttpService)

    if ((status == "301" || status == "302") && location)
        content = curl(location)

    return assert(content, "[ERROR] Null response.")
}

# Send an HTTP POST request and return response from an online translator.
function postResponse(text, sl, tl, hl, type,
                      ####
                      content, contentLength, contentType, group,
                      header, isBody, reqBody, url, status, location) {
    url = _PostRequestUrl(text, sl, tl, hl, type)
    contentType = _PostRequestContentType(text, sl, tl, hl, type)
    reqBody = _PostRequestBody(text, sl, tl, hl, type)
    if (DumpContentengths[reqBody])
        contentLength = DumpContentengths[reqBody]
    else
        contentLength = DumpContentengths[reqBody] = dump(reqBody, group)

    header = "POST " url " HTTP/1.1\r\n"                  \
        "Host: " HttpHost "\r\n"                          \
        "Connection: close\r\n"                           \
        "Content-Length: " contentLength "\r\n"           \
        "Content-Type: " contentType "\r\n"     # must!
    if (Option["user-agent"])
        header = header "User-Agent: " Option["user-agent"] "\r\n"
    if (Cookie)
        header = header "Cookie: " Cookie "\r\n"
    if (HttpAuthUser && HttpAuthPass)
        # TODO: digest auth
        header = header "Proxy-Authorization: Basic " HttpAuthCredentials "\r\n"

    content = NULLSTR; isBody = 0
    print (header "\r\n" reqBody) |& HttpService
    while ((HttpService |& getline) > 0) {
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
        l(sprintf("%4s bytes > %s", length($0), $0))
    }
    close(HttpService)

    if (status == "404") {
        e("[ERROR] 404 Not Found")
        exit 1
    }
    if ((status == "301" || status == "302") && location) {
        url = "https" substr(url, 5) # switch to HTTPS; don't use location!
        content = curlPost(url, reqBody)
    }

    return content
}

# Print a string (to output file or terminal pager).
function p(string) {
    if (Option["view"])
        print string | Option["pager"]
    else
        print string > Option["output"]
}

# Play using a Text-to-Speech engine.
function play(text, tl,    url) {
    url = _TTSUrl(text, tl)

    # Don't use getline from pipe here - the same pipe will be run only once for each AWK script!
    system(Option["player"] " " parameterize(url) SUPOUT SUPERR)
}

# Download audio from a Text-to-Speech engine.
function download_audio(text, tl,    url, output) {
    url = _TTSUrl(text, tl)

    if (Option["download-audio-as"])
        output = Option["download-audio-as"]
    else
        output = text " [" Option["engine"] "] (" Option["narrator"] ").ts"

    if (url ~ /^\//)
        system("mv -- " parameterize(url) " " parameterize(output))
    else
        curl(url, output)
}

# Get the translation of a string.
function getTranslation(text, sl, tl, hl,
                        isVerbose, toSpeech, returnPlaylist, returnIl) {
    return _Translate(text, sl, tl, hl,
                      isVerbose, toSpeech, returnPlaylist, returnIl)
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
    system(Option["browser"] " "                                \
           parameterize(_WebTranslateUrl(uri, sl, tl, hl)) "&")
}

# Translate the source text (into all target languages).
function translate(text, inline,
                   ####
                   i, j, playlist, il, saveSortedIn) {

    if (!getCode(Option["hl"])) {
        # Check if home language is supported
        w("[WARNING] Unknown language code: " Option["hl"] ", fallback to English: en")
        Option["hl"] = "en" # fallback to English
    } else if (isRTL(Option["hl"])) {
        # Check if home language is R-to-L
        if (!FriBidi)
            w("[WARNING] " getName(Option["hl"]) " is a right-to-left language, but FriBidi is not found.")
    }

    if (!getCode(Option["sl"])) {
        # Check if source language is supported
        w("[WARNING] Unknown source language code: " Option["sl"])
    } else if (isRTL(Option["sl"])) {
        # Check if source language is R-to-L
        if (!FriBidi)
            w("[WARNING] " getName(Option["sl"]) " is a right-to-left language, but FriBidi is not found.")
    }

    saveSortedIn = PROCINFO["sorted_in"]
    PROCINFO["sorted_in"] = "@ind_num_asc"
    for (i in Option["tl"]) {
        # Non-interactive verbose mode: separator between targets
        if (!Option["interactive"])
            if (Option["verbose"] && i > 1)
                p(prettify("target-seperator", replicate(Option["chr-target-seperator"], Option["width"])))

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
            if (!Option["no-translate"])
                p(getTranslation(text, Option["sl"], Option["tl"][i], Option["hl"], Option["verbose"], Option["play"] || Option["download-audio"], playlist, il))
            else
                il[0] = Option["sl"] == "auto" ? "en" : Option["sl"]

            if (Option["play"] == 1) {
                if (Option["player"])
                    for (j in playlist)
                        play(playlist[j]["text"], playlist[j]["tl"])
                else if (SpeechSynthesizer)
                    for (j in playlist)
                        print playlist[j]["text"] | SpeechSynthesizer
            } else if (Option["play"] == 2) {
                if (Option["player"])
                    play(text, il[0])
                else if (SpeechSynthesizer)
                    print text | SpeechSynthesizer
            }

            if (Option["download-audio"] == 1) {
                # Download the translation unless used with -sp or -no-trans
                if (Option["play"] != 2 && !Option["no-translate"])
                    download_audio(playlist[length(playlist) - 1]["text"], \
                                   playlist[length(playlist) - 1]["tl"])
                else
                    download_audio(text, il[0])
            }
        }
    }
    PROCINFO["sorted_in"] = saveSortedIn
}

# Read from input and translate each line.
function translateMain(    i, line) {
    if (Option["interactive"])
        prompt()

    if (Option["input"] == STDIN || fileExists(Option["input"])) {
        i = 0
        while (getline line < Option["input"])
            if (line) {
                # Non-interactive verbose mode: separator between sources
                if (!Option["interactive"])
                    if (Option["verbose"] && i++ > 0)
                        p(prettify("source-seperator",
                                   replicate(Option["chr-source-seperator"],
                                             Option["width"])))

                if (Option["interactive"])
                    repl(line)
                else
                    translate(line)
            } else {
                # Non-interactive brief mode: preserve line breaks
                if (!Option["interactive"])
                    if (!Option["verbose"])
                        p(line)
            }
    } else
        e("[ERROR] File not found: " Option["input"])
}
