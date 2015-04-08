#!/usr/bin/gawk -f

# This is free and unencumbered software released into the
# public domain.
#
# This software is provided for the purpose of personal, reasonable
# and convenient human use of the Google Translate Service, i.e.,
# only for those who feel that their terminal is more accessible
# than a web browser. For other purposes, please use the official
# Google Translate API <https://developers.google.com/translate/>.
#
# By using this software, you ("the user") agree that:
#
# 1. Neither this software nor its author is affiliated with
# Google Inc. ("Google").
#
# 2. By using this software, the user is de facto using web
# services provided by Google, therefore they are obliged to
# follow the Google Terms of Service.
#
# 3. This software is provided "as is". The user of this software
# shall be fully liable for any possible infringement of, including
# but not limited to, the Google Terms of Service; per contra,
# the user must be aware that their data might be collected by
# Google, therefore they shall be liable for their own privacy
# concern, including but not limited to, possible disclosure of
# personal information. See the (un)LICENSE file for more details.

BEGIN {
    Name        = "Translate Shell"
    Description = "Google Translate to serve as a command-line tool"
    Version     = "0.8.23"
    Command     = "trans"
    EntryPoint  = "translate.awk"
}

####################################################################
# Commons.awk                                                      #
#                                                                  #
# Commonly used functions for string and array operations, logging.#
####################################################################

# Initialize `UrlEncoding`.
# See: <https://en.wikipedia.org/wiki/Percent-encoding>
function initUrlEncoding() {
    UrlEncoding["\n"] = "%0A"
    UrlEncoding[" "]  = "%20"
    UrlEncoding["!"]  = "%21"
    UrlEncoding["\""] = "%22"
    UrlEncoding["#"]  = "%23"
    UrlEncoding["$"]  = "%24"
    UrlEncoding["%"]  = "%25"
    UrlEncoding["&"]  = "%26"
    UrlEncoding["'"]  = "%27"
    UrlEncoding["("]  = "%28"
    UrlEncoding[")"]  = "%29"
    UrlEncoding["*"]  = "%2A"
    UrlEncoding["+"]  = "%2B"
    UrlEncoding[","]  = "%2C"
    UrlEncoding["-"]  = "%2D"
    UrlEncoding["."]  = "%2E"
    UrlEncoding["/"]  = "%2F"
    UrlEncoding[":"]  = "%3A"
    UrlEncoding[";"]  = "%3B"
    UrlEncoding["<"]  = "%3C"
    UrlEncoding["="]  = "%3D"
    UrlEncoding[">"]  = "%3E"
    UrlEncoding["?"]  = "%3F"
    UrlEncoding["@"]  = "%40"
    UrlEncoding["["]  = "%5B"
    UrlEncoding["\\"] = "%5C"
    UrlEncoding["]"]  = "%5D"
    UrlEncoding["^"]  = "%5E"
    UrlEncoding["_"]  = "%5F"
    UrlEncoding["`"]  = "%60"
    UrlEncoding["{"]  = "%7B"
    UrlEncoding["|"]  = "%7C"
    UrlEncoding["}"]  = "%7D"
    UrlEncoding["~"]  = "%7E"
}

# Return the real character represented by an escape sequence.
# Example: escapeChar("n") returns "\n".
# See: <https://en.wikipedia.org/wiki/Escape_character>
#      <https://en.wikipedia.org/wiki/Escape_sequences_in_C>
function escapeChar(char) {
    switch (char) {
    case "b":
        return "\b" # Backspace
    case "f":
        return "\f" # Formfeed
    case "n":
        return "\n" # Newline (Line Feed)
    case "r":
        return "\r" # Carriage Return
    case "t":
        return "\t" # Horizontal Tab
    case "v":
        return "\v" # Vertical Tab
    default:
        return char
    }
}

# Convert a literal-formatted string into its original string.
function literal(string,
                 ####
                 c, escaping, i, s) {
    if (string !~ /^".*"$/)
        return string

    split(string, s, "")
    string = ""
    escaping = 0
    for (i = 2; i < length(s); i++) {
        c = s[i]
        if (escaping) {
            string = string escapeChar(c)
            escaping = 0 # escape ends
        } else {
            if (c == "\\")
                escaping = 1 # escape begins
            else
                string = string c
        }
    }
    return string
}

# Return the escaped string.
function escape(string) {
    gsub(/"/, "\\\"", string)
    gsub(/\\/, "\\\\", string)
    return string
}

# Return the escaped, quoted string.
function parameterize(string, quotationMark) {
    if (!quotationMark)
        quotationMark = "'"

    if (quotationMark == "'") {
        gsub(/'/, "'\\''", string)
        return "'" string "'"
    } else {
        return "\"" escape(string) "\""
    }
}

# Return the URL-encoded string.
function quote(string,    i, r, s) {
    r = ""
    split(string, s, "")
    for (i = 1; i <= length(s); i++)
        r = r (s[i] in UrlEncoding ? UrlEncoding[s[i]] : s[i])
    return r
}

# Replicate a string.
function replicate(string, len,
                   ####
                   i, temp) {
    temp = ""
    for (i = 0; i < len; i++)
        temp = temp string
    return temp
}

# Squeeze a source line of AWK code.
function squeeze(line) {
    # Remove preceding spaces
    gsub(/^[[:space:]]+/, "", line)
    # Remove in-line comment
    gsub(/#[^"]*$/, "", line)
    # Remove trailing spaces
    gsub(/[[:space:]]+$/, "", line)

    return line
}

# Return 1 if the array contains anything; otherwise return 0.
function anything(array,
                  ####
                  i) {
    for (i in array)
        if (array[i]) return 1
    return 0
}

# Append an element into an array (zero-based).
function append(array, element) {
    array[anything(array) ? length(array) : 0] = element
}

# Return an element if it belongs to the array;
# Otherwise, return a null string.
function belongsTo(element, array,
                   ####
                   i) {
    for (i in array)
        if (element == array[i]) return element
    return ""
}

# Return one of the substrings if the string starts with it;
# Otherwise, return a null string.
function startsWithAny(string, substrings,
                       ####
                       i) {
    for (i in substrings)
        if (index(string, substrings[i]) == 1) return substrings[i]
    return ""
}

# Return one of the patterns if the string matches this pattern at the beginning;
# Otherwise, return a null string.
function matchesAny(string, patterns,
                    ####
                    i) {
    for (i in patterns)
        if (string ~ "^" patterns[i]) return patterns[i]
    return ""
}

# Join an array into one string;
# Return the string.
function join(array, separator, sortedIn, preserveNull,
              ####
              i, j, saveSortedIn, temp) {
    # Default parameters
    if (!separator)
        separator = " "
    if (!sortedIn)
        sortedIn = "@ind_num_asc"

    temp = ""
    j = 0
    saveSortedIn = PROCINFO["sorted_in"]
    if (length(array)) {
        PROCINFO["sorted_in"] = sortedIn
        for (i in array)
            if (preserveNull || array[i] != "")
                temp = j++ ? temp separator array[i] : array[i]
        PROCINFO["sorted_in"] = saveSortedIn
    } else
        temp = array # array == ""

    return temp
}

# Initialize ANSI escape codes (ANSI X3.64 Standard Control Sequences).
# See: <https://en.wikipedia.org/wiki/ANSI_escape_code>
function initAnsiCode() {
    # Dumb terminal: no ANSI escape code whatsoever
    if (ENVIRON["TERM"] == "dumb") return

    AnsiCode["reset"]         = AnsiCode[0] = "\33[0m"

    AnsiCode["bold"]          = "\33[1m"
    AnsiCode["underline"]     = "\33[4m"
    AnsiCode["negative"]      = "\33[7m"
    AnsiCode["no bold"]       = "\33[22m" # SGR code 21 (bold off) not widely supported
    AnsiCode["no underline"]  = "\33[24m"
    AnsiCode["positive"]      = "\33[27m"

    AnsiCode["black"]         = "\33[30m"
    AnsiCode["red"]           = "\33[31m"
    AnsiCode["green"]         = "\33[32m"
    AnsiCode["yellow"]        = "\33[33m"
    AnsiCode["blue"]          = "\33[34m"
    AnsiCode["magenta"]       = "\33[35m"
    AnsiCode["cyan"]          = "\33[36m"
    AnsiCode["gray"]          = "\33[37m"

    AnsiCode["default"]       = "\33[39m"

    AnsiCode["dark gray"]     = "\33[90m"
    AnsiCode["light red"]     = "\33[91m"
    AnsiCode["light green"]   = "\33[92m"
    AnsiCode["light yellow"]  = "\33[93m"
    AnsiCode["light blue"]    = "\33[94m"
    AnsiCode["light magenta"] = "\33[95m"
    AnsiCode["light cyan"]    = "\33[96m"
    AnsiCode["white"]         = "\33[97m"
}

# Print warning message.
function w(text) {
    print AnsiCode["yellow"] text AnsiCode[0] > "/dev/stderr"
}

# Print error message.
function e(text) {
    print AnsiCode["red"] AnsiCode["bold"] text AnsiCode[0] > "/dev/stderr"
}

# Print debugging message.
function d(text) {
    print AnsiCode["gray"] text AnsiCode[0] > "/dev/stderr"
}

# Log an array.
function da(array, formatString, sortedIn,
            ####
            i, j, saveSortedIn) {
    # Default parameters
    if (!formatString)
        formatString = "_[%s]='%s'"
    if (!sortedIn)
        sortedIn = "@ind_num_asc"

    saveSortedIn = PROCINFO["sorted_in"]
    PROCINFO["sorted_in"] = sortedIn
    for (i in array) {
        split(i, j, SUBSEP)
        d(sprintf(formatString, join(j, ","), array[i]))
    }
    PROCINFO["sorted_in"] = saveSortedIn
}

# Naive assertion.
function assert(x, message) {
    if (!message)
        message = "[ERROR] Assertion failed."

    if (x)
        return x
    else
        e(message)
}

# Return non-zero if file exists, otherwise return 0.
function fileExists(file) {
    return !system("test -f " file)
}

# Initialize `UriSchemes`.
function initUriSchemes() {
    UriSchemes[0] = "file://"
    UriSchemes[1] = "http://"
    UriSchemes[2] = "https://"
}

BEGIN {
    initUrlEncoding()
    initAnsiCode()
    initUriSchemes()
}

####################################################################
# Languages.awk                                                    #
####################################################################

# Initialize all supported locales.
# Mostly ISO 639-1 codes, with a few ISO 639-2 codes (alpha-3).
# See: <https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes>
#      <http://www.loc.gov/standards/iso639-2/php/code_list.php>
function initLocale() {

    #1 Afrikaans
    Locale["af"]["name"]       = "Afrikaans"
    Locale["af"]["endonym"]    = "Afrikaans"
    Locale["af"]["message"]    = "Vertalings van %s"

    #2 Albanian
    Locale["sq"]["name"]       = "Albanian"
    Locale["sq"]["endonym"]    = "Shqip"
    Locale["sq"]["message"]    = "Përkthimet e %s"

    #3 Arabic
    Locale["ar"]["name"]       = "Arabic"
    Locale["ar"]["endonym"]    = "العربية"
    Locale["ar"]["message"]    = "ترجمات %s"
    Locale["ar"]["rtl"]        = "true" # RTL language

    #4 Armenian
    Locale["hy"]["name"]       = "Armenian"
    Locale["hy"]["endonym"]    = "Հայերեն"
    Locale["hy"]["message"]    = "%s-ի թարգմանությունները"

    #5 Azerbaijani
    Locale["az"]["name"]       = "Azerbaijani"
    Locale["az"]["endonym"]    = "Azərbaycanca"
    Locale["az"]["message"]    = "%s sözünün tərcüməsi"

    #6 Basque
    Locale["eu"]["name"]       = "Basque"
    Locale["eu"]["endonym"]    = "Euskara"
    Locale["eu"]["message"]    = "%s esapidearen itzulpena"

    #7 Belarusian (Cyrillic alphabet)
    Locale["be"]["name"]       = "Belarusian"
    Locale["be"]["endonym"]    = "беларуская"
    Locale["be"]["message"]    = "Пераклады %s"

    #8 Bengali
    Locale["bn"]["name"]       = "Bengali"
    Locale["bn"]["endonym"]    = "বাংলা"
    Locale["bn"]["message"]    = "%s এর অনুবাদ"

    #9 Bosnian (Latin alphabet)
    Locale["bs"]["name"]       = "Bosnian"
    Locale["bs"]["endonym"]    = "Bosanski"
    Locale["bs"]["message"]    = "Prijevod za: %s"

    #10 Bulgarian
    Locale["bg"]["name"]       = "Bulgarian"
    Locale["bg"]["endonym"]    = "български"
    Locale["bg"]["message"]    = "Преводи на %s"

    #11 Catalan
    Locale["ca"]["name"]       = "Catalan"
    Locale["ca"]["endonym"]    = "Català"
    Locale["ca"]["message"]    = "Traduccions per a %s"

    #12 Cebuano
    Locale["ceb"]["name"]      = "Cebuano"
    Locale["ceb"]["endonym"]   = "Cebuano"
    Locale["ceb"]["message"]   = "%s Mga Paghubad sa PULONG_O_HUGPONG SA PAMULONG"

    #13a Chinese (Simplified)
    Locale["zh-CN"]["name"]    = "Chinese Simplified"
    Locale["zh-CN"]["endonym"] = "简体中文"
    Locale["zh-CN"]["message"] = "%s 的翻译"

    #13b Chinese (Traditional)
    Locale["zh-TW"]["name"]    = "Chinese Traditional"
    Locale["zh-TW"]["endonym"] = "正體中文"
    Locale["zh-TW"]["message"] = "「%s」的翻譯"

    #14 Chichewa
    Locale["ny"]["name"]       = "Chichewa"
    Locale["ny"]["endonym"]    = "Nyanja"
    Locale["ny"]["message"]    = "Matanthauzidwe a %s"

    #15 Croatian
    Locale["hr"]["name"]       = "Croatian"
    Locale["hr"]["endonym"]    = "Hrvatski"
    Locale["hr"]["message"]    = "Prijevodi riječi ili izraza %s"

    #16 Czech
    Locale["cs"]["name"]       = "Czech"
    Locale["cs"]["endonym"]    = "Čeština"
    Locale["cs"]["message"]    = "Překlad výrazu %s"

    #17 Danish
    Locale["da"]["name"]       = "Danish"
    Locale["da"]["endonym"]    = "Dansk"
    Locale["da"]["message"]    = "Oversættelser af %s"

    #18 Dutch
    Locale["nl"]["name"]       = "Dutch"
    Locale["nl"]["endonym"]    = "Nederlands"
    Locale["nl"]["message"]    = "Vertalingen van %s"

    #19 English
    Locale["en"]["name"]       = "English"
    Locale["en"]["endonym"]    = "English"
    Locale["en"]["message"]    = "Translations of %s"

    #20 Esperanto
    Locale["eo"]["name"]       = "Esperanto"
    Locale["eo"]["endonym"]    = "Esperanto"
    Locale["eo"]["message"]    = "Tradukoj de %s"

    #21 Estonian
    Locale["et"]["name"]       = "Estonian"
    Locale["et"]["endonym"]    = "Eesti"
    Locale["et"]["message"]    = "Sõna(de) %s tõlked"

    #22 Filipino
    Locale["tl"]["name"]       = "Filipino"
    Locale["tl"]["endonym"]    = "Tagalog"
    Locale["tl"]["message"]    = "Mga pagsasalin ng %s"

    #23 Finnish
    Locale["fi"]["name"]       = "Finnish"
    Locale["fi"]["endonym"]    = "Suomi"
    Locale["fi"]["message"]    = "Käännökset tekstille %s"

    #24 French
    Locale["fr"]["name"]       = "French"
    Locale["fr"]["endonym"]    = "Français"
    Locale["fr"]["message"]    = "Traductions de %s"

    #25 Galician
    Locale["gl"]["name"]       = "Galician"
    Locale["gl"]["endonym"]    = "Galego"
    Locale["gl"]["message"]    = "Traducións de %s"

    #26 Georgian
    Locale["ka"]["name"]       = "Georgian"
    Locale["ka"]["endonym"]    = "ქართული"
    Locale["ka"]["message"]    = "%s-ის თარგმანები"

    #27 German
    Locale["de"]["name"]       = "German"
    Locale["de"]["endonym"]    = "Deutsch"
    Locale["de"]["message"]    = "Übersetzungen für %s"

    #28 Greek
    Locale["el"]["name"]       = "Greek"
    Locale["el"]["endonym"]    = "Ελληνικά"
    Locale["el"]["message"]    = "Μεταφράσεις του %s"

    #29 Gujarati
    Locale["gu"]["name"]       = "Gujarati"
    Locale["gu"]["endonym"]    = "ગુજરાતી"
    Locale["gu"]["message"]    = "%s ના અનુવાદ"

    #30 Haitian Creole
    Locale["ht"]["name"]       = "Haitian Creole"
    Locale["ht"]["endonym"]    = "Kreyòl Ayisyen"
    Locale["ht"]["message"]    = "Tradiksyon %s"

    #31 Hausa (Latin / Boko alphabet)
    Locale["ha"]["name"]       = "Hausa"
    Locale["ha"]["endonym"]    = "Hausa"
    Locale["ha"]["message"]    = "Fassarar %s"

    #32 Hebrew
    Locale["he"]["name"]       = "Hebrew"
    Locale["he"]["endonym"]    = "עִבְרִית"
    Locale["he"]["message"]    = "תרגומים של %s"
    Locale["he"]["rtl"]        = "true" # RTL language

    #33 Hindi
    Locale["hi"]["name"]       = "Hindi"
    Locale["hi"]["endonym"]    = "हिन्दी"
    Locale["hi"]["message"]    = "%s के अनुवाद"

    #34 Hmong
    Locale["hmn"]["name"]      = "Hmong"
    Locale["hmn"]["endonym"]   = "Hmoob"
    Locale["hmn"]["message"]   = "Lus txhais: %s"

    #35 Hungarian
    Locale["hu"]["name"]       = "Hungarian"
    Locale["hu"]["endonym"]    = "Magyar"
    Locale["hu"]["message"]    = "%s fordításai"

    #36 Icelandic
    Locale["is"]["name"]       = "Icelandic"
    Locale["is"]["endonym"]    = "Íslenska"
    Locale["is"]["message"]    = "Þýðingar á %s"

    #37 Igbo
    Locale["ig"]["name"]       = "Igbo"
    Locale["ig"]["endonym"]    = "Igbo"
    Locale["ig"]["message"]    = "Ntụgharị asụsụ nke %s"

    #38 Indonesian
    Locale["id"]["name"]       = "Indonesian"
    Locale["id"]["endonym"]    = "Bahasa Indonesia"
    Locale["id"]["message"]    = "Terjemahan dari %s"

    #39 Irish
    Locale["ga"]["name"]       = "Irish"
    Locale["ga"]["endonym"]    = "Gaeilge"
    Locale["ga"]["message"]    = "Aistriúcháin ar %s"

    #40 Italian
    Locale["it"]["name"]       = "Italian"
    Locale["it"]["endonym"]    = "Italiano"
    Locale["it"]["message"]    = "Traduzioni di %s"

    #41 Japanese
    Locale["ja"]["name"]       = "Japanese"
    Locale["ja"]["endonym"]    = "日本語"
    Locale["ja"]["message"]    = "「%s」の翻訳"

    #42 Javanese (Latin alphabet)
    Locale["jv"]["name"]       = "Javanese"
    Locale["jv"]["endonym"]    = "Basa Jawa"
    Locale["jv"]["message"]    = "Terjemahan"

    #43 Kannada
    Locale["kn"]["name"]       = "Kannada"
    Locale["kn"]["endonym"]    = "ಕನ್ನಡ"
    Locale["kn"]["message"]    = "%s ನ ಅನುವಾದಗಳು"

    #44 Kazakh (Cyrillic alphabet)
    Locale["kk"]["name"]       = "Kazakh"
    Locale["kk"]["endonym"]    = "Қазақ тілі"
    Locale["kk"]["message"]    = "%s аудармалары"

    #45 Khmer (Central Khmer)
    Locale["km"]["name"]       = "Khmer"
    Locale["km"]["endonym"]    = "ភាសាខ្មែរ"
    Locale["km"]["message"]    = "ការ​បក​ប្រែ​នៃ %s"

    #46 Korean
    Locale["ko"]["name"]       = "Korean"
    Locale["ko"]["endonym"]    = "한국어"
    Locale["ko"]["message"]    = "%s의 번역"

    #47 Lao
    Locale["lo"]["name"]       = "Lao"
    Locale["lo"]["endonym"]    = "ລາວ"
    Locale["lo"]["message"]    = "ການ​ແປ​ພາ​ສາ​ຂອງ %s"

    #48 Latin
    Locale["la"]["name"]       = "Latin"
    Locale["la"]["endonym"]    = "Latina"
    Locale["la"]["message"]    = "Versio de %s"

    #49 Latvian
    Locale["lv"]["name"]       = "Latvian"
    Locale["lv"]["endonym"]    = "Latviešu"
    Locale["lv"]["message"]    = "%s tulkojumi"

    #50 Lithuanian
    Locale["lt"]["name"]       = "Lithuanian"
    Locale["lt"]["endonym"]    = "Lietuvių"
    Locale["lt"]["message"]    = "„%s“ vertimai"

    #51 Macedonian
    Locale["mk"]["name"]       = "Macedonian"
    Locale["mk"]["endonym"]    = "Македонски"
    Locale["mk"]["message"]    = "Преводи на %s"

    #52 Malagasy
    Locale["mg"]["name"]       = "Malagasy"
    Locale["mg"]["endonym"]    = "Malagasy"
    Locale["mg"]["message"]    = "Dikan'ny %s"

    #53 Malay
    Locale["ms"]["name"]       = "Malay"
    Locale["ms"]["endonym"]    = "Bahasa Melayu"
    Locale["ms"]["message"]    = "Terjemahan %s"

    #54 Malayalam
    Locale["ml"]["name"]       = "Malayalam"
    Locale["ml"]["endonym"]    = "മലയാളം"
    Locale["ml"]["message"]    = "%s എന്നതിന്റെ വിവർത്തനങ്ങൾ"

    #55 Maltese
    Locale["mt"]["name"]       = "Maltese"
    Locale["mt"]["endonym"]    = "Malti"
    Locale["mt"]["message"]    = "Traduzzjonijiet ta' %s"

    #56 Maori
    Locale["mi"]["name"]       = "Maori"
    Locale["mi"]["endonym"]    = "Māori"
    Locale["mi"]["message"]    = "Ngā whakamāoritanga o %s"

    #57 Marathi
    Locale["mr"]["name"]       = "Marathi"
    Locale["mr"]["endonym"]    = "मराठी"
    Locale["mr"]["message"]    = "%s ची भाषांतरे"

    #58 Mongolian (Cyrillic alphabet)
    Locale["mn"]["name"]       = "Mongolian"
    Locale["mn"]["endonym"]    = "Монгол"
    Locale["mn"]["message"]    = "%s-н орчуулга"

    #59 Myanmar (Burmese)
    Locale["my"]["name"]       = "Myanmar"
    Locale["my"]["endonym"]    = "မြန်မာစာ"
    Locale["my"]["message"]    = "%s၏ ဘာသာပြန်ဆိုချက်များ"

    #60 Nepali
    Locale["ne"]["name"]       = "Nepali"
    Locale["ne"]["endonym"]    = "नेपाली"
    Locale["ne"]["message"]    = "%sका अनुवाद"

    #61 Norwegian
    Locale["no"]["name"]       = "Norwegian"
    Locale["no"]["endonym"]    = "Norsk"
    Locale["no"]["message"]    = "Oversettelser av %s"

    #62 Persian
    Locale["fa"]["name"]       = "Persian"
    Locale["fa"]["endonym"]    = "فارسی"
    Locale["fa"]["message"]    = "ترجمه‌های %s"
    Locale["fa"]["rtl"]        = "true" # RTL language

    #63 Punjabi (Brahmic / Gurmukhī alphabet)
    Locale["pa"]["name"]       = "Punjabi"
    Locale["pa"]["endonym"]    = "ਪੰਜਾਬੀ"
    Locale["pa"]["message"]    = "ਦੇ ਅਨੁਵਾਦ%s"

    #64 Polish
    Locale["pl"]["name"]       = "Polish"
    Locale["pl"]["endonym"]    = "Polski"
    Locale["pl"]["message"]    = "Tłumaczenia %s"

    #65 Portuguese
    Locale["pt"]["name"]       = "Portuguese"
    Locale["pt"]["endonym"]    = "Português"
    Locale["pt"]["message"]    = "Traduções de %s"

    #66 Romanian
    Locale["ro"]["name"]       = "Romanian"
    Locale["ro"]["endonym"]    = "Română"
    Locale["ro"]["message"]    = "Traduceri pentru %s"

    #67 Russian
    Locale["ru"]["name"]       = "Russian"
    Locale["ru"]["endonym"]    = "Русский"
    Locale["ru"]["message"]    = "%s: варианты перевода"

    #68 Serbian (Cyrillic alphabet)
    Locale["sr"]["name"]       = "Serbian"
    Locale["sr"]["endonym"]    = "српски"
    Locale["sr"]["message"]    = "Преводи за „%s“"

    #69 Sesotho
    Locale["st"]["name"]       = "Sesotho"
    Locale["st"]["endonym"]    = "Sesotho"
    Locale["st"]["message"]    = "Liphetolelo tsa %s"

    #70 Sinhala
    Locale["si"]["name"]       = "Sinhala"
    Locale["si"]["endonym"]    = "සිංහල"
    Locale["si"]["message"]    = "%s හි පරිවර්තන"

    #71 Slovak
    Locale["sk"]["name"]       = "Slovak"
    Locale["sk"]["endonym"]    = "Slovenčina"
    Locale["sk"]["message"]    = "Preklady výrazu: %s"

    #72 Slovenian
    Locale["sl"]["name"]       = "Slovenian"
    Locale["sl"]["endonym"]    = "Slovenščina"
    Locale["sl"]["message"]    = "Prevodi za %s"

    #73 Somali
    Locale["so"]["name"]       = "Somali"
    Locale["so"]["endonym"]    = "Soomaali"
    Locale["so"]["message"]    = "Turjumaada %s"

    #74 Spanish
    Locale["es"]["name"]       = "Spanish"
    Locale["es"]["endonym"]    = "Español"
    Locale["es"]["message"]    = "Traducciones de %s"

    #75 Sundanese (Latin alphabet)
    Locale["su"]["name"]       = "Sundanese"
    Locale["su"]["endonym"]    = "Basa Sunda"
    Locale["su"]["message"]    = "Tarjamahan tina %s"

    #76 Swahili
    Locale["sw"]["name"]       = "Swahili"
    Locale["sw"]["endonym"]    = "Kiswahili"
    Locale["sw"]["message"]    = "Tafsiri ya %s"

    #77 Swedish
    Locale["sv"]["name"]       = "Swedish"
    Locale["sv"]["endonym"]    = "Svenska"
    Locale["sv"]["message"]    = "Översättningar av %s"

    #78 Tajik (Cyrillic alphabet)
    Locale["tg"]["name"]       = "Tajik"
    Locale["tg"]["endonym"]    = "Тоҷикӣ"
    Locale["tg"]["message"]    = "Тарҷумаҳои %s"

    #79 Tamil
    Locale["ta"]["name"]       = "Tamil"
    Locale["ta"]["endonym"]    = "தமிழ்"
    Locale["ta"]["message"]    = "%s இன் மொழிபெயர்ப்புகள்"

    #80 Telugu
    Locale["te"]["name"]       = "Telugu"
    Locale["te"]["endonym"]    = "తెలుగు"
    Locale["te"]["message"]    = "%s యొక్క అనువాదాలు"

    #81 Thai
    Locale["th"]["name"]       = "Thai"
    Locale["th"]["endonym"]    = "ไทย"
    Locale["th"]["message"]    = "คำแปลของ %s"

    #82 Turkish
    Locale["tr"]["name"]       = "Turkish"
    Locale["tr"]["endonym"]    = "Türkçe"
    Locale["tr"]["message"]    = "%s çevirileri"

    #83 Ukrainian
    Locale["uk"]["name"]       = "Ukrainian"
    Locale["uk"]["endonym"]    = "Українська"
    Locale["uk"]["message"]    = "Переклади слова або виразу \"%s\""

    #84 Urdu
    Locale["ur"]["name"]       = "Urdu"
    Locale["ur"]["endonym"]    = "اُردُو"
    Locale["ur"]["message"]    = "کے ترجمے %s"
    Locale["ur"]["rtl"]        = "true" # RTL language

    #85 Uzbek (Latin alphabet)
    Locale["uz"]["name"]       = "Uzbek"
    Locale["uz"]["endonym"]    = "Oʻzbek tili"
    Locale["uz"]["message"]    = "%s tarjimalari"

    #86 Vietnamese
    Locale["vi"]["name"]       = "Vietnamese"
    Locale["vi"]["endonym"]    = "Tiếng Việt"
    Locale["vi"]["message"]    = "Bản dịch của %s"

    #87 Welsh
    Locale["cy"]["name"]       = "Welsh"
    Locale["cy"]["endonym"]    = "Cymraeg"
    Locale["cy"]["message"]    = "Cyfieithiadau %s"

    #88 Yiddish
    Locale["yi"]["name"]       = "Yiddish"
    Locale["yi"]["endonym"]    = "ייִדיש"
    Locale["yi"]["message"]    = "איבערזעצונגען פון %s"
    Locale["yi"]["rtl"]        = "true" # RTL language

    #89 Yoruba
    Locale["yo"]["name"]       = "Yoruba"
    Locale["yo"]["endonym"]    = "Yorùbá"
    Locale["yo"]["message"]    = "Awọn itumọ ti %s"

    #90 Zulu
    Locale["zu"]["name"]       = "Zulu"
    Locale["zu"]["endonym"]    = "isiZulu"
    Locale["zu"]["message"]    = "Ukuhumusha i-%s"

    # Aliases for some locales
    # See: <http://www.loc.gov/standards/iso639-2/php/code_changes.php>
    LocaleAlias["in"] = "id" # withdrawn language code for Indonesian
    LocaleAlias["iw"] = "he" # withdrawn language code for Hebrew
    LocaleAlias["ji"] = "yi" # withdrawn language code for Yiddish

    LocaleAlias["jw"] = "jv" # withdrawn language code for Javanese
    LocaleAlias["mo"] = "ro" # Moldavian or Moldovan considered a variant of the Romanian language
    LocaleAlias["sh"] = "sr" # Serbo-Croatian: prefer Serbian
    LocaleAlias["zh"] = "zh-CN" # Chinese: prefer Chinese Simplified
    LocaleAlias["zh-cn"] = "zh-CN" # lowercase
    LocaleAlias["zh-tw"] = "zh-TW" # lowercase
    # TODO: any more aliases supported by Google Translate?
}

# Get locale key by language code or alias.
function getCode(code) {
    code = tolower(code) # case-insensitive

    if (code in Locale || code == "auto")
        return code
    else if (code in LocaleAlias)
        return LocaleAlias[code]
    else
        return # return nothing if not found
}

# Detect external bidirectional algorithm utility (fribidi);
# Fallback to Unix `rev` if not found.
function initBiDi() {
    "fribidi --version 2>/dev/null" |& getline FriBidi
    BiDiNoPad = FriBidi ? "fribidi --nopad" : "rev"
    BiDi = FriBidi ? "fribidi --width %s" : "rev | sed \"s/'/\\\\\\'/\" | xargs printf '%%s '"
}

# Convert a logical string to visual; don't right justify RTL lines.
# Parameters:
#     code: ignore to apply bidirectional algorithm on every string
function show(text, code,    temp) {
    if (!code || Locale[getCode(code)]["rtl"]) {
        if (Cache[text][0])
            return Cache[text][0]
        else {
            if (FriBidi || (code && Locale[getCode(code)]["rtl"]))
                ("echo " parameterize(text) " | " BiDiNoPad) | getline temp
            else # non-RTL language, or FriBidi not installed
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
function s(text, code, width,    temp) {
    if (!code || Locale[getCode(code)]["rtl"]) {
        if (!width) width = Option["width"]
        if (Cache[text][width])
            return Cache[text][width]
        else {
            if (FriBidi || (code && Locale[getCode(code)]["rtl"]))
                ("echo " parameterize(text) " | " sprintf(BiDi, width)) | getline temp
            else # non-RTL language, or FriBidi not installed
                temp = text
            return Cache[text][width] = temp
        }
    } else
        return text
}

# Initialize strings for displaying endonyms of locales.
function initLocaleDisplay(    i) {
    for (i in Locale)
        Locale[i]["display"] = show(Locale[i]["endonym"], i)
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
function initUserLang() {
    UserLang = ENVIRON["LC_CTYPE"] ?
        parseLang(ENVIRON["LC_CTYPE"]) :
        (ENVIRON["LANG"] ?
         parseLang(ENVIRON["LANG"]) :
         "en")

    if (tolower(ENVIRON["LANG"]) !~ /utf-?8$/ && tolower(ENVIRON["LC_CTYPE"]) !~ /utf-?8$/)
        w("[WARNING] Your locale codeset (" ENVIRON["LANG"] ") is not UTF-8. You have been warned.")
}
####################################################################
# Help.awk                                                         #
####################################################################

# Return version as a string.
function getVersion() {
    return Name " " Version
}

# Return a list of language codes as a string.
# Parameters:
#     displayName = "endonym" or "name"
function getReference(displayName) {
    if (displayName == "name")
        return "┌─────────────────────────────┬──────────────────────┬─────────────────┐\n" \
            "│ " Locale["af"]["name"] "           - " AnsiCode["bold"] "af" AnsiCode["no bold"] "    │ " \
            Locale["ha"]["name"] "          - " AnsiCode["bold"] "ha" AnsiCode["no bold"] "  │ " \
            Locale["fa"]["name"] "    - " AnsiCode["bold"] "fa" AnsiCode["no bold"] " │\n" \
            "│ " Locale["sq"]["name"] "            - " AnsiCode["bold"] "sq" AnsiCode["no bold"] "    │ " \
            Locale["he"]["name"] "         - " AnsiCode["bold"] "he" AnsiCode["no bold"] "  │ " \
            Locale["pl"]["name"] "     - " AnsiCode["bold"] "pl" AnsiCode["no bold"] " │\n" \
            "│ " Locale["ar"]["name"] "              - " AnsiCode["bold"] "ar" AnsiCode["no bold"] "    │ " \
            Locale["hi"]["name"] "          - " AnsiCode["bold"] "hi" AnsiCode["no bold"] "  │ " \
            Locale["pt"]["name"] " - " AnsiCode["bold"] "pt" AnsiCode["no bold"] " │\n" \
            "│ " Locale["hy"]["name"] "            - " AnsiCode["bold"] "hy" AnsiCode["no bold"] "    │ " \
            Locale["hmn"]["name"] "          - " AnsiCode["bold"] "hmn" AnsiCode["no bold"] " │ " \
            Locale["pa"]["name"] "    - " AnsiCode["bold"] "pa" AnsiCode["no bold"] " │\n" \
            "│ " Locale["az"]["name"] "         - " AnsiCode["bold"] "az" AnsiCode["no bold"] "    │ " \
            Locale["hu"]["name"] "      - " AnsiCode["bold"] "hu" AnsiCode["no bold"] "  │ " \
            Locale["ro"]["name"] "   - " AnsiCode["bold"] "ro" AnsiCode["no bold"] " │\n" \
            "│ " Locale["eu"]["name"] "              - " AnsiCode["bold"] "eu" AnsiCode["no bold"] "    │ " \
            Locale["is"]["name"] "      - " AnsiCode["bold"] "is" AnsiCode["no bold"] "  │ " \
            Locale["ru"]["name"] "    - " AnsiCode["bold"] "ru" AnsiCode["no bold"] " │\n" \
            "│ " Locale["be"]["name"] "          - " AnsiCode["bold"] "be" AnsiCode["no bold"] "    │ " \
            Locale["ig"]["name"] "           - " AnsiCode["bold"] "ig" AnsiCode["no bold"] "  │ " \
            Locale["sr"]["name"] "    - " AnsiCode["bold"] "sr" AnsiCode["no bold"] " │\n" \
            "│ " Locale["bn"]["name"] "             - " AnsiCode["bold"] "bn" AnsiCode["no bold"] "    │ " \
            Locale["id"]["name"] "     - " AnsiCode["bold"] "id" AnsiCode["no bold"] "  │ " \
            Locale["st"]["name"] "    - " AnsiCode["bold"] "st" AnsiCode["no bold"] " │\n" \
            "│ " Locale["bs"]["name"] "             - " AnsiCode["bold"] "bs" AnsiCode["no bold"] "    │ " \
            Locale["ga"]["name"] "          - " AnsiCode["bold"] "ga" AnsiCode["no bold"] "  │ " \
            Locale["si"]["name"] "    - " AnsiCode["bold"] "si" AnsiCode["no bold"] " │\n" \
            "│ " Locale["bg"]["name"] "           - " AnsiCode["bold"] "bg" AnsiCode["no bold"] "    │ " \
            Locale["it"]["name"] "        - " AnsiCode["bold"] "it" AnsiCode["no bold"] "  │ " \
            Locale["sk"]["name"] "     - " AnsiCode["bold"] "sk" AnsiCode["no bold"] " │\n" \
            "│ " Locale["ca"]["name"] "             - " AnsiCode["bold"] "ca" AnsiCode["no bold"] "    │ " \
            Locale["ja"]["name"] "       - " AnsiCode["bold"] "ja" AnsiCode["no bold"] "  │ " \
            Locale["sl"]["name"] "  - " AnsiCode["bold"] "sl" AnsiCode["no bold"] " │\n" \
            "│ " Locale["ceb"]["name"] "             - " AnsiCode["bold"] "ceb" AnsiCode["no bold"] "   │ " \
            Locale["jv"]["name"] "       - " AnsiCode["bold"] "jv" AnsiCode["no bold"] "  │ " \
            Locale["so"]["name"] "     - " AnsiCode["bold"] "so" AnsiCode["no bold"] " │\n" \
            "│ " Locale["ny"]["name"] "            - " AnsiCode["bold"] "ny" AnsiCode["no bold"] "    │ " \
            Locale["kn"]["name"] "        - " AnsiCode["bold"] "kn" AnsiCode["no bold"] "  │ " \
            Locale["es"]["name"] "    - " AnsiCode["bold"] "es" AnsiCode["no bold"] " │\n" \
            "│ " Locale["zh-CN"]["name"] "  - " AnsiCode["bold"] "zh-CN" AnsiCode["no bold"] " │ " \
            Locale["kk"]["name"] "         - " AnsiCode["bold"] "kk" AnsiCode["no bold"] "  │ " \
            Locale["su"]["name"] "  - " AnsiCode["bold"] "su" AnsiCode["no bold"] " │\n" \
            "│ " Locale["zh-TW"]["name"] " - " AnsiCode["bold"] "zh-TW" AnsiCode["no bold"] " │ " \
            Locale["km"]["name"] "          - " AnsiCode["bold"] "km" AnsiCode["no bold"] "  │ " \
            Locale["sw"]["name"] "    - " AnsiCode["bold"] "sw" AnsiCode["no bold"] " │\n" \
            "│ " Locale["hr"]["name"] "            - " AnsiCode["bold"] "hr" AnsiCode["no bold"] "    │ " \
            Locale["ko"]["name"] "         - " AnsiCode["bold"] "ko" AnsiCode["no bold"] "  │ " \
            Locale["sv"]["name"] "    - " AnsiCode["bold"] "sv" AnsiCode["no bold"] " │\n" \
            "│ " Locale["cs"]["name"] "               - " AnsiCode["bold"] "cs" AnsiCode["no bold"] "    │ " \
            Locale["lo"]["name"] "            - " AnsiCode["bold"] "lo" AnsiCode["no bold"] "  │ " \
            Locale["tg"]["name"] "      - " AnsiCode["bold"] "tg" AnsiCode["no bold"] " │\n" \
            "│ " Locale["da"]["name"] "              - " AnsiCode["bold"] "da" AnsiCode["no bold"] "    │ " \
            Locale["la"]["name"] "          - " AnsiCode["bold"] "la" AnsiCode["no bold"] "  │ " \
            Locale["ta"]["name"] "      - " AnsiCode["bold"] "ta" AnsiCode["no bold"] " │\n" \
            "│ " Locale["nl"]["name"] "               - " AnsiCode["bold"] "nl" AnsiCode["no bold"] "    │ " \
            Locale["lv"]["name"] "        - " AnsiCode["bold"] "lv" AnsiCode["no bold"] "  │ " \
            Locale["te"]["name"] "     - " AnsiCode["bold"] "te" AnsiCode["no bold"] " │\n" \
            "│ " Locale["en"]["name"] "             - " AnsiCode["bold"] "en" AnsiCode["no bold"] "    │ " \
            Locale["lt"]["name"] "     - " AnsiCode["bold"] "lt" AnsiCode["no bold"] "  │ " \
            Locale["th"]["name"] "       - " AnsiCode["bold"] "th" AnsiCode["no bold"] " │\n" \
            "│ " Locale["eo"]["name"] "           - " AnsiCode["bold"] "eo" AnsiCode["no bold"] "    │ " \
            Locale["mk"]["name"] "     - " AnsiCode["bold"] "mk" AnsiCode["no bold"] "  │ " \
            Locale["tr"]["name"] "    - " AnsiCode["bold"] "tr" AnsiCode["no bold"] " │\n" \
            "│ " Locale["et"]["name"] "            - " AnsiCode["bold"] "et" AnsiCode["no bold"] "    │ " \
            Locale["mg"]["name"] "       - " AnsiCode["bold"] "mg" AnsiCode["no bold"] "  │ " \
            Locale["uk"]["name"] "  - " AnsiCode["bold"] "uk" AnsiCode["no bold"] " │\n" \
            "│ " Locale["tl"]["name"] "            - " AnsiCode["bold"] "tl" AnsiCode["no bold"] "    │ " \
            Locale["ms"]["name"] "          - " AnsiCode["bold"] "ms" AnsiCode["no bold"] "  │ " \
            Locale["ur"]["name"] "       - " AnsiCode["bold"] "ur" AnsiCode["no bold"] " │\n" \
            "│ " Locale["fi"]["name"] "             - " AnsiCode["bold"] "fi" AnsiCode["no bold"] "    │ " \
            Locale["ml"]["name"] "      - " AnsiCode["bold"] "ml" AnsiCode["no bold"] "  │ " \
            Locale["uz"]["name"] "      - " AnsiCode["bold"] "uz" AnsiCode["no bold"] " │\n" \
            "│ " Locale["fr"]["name"] "              - " AnsiCode["bold"] "fr" AnsiCode["no bold"] "    │ " \
            Locale["mt"]["name"] "        - " AnsiCode["bold"] "mt" AnsiCode["no bold"] "  │ " \
            Locale["vi"]["name"] " - " AnsiCode["bold"] "vi" AnsiCode["no bold"] " │\n" \
            "│ " Locale["gl"]["name"] "            - " AnsiCode["bold"] "gl" AnsiCode["no bold"] "    │ " \
            Locale["mi"]["name"] "          - " AnsiCode["bold"] "mi" AnsiCode["no bold"] "  │ " \
            Locale["cy"]["name"] "      - " AnsiCode["bold"] "cy" AnsiCode["no bold"] " │\n" \
            "│ " Locale["ka"]["name"] "            - " AnsiCode["bold"] "ka" AnsiCode["no bold"] "    │ " \
            Locale["mr"]["name"] "        - " AnsiCode["bold"] "mr" AnsiCode["no bold"] "  │ " \
            Locale["yi"]["name"] "    - " AnsiCode["bold"] "yi" AnsiCode["no bold"] " │\n" \
            "│ " Locale["de"]["name"] "              - " AnsiCode["bold"] "de" AnsiCode["no bold"] "    │ " \
            Locale["my"]["name"] "        - " AnsiCode["bold"] "my" AnsiCode["no bold"] "  │ " \
            Locale["yo"]["name"] "     - " AnsiCode["bold"] "yo" AnsiCode["no bold"] " │\n" \
            "│ " Locale["el"]["name"] "               - " AnsiCode["bold"] "el" AnsiCode["no bold"] "    │ " \
            Locale["mn"]["name"] "      - " AnsiCode["bold"] "mn" AnsiCode["no bold"] "  │ " \
            Locale["zu"]["name"] "       - " AnsiCode["bold"] "zu" AnsiCode["no bold"] " │\n" \
            "│ " Locale["gu"]["name"] "            - " AnsiCode["bold"] "gu" AnsiCode["no bold"] "    │ " \
            Locale["ne"]["name"] "         - " AnsiCode["bold"] "ne" AnsiCode["no bold"] "  │ " \
            "                │\n" \
            "│ " Locale["ht"]["name"] "      - " AnsiCode["bold"] "ht" AnsiCode["no bold"] "    │ " \
            Locale["no"]["name"] "      - " AnsiCode["bold"] "no" AnsiCode["no bold"] "  │ " \
            "                │\n" \
            "└─────────────────────────────┴──────────────────────┴─────────────────┘"
    else
        return "┌──────────────────────┬───────────────────────┬─────────────────────┐\n" \
            "│ " Locale["af"]["display"] "      - " AnsiCode["bold"] "af" AnsiCode["no bold"] "  │ " \
            Locale["hu"]["display"] "           - " AnsiCode["bold"] "hu" AnsiCode["no bold"] " │ " \
            Locale["pl"]["display"] "      - " AnsiCode["bold"] "pl" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["ar"]["display"] "        - " AnsiCode["bold"] "ar" AnsiCode["no bold"] "  │ " \
            Locale["hy"]["display"] "          - " AnsiCode["bold"] "hy" AnsiCode["no bold"] " │ " \
            Locale["pt"]["display"] "   - " AnsiCode["bold"] "pt" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["az"]["display"] "   - " AnsiCode["bold"] "az" AnsiCode["no bold"] "  │ " \
            Locale["id"]["display"] " - " AnsiCode["bold"] "id" AnsiCode["no bold"] " │ " \
            Locale["ro"]["display"] "      - " AnsiCode["bold"] "ro" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["be"]["display"] "     - " AnsiCode["bold"] "be" AnsiCode["no bold"] "  │ " \
            Locale["ig"]["display"] "             - " AnsiCode["bold"] "ig" AnsiCode["no bold"] " │ " \
            Locale["ru"]["display"] "     - " AnsiCode["bold"] "ru" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["bg"]["display"] "      - " AnsiCode["bold"] "bg" AnsiCode["no bold"] "  │ " \
            Locale["is"]["display"] "         - " AnsiCode["bold"] "is" AnsiCode["no bold"] " │ " \
            Locale["si"]["display"] "        - " AnsiCode["bold"] "si" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["bn"]["display"] "          - " AnsiCode["bold"] "bn" AnsiCode["no bold"] "  │ " \
            Locale["it"]["display"] "         - " AnsiCode["bold"] "it" AnsiCode["no bold"] " │ " \
            Locale["sk"]["display"] "  - " AnsiCode["bold"] "sk" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["bs"]["display"] "       - " AnsiCode["bold"] "bs" AnsiCode["no bold"] "  │ " \
            Locale["ja"]["display"] "           - " AnsiCode["bold"] "ja" AnsiCode["no bold"] " │ " \
            Locale["sl"]["display"] " - " AnsiCode["bold"] "sl" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["ca"]["display"] "         - " AnsiCode["bold"] "ca" AnsiCode["no bold"] "  │ " \
            Locale["jv"]["display"] "        - " AnsiCode["bold"] "jv" AnsiCode["no bold"] " │ " \
            Locale["so"]["display"] "    - " AnsiCode["bold"] "so" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["ceb"]["display"] "        - " AnsiCode["bold"] "ceb" AnsiCode["no bold"] " │ " \
            Locale["ka"]["display"] "          - " AnsiCode["bold"] "ka" AnsiCode["no bold"] " │ " \
            Locale["sq"]["display"] "       - " AnsiCode["bold"] "sq" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["cs"]["display"] "        - " AnsiCode["bold"] "cs" AnsiCode["no bold"] "  │ " \
            Locale["kk"]["display"] "       - " AnsiCode["bold"] "kk" AnsiCode["no bold"] " │ " \
            Locale["sr"]["display"] "      - " AnsiCode["bold"] "sr" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["cy"]["display"] "        - " AnsiCode["bold"] "cy" AnsiCode["no bold"] "  │ " \
            Locale["km"]["display"] "         - " AnsiCode["bold"] "km" AnsiCode["no bold"] " │ " \
            Locale["st"]["display"] "     - " AnsiCode["bold"] "st" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["da"]["display"] "          - " AnsiCode["bold"] "da" AnsiCode["no bold"] "  │ " \
            Locale["kn"]["display"] "             - " AnsiCode["bold"] "kn" AnsiCode["no bold"] " │ " \
            Locale["su"]["display"] "  - " AnsiCode["bold"] "su" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["de"]["display"] "        - " AnsiCode["bold"] "de" AnsiCode["no bold"] "  │ " \
            Locale["ko"]["display"] "           - " AnsiCode["bold"] "ko" AnsiCode["no bold"] " │ " \
            Locale["sv"]["display"] "     - " AnsiCode["bold"] "sv" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["el"]["display"] "       - " AnsiCode["bold"] "el" AnsiCode["no bold"] "  │ " \
            Locale["la"]["display"] "           - " AnsiCode["bold"] "la" AnsiCode["no bold"] " │ " \
            Locale["sw"]["display"] "   - " AnsiCode["bold"] "sw" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["en"]["display"] "        - " AnsiCode["bold"] "en" AnsiCode["no bold"] "  │ " \
            Locale["lo"]["display"] "              - " AnsiCode["bold"] "lo" AnsiCode["no bold"] " │ " \
            Locale["ta"]["display"] "        - " AnsiCode["bold"] "ta" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["eo"]["display"] "      - " AnsiCode["bold"] "eo" AnsiCode["no bold"] "  │ " \
            Locale["lt"]["display"] "         - " AnsiCode["bold"] "lt" AnsiCode["no bold"] " │ " \
            Locale["te"]["display"] "       - " AnsiCode["bold"] "te" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["es"]["display"] "        - " AnsiCode["bold"] "es" AnsiCode["no bold"] "  │ " \
            Locale["lv"]["display"] "         - " AnsiCode["bold"] "lv" AnsiCode["no bold"] " │ " \
            Locale["tg"]["display"] "      - " AnsiCode["bold"] "tg" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["et"]["display"] "          - " AnsiCode["bold"] "et" AnsiCode["no bold"] "  │ " \
            Locale["mg"]["display"] "         - " AnsiCode["bold"] "mg" AnsiCode["no bold"] " │ " \
            Locale["th"]["display"] "         - " AnsiCode["bold"] "th" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["eu"]["display"] "        - " AnsiCode["bold"] "eu" AnsiCode["no bold"] "  │ " \
            Locale["mi"]["display"] "            - " AnsiCode["bold"] "mi" AnsiCode["no bold"] " │ " \
            Locale["tl"]["display"] "     - " AnsiCode["bold"] "tl" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["fa"]["display"] "          - " AnsiCode["bold"] "fa" AnsiCode["no bold"] "  │ " \
            Locale["mk"]["display"] "       - " AnsiCode["bold"] "mk" AnsiCode["no bold"] " │ " \
            Locale["tr"]["display"] "      - " AnsiCode["bold"] "tr" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["fi"]["display"] "          - " AnsiCode["bold"] "fi" AnsiCode["no bold"] "  │ " \
            Locale["ml"]["display"] "           - " AnsiCode["bold"] "ml" AnsiCode["no bold"] " │ " \
            Locale["uk"]["display"] "  - " AnsiCode["bold"] "uk" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["fr"]["display"] "       - " AnsiCode["bold"] "fr" AnsiCode["no bold"] "  │ " \
            Locale["mn"]["display"] "           - " AnsiCode["bold"] "mn" AnsiCode["no bold"] " │ " \
            Locale["ur"]["display"] "        - " AnsiCode["bold"] "ur" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["ga"]["display"] "        - " AnsiCode["bold"] "ga" AnsiCode["no bold"] "  │ " \
            Locale["mr"]["display"] "            - " AnsiCode["bold"] "mr" AnsiCode["no bold"] " │ " \
            Locale["uz"]["display"] " - " AnsiCode["bold"] "uz" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["gl"]["display"] "         - " AnsiCode["bold"] "gl" AnsiCode["no bold"] "  │ " \
            Locale["ms"]["display"] "    - " AnsiCode["bold"] "ms" AnsiCode["no bold"] " │ " \
            Locale["vi"]["display"] "  - " AnsiCode["bold"] "vi" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["gu"]["display"] "         - " AnsiCode["bold"] "gu" AnsiCode["no bold"] "  │ " \
            Locale["mt"]["display"] "            - " AnsiCode["bold"] "mt" AnsiCode["no bold"] " │ " \
            Locale["yi"]["display"] "       - " AnsiCode["bold"] "yi" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["ha"]["display"] "          - " AnsiCode["bold"] "ha" AnsiCode["no bold"] "  │ " \
            Locale["my"]["display"] "          - " AnsiCode["bold"] "my" AnsiCode["no bold"] " │ " \
            Locale["yo"]["display"] "      - " AnsiCode["bold"] "yo" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["he"]["display"] "          - " AnsiCode["bold"] "he" AnsiCode["no bold"] "  │ " \
            Locale["ne"]["display"] "            - " AnsiCode["bold"] "ne" AnsiCode["no bold"] " │ " \
            Locale["zh-CN"]["display"] "    - " AnsiCode["bold"] "zh-CN" AnsiCode["no bold"] " │\n" \
            "│ " Locale["hi"]["display"] "          - " AnsiCode["bold"] "hi" AnsiCode["no bold"] "  │ " \
            Locale["nl"]["display"] "       - " AnsiCode["bold"] "nl" AnsiCode["no bold"] " │ " \
            Locale["zh-TW"]["display"] "    - " AnsiCode["bold"] "zh-TW" AnsiCode["no bold"] " │\n" \
            "│ " Locale["hmn"]["display"] "          - " AnsiCode["bold"] "hmn" AnsiCode["no bold"] " │ " \
            Locale["no"]["display"] "            - " AnsiCode["bold"] "no" AnsiCode["no bold"] " │ " \
            Locale["zu"]["display"] "     - " AnsiCode["bold"] "zu" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["hr"]["display"] "       - " AnsiCode["bold"] "hr" AnsiCode["no bold"] "  │ " \
            Locale["ny"]["display"] "           - " AnsiCode["bold"] "ny" AnsiCode["no bold"] " │ " \
            "                    │\n" \
            "│ " Locale["ht"]["display"] " - " AnsiCode["bold"] "ht" AnsiCode["no bold"] "  │ " \
            Locale["pa"]["display"] "            - " AnsiCode["bold"] "pa" AnsiCode["no bold"] " │ " \
            "                    │\n" \
            "└──────────────────────┴───────────────────────┴─────────────────────┘"
}

# Return help message as a string.
function getHelp() {
    return "Usage: " Command " [options] [source]:[target] [" AnsiCode["underline"] "text" AnsiCode["no underline"] "] ...\n" \
        "       " Command " [options] [source]:[target1]+[target2]+... [" AnsiCode["underline"] "text" AnsiCode["no underline"] "] ...\n\n" \
        "Options:\n" \
        "  " AnsiCode["bold"] "-V, -version" AnsiCode["no bold"] "\n    Print version and exit.\n" \
        "  " AnsiCode["bold"] "-H, -h, -help" AnsiCode["no bold"] "\n    Print this help message and exit.\n" \
        "  " AnsiCode["bold"] "-M, -m, -manual" AnsiCode["no bold"] "\n    Show the manual.\n" \
        "  " AnsiCode["bold"] "-r, -reference" AnsiCode["no bold"] "\n    Print a list of languages (displayed in endonyms) and their ISO 639 codes for reference, and exit.\n" \
        "  " AnsiCode["bold"] "-R, -reference-english" AnsiCode["no bold"] "\n    Print a list of languages (displayed in English names) and their ISO 639 codes for reference, and exit.\n" \
        "  " AnsiCode["bold"] "-v, -verbose" AnsiCode["no bold"] "\n    Verbose mode. (default)\n" \
        "  " AnsiCode["bold"] "-b, -brief" AnsiCode["no bold"] "\n    Brief mode.\n" \
        "  " AnsiCode["bold"] "-no-ansi" AnsiCode["no bold"] "\n    Don't use ANSI escape codes in the translation.\n" \
        "  " AnsiCode["bold"] "-w [num], -width [num]" AnsiCode["no bold"] "\n    Specify the screen width for padding when displaying right-to-left languages.\n" \
        "  " AnsiCode["bold"] "-browser [program]" AnsiCode["no bold"] "\n    Specify the web browser to use.\n" \
        "  " AnsiCode["bold"] "-p, -play" AnsiCode["no bold"] "\n    Listen to the translation.\n" \
        "  " AnsiCode["bold"] "-player [program]" AnsiCode["no bold"] "\n    Specify the command-line audio player to use, and listen to the translation.\n" \
        "  " AnsiCode["bold"] "-x [proxy], -proxy [proxy]" AnsiCode["no bold"] "\n    Use proxy on given port.\n" \
        "  " AnsiCode["bold"] "-I, -interactive" AnsiCode["no bold"] "\n    Start an interactive shell, invoking `rlwrap` whenever possible (unless `-no-rlwrap` is specified).\n" \
        "  " AnsiCode["bold"] "-no-rlwrap" AnsiCode["no bold"] "\n    Don't invoke `rlwrap` when starting an interactive shell with `-I`.\n" \
        "  " AnsiCode["bold"] "-E, -emacs" AnsiCode["no bold"] "\n    Start an interactive shell within GNU Emacs, invoking `emacs`.\n" \
        "  " AnsiCode["bold"] "-prompt [prompt_string]" AnsiCode["no bold"] "\n    Customize your prompt string in the interactive shell.\n" \
        "  " AnsiCode["bold"] "-prompt-color [color_code]" AnsiCode["no bold"] "\n    Customize your prompt color in the interactive shell.\n" \
        "  " AnsiCode["bold"] "-i [file], -input [file]" AnsiCode["no bold"] "\n    Specify the input file name.\n" \
        "  " AnsiCode["bold"] "-o [file], -output [file]" AnsiCode["no bold"] "\n    Specify the output file name.\n" \
        "  " AnsiCode["bold"] "-l [code], -lang [code]" AnsiCode["no bold"] "\n    Specify your own, native language (\"home/host language\").\n" \
        "  " AnsiCode["bold"] "-s [code], -source [code]" AnsiCode["no bold"] "\n    Specify the source language (language of the original text).\n" \
        "  " AnsiCode["bold"] "-t [codes], -target [codes]" AnsiCode["no bold"] "\n    Specify the target language(s) (language(s) of the translated text).\n" \
        "\nSee the man page " Command "(1) for more information."
}
####################################################################
# PLTokenizer.awk                                                  #
####################################################################

# Tokenize a string.
function plTokenize(returnTokens, string,
                    delimiters,
                    newlines,
                    quotes,
                    escapeChars,
                    leftBlockComments,
                    rightBlockComments,
                    lineComments,
                    reservedOperators,
                    reservedPatterns,
                    ####
                    blockCommenting,
                    c,
                    currentToken,
                    escaping,
                    i,
                    lineCommenting,
                    p,
                    quoting,
                    r,
                    s,
                    tempGroup,
                    tempPattern,
                    tempString) {
    # Default parameters
    if (!delimiters[0]) {
        delimiters[0] = " "  # whitespace
        delimiters[1] = "\t" # horizontal tab
        delimiters[2] = "\v" # vertical tab
    }
    if (!newlines[0]) {
        newlines[0] = "\n" # line feed
        newlines[1] = "\r" # carriage return
    }
    if (!quotes[0]) {
        quotes[0] = "\"" # double quote
    }
    if (!escapeChars[0]) {
        escapeChars[0] = "\\" # backslash
    }
    if (!leftBlockComments[0]) {
        leftBlockComments[0] = "#|" # Lisp-style extended comment (open)
        leftBlockComments[1] = "/*" # C-style comment (open)
        leftBlockComments[2] = "(*" # ML-style comment (open)
    }
    if (!rightBlockComments[0]) {
        rightBlockComments[0] = "|#" # Lisp-style extended comment (close)
        rightBlockComments[1] = "*/" # C-style comment (close)
        rightBlockComments[2] = "*)" # ML-style comment (close)
    }
    if (!lineComments[0]) {
        lineComments[0] = ";"  # Lisp-style line comment
        lineComments[1] = "//" # C++-style line comment
        lineComments[2] = "#"  # hash comment
    }
    if (!reservedOperators[0]) {
        reservedOperators[0] = "(" #  left parenthesis
        reservedOperators[1] = ")" # right parenthesis
        reservedOperators[2] = "[" #  left bracket
        reservedOperators[3] = "]" # right bracket
        reservedOperators[4] = "{" #  left brace
        reservedOperators[5] = "}" # right brace
        reservedOperators[6] = "," # comma
    }
    if (!reservedPatterns[0]) {
        reservedPatterns[0] = "[+-]?((0|[1-9][0-9]*)|[.][0-9]*|(0|[1-9][0-9]*)[.][0-9]*)([Ee][+-]?[0-9]+)?" # numeric literal (scientific notation possible)
        reservedPatterns[1] = "[+-]?0[0-7]+([.][0-7]*)?" # numeric literal (octal)
        reservedPatterns[2] = "[+-]?0[Xx][0-9A-Fa-f]+([.][0-9A-Fa-f]*)?" # numeric literal (hexadecimal)
    }

    split(string, s, "")
    currentToken = ""
    quoting = escaping = blockCommenting = lineCommenting = 0
    p = 0
    i = 1
    while (i <= length(s)) {
        c = s[i]
        r = substr(string, i)

        if (blockCommenting) {
            if (tempString = startsWithAny(r, rightBlockComments))
                blockCommenting = 0 # block comment ends

            i++

        } else if (lineCommenting) {
            if (belongsTo(c, newlines))
                lineCommenting = 0 # line comment ends

            i++

        } else if (quoting) {
            currentToken = currentToken c

            if (escaping) {
                escaping = 0 # escape ends

            } else {
                if (belongsTo(c, quotes)) {
                    # Finish the current token
                    if (currentToken) {
                        returnTokens[p++] = currentToken
                        currentToken = ""
                    }

                    quoting = 0 # quotation ends

                } else if (belongsTo(c, escapeChars)) {
                    escaping = 1 # escape begins

                } else {
                    # Continue
                }
            }

            i++

        } else {
            if (belongsTo(c, delimiters) || belongsTo(c, newlines)) {
                # Finish the current token
                if (currentToken) {
                    returnTokens[p++] = currentToken
                    currentToken = ""
                }

                i++

            } else if (belongsTo(c, quotes)) {
                # Finish the current token
                if (currentToken) {
                    returnTokens[p++] = currentToken
                }

                currentToken = c

                quoting = 1 # quotation begins

                i++

            } else if (tempString = startsWithAny(r, leftBlockComments)) {
                # Finish the current token
                if (currentToken) {
                    returnTokens[p++] = currentToken
                    currentToken = ""
                }

                blockCommenting = 1 # block comment begins

                i += length(tempString)

            } else if (tempString = startsWithAny(r, lineComments)) {
                # Finish the current token
                if (currentToken) {
                    returnTokens[p++] = currentToken
                    currentToken = ""
                }

                lineCommenting = 1 # line comment begins

                i += length(tempString)

            } else if (tempString = startsWithAny(r, reservedOperators)) {
                # Finish the current token
                if (currentToken) {
                    returnTokens[p++] = currentToken
                    currentToken = ""
                }

                # Reserve token
                returnTokens[p++] = tempString

                i += length(tempString)

            } else if (tempPattern = matchesAny(r, reservedPatterns)) {
                # Finish the current token
                if (currentToken) {
                    returnTokens[p++] = currentToken
                    currentToken = ""
                }

                # Reserve token
                match(r, "^" tempPattern, tempGroup)
                returnTokens[p++] = tempGroup[0]

                i += length(tempGroup[0])

            } else {
                # Continue with the current token
                currentToken = currentToken c

                i++
            }
        }
    }

    # Finish the last token
    if (currentToken)
        returnTokens[p++] = currentToken

}
####################################################################
# PLParser.awk                                                     #
####################################################################

# Parse a list of tokens and return an AST.
function plParse(returnAST, tokens,
                 leftBrackets,
                 rightBrackets,
                 separators,
                 ####
                 i, j, key, p, stack, token) {
    # Default parameters
    if (!leftBrackets[0]) {
        leftBrackets[0] = "(" # left parenthesis
        leftBrackets[1] = "[" # left bracket
        leftBrackets[2] = "{" # left brace
    }
    if (!rightBrackets[0]) {
        rightBrackets[0] = ")" # right parenthesis
        rightBrackets[1] = "]" # right bracket
        rightBrackets[2] = "}" # right brace
    }
    if (!separators[0]) {
        separators[0] = "," # comma
    }

    stack[p = 0] = 0
    for (i = 0; i < length(tokens); i++) {
        token = tokens[i]

        if (belongsTo(token, leftBrackets))
            stack[++p] = 0
        else if (belongsTo(token, rightBrackets))
            --p
        else if (belongsTo(token, separators))
            stack[p]++
        else {
            key = stack[0]
            for (j = 1; j <= p; j++)
                key = key SUBSEP stack[j]
            returnAST[key] = token
        }
    }
}
####################################################################
# Translate.awk                                                    #
####################################################################

# Detect external audio player (mplayer, mpv, mpg123).
function initAudioPlayer() {
    AudioPlayer = !system("mplayer >/dev/null 2>/dev/null") ?
        "mplayer" :
        (!system("mpv >/dev/null 2>/dev/null") ?
         "mpv" :
         (!system("mpg123 >/dev/null 2>/dev/null") ?
          "mpg123" :
          ""))
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
    url = HttpPathPrefix "/translate_a/single?client=t"                 \
        "&ie=UTF-8&oe=UTF-8"                                            \
        "&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&dt=at"  \
        "&q=" preprocess(text) "&sl=" sl "&tl=" tl "&hl=" hl

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
        d(content)
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
####################################################################
# Shell.awk                                                        #
####################################################################

# Detect external readline wrapper (rlwrap).
function initRlwrap() {
    Rlwrap = ("rlwrap --version 2>/dev/null" | getline) ? "rlwrap" : ""
}

# Prompt for interactive session.
function prompt(    i, p, temp) {
    p = Option["prompt"]

    # Format specifiers supported by strftime().
    # Roughly following ISO 8601:1988, with the notable exception of "%S", "%t" and "%T".
    # GNU libc extensions like "%l", "%s" and "%_*" are not supported.
    # See: <https://www.gnu.org/software/gawk/manual/html_node/Time-Functions.html>
    #      <http://pubs.opengroup.org/onlinepubs/007908799/xsh/strftime.html>
    if (p ~ /%a/) gsub(/%a/, strftime("%a"), p)
    if (p ~ /%A/) gsub(/%A/, strftime("%A"), p)
    if (p ~ /%b/) gsub(/%b/, strftime("%b"), p)
    if (p ~ /%B/) gsub(/%B/, strftime("%B"), p)
    if (p ~ /%c/) gsub(/%c/, strftime("%c"), p)
    if (p ~ /%C/) gsub(/%C/, strftime("%C"), p)
    if (p ~ /%d/) gsub(/%d/, strftime("%d"), p)
    if (p ~ /%D/) gsub(/%D/, strftime("%D"), p)
    if (p ~ /%e/) gsub(/%e/, strftime("%e"), p)
    if (p ~ /%F/) gsub(/%F/, strftime("%F"), p)
    if (p ~ /%g/) gsub(/%g/, strftime("%g"), p)
    if (p ~ /%G/) gsub(/%G/, strftime("%G"), p)
    if (p ~ /%h/) gsub(/%h/, strftime("%h"), p)
    if (p ~ /%H/) gsub(/%H/, strftime("%H"), p)
    if (p ~ /%I/) gsub(/%I/, strftime("%I"), p)
    if (p ~ /%j/) gsub(/%j/, strftime("%j"), p)
    if (p ~ /%m/) gsub(/%m/, strftime("%m"), p)
    if (p ~ /%M/) gsub(/%M/, strftime("%M"), p)
    if (p ~ /%n/) gsub(/%n/, strftime("%n"), p)
    if (p ~ /%p/) gsub(/%p/, strftime("%p"), p)
    if (p ~ /%r/) gsub(/%r/, strftime("%r"), p)
    if (p ~ /%R/) gsub(/%R/, strftime("%R"), p)
    if (p ~ /%u/) gsub(/%u/, strftime("%u"), p)
    if (p ~ /%U/) gsub(/%U/, strftime("%U"), p)
    if (p ~ /%V/) gsub(/%V/, strftime("%V"), p)
    if (p ~ /%w/) gsub(/%w/, strftime("%w"), p)
    if (p ~ /%W/) gsub(/%W/, strftime("%W"), p)
    if (p ~ /%x/) gsub(/%x/, strftime("%x"), p)
    if (p ~ /%X/) gsub(/%X/, strftime("%X"), p)
    if (p ~ /%y/) gsub(/%y/, strftime("%y"), p)
    if (p ~ /%Y/) gsub(/%Y/, strftime("%Y"), p)
    if (p ~ /%z/) gsub(/%z/, strftime("%z"), p)
    if (p ~ /%Z/) gsub(/%Z/, strftime("%Z"), p)

    # %_ : prompt message
    if (p ~ /%_/)
        gsub(/%_/, sprintf(Locale[getCode(Option["hl"])]["message"], ""), p)

    # %l : home language
    if (p ~ /%l/)
        gsub(/%l/, Locale[getCode(Option["hl"])]["display"], p)

    # %L : home language (English name)
    if (p ~ /%L/)
        gsub(/%L/, Locale[getCode(Option["hl"])]["name"], p)

    # %s : source language
    # 's' is the format-control character for string

    # %S : source language (English name)
    if (p ~ /%S/)
        gsub(/%S/, Locale[getCode(Option["sl"])]["name"], p)

    # %t : target languages, separated by "+"
    if (p ~ /%t/) {
        temp = Locale[getCode(Option["tl"][1])]["display"]
        for (i = 2; i <= length(Option["tl"]); i++)
            temp = temp "+" Locale[getCode(Option["tl"][i])]["display"]
        gsub(/%t/, temp, p)
    }

    # %T : target languages (English names), separated by "+"
    if (p ~ /%T/) {
        temp = Locale[getCode(Option["tl"][1])]["name"]
        for (i = 2; i <= length(Option["tl"]); i++)
            temp = temp "+" Locale[getCode(Option["tl"][i])]["name"]
        gsub(/%T/, temp, p)
    }

    # %, : target languages, separated by ","
    if (p ~ /%,/) {
        temp = Locale[getCode(Option["tl"][1])]["display"]
        for (i = 2; i <= length(Option["tl"]); i++)
            temp = temp "," Locale[getCode(Option["tl"][i])]["display"]
        gsub(/%,/, temp, p)
    }

    # %< : target languages (English names), separated by ","
    if (p ~ /%</) {
        temp = Locale[getCode(Option["tl"][1])]["name"]
        for (i = 2; i <= length(Option["tl"]); i++)
            temp = temp "," Locale[getCode(Option["tl"][i])]["name"]
        gsub(/%</, temp, p)
    }

    # %/ : target languages, separated by "/"
    if (p ~ /%\//) {
        temp = Locale[getCode(Option["tl"][1])]["display"]
        for (i = 2; i <= length(Option["tl"]); i++)
            temp = temp "/" Locale[getCode(Option["tl"][i])]["display"]
        gsub(/%\//, temp, p)
    }

    # %? : target languages (English names), separated by "/"
    if (p ~ /%\?/) {
        temp = Locale[getCode(Option["tl"][1])]["name"]
        for (i = 2; i <= length(Option["tl"]); i++)
            temp = temp "/" Locale[getCode(Option["tl"][i])]["name"]
        gsub(/%\?/, temp, p)
    }

    # %s : source language
    printf(AnsiCode["bold"] AnsiCode[tolower(Option["prompt-color"])] p AnsiCode[0] " ", Locale[getCode(Option["sl"])]["display"]) > "/dev/stderr"
}

####################################################################
# Main.awk                                                         #
####################################################################

# Detect gawk version.
function initGawk(    group) {
    Gawk = "gawk"
    GawkVersion = PROCINFO["version"]

    split(PROCINFO["version"], group, ".")
    if (group[1] < 4) {
        e("[ERROR] Oops! Your gawk (version " GawkVersion ") appears to be too old.\nYou need at least gawk 4.0.0 to run this program.")
        exit 1
    }
}

# Pre-initialization (before option parsing).
function preInit() {
    initGawk()          #<< AnsiCode

    # Languages
    initBiDi()
    initLocale()
    initLocaleDisplay() #<< Locale, BiDi
    initUserLang()      #<< Locale

    RS = "\n"

    ExitCode = 0

    Option["debug"] = 0

    Option["verbose"] = 1
    Option["width"] = ENVIRON["COLUMNS"] ? ENVIRON["COLUMNS"] : 64

    Option["browser"] = ENVIRON["BROWSER"]

    Option["play"] = 0
    Option["player"] = ENVIRON["PLAYER"]

    Option["proxy"] = ENVIRON["HTTP_PROXY"] ? ENVIRON["HTTP_PROXY"] : ENVIRON["http_proxy"]

    Option["interactive"] = 0
    Option["no-rlwrap"] = 0
    Option["emacs"] = 0
    Option["prompt"] = ENVIRON["TRANS_PS"] ? ENVIRON["TRANS_PS"] : "%s>"
    Option["prompt-color"] = ENVIRON["TRANS_PS_COLOR"] ? ENVIRON["TRANS_PS_COLOR"] : "default"

    Option["input"] = ""
    Option["output"] = "/dev/stdout"

    Option["hl"] = ENVIRON["HOME_LANG"] ? ENVIRON["HOME_LANG"] : UserLang
    Option["sl"] = ENVIRON["SOURCE_LANG"] ? ENVIRON["SOURCE_LANG"] : "auto"
    Option["tl"][1] = ENVIRON["TARGET_LANG"] ? ENVIRON["TARGET_LANG"] : UserLang
}

# Post-initialization (after option parsing).
function postInit() {
    # Translate
    initHttpService()
}

# Main entry point.
BEGIN {
    preInit()

    pos = 0
    while (ARGV[++pos]) {
        # -, -no-op
        match(ARGV[pos], /^-(-?no-op)?$/)
        if (RSTART) continue

        # -V, -version
        match(ARGV[pos], /^--?(vers(i(on?)?)?|V)$/)
        if (RSTART) {
            print getVersion()
            print
            printf("%-22s%s\n", "gawk (GNU Awk)", PROCINFO["version"])
            printf("%s\n", FriBidi ? FriBidi : "fribidi (GNU FriBidi) [NOT INSTALLED]")
            printf("%-22s%s\n", "User Language", Locale[getCode(UserLang)]["name"] " (" show(Locale[getCode(UserLang)]["endonym"]) ")")
            exit
        }

        # -H, -h, -help
        match(ARGV[pos], /^--?(h(e(lp?)?)?|H)$/)
        if (RSTART) {
            print getHelp()
            exit
        }

        # -M, -m, -manual
        match(ARGV[pos], /^--?(m(a(n(u(al?)?)?)?)?|M)$/)
        if (RSTART) {
            if (ENVIRON["TRANS_MANPAGE"])
                system("echo -E \"${TRANS_MANPAGE}\" | " \
                       "groff -Wall -mtty-char -mandoc -Tutf8 -rLL=${COLUMNS}n -rLT=${COLUMNS}n | " \
                       (system("most 2>/dev/null") ?
                        "less -s -P\"\\ \\Manual page " Command "(1) line %lt (press h for help or q to quit)\"" :
                        "most -Cs"))
            else
                print getHelp()
            exit
        }

        # -r, -reference
        match(ARGV[pos], /^--?r(e(f(e(r(e(n(ce?)?)?)?)?)?)?)?$/)
        if (RSTART) {
            print getReference("endonym")
            exit
        }

        # -R, -reference-english
        match(ARGV[pos], /^--?(reference-(e(n(g(l(i(sh?)?)?)?)?)?)?|R)$/)
        if (RSTART) {
            print getReference("name")
            exit
        }

        # -d, -debug
        match(ARGV[pos], /^--?d(e(b(ug?)?)?)?$/)
        if (RSTART) {
            Option["debug"] = 1
            continue
        }

        # -v, -verbose
        match(ARGV[pos], /^--?v(e(r(b(o(se?)?)?)?)?)?$/)
        if (RSTART) {
            Option["verbose"] = 1 # default value
            continue
        }

        # -b, -brief
        match(ARGV[pos], /^--?b(r(i(ef?)?)?)?$/)
        if (RSTART) {
            Option["verbose"] = 0
            continue
        }

        # -no-ansi
        match(ARGV[pos], /^--?no-ansi/)
        if (RSTART) {
            Option["no-ansi"] = 1
            continue
        }

        # -w [num], -width [num]
        match(ARGV[pos], /^--?w(i(d(th?)?)?)?(=(.*)?)?$/, group)
        if (RSTART) {
            Option["width"] = group[4] ?
                (group[5] ? group[5] : Option["width"]) :
                ARGV[++pos]
            continue
        }

        # -browser [program]
        match(ARGV[pos], /^--?browser(=(.*)?)?$/, group)
        if (RSTART) {
            Option["browser"] = group[1] ?
                (group[2] ? group[2] : Option["browser"]) :
                ARGV[++pos]
            continue
        }

        # -p, -play
        match(ARGV[pos], /^--?p(l(ay?)?)?$/)
        if (RSTART) {
            Option["play"] = 1
            continue
        }

        # -player [program]
        match(ARGV[pos], /^--?player(=(.*)?)?$/, group)
        if (RSTART) {
            Option["play"] = 1
            Option["player"] = group[1] ?
                (group[2] ? group[2] : Option["player"]) :
                ARGV[++pos]
            continue
        }

        # -x [proxy], -proxy [proxy]
        match(ARGV[pos], /^--?(proxy|x)(=(.*)?)?$/, group)
        if (RSTART) {
            Option["proxy"] = group[2] ?
                (group[3] ? group[3] : Option["proxy"]) :
                ARGV[++pos]
            continue
        }

        # -I, -interactive
        match(ARGV[pos], /^--?(int(e(r(a(c(t(i(ve?)?)?)?)?)?)?)?|I)$/)
        if (RSTART) {
            Option["interactive"] = 1
            continue
        }

        # -no-rlwrap
        match(ARGV[pos], /^--?no-rlwrap/)
        if (RSTART) {
            Option["no-rlwrap"] = 1
            continue
        }

        # -E, -emacs
        match(ARGV[pos], /^--?(emacs|E)$/)
        if (RSTART) {
            Option["emacs"] = 1
            continue
        }

        # -prompt [prompt_string]
        match(ARGV[pos], /^--?prompt(=(.*)?)?$/, group)
        if (RSTART) {
            Option["prompt"] = group[1] ?
                (group[2] ? group[2] : Option["prompt"]) :
                ARGV[++pos]
            continue
        }

        # -prompt-color [color_code]
        match(ARGV[pos], /^--?prompt-color(=(.*)?)?$/, group)
        if (RSTART) {
            Option["prompt-color"] = group[1] ?
                (group[2] ? group[2] : Option["prompt-color"]) :
                ARGV[++pos]
            continue
        }

        # -i [file], -input [file]
        match(ARGV[pos], /^--?i(n(p(ut?)?)?)?(=(.*)?)?$/, group)
        if (RSTART) {
            Option["input"] = group[4] ?
                (group[5] ? group[5] : Option["input"]) :
                ARGV[++pos]
            continue
        }

        # -o [file], -output [file]
        match(ARGV[pos], /^--?o(u(t(p(ut?)?)?)?)?(=(.*)?)?$/, group)
        if (RSTART) {
            Option["output"] = group[5] ?
                (group[6] ? group[6] : Option["output"]) :
                ARGV[++pos]
            continue
        }

        # -l [code], -lang [code]
        match(ARGV[pos], /^--?l(a(ng?)?)?(=(.*)?)?$/, group)
        if (RSTART) {
            Option["hl"] = group[3] ?
                (group[4] ? group[4] : Option["hl"]) :
                ARGV[++pos]
            continue
        }

        # -s [code], -source [code]
        match(ARGV[pos], /^--?s(o(u(r(ce?)?)?)?)?(=(.*)?)?$/, group)
        if (RSTART) {
            Option["sl"] = group[5] ?
                (group[6] ? group[6] : Option["sl"]) :
                ARGV[++pos]
            continue
        }

        # -t [codes], -target [codes]
        match(ARGV[pos], /^--?t(a(r(g(et?)?)?)?)?(=(.*)?)?$/, group)
        if (RSTART) {
            if (group[5]) {
                if (group[6]) split(group[6], Option["tl"], "+")
            } else
                split(ARGV[++pos], Option["tl"], "+")
            continue
        }

        # Shortcut format
        # '[code]:[code]+...' or '[code]=[code]+...'
        match(ARGV[pos], /^[{([]?([[:alpha:]][[:alpha:]][[:alpha:]]?(-[[:alpha:]][[:alpha:]])?)?(:|=)((@?[[:alpha:]][[:alpha:]][[:alpha:]]?(-[[:alpha:]][[:alpha:]])?\+)*(@?[[:alpha:]][[:alpha:]][[:alpha:]]?(-[[:alpha:]][[:alpha:]])?)?)[})\]]?$/, group)
        if (RSTART) {
            if (group[1]) Option["sl"] = group[1]
            if (group[4]) split(group[4], Option["tl"], "+")
            continue
        }

        # --
        match(ARGV[pos], /^--$/)
        if (RSTART) {
            ++pos # skip the end-of-options option
            break # no more option from here
        }

        break # no more option from here
    }

    # Option parsing finished
    postInit()

    if (Option["interactive"] && !Option["no-rlwrap"]) {
        # Interactive mode
        initRlwrap() # initialize Rlwrap

        if (Rlwrap && (ENVIRON["TRANS_PROGRAM"] || fileExists(EntryPoint))) {
            command = Rlwrap " " Gawk " " (ENVIRON["TRANS_PROGRAM"] ?
                                           "\"${TRANS_PROGRAM}\"" :
                                           "-f " EntryPoint) " -" \
                " -no-rlwrap" # be careful - never fork Rlwrap recursively!
            for (i = 1; i < length(ARGV); i++)
                if (ARGV[i])
                    command = command " " parameterize(ARGV[i])

            if (!system(command))
                exit # child process finished, exit
            else
                ; # skip
        } else
            ; # skip

    } else if (!Option["interactive"] && !Option["no-rlwrap"] && Option["emacs"]) {
        # Emacs interface
        Emacs = "emacs"

        if (ENVIRON["TRANS_PROGRAM"] || fileExists(EntryPoint)) {
            params = ""
            for (i = 1; i < length(ARGV); i++)
                if (ARGV[i])
                    params = params " " (parameterize(ARGV[i], "\""))
            if (ENVIRON["TRANS_PROGRAM"]) {
                el = "(progn (setq trans-program (getenv \"TRANS_PROGRAM\")) " \
                    "(setq explicit-shell-file-name \"" Gawk "\") " \
                    "(setq explicit-" Gawk "-args (cons trans-program '(\"-\" \"-I\" \"-no-rlwrap\"" params "))) " \
                    "(command-execute 'shell) (rename-buffer \"" Name "\"))"
            } else {
                el = "(progn (setq explicit-shell-file-name \"" Gawk "\") " \
                    "(setq explicit-" Gawk "-args '(\"-f\" \"" EntryPoint "\" \"--\" \"-I\" \"-no-rlwrap\"" params ")) " \
                    "(command-execute 'shell) (rename-buffer \"" Name "\"))"
            }
            command = Emacs " --eval " parameterize(el)

            if (!system(command))
                exit # child process finished, exit
            else
                Option["interactive"] = 1 # skip
        } else
            Option["interactive"] = 1 # skip
    }

    if (Option["play"]) {
        # Initialize audio player or speech synthesizer
        if (!Option["player"]) {
            initAudioPlayer()
            Option["player"] = AudioPlayer ? AudioPlayer : Option["player"]
            if (!Option["player"])
                initSpeechSynthesizer()
        }

        if (!Option["player"] && !SpeechSynthesizer) {
            w("[WARNING] No available audio player or speech synthesizer is found.")
            Option["play"] = 0
        }
    }

    if (Option["interactive"]) {
        print AnsiCode["bold"] AnsiCode[tolower(Option["prompt-color"])] getVersion() AnsiCode[0] > "/dev/stderr"
        print AnsiCode[tolower(Option["prompt-color"])] "(:q to quit)" AnsiCode[0] > "/dev/stderr"
    }

    # Initialize browser
    if (!Option["browser"]) {
        "xdg-mime query default text/html 2>/dev/null" |& getline Option["browser"]
        match(Option["browser"], "(.*).desktop$", group)
        Option["browser"] = group[1]
    }

    # Disable ANSI SGR (Select Graphic Rendition) codes if required
    if (Option["no-ansi"])
        delete AnsiCode

    if (pos < ARGC) {
        # More parameters

        # Translate the remaining parameters
        for (i = pos; i < ARGC; i++) {
            # Verbose mode: separator between sources
            if (Option["verbose"] && i > pos)
                print replicate("═", Option["width"])

            translate(ARGV[i], 1) # inline mode
        }

        # If input not specified, we're done
    } else {
        # No more parameter besides options

        # If input not specified, use stdin
        if (!Option["input"]) Option["input"] = "/dev/stdin"
    }

    # If input specified, start translating
    if (Option["input"])
        translateMain()

    exit ExitCode
}
