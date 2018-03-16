####################################################################
# TranslatorInterface.awk                                          #
####################################################################

# Abstract method foobarInit(): ()
function _Init(    vm) {
    vm = engineMethod("Init")
    return @vm()
}

# Abstract method foobarRequestUrl(text, sl, tl, hl: string): string
function _RequestUrl(text, sl, tl, hl,    vm) {
    vm = engineMethod("RequestUrl")
    return @vm(text, sl, tl, hl)
}

# Abstract method foobarPostRequestUrl(text, sl, tl, hl, type: string): string
function _PostRequestUrl(text, sl, tl, hl, type,    vm) {
    vm = engineMethod("PostRequestUrl")
    return @vm(text, sl, tl, hl, type)
}

# Abstract method foobarPostRequestBody(text, sl, tl, hl, type: string): string
function _PostRequestBody(text, sl, tl, hl, type,    vm) {
    vm = engineMethod("PostRequestBody")
    return @vm(text, sl, tl, hl, type)
}

# Abstract method foobarTTSUrl(text, tl: string): string
function _TTSUrl(text, tl,    vm) {
    vm = engineMethod("TTSUrl")
    return @vm(text, tl)
}

# Abstract method foobarWebTranslateUrl(uri, sl, tl, hl: string): string
function _WebTranslateUrl(uri, sl, tl, hl,    vm) {
    vm = engineMethod("WebTranslateUrl")
    return @vm(uri, sl, tl, hl)
}

# Abstract method foobarTranslate(text, sl, tl, hl: string,
#                                 isVerbose, toSpeech: boolean,
#                                 returnPlaylist, returnIl: array): string
function _Translate(text, sl, tl, hl,
                    isVerbose, toSpeech, returnPlaylist, returnIl,
                    ####
                    vm) {
    vm = engineMethod("Translate")
    return @vm(text, sl, tl, hl,
               isVerbose, toSpeech, returnPlaylist, returnIl)
}
