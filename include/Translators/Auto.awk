####################################################################
# Auto.awk                                                         #
####################################################################
BEGIN { provides("auto") }

function autoInit() {
}

function autoTTSUrl(text, tl) {
    # TODO: support Bing
    return googleTTSUrl(text, tl)
}

function autoWebTranslateUrl(uri, sl, tl, hl) {
    # TODO: support Bing
    return googleWebTranslateUrl(uri, sl, tl, hl)
}

function autoTranslate(text, sl, tl, hl,
                       isVerbose, toSpeech, returnPlaylist, returnIl,
                       ####
                       engine, temp) {
    if ((sl == "auto" || isSupportedByGoogle(sl)) && (tl == "auto" || isSupportedByGoogle(tl))) {
        # both source and target languages are supported by Google
        engine = Option["engine"] # auto
        Option["engine"] = "google"
        initHttpService()
        temp = googleTranslate(text, sl, tl, hl, isVerbose, toSpeech, returnPlaylist, returnIl)
        Option["engine"] = engine
    } else if ((sl == "auto" || isSupportedByBing(sl)) && (tl == "auto" || isSupportedByBing(tl))) {
        # both source and target languages are supported by Bing
        engine = Option["engine"] # auto
        Option["engine"] = "bing"
        initHttpService()
        temp = bingTranslate(text, sl, tl, hl, isVerbose, toSpeech, returnPlaylist, returnIl)
        Option["engine"] = engine
    } else {
        # TODO: translate between Google-only and Bing-only languages

        # fallback to Google
        engine = Option["engine"] # auto
        Option["engine"] = "google"
        initHttpService()
        temp = googleTranslate(text, sl, tl, hl, isVerbose, toSpeech, returnPlaylist, returnIl)
        Option["engine"] = engine
    }
    return temp
}
