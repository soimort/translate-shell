####################################################################
# LanguageHelper.awk                                               #
####################################################################

# Get locale key by language code or alias.
function getCode(code,    group) {
    if (code == "auto" || code in Locale)
        return code
    else if (code in LocaleAlias)
        return LocaleAlias[code]
    else if (tolower(code) in LocaleAlias)
        return LocaleAlias[tolower(code)]

    # Remove unidentified region or script code
    match(code, /^([[:alpha:]][[:alpha:]][[:alpha:]]?)-(.*)$/, group)
    if (group[1])
        return group[1]

    return # return nothing if not found
}

# Return the name of a language.
function getName(code) {
    return Locale[getCode(code)]["name"]
}

# Return all the names of a language, separated by "/"
function getNames(code) {
    if ("name2" in Locale[getCode(code)])
        return Locale[getCode(code)]["name"] " / " Locale[getCode(code)]["name2"]
    else
        return Locale[getCode(code)]["name"]
}

# Return the endonym of a language.
function getEndonym(code) {
    return Locale[getCode(code)]["endonym"]
}

# Return the string for displaying the endonym of a language.
function getDisplay(code) {
    return Locale[getCode(code)]["display"]
}

# Return formatted text for "translations of".
function showTranslationsOf(code, text,    fmt) {
    fmt = Locale[getCode(code)]["translations-of"]
    if (!fmt) fmt = Locale["en"]["translations-of"]
    return sprintf(fmt, text)
}

# Return formatted text for "definitions of".
function showDefinitionsOf(code, text,    fmt) {
    fmt = Locale[getCode(code)]["definitions-of"]
    if (!fmt) fmt = Locale["en"]["definitions-of"]
    return sprintf(fmt, text)
}

# Return a string of "synonyms".
function showSynonyms(code,    tmp) {
    tmp = Locale[getCode(code)]["synonyms"]
    if (!tmp) tmp = Locale["en"]["synonyms"]
    return tmp
}

# Return a string of "examples".
function showExamples(code,    tmp) {
    tmp = Locale[getCode(code)]["examples"]
    if (!tmp) tmp = Locale["en"]["examples"]
    return tmp
}

# Return a string of "see also".
function showSeeAlso(code,    tmp) {
    tmp = Locale[getCode(code)]["see-also"]
    if (!tmp) tmp = Locale["en"]["see-also"]
    return tmp
}

# Return the family of a language.
function getFamily(code) {
    return Locale[getCode(code)]["family"]
}

# Return the branch of a language.
function getBranch(code) {
    return Locale[getCode(code)]["branch"]
}

# Return the ISO 639-3 code of a language.
function getISO(code) {
    return Locale[getCode(code)]["iso"]
}

# Return the Glottocode of a language.
function getGlotto(code) {
    return Locale[getCode(code)]["glotto"]
}

# Return the ISO 15924 script code of a language.
function getScript(code) {
    return Locale[getCode(code)]["script"]
}

# Return 1 if a language is R-to-L; otherwise return 0.
function isRTL(code) {
    return Locale[getCode(code)]["rtl"] ? 1 : 0
}

# Return 1 if Google provides dictionary data for a language; otherwise return 0.
function hasDictionary(code) {
    return Locale[getCode(code)]["dictionary"] ? 1 : 0
}

# Comparator using getName().
function compName(i1, v1, i2, v2) {
    if (getName(i1) < getName(i2))
        return -1
    else
        return (getName(i1) != getName(i2))
}

# Return the name of script (writing system).
# See: <https://en.wikipedia.org/wiki/ISO_15924#List_of_codes>
#      <http://unicode.org/iso15924/iso15924-codes.html>
function scriptName(code) {
    switch (code) {
    case "Arab": return "Arabic"
    case "Armn": return "Armenian"
    case "Beng": return "Bengali"
    case "Cher": return "Cherokee"
    case "Cyrl": return "Cyrillic"
    case "Deva": return "Devanagari"
    case "Ethi": return "Ethiopic (Geʻez)"
    case "Geor": return "Georgian (Mkhedruli)"
    case "Grek": return "Greek"
    case "Gujr": return "Gujarati"
    case "Guru": return "Gurmukhi"
    case "Hani": return "Han"
    case "Hans": return "Han (Simplified)"
    case "Hant": return "Han (Traditional)"
    case "Hebr": return "Hebrew"
    case "Jpan": return "Japanese (Han + Hiragana + Katakana)"
    case "Khmr": return "Khmer"
    case "Knda": return "Kannada"
    case "Kore": return "Korean (Hangul + Han)"
    case "Laoo": return "Lao"
    case "Latn": return "Latin"
    case "Mtei": return "Meitei Mayek"
    case "Mlym": return "Malayalam"
    case "Mymr": return "Myanmar"
    case "Orya": return "Oriya"
    case "Piqd": return "Klingon (pIqaD)"
    case "Sinh": return "Sinhala"
    case "Taml": return "Tamil"
    case "Telu": return "Telugu"
    case "Thaa": return "Thaana"
    case "Thai": return "Thai"
    case "Tibt": return "Tibetan"
    default: return "Unknown"
    }
}

# Return the regions that a language is spoken in, as an English string.
function getSpokenIn(code,    i, j, r, regions, str) {
    r = NULLSTR
    str = Locale[getCode(code)]["spoken-in"]
    if (str) {
        split(str, regions, /\s?;\s?/)
        j = 0
        for (i in regions) {
            r = r regions[i]
            j++
            if (j < length(regions) - 1)
                r = r ", "
            else if (j == length(regions) - 1)
                r = r " and "
        }
    }
    return r
}

# Return the regions that a script is written in, as an English string.
function getWrittenIn(code,    i, j, r, regions, str) {
    r = NULLSTR
    str = Locale[getCode(code)]["written-in"]
    if (str) {
        split(str, regions, /\s?;\s?/)
        j = 0
        for (i in regions) {
            r = r regions[i]
            j++
            if (j < length(regions) - 1)
                r = r ", "
            else if (j == length(regions) - 1)
                r = r " and "
        }
    }
    return r
}

# Return the extra description of a language.
function getDescription(code) {
    return Locale[getCode(code)]["description"]
}

# Return 1 if a language is supported by Google; otherwise return 0.
function isSupportedByGoogle(code,    engines, i, str) {
    str = Locale[getCode(code)]["supported-by"]
    if (str) {
        split(str, engines, /\s?;\s?/)
        for (i in engines)
            if (engines[i] == "google") return 1
    }
    return 0
}

# Return 1 if a language is supported by Bing; otherwise return 0.
function isSupportedByBing(code,    engines, i, str) {
    str = Locale[getCode(code)]["supported-by"]
    if (str) {
        split(str, engines, /\s?;\s?/)
        for (i in engines)
            if (engines[i] == "bing") return 1
    }
    return 0
}

# Return detailed information of a language as a string.
function getDetails(code,    article, desc, group, iso, name, names, script, writing) {
    if (code == "auto" || !getCode(code)) {
        e("[ERROR] Language not found: " code "\n"                      \
          "        Run '-reference / -R' to see a list of available languages.")
        exit 1
    }

    script = scriptName(getScript(code))
    if (isRTL(code)) script = script " (R-to-L)"

    split(getISO(code), group, "-")
    iso = group[1]

    name = getName(code)
    names = getNames(code)
    if (match(name, /\(.*\)/)) {
        writing = substr(name, match(name, /\(.*\)/) + 1)
        writing = substr(writing, 1, length(writing) - 1)
        name = substr(name, 1, match(name, /\(.*\)/) - 2)
    }

    if (getBranch(code)) {
        article = match(tolower(getBranch(code)), /^[aeiou]/) ? "an" : "a"
        if (iso == "eng")
            desc = sprintf("%s is %s %s language spoken %s.",
                           names, article, getBranch(code), getSpokenIn(code))
        else
            desc = sprintf("%s is %s %s language spoken mainly in %s.",
                           names, article, getBranch(code), getSpokenIn(code))
    } else if (getFamily(code) == NULLSTR || tolower(getFamily(code)) == "language isolate")
        desc = sprintf("%s is a language spoken mainly in %s.", names, getSpokenIn(code))
    else if (tolower(getFamily(code)) == "constructed language")
        desc = sprintf("%s is %s.", names, getDescription(code))
    else
        desc = sprintf("%s is a language of the %s family, spoken mainly in %s.",
                       names, getFamily(code), getSpokenIn(code))
    if (writing && getWrittenIn(code))
        desc = desc sprintf(" The %s writing system is officially used in %s.",
                            tolower(writing), getWrittenIn(code))

    return ansi("bold", sprintf("%s\n", getDisplay(code)))              \
        sprintf("%-22s%s\n", "Name", ansi("bold", names))               \
        sprintf("%-22s%s\n", "Family", ansi("bold", getFamily(code)))   \
        sprintf("%-22s%s\n", "Writing system", ansi("bold", script))    \
        sprintf("%-22s%s\n", "Code", ansi("bold", getCode(code)))       \
        sprintf("%-22s%s\n", "ISO 639-3", ansi("bold", iso))            \
        sprintf("%-22s%s\n", "SIL", ansi("bold", "https://iso639-3.sil.org/code/" iso)) \
        sprintf("%-22s%s\n", "Glottolog", getGlotto(code) ?
                ansi("bold", "https://glottolog.org/resource/languoid/id/" getGlotto(code)) : "") \
        sprintf("%-22s%s\n", "Wikipedia", ansi("bold", "https://en.wikipedia.org/wiki/ISO_639:" iso)) \
        (Locale[getCode(code)]["supported-by"] ? # FIXME
        sprintf("%-22s%s\n", "Translator support", sprintf("Google [%s]    Bing [%s]",
                isSupportedByGoogle(code) ? "✔" : "✘", isSupportedByBing(code) ? "✔" : "✘")) : "") \
        (Locale[getCode(code)]["spoken-in"] ? # FIXME
        ansi("bold", sprintf("\n%s", desc)) : "")
}

# Add /slashes/ for IPA phonemic notations and (parentheses) for others.
# Parameters:
#     code
function showPhonetics(phonetics, code) {
    if (code && getCode(code) == "en")
        return "/" phonetics "/"
    else
        return "(" phonetics ")"
}

# Convert a logical string to visual; don't right justify RTL lines.
# Parameters:
#     code: ignore to apply bidirectional algorithm on every string
function show(text, code,    command, temp) {
    if (!code || isRTL(code)) {
        if (Cache[text][0])
            return Cache[text][0]
        else {
            if ((FriBidi || (code && isRTL(code))) && BiDiNoPad) {
                command = "echo " parameterize(text) PIPE BiDiNoPad
                command | getline temp
                close(command)
            } else # non-RTL language, or FriBidi not installed
                temp = text
            return Cache[text][0] = temp
        }
    } else
        return text
}

# Convert a logical string to visual and right justify RTL lines.
# Parameters:
#     code: ignore to apply bidirectional algorithm on every string
#     width: ignore to use default width for padding
function s(text, code, width,    command, temp) {
    if (!code || isRTL(code)) {
        if (!width) width = Option["width"]
        if (Cache[text][width])
            return Cache[text][width]
        else {
            if ((FriBidi || (code && isRTL(code))) && BiDi) {
                command = "echo " parameterize(text) PIPE sprintf(BiDi, width)
                command | getline temp
                close(command)
            } else # non-RTL language, or FriBidi not installed
                temp = text
            return Cache[text][width] = temp
        }
    } else
        return text
}

# Convert a logical string to visual with a certain level of indentation.
# Parameters:
#     level: level of indentation
#     code: ignore to apply left indentation
#     width: ignore to use default width for padding
function ins(level, text, code, width,    i, temp) {
    if (code && isRTL(code)) {
        if (!width) width = Option["width"]
        return s(text, code, width - Option["indent"] * level)
    } else
        return replicate(" ", Option["indent"] * level) text
}

# Parse a POSIX locale identifier and return the language code;
# Identified by both language identifier and region identifier.
# Parameters:
#     lang = [language[_territory][.codeset][@modifier]]
# See: <https://en.wikipedia.org/wiki/Locale>
function parseLang(lang,    code, group) {
    match(lang, /^([a-z][a-z][a-z]?)(_|$)/, group)
    code = getCode(group[1])

    # Detect region identifier
    ## Regions using Chinese Simplified: China, Singapore
    if (lang ~ /^zh_(CN|SG)/) code = "zh-CN"
    ## Regions using Chinese Traditional: Taiwan, Hong Kong
    else if (lang ~ /^zh_(TW|HK)/) code = "zh-TW"

    # FIXME: handle unrecognized language code
    if (!code) code = "en"

    return code
}

# Initialize `UserLang`.
function initUserLang(    lang, utf) {
    if (lang = ENVIRON["LC_ALL"]) {
        if (!UserLocale) UserLocale = lang
        utf = utf || tolower(lang) ~ /utf-?8$/
    }
    if (lang = ENVIRON["LANG"]) {
        if (!UserLocale) UserLocale = lang
        utf = utf || tolower(lang) ~ /utf-?8$/
    }
    if (!UserLocale) {
        UserLocale = "en_US.UTF-8"
        utf = 1
    }
    if (!utf)
        w("[WARNING] Your locale codeset (" UserLocale ") is not UTF-8.")

    UserLang = parseLang(UserLocale)
}
