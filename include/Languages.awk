#!/usr/bin/gawk -f

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

    #14 Croatian
    Locale["hr"]["name"]       = "Croatian"
    Locale["hr"]["endonym"]    = "Hrvatski"
    Locale["hr"]["message"]    = "Prijevodi riječi ili izraza %s"

    #15 Czech
    Locale["cs"]["name"]       = "Czech"
    Locale["cs"]["endonym"]    = "Čeština"
    Locale["cs"]["message"]    = "Překlad výrazu %s"

    #16 Danish
    Locale["da"]["name"]       = "Danish"
    Locale["da"]["endonym"]    = "Dansk"
    Locale["da"]["message"]    = "Oversættelser af %s"

    #17 Dutch
    Locale["nl"]["name"]       = "Dutch"
    Locale["nl"]["endonym"]    = "Nederlands"
    Locale["nl"]["message"]    = "Vertalingen van %s"

    #18 English
    Locale["en"]["name"]       = "English"
    Locale["en"]["endonym"]    = "English"
    Locale["en"]["message"]    = "Translations of %s"

    #19 Esperanto
    Locale["eo"]["name"]       = "Esperanto"
    Locale["eo"]["endonym"]    = "Esperanto"
    Locale["eo"]["message"]    = "Tradukoj de %s"

    #20 Estonian
    Locale["et"]["name"]       = "Estonian"
    Locale["et"]["endonym"]    = "Eesti"
    Locale["et"]["message"]    = "Sõna(de) %s tõlked"

    #21 Filipino
    Locale["tl"]["name"]       = "Filipino"
    Locale["tl"]["endonym"]    = "Tagalog"
    Locale["tl"]["message"]    = "Mga pagsasalin ng %s"

    #22 Finnish
    Locale["fi"]["name"]       = "Finnish"
    Locale["fi"]["endonym"]    = "Suomi"
    Locale["fi"]["message"]    = "Käännökset tekstille %s"

    #23 French
    Locale["fr"]["name"]       = "French"
    Locale["fr"]["endonym"]    = "Français"
    Locale["fr"]["message"]    = "Traductions de %s"

    #24 Galician
    Locale["gl"]["name"]       = "Galician"
    Locale["gl"]["endonym"]    = "Galego"
    Locale["gl"]["message"]    = "Traducións de %s"

    #25 Georgian
    Locale["ka"]["name"]       = "Georgian"
    Locale["ka"]["endonym"]    = "ქართული"
    Locale["ka"]["message"]    = "%s-ის თარგმანები"

    #26 German
    Locale["de"]["name"]       = "German"
    Locale["de"]["endonym"]    = "Deutsch"
    Locale["de"]["message"]    = "Übersetzungen für %s"

    #27 Greek
    Locale["el"]["name"]       = "Greek"
    Locale["el"]["endonym"]    = "Ελληνικά"
    Locale["el"]["message"]    = "Μεταφράσεις του %s"

    #28 Gujarati
    Locale["gu"]["name"]       = "Gujarati"
    Locale["gu"]["endonym"]    = "ગુજરાતી"
    Locale["gu"]["message"]    = "%s ના અનુવાદ"

    #29 Haitian Creole
    Locale["ht"]["name"]       = "Haitian Creole"
    Locale["ht"]["endonym"]    = "Kreyòl Ayisyen"
    Locale["ht"]["message"]    = "Tradiksyon %s"

    #30 Hausa (Latin / Boko alphabet)
    Locale["ha"]["name"]       = "Hausa"
    Locale["ha"]["endonym"]    = "Hausa"
    Locale["ha"]["message"]    = "Fassarar %s"

    #31 Hebrew
    Locale["he"]["name"]       = "Hebrew"
    Locale["he"]["endonym"]    = "עִבְרִית"
    Locale["he"]["message"]    = "תרגומים של %s"
    Locale["he"]["rtl"]        = "true" # RTL language

    #32 Hindi
    Locale["hi"]["name"]       = "Hindi"
    Locale["hi"]["endonym"]    = "हिन्दी"
    Locale["hi"]["message"]    = "%s के अनुवाद"

    #33 Hmong
    Locale["hmn"]["name"]      = "Hmong"
    Locale["hmn"]["endonym"]   = "Hmoob"
    Locale["hmn"]["message"]   = "Lus txhais: %s"

    #34 Hungarian
    Locale["hu"]["name"]       = "Hungarian"
    Locale["hu"]["endonym"]    = "Magyar"
    Locale["hu"]["message"]    = "%s fordításai"

    #35 Icelandic
    Locale["is"]["name"]       = "Icelandic"
    Locale["is"]["endonym"]    = "Íslenska"
    Locale["is"]["message"]    = "Þýðingar á %s"

    #36 Igbo
    Locale["ig"]["name"]       = "Igbo"
    Locale["ig"]["endonym"]    = "Igbo"
    Locale["ig"]["message"]    = "Ntụgharị asụsụ nke %s"

    #37 Indonesian
    Locale["id"]["name"]       = "Indonesian"
    Locale["id"]["endonym"]    = "Bahasa Indonesia"
    Locale["id"]["message"]    = "Terjemahan dari %s"

    #38 Irish
    Locale["ga"]["name"]       = "Irish"
    Locale["ga"]["endonym"]    = "Gaeilge"
    Locale["ga"]["message"]    = "Aistriúcháin ar %s"

    #39 Italian
    Locale["it"]["name"]       = "Italian"
    Locale["it"]["endonym"]    = "Italiano"
    Locale["it"]["message"]    = "Traduzioni di %s"

    #40 Japanese
    Locale["ja"]["name"]       = "Japanese"
    Locale["ja"]["endonym"]    = "日本語"
    Locale["ja"]["message"]    = "「%s」の翻訳"

    #41 Javanese (Latin alphabet)
    Locale["jv"]["name"]       = "Javanese"
    Locale["jv"]["endonym"]    = "Basa Jawa"
    Locale["jv"]["message"]    = "Terjemahan"

    #42 Kannada
    Locale["kn"]["name"]       = "Kannada"
    Locale["kn"]["endonym"]    = "ಕನ್ನಡ"
    Locale["kn"]["message"]    = "%s ನ ಅನುವಾದಗಳು"

    #43 Khmer (Central Khmer)
    Locale["km"]["name"]       = "Khmer"
    Locale["km"]["endonym"]    = "ភាសាខ្មែរ"
    Locale["km"]["message"]    = "ការ​បក​ប្រែ​នៃ %s"

    #44 Korean
    Locale["ko"]["name"]       = "Korean"
    Locale["ko"]["endonym"]    = "한국어"
    Locale["ko"]["message"]    = "%s의 번역"

    #45 Lao
    Locale["lo"]["name"]       = "Lao"
    Locale["lo"]["endonym"]    = "ລາວ"
    Locale["lo"]["message"]    = "ການ​ແປ​ພາ​ສາ​ຂອງ %s"

    #46 Latin
    Locale["la"]["name"]       = "Latin"
    Locale["la"]["endonym"]    = "Latina"
    Locale["la"]["message"]    = "Versio de %s"

    #47 Latvian
    Locale["lv"]["name"]       = "Latvian"
    Locale["lv"]["endonym"]    = "Latviešu"
    Locale["lv"]["message"]    = "%s tulkojumi"

    #48 Lithuanian
    Locale["lt"]["name"]       = "Lithuanian"
    Locale["lt"]["endonym"]    = "Lietuvių"
    Locale["lt"]["message"]    = "„%s“ vertimai"

    #49 Macedonian
    Locale["mk"]["name"]       = "Macedonian"
    Locale["mk"]["endonym"]    = "Македонски"
    Locale["mk"]["message"]    = "Преводи на %s"

    #50 Malay
    Locale["ms"]["name"]       = "Malay"
    Locale["ms"]["endonym"]    = "Bahasa Melayu"
    Locale["ms"]["message"]    = "Terjemahan %s"

    #51 Maltese
    Locale["mt"]["name"]       = "Maltese"
    Locale["mt"]["endonym"]    = "Malti"
    Locale["mt"]["message"]    = "Traduzzjonijiet ta' %s"

    #52 Maori
    Locale["mi"]["name"]       = "Maori"
    Locale["mi"]["endonym"]    = "Māori"
    Locale["mi"]["message"]    = "Ngā whakamāoritanga o %s"

    #53 Marathi
    Locale["mr"]["name"]       = "Marathi"
    Locale["mr"]["endonym"]    = "मराठी"
    Locale["mr"]["message"]    = "%s ची भाषांतरे"

    #54 Mongolian (Cyrillic alphabet)
    Locale["mn"]["name"]       = "Mongolian"
    Locale["mn"]["endonym"]    = "Монгол"
    Locale["mn"]["message"]    = "%s-н орчуулга"

    #55 Nepali
    Locale["ne"]["name"]       = "Nepali"
    Locale["ne"]["endonym"]    = "नेपाली"
    Locale["ne"]["message"]    = "%sका अनुवाद"

    #56 Norwegian
    Locale["no"]["name"]       = "Norwegian"
    Locale["no"]["endonym"]    = "Norsk"
    Locale["no"]["message"]    = "Oversettelser av %s"

    #57 Persian
    Locale["fa"]["name"]       = "Persian"
    Locale["fa"]["endonym"]    = "فارسی"
    Locale["fa"]["message"]    = "ترجمه‌های %s"
    Locale["fa"]["rtl"]        = "true" # RTL language

    #58 Punjabi (Brahmic / Gurmukhī alphabet)
    Locale["pa"]["name"]       = "Punjabi"
    Locale["pa"]["endonym"]    = "ਪੰਜਾਬੀ"
    Locale["pa"]["message"]    = "ਦੇ ਅਨੁਵਾਦ%s"

    #59 Polish
    Locale["pl"]["name"]       = "Polish"
    Locale["pl"]["endonym"]    = "Polski"
    Locale["pl"]["message"]    = "Tłumaczenia %s"

    #60 Portuguese
    Locale["pt"]["name"]       = "Portuguese"
    Locale["pt"]["endonym"]    = "Português"
    Locale["pt"]["message"]    = "Traduções de %s"

    #61 Romanian
    Locale["ro"]["name"]       = "Romanian"
    Locale["ro"]["endonym"]    = "Română"
    Locale["ro"]["message"]    = "Traduceri pentru %s"

    #62 Russian
    Locale["ru"]["name"]       = "Russian"
    Locale["ru"]["endonym"]    = "Русский"
    Locale["ru"]["message"]    = "%s: варианты перевода"

    #63 Serbian (Cyrillic alphabet)
    Locale["sr"]["name"]       = "Serbian"
    Locale["sr"]["endonym"]    = "српски"
    Locale["sr"]["message"]    = "Преводи за „%s“"

    #64 Slovak
    Locale["sk"]["name"]       = "Slovak"
    Locale["sk"]["endonym"]    = "Slovenčina"
    Locale["sk"]["message"]    = "Preklady výrazu: %s"

    #65 Slovenian
    Locale["sl"]["name"]       = "Slovenian"
    Locale["sl"]["endonym"]    = "Slovenščina"
    Locale["sl"]["message"]    = "Prevodi za %s"

    #66 Somali
    Locale["so"]["name"]       = "Somali"
    Locale["so"]["endonym"]    = "Soomaali"
    Locale["so"]["message"]    = "Turjumaada %s"

    #67 Spanish
    Locale["es"]["name"]       = "Spanish"
    Locale["es"]["endonym"]    = "Español"
    Locale["es"]["message"]    = "Traducciones de %s"

    #68 Swahili
    Locale["sw"]["name"]       = "Swahili"
    Locale["sw"]["endonym"]    = "Kiswahili"
    Locale["sw"]["message"]    = "Tafsiri ya %s"

    #69 Swedish
    Locale["sv"]["name"]       = "Swedish"
    Locale["sv"]["endonym"]    = "Svenska"
    Locale["sv"]["message"]    = "Översättningar av %s"

    #70 Tamil
    Locale["ta"]["name"]       = "Tamil"
    Locale["ta"]["endonym"]    = "தமிழ்"
    Locale["ta"]["message"]    = "%s இன் மொழிபெயர்ப்புகள்"

    #71 Telugu
    Locale["te"]["name"]       = "Telugu"
    Locale["te"]["endonym"]    = "తెలుగు"
    Locale["te"]["message"]    = "%s యొక్క అనువాదాలు"

    #72 Thai
    Locale["th"]["name"]       = "Thai"
    Locale["th"]["endonym"]    = "ไทย"
    Locale["th"]["message"]    = "คำแปลของ %s"

    #73 Turkish
    Locale["tr"]["name"]       = "Turkish"
    Locale["tr"]["endonym"]    = "Türkçe"
    Locale["tr"]["message"]    = "%s çevirileri"

    #74 Ukrainian
    Locale["uk"]["name"]       = "Ukrainian"
    Locale["uk"]["endonym"]    = "Українська"
    Locale["uk"]["message"]    = "Переклади слова або виразу \"%s\""

    #75 Urdu
    Locale["ur"]["name"]       = "Urdu"
    Locale["ur"]["endonym"]    = "اُردُو"
    Locale["ur"]["message"]    = "کے ترجمے %s"
    Locale["ur"]["rtl"]        = "true" # RTL language

    #76 Vietnamese
    Locale["vi"]["name"]       = "Vietnamese"
    Locale["vi"]["endonym"]    = "Tiếng Việt"
    Locale["vi"]["message"]    = "Bản dịch của %s"

    #77 Welsh
    Locale["cy"]["name"]       = "Welsh"
    Locale["cy"]["endonym"]    = "Cymraeg"
    Locale["cy"]["message"]    = "Cyfieithiadau %s"

    #78 Yiddish
    Locale["yi"]["name"]       = "Yiddish"
    Locale["yi"]["endonym"]    = "ייִדיש"
    Locale["yi"]["message"]    = "איבערזעצונגען פון %s"
    Locale["yi"]["rtl"]        = "true" # RTL language

    #79 Yoruba
    Locale["yo"]["name"]       = "Yoruba"
    Locale["yo"]["endonym"]    = "Yorùbá"
    Locale["yo"]["message"]    = "Awọn itumọ ti %s"

    #80 Zulu
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
    BiDi = FriBidi ? "fribidi --width %s" : "rev | xargs printf '%%ss\n'"
}

# Return the single-quoted string.
function parameterize(text) {
    gsub(/'/, "'\\''", text)
    return "'" text "'"
}

# Convert a logical string to visual; don't right justify RTL lines.
# Parameters:
#     code: ignore to apply bidirectional algorithm on every string
function show(text, code,    temp) {
    if (!code || Locale[getCode(code)]["rtl"]) {
        if (Cache[text][0])
            return Cache[text][0]
        else {
            ("echo " parameterize(text) " | " BiDiNoPad) | getline temp
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
            ("echo " parameterize(text) " | " sprintf(BiDi, width)) | getline temp
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
    UserLang = ENVIRON["LANG"] ? parseLang(ENVIRON["LANG"]) : "en"

    if (!(ENVIRON["LANG"] ~ /UTF-8$/))
        w("[WARNING] Your codeset of locale (" ENVIRON["LANG"] ") is not UTF-8. You have been warned.")
}
