####################################################################
# Languages.awk                                                    #
####################################################################

# Initialize all locales supported on Google Translate.
# Mostly ISO 639-1 codes, with a few ISO 639-3 codes.
# "family" : Language family (from Glottolog)
# "iso"    : ISO 639-3 code
# "glotto" : Glottocode
# "script" : Writing system (ISO 15924 script code)
# See: <https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes>
#      <https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes>
#      <https://en.wikipedia.org/wiki/ISO_15924#List_of_codes>
#      <http://glottolog.org/>
function initLocale(    i) {

    # Amharic
    Locale["am"]["name"]               = "Amharic"
    Locale["am"]["endonym"]            = "አማርኛ"
    Locale["am"]["translations-of"]    = "የ %s ትርጉሞች"
    Locale["am"]["definitions-of"]     = "የ %s ቃላት ፍችዎች"
    Locale["am"]["synonyms"]           = "ተመሳሳይ ቃላት"
    Locale["am"]["examples"]           = "ምሳሌዎች"
    Locale["am"]["see-also"]           = "የሚከተለውንም ይመልከቱ"
    Locale["am"]["family"]             = "Afro-Asiatic"
    Locale["am"]["iso"]                = "amh"
    Locale["am"]["glotto"]             = "amha1245"
    Locale["am"]["script"]             = "Ethi"

    #? Assamese
    Locale["as"]["support"]            = "unstable"
    Locale["as"]["name"]               = "Assamese"
    Locale["as"]["endonym"]            = "অসমীয়া"
    #Locale["as"]["translations-of"]
    #Locale["as"]["definitions-of"]
    #Locale["as"]["synonyms"]
    #Locale["as"]["examples"]
    #Locale["as"]["see-also"]
    Locale["as"]["family"]             = "Indo-European"
    Locale["as"]["iso"]                = "asm"
    Locale["as"]["glotto"]             = "assa1263"
    Locale["as"]["script"]             = "Beng"

    #? Bashkir
    Locale["ba"]["support"]            = "unstable"
    Locale["ba"]["name"]               = "Bashkir"
    Locale["ba"]["endonym"]            = "башҡорт теле"
    #Locale["ba"]["translations-of"]
    #Locale["ba"]["definitions-of"]
    #Locale["ba"]["synonyms"]
    #Locale["ba"]["examples"]
    #Locale["ba"]["see-also"]
    Locale["ba"]["family"]             = "Turkic"
    Locale["ba"]["iso"]                = "bak"
    Locale["ba"]["glotto"]             = "bash1264"
    Locale["ba"]["script"]             = "Cyrl"

    #? Breton
    Locale["br"]["support"]            = "unstable"
    Locale["br"]["name"]               = "Breton"
    Locale["br"]["endonym"]            = "Brezhoneg"
    #Locale["br"]["translations-of"]
    #Locale["br"]["definitions-of"]
    #Locale["br"]["synonyms"]
    #Locale["br"]["examples"]
    #Locale["br"]["see-also"]
    Locale["br"]["family"]             = "Indo-European"
    Locale["br"]["iso"]                = "bre"
    Locale["br"]["glotto"]             = "bret1244"
    Locale["br"]["script"]             = "Latn"

    # Corsican
    Locale["co"]["name"]               = "Corsican"
    Locale["co"]["endonym"]            = "Corsu"
    Locale["co"]["translations-of"]    = "Traductions de %s"
    Locale["co"]["definitions-of"]     = "Définitions de %s"
    Locale["co"]["synonyms"]           = "Synonymes"
    Locale["co"]["examples"]           = "Exemples"
    Locale["co"]["see-also"]           = "Voir aussi"
    Locale["co"]["family"]             = "Indo-European"
    Locale["co"]["iso"]                = "cos"
    Locale["co"]["glotto"]             = "cors1242"
    Locale["co"]["script"]             = "Latn"

    #? Dzongkha
    Locale["dz"]["support"]            = "unstable"
    Locale["dz"]["name"]               = "Dzongkha"
    Locale["dz"]["endonym"]            = "རྫོང་ཁ"
    #Locale["dz"]["translations-of"]
    #Locale["dz"]["definitions-of"]
    #Locale["dz"]["synonyms"]
    #Locale["dz"]["examples"]
    #Locale["dz"]["see-also"]
    Locale["dz"]["family"]             = "Sino-Tibetan"
    Locale["dz"]["iso"]                = "dzo"
    Locale["dz"]["glotto"]             = "nucl1307"
    Locale["dz"]["script"]             = "Tibt"

    #? Faroese
    Locale["fo"]["support"]            = "unstable"
    Locale["fo"]["name"]               = "Faroese"
    Locale["fo"]["endonym"]            = "Føroyskt"
    #Locale["fo"]["translations-of"]
    #Locale["fo"]["definitions-of"]
    #Locale["fo"]["synonyms"]
    #Locale["fo"]["examples"]
    #Locale["fo"]["see-also"]
    Locale["fo"]["family"]             = "Indo-European"
    Locale["fo"]["iso"]                = "fao"
    Locale["fo"]["glotto"]             = "faro1244"
    Locale["fo"]["script"]             = "Latn"

    #? Fijian
    Locale["fj"]["support"]            = "unstable"
    Locale["fj"]["name"]               = "Fijian"
    Locale["fj"]["endonym"]            = "Vosa Vakaviti"
    #Locale["fj"]["translations-of"]
    #Locale["fj"]["definitions-of"]
    #Locale["fj"]["synonyms"]
    #Locale["fj"]["examples"]
    #Locale["fj"]["see-also"]
    Locale["fj"]["family"]             = "Austronesian"
    Locale["fj"]["iso"]                = "fij"
    Locale["fj"]["glotto"]             = "fiji1243"
    Locale["fj"]["script"]             = "Latn"

    #? Guarani
    Locale["gn"]["support"]            = "unstable"
    Locale["gn"]["name"]               = "Guarani"
    Locale["gn"]["endonym"]            = "Avañe'ẽ"
    #Locale["gn"]["translations-of"]
    #Locale["gn"]["definitions-of"]
    #Locale["gn"]["synonyms"]
    #Locale["gn"]["examples"]
    #Locale["gn"]["see-also"]
    Locale["gn"]["family"]             = "Tupian"
    Locale["gn"]["iso"]                = "grn"
    Locale["gn"]["glotto"]             = "para1311"
    Locale["gn"]["script"]             = "Latn"

    #? Interlingue
    Locale["ie"]["support"]            = "unstable"
    Locale["ie"]["name"]               = "Interlingue"
    Locale["ie"]["endonym"]            = "Interlingue"
    #Locale["ie"]["translations-of"]
    #Locale["ie"]["definitions-of"]
    #Locale["ie"]["synonyms"]
    #Locale["ie"]["examples"]
    #Locale["ie"]["see-also"]
    Locale["ie"]["family"]             = "Artificial Language"
    Locale["ie"]["iso"]                = "ile"
    Locale["ie"]["glotto"]             = "occi1241"
    Locale["ie"]["script"]             = "Latn"

    #? Kinyarwanda
    Locale["rw"]["support"]            = "unstable"
    Locale["rw"]["name"]               = "Kinyarwanda"
    Locale["rw"]["endonym"]            = "Ikinyarwanda"
    #Locale["rw"]["translations-of"]
    #Locale["rw"]["definitions-of"]
    #Locale["rw"]["synonyms"]
    #Locale["rw"]["examples"]
    #Locale["rw"]["see-also"]
    Locale["rw"]["family"]             = "Atlantic-Congo"
    Locale["rw"]["iso"]                = "kin"
    Locale["rw"]["glotto"]             = "kiny1244"
    Locale["rw"]["script"]             = "Latn"

    # Kyrgyz
    Locale["ky"]["name"]               = "Kyrgyz"
    Locale["ky"]["endonym"]            = "Кыргызча"
    Locale["ky"]["translations-of"]    = "%s котормосу"
    Locale["ky"]["definitions-of"]     = "%s аныктамасы"
    Locale["ky"]["synonyms"]           = "Синонимдер"
    Locale["ky"]["examples"]           = "Мисалдар"
    Locale["ky"]["see-also"]           = "Дагы караңыз"
    Locale["ky"]["family"]             = "Turkic"
    Locale["ky"]["iso"]                = "kir"
    Locale["ky"]["glotto"]             = "kirg1245"
    Locale["ky"]["script"]             = "Cyrl"

    #? Kurdish (Central Kurdish, Sorani), Latin alphabet
    Locale["ku"]["support"]            = "unstable"
    Locale["ku"]["name"]               = "Kurdish"
    Locale["ku"]["endonym"]            = "Kurdî"
    #Locale["ku"]["translations-of"]
    #Locale["ku"]["definitions-of"]
    #Locale["ku"]["synonyms"]
    #Locale["ku"]["examples"]
    #Locale["ku"]["see-also"]
    Locale["ku"]["family"]             = "Indo-European"
    Locale["ku"]["iso"]                = "kur"
    Locale["ku"]["glotto"]             = "kurd1259"
    Locale["ku"]["script"]             = "Latn"

    #? Luxembourgish
    Locale["lb"]["support"]            = "unstable"
    Locale["lb"]["name"]               = "Luxembourgish"
    Locale["lb"]["endonym"]            = "Lëtzebuergesch"
    #Locale["lb"]["translations-of"]
    #Locale["lb"]["definitions-of"]
    #Locale["lb"]["synonyms"]
    #Locale["lb"]["examples"]
    #Locale["lb"]["see-also"]
    Locale["lb"]["family"]             = "Indo-European"
    Locale["lb"]["iso"]                = "ltz"
    Locale["lb"]["glotto"]             = "luxe1241"
    Locale["lb"]["script"]             = "Latn"

    #? Occitan
    Locale["oc"]["support"]            = "unstable"
    Locale["oc"]["name"]               = "Occitan"
    Locale["oc"]["endonym"]            = "Occitan"
    #Locale["oc"]["translations-of"]
    #Locale["oc"]["definitions-of"]
    #Locale["oc"]["synonyms"]
    #Locale["oc"]["examples"]
    #Locale["oc"]["see-also"]
    Locale["oc"]["family"]             = "Indo-European"
    Locale["oc"]["iso"]                = "oci"
    Locale["oc"]["glotto"]             = "occi1239"
    Locale["oc"]["script"]             = "Latn"

    #? Oromo
    Locale["om"]["support"]            = "unstable"
    Locale["om"]["name"]               = "Oromo"
    Locale["om"]["endonym"]            = "Afaan Oromoo"
    #Locale["om"]["translations-of"]
    #Locale["om"]["definitions-of"]
    #Locale["om"]["synonyms"]
    #Locale["om"]["examples"]
    #Locale["om"]["see-also"]
    Locale["om"]["family"]             = "Afro-Asiatic"
    Locale["om"]["iso"]                = "orm"
    Locale["om"]["glotto"]             = "nucl1736"
    Locale["om"]["script"]             = "Latn"

    #? Oriya
    Locale["or"]["support"]            = "unstable"
    Locale["or"]["name"]               = "Oriya"
    Locale["or"]["endonym"]            = "ଓଡ଼ିଆ"
    #Locale["or"]["translations-of"]
    #Locale["or"]["definitions-of"]
    #Locale["or"]["synonyms"]
    #Locale["or"]["examples"]
    #Locale["or"]["see-also"]
    Locale["or"]["family"]             = "Indo-European"
    Locale["or"]["iso"]                = "ori"
    Locale["or"]["glotto"]             = "macr1269"
    Locale["or"]["script"]             = "Orya"

    #? Pashto
    Locale["ps"]["support"]            = "unstable"
    Locale["ps"]["name"]               = "Pashto"
    Locale["ps"]["endonym"]            = "پښتو"
    #Locale["ps"]["translations-of"]
    #Locale["ps"]["definitions-of"]
    #Locale["ps"]["synonyms"]
    #Locale["ps"]["examples"]
    #Locale["ps"]["see-also"]
    Locale["ps"]["family"]             = "Indo-European"
    Locale["ps"]["iso"]                = "pus"
    Locale["ps"]["glotto"]             = "pash1269"
    Locale["ps"]["script"]             = "Arab"
    Locale["ps"]["rtl"]                = "true" # RTL language

    #? Romansh
    Locale["rm"]["support"]            = "unstable"
    Locale["rm"]["name"]               = "Romansh"
    Locale["rm"]["endonym"]            = "Rumantsch"
    #Locale["rm"]["translations-of"]
    #Locale["rm"]["definitions-of"]
    #Locale["rm"]["synonyms"]
    #Locale["rm"]["examples"]
    #Locale["rm"]["see-also"]
    Locale["rm"]["family"]             = "Indo-European"
    Locale["rm"]["iso"]                = "roh"
    Locale["rm"]["glotto"]             = "roma1326"
    Locale["rm"]["script"]             = "Latn"

    #? Sindhi
    Locale["sd"]["support"]            = "unstable"
    Locale["sd"]["name"]               = "Sindhi"
    Locale["sd"]["endonym"]            = "سنڌي"
    #Locale["sd"]["translations-of"]
    #Locale["sd"]["definitions-of"]
    #Locale["sd"]["synonyms"]
    #Locale["sd"]["examples"]
    #Locale["sd"]["see-also"]
    Locale["sd"]["family"]             = "Indo-European"
    Locale["sd"]["iso"]                = "snd"
    Locale["sd"]["glotto"]             = "sind1272"
    Locale["sd"]["script"]             = "Arab"
    Locale["sd"]["rtl"]                = "true" # RTL language

    #? Samoan
    Locale["sm"]["support"]            = "unstable"
    Locale["sm"]["name"]               = "Samoan"
    Locale["sm"]["endonym"]            = "Gagana Sāmoa"
    #Locale["sm"]["translations-of"]
    #Locale["sm"]["definitions-of"]
    #Locale["sm"]["synonyms"]
    #Locale["sm"]["examples"]
    #Locale["sm"]["see-also"]
    Locale["sm"]["family"]             = "Austronesian"
    Locale["sm"]["iso"]                = "smo"
    Locale["sm"]["glotto"]             = "samo1305"
    Locale["sm"]["script"]             = "Latn"

    #? Scottish Gaelic
    Locale["gd"]["support"]            = "unstable"
    Locale["gd"]["name"]               = "Scottish Gaelic"
    Locale["gd"]["endonym"]            = "Gàidhlig"
    #Locale["gd"]["translations-of"]
    #Locale["gd"]["definitions-of"]
    #Locale["gd"]["synonyms"]
    #Locale["gd"]["examples"]
    #Locale["gd"]["see-also"]
    Locale["gd"]["family"]             = "Indo-European"
    Locale["gd"]["iso"]                = "gla"
    Locale["gd"]["glotto"]             = "scot1245"
    Locale["gd"]["script"]             = "Latn"

    #? Shona
    Locale["sn"]["support"]            = "unstable"
    Locale["sn"]["name"]               = "Shona"
    Locale["sn"]["endonym"]            = "chiShona"
    #Locale["sn"]["translations-of"]
    #Locale["sn"]["definitions-of"]
    #Locale["sn"]["synonyms"]
    #Locale["sn"]["examples"]
    #Locale["sn"]["see-also"]
    Locale["sn"]["family"]             = "Atlantic-Congo"
    Locale["sn"]["iso"]                = "sna"
    Locale["sn"]["glotto"]             = "core1255"
    Locale["sn"]["script"]             = "Latn"

    #? Tigrinya
    Locale["ti"]["support"]            = "unstable"
    Locale["ti"]["name"]               = "Tigrinya"
    Locale["ti"]["endonym"]            = "ትግርኛ"
    #Locale["ti"]["translations-of"]
    #Locale["ti"]["definitions-of"]
    #Locale["ti"]["synonyms"]
    #Locale["ti"]["examples"]
    #Locale["ti"]["see-also"]
    Locale["ti"]["family"]             = "Afro-Asiatic"
    Locale["ti"]["iso"]                = "tir"
    Locale["ti"]["glotto"]             = "tigr1271"
    Locale["ti"]["script"]             = "Ethi"

    #? Tibetan (Standard Tibetan)
    Locale["bo"]["support"]            = "unstable"
    Locale["bo"]["name"]               = "Tibetan"
    Locale["bo"]["endonym"]            = "བོད་ཡིག"
    #Locale["bo"]["translations-of"]
    #Locale["bo"]["definitions-of"]
    #Locale["bo"]["synonyms"]
    #Locale["bo"]["examples"]
    #Locale["bo"]["see-also"]
    Locale["bo"]["family"]             = "Sino-Tibetan"
    Locale["bo"]["iso"]                = "bod"
    Locale["bo"]["glotto"]             = "tibe1272"
    Locale["bo"]["script"]             = "Tibt"

    #? Turkmen
    Locale["tk"]["support"]            = "unstable"
    Locale["tk"]["name"]               = "Turkmen"
    Locale["tk"]["endonym"]            = "Türkmen"
    #Locale["tk"]["translations-of"]
    #Locale["tk"]["definitions-of"]
    #Locale["tk"]["synonyms"]
    #Locale["tk"]["examples"]
    #Locale["tk"]["see-also"]
    Locale["tk"]["family"]             = "Turkic"
    Locale["tk"]["iso"]                = "tuk"
    Locale["tk"]["glotto"]             = "turk1304"
    Locale["tk"]["script"]             = "Latn"

    #? Tatar
    Locale["tt"]["support"]            = "yandex-only"
    Locale["tt"]["name"]               = "Tatar"
    Locale["tt"]["endonym"]            = "татарча"
    #Locale["tt"]["translations-of"]
    #Locale["tt"]["definitions-of"]
    #Locale["tt"]["synonyms"]
    #Locale["tt"]["examples"]
    #Locale["tt"]["see-also"]
    Locale["tt"]["family"]             = "Turkic"
    Locale["tt"]["iso"]                = "tat"
    Locale["tt"]["glotto"]             = "tata1255"
    Locale["tt"]["script"]             = "Cyrl"

    #? Uyghur
    Locale["ug"]["support"]            = "unstable"
    Locale["ug"]["name"]               = "Uyghur"
    Locale["ug"]["endonym"]            = "ئۇيغۇر تىلى"
    #Locale["ug"]["translations-of"]
    #Locale["ug"]["definitions-of"]
    #Locale["ug"]["synonyms"]
    #Locale["ug"]["examples"]
    #Locale["ug"]["see-also"]
    Locale["ug"]["family"]             = "Turkic"
    Locale["ug"]["iso"]                = "uig"
    Locale["ug"]["glotto"]             = "uigh1240"
    Locale["ug"]["script"]             = "Arab"
    Locale["ug"]["rtl"]                = "true" # RTL language

    #? Volapük
    Locale["vo"]["support"]            = "unstable"
    Locale["vo"]["name"]               = "Volapük"
    Locale["vo"]["endonym"]            = "Volapük"
    #Locale["vo"]["translations-of"]
    #Locale["vo"]["definitions-of"]
    #Locale["vo"]["synonyms"]
    #Locale["vo"]["examples"]
    #Locale["vo"]["see-also"]
    Locale["vo"]["family"]             = "Artificial Language"
    Locale["vo"]["iso"]                = "vol"
    #Locale["vo"]["glotto"]
    Locale["vo"]["script"]             = "Latn"

    #? Wolof
    Locale["wo"]["support"]            = "unstable"
    Locale["wo"]["name"]               = "Wolof"
    Locale["wo"]["endonym"]            = "Wollof"
    #Locale["wo"]["translations-of"]
    #Locale["wo"]["definitions-of"]
    #Locale["wo"]["synonyms"]
    #Locale["wo"]["examples"]
    #Locale["wo"]["see-also"]
    Locale["wo"]["family"]             = "Atlantic-Congo"
    Locale["wo"]["iso"]                = "wol"
    Locale["wo"]["glotto"]             = "wolo1247"
    Locale["wo"]["script"]             = "Latn"

    # West Frisian
    Locale["fy"]["name"]               = "Frisian"
    Locale["fy"]["endonym"]            = "Frysk"
    Locale["fy"]["translations-of"]    = "Oersettings fan %s"
    Locale["fy"]["definitions-of"]     = "Definysjes fan %s"
    Locale["fy"]["synonyms"]           = "Synonimen"
    Locale["fy"]["examples"]           = "Foarbylden"
    Locale["fy"]["see-also"]           = "Sjoch ek"
    Locale["fy"]["family"]             = "Indo-European"
    Locale["fy"]["iso"]                = "fry"
    Locale["fy"]["glotto"]             = "west2354"
    Locale["fy"]["script"]             = "Latn"

    #? Xhosa
    Locale["xh"]["support"]            = "unstable"
    Locale["xh"]["name"]               = "Xhosa"
    Locale["xh"]["endonym"]            = "isiXhosa"
    #Locale["xh"]["translations-of"]
    #Locale["xh"]["definitions-of"]
    #Locale["xh"]["synonyms"]
    #Locale["xh"]["examples"]
    #Locale["xh"]["see-also"]
    Locale["xh"]["family"]             = "Atlantic-Congo"
    Locale["xh"]["iso"]                = "xho"
    Locale["xh"]["glotto"]             = "xhos1239"
    Locale["xh"]["script"]             = "Latn"

    #? Cherokee
    Locale["chr"]["support"]           = "unstable"
    Locale["chr"]["name"]              = "Cherokee"
    Locale["chr"]["endonym"]           = "ᏣᎳᎩ"
    #Locale["chr"]["translations-of"]
    #Locale["chr"]["definitions-of"]
    #Locale["chr"]["synonyms"]
    #Locale["chr"]["examples"]
    #Locale["chr"]["see-also"]
    Locale["chr"]["family"]            = "Iroquoian"
    Locale["chr"]["iso"]               = "chr"
    Locale["chr"]["glotto"]            = "cher1273"
    Locale["chr"]["script"]            = "Cher"

    #? Hawaiian
    Locale["haw"]["support"]           = "unstable"
    Locale["haw"]["name"]              = "Hawaiian"
    Locale["haw"]["endonym"]           = "ʻŌlelo Hawaiʻi"
    #Locale["haw"]["translations-of"]
    #Locale["haw"]["definitions-of"]
    #Locale["haw"]["synonyms"]
    #Locale["haw"]["examples"]
    #Locale["haw"]["see-also"]
    Locale["haw"]["family"]            = "Austronesian"
    Locale["haw"]["iso"]               = "haw"
    Locale["haw"]["glotto"]            = "hawa1245"
    Locale["haw"]["script"]            = "Latn"

    #1 Afrikaans
    Locale["af"]["name"]               = "Afrikaans"
    Locale["af"]["endonym"]            = "Afrikaans"
    Locale["af"]["translations-of"]    = "Vertalings van %s"
    Locale["af"]["definitions-of"]     = "Definisies van %s"
    Locale["af"]["synonyms"]           = "Sinonieme"
    Locale["af"]["examples"]           = "Voorbeelde"
    Locale["af"]["see-also"]           = "Sien ook"
    Locale["af"]["family"]             = "Indo-European"
    Locale["af"]["iso"]                = "afr"
    Locale["af"]["glotto"]             = "afri1274"
    Locale["af"]["script"]             = "Latn"

    #2 Albanian
    Locale["sq"]["name"]               = "Albanian"
    Locale["sq"]["endonym"]            = "Shqip"
    Locale["sq"]["translations-of"]    = "Përkthimet e %s"
    Locale["sq"]["definitions-of"]     = "Përkufizime të %s"
    Locale["sq"]["synonyms"]           = "Sinonime"
    Locale["sq"]["examples"]           = "Shembuj"
    Locale["sq"]["see-also"]           = "Shihni gjithashtu"
    Locale["sq"]["family"]             = "Indo-European"
    Locale["sq"]["iso"]                = "sqi"
    Locale["sq"]["glotto"]             = "alba1267"
    Locale["sq"]["script"]             = "Latn"

    #3 Arabic (Standard Arabic)
    Locale["ar"]["name"]               = "Arabic"
    Locale["ar"]["endonym"]            = "العربية"
    Locale["ar"]["translations-of"]    = "ترجمات %s"
    Locale["ar"]["definitions-of"]     = "تعريفات %s"
    Locale["ar"]["synonyms"]           = "مرادفات"
    Locale["ar"]["examples"]           = "أمثلة"
    Locale["ar"]["see-also"]           = "انظر أيضًا"
    Locale["ar"]["family"]             = "Afro-Asiatic"
    Locale["ar"]["iso"]                = "ara"
    Locale["ar"]["glotto"]             = "stan1318"
    Locale["ar"]["script"]             = "Arab"
    Locale["ar"]["rtl"]                = "true" # RTL language

    #4 Armenian (Modern Armenian)
    Locale["hy"]["name"]               = "Armenian"
    Locale["hy"]["endonym"]            = "Հայերեն"
    Locale["hy"]["translations-of"]    = "%s-ի թարգմանությունները"
    Locale["hy"]["definitions-of"]     = "%s-ի սահմանումները"
    Locale["hy"]["synonyms"]           = "Հոմանիշներ"
    Locale["hy"]["examples"]           = "Օրինակներ"
    Locale["hy"]["see-also"]           = "Տես նաև"
    Locale["hy"]["family"]             = "Indo-European"
    Locale["hy"]["iso"]                = "hye"
    Locale["hy"]["glotto"]             = "nucl1235"
    Locale["hy"]["script"]             = "Armn"

    #5 Azerbaijani (North Azerbaijani)
    Locale["az"]["name"]               = "Azerbaijani"
    Locale["az"]["endonym"]            = "Azərbaycanca"
    Locale["az"]["translations-of"]    = "%s sözünün tərcüməsi"
    Locale["az"]["definitions-of"]     = "%s sözünün tərifləri"
    Locale["az"]["synonyms"]           = "Sinonimlər"
    Locale["az"]["examples"]           = "Nümunələr"
    Locale["az"]["see-also"]           = "Həmçinin, baxın:"
    Locale["az"]["family"]             = "Turkic"
    Locale["az"]["iso"]                = "aze"
    Locale["az"]["glotto"]             = "nort2697"
    Locale["az"]["script"]             = "Latn"

    #6 Basque
    Locale["eu"]["name"]               = "Basque"
    Locale["eu"]["endonym"]            = "Euskara"
    Locale["eu"]["translations-of"]    = "%s esapidearen itzulpena"
    Locale["eu"]["definitions-of"]     = "Honen definizioak: %s"
    Locale["eu"]["synonyms"]           = "Sinonimoak"
    Locale["eu"]["examples"]           = "Adibideak"
    Locale["eu"]["see-also"]           = "Ikusi hauek ere"
    Locale["eu"]["family"]             = "Language Isolate"
    Locale["eu"]["iso"]                = "eus"
    Locale["eu"]["glotto"]             = "basq1248"
    Locale["eu"]["script"]             = "Latn"

    #7 Belarusian, Cyrillic alphabet
    Locale["be"]["name"]               = "Belarusian"
    Locale["be"]["endonym"]            = "беларуская"
    Locale["be"]["translations-of"]    = "Пераклады %s"
    Locale["be"]["definitions-of"]     = "Вызначэннi %s"
    Locale["be"]["synonyms"]           = "Сінонімы"
    Locale["be"]["examples"]           = "Прыклады"
    Locale["be"]["see-also"]           = "Гл. таксама"
    Locale["be"]["family"]             = "Indo-European"
    Locale["be"]["iso"]                = "bel"
    Locale["be"]["glotto"]             = "bela1254"
    Locale["be"]["script"]             = "Cyrl"

    #8 Bengali
    Locale["bn"]["name"]               = "Bengali"
    Locale["bn"]["endonym"]            = "বাংলা"
    Locale["bn"]["translations-of"]    = "%s এর অনুবাদ"
    Locale["bn"]["definitions-of"]     = "%s এর সংজ্ঞা"
    Locale["bn"]["synonyms"]           = "প্রতিশব্দ"
    Locale["bn"]["examples"]           = "উদাহরণ"
    Locale["bn"]["see-also"]           = "আরো দেখুন"
    Locale["bn"]["family"]             = "Indo-European"
    Locale["bn"]["iso"]                = "ben"
    Locale["bn"]["glotto"]             = "beng1280"
    Locale["bn"]["script"]             = "Beng"

    #9 Bosnian, Latin alphabet
    Locale["bs"]["name"]               = "Bosnian"
    Locale["bs"]["endonym"]            = "Bosanski"
    Locale["bs"]["translations-of"]    = "Prijevod za: %s"
    Locale["bs"]["definitions-of"]     = "Definicije za %s"
    Locale["bs"]["synonyms"]           = "Sinonimi"
    Locale["bs"]["examples"]           = "Primjeri"
    Locale["bs"]["see-also"]           = "Pogledajte i"
    Locale["bs"]["family"]             = "Indo-European"
    Locale["bs"]["iso"]                = "bos"
    Locale["bs"]["glotto"]             = "bosn1245"
    Locale["bs"]["script"]             = "Latn"

    #10 Bulgarian
    Locale["bg"]["name"]               = "Bulgarian"
    Locale["bg"]["endonym"]            = "български"
    Locale["bg"]["translations-of"]    = "Преводи на %s"
    Locale["bg"]["definitions-of"]     = "Дефиниции за %s"
    Locale["bg"]["synonyms"]           = "Синоними"
    Locale["bg"]["examples"]           = "Примери"
    Locale["bg"]["see-also"]           = "Вижте също"
    Locale["bg"]["family"]             = "Indo-European"
    Locale["bg"]["iso"]                = "bul"
    Locale["bg"]["glotto"]             = "bulg1262"
    Locale["bg"]["script"]             = "Cyrl"

    #11 Catalan (Standard Catalan)
    Locale["ca"]["name"]               = "Catalan"
    Locale["ca"]["endonym"]            = "Català"
    Locale["ca"]["translations-of"]    = "Traduccions per a %s"
    Locale["ca"]["definitions-of"]     = "Definicions de: %s"
    Locale["ca"]["synonyms"]           = "Sinònims"
    Locale["ca"]["examples"]           = "Exemples"
    Locale["ca"]["see-also"]           = "Vegeu també"
    Locale["ca"]["family"]             = "Indo-European"
    Locale["ca"]["iso"]                = "cat"
    Locale["ca"]["glotto"]             = "stan1289"
    Locale["ca"]["script"]             = "Latn"

    #12 Cebuano
    Locale["ceb"]["name"]              = "Cebuano"
    Locale["ceb"]["endonym"]           = "Cebuano"
    Locale["ceb"]["translations-of"]   = "%s Mga Paghubad sa PULONG_O_HUGPONG SA PAMULONG"
    Locale["ceb"]["definitions-of"]    = "Mga kahulugan sa %s"
    Locale["ceb"]["synonyms"]          = "Mga Kapulong"
    Locale["ceb"]["examples"]          = "Mga pananglitan:"
    Locale["ceb"]["see-also"]          = "Kitaa pag-usab"
    Locale["ceb"]["family"]            = "Austronesian"
    Locale["ceb"]["iso"]               = "ceb"
    Locale["ceb"]["glotto"]            = "cebu1242"
    Locale["ceb"]["script"]            = "Latn"

    #13 Chichewa
    Locale["ny"]["name"]               = "Chichewa"
    Locale["ny"]["endonym"]            = "Nyanja"
    Locale["ny"]["translations-of"]    = "Matanthauzidwe a %s"
    Locale["ny"]["definitions-of"]     = "Mamasulidwe a %s"
    Locale["ny"]["synonyms"]           = "Mau ofanana"
    Locale["ny"]["examples"]           = "Zitsanzo"
    Locale["ny"]["see-also"]           = "Onaninso"
    Locale["ny"]["family"]             = "Atlantic-Congo"
    Locale["ny"]["iso"]                = "nya"
    Locale["ny"]["glotto"]             = "nyan1308"
    Locale["ny"]["script"]             = "Latn"

    #14a Chinese (Mandarin), Simplified
    Locale["zh-CN"]["name"]            = "Chinese Simplified"
    Locale["zh-CN"]["endonym"]         = "简体中文"
    Locale["zh-CN"]["translations-of"] = "%s 的翻译"
    Locale["zh-CN"]["definitions-of"]  = "%s的定义"
    Locale["zh-CN"]["synonyms"]        = "同义词"
    Locale["zh-CN"]["examples"]        = "示例"
    Locale["zh-CN"]["see-also"]        = "另请参阅"
    Locale["zh-CN"]["family"]          = "Sino-Tibetan"
    Locale["zh-CN"]["iso"]             = "zho-CN"
    Locale["zh-CN"]["glotto"]          = "mand1415"
    Locale["zh-CN"]["script"]          = "Hans"
    Locale["zh-CN"]["dictionary"]      = "true" # has dictionary

    #14b Chinese (Mandarin), Traditional
    Locale["zh-TW"]["name"]            = "Chinese Traditional"
    Locale["zh-TW"]["endonym"]         = "正體中文"
    Locale["zh-TW"]["translations-of"] = "「%s」的翻譯"
    Locale["zh-TW"]["definitions-of"]  = "「%s」的定義"
    Locale["zh-TW"]["synonyms"]        = "同義詞"
    Locale["zh-TW"]["examples"]        = "例句"
    Locale["zh-TW"]["see-also"]        = "另請參閱"
    Locale["zh-TW"]["family"]          = "Sino-Tibetan"
    Locale["zh-TW"]["iso"]             = "zho-TW"
    Locale["zh-TW"]["glotto"]          = "mand1415"
    Locale["zh-TW"]["script"]          = "Hant"
    Locale["zh-TW"]["dictionary"]      = "true" # has dictionary

    #15 Croatian
    Locale["hr"]["name"]               = "Croatian"
    Locale["hr"]["endonym"]            = "Hrvatski"
    Locale["hr"]["translations-of"]    = "Prijevodi riječi ili izraza %s"
    Locale["hr"]["definitions-of"]     = "Definicije riječi ili izraza %s"
    Locale["hr"]["synonyms"]           = "Sinonimi"
    Locale["hr"]["examples"]           = "Primjeri"
    Locale["hr"]["see-also"]           = "Također pogledajte"
    Locale["hr"]["family"]             = "Indo-European"
    Locale["hr"]["iso"]                = "hrv"
    Locale["hr"]["glotto"]             = "croa1245"
    Locale["hr"]["script"]             = "Latn"

    #16 Czech
    Locale["cs"]["name"]               = "Czech"
    Locale["cs"]["endonym"]            = "Čeština"
    Locale["cs"]["translations-of"]    = "Překlad výrazu %s"
    Locale["cs"]["definitions-of"]     = "Definice výrazu %s"
    Locale["cs"]["synonyms"]           = "Synonyma"
    Locale["cs"]["examples"]           = "Příklady"
    Locale["cs"]["see-also"]           = "Viz také"
    Locale["cs"]["family"]             = "Indo-European"
    Locale["cs"]["iso"]                = "ces"
    Locale["cs"]["glotto"]             = "czec1258"
    Locale["cs"]["script"]             = "Latn"

    #17 Danish
    Locale["da"]["name"]               = "Danish"
    Locale["da"]["endonym"]            = "Dansk"
    Locale["da"]["translations-of"]    = "Oversættelser af %s"
    Locale["da"]["definitions-of"]     = "Definitioner af %s"
    Locale["da"]["synonyms"]           = "Synonymer"
    Locale["da"]["examples"]           = "Eksempler"
    Locale["da"]["see-also"]           = "Se også"
    Locale["da"]["family"]             = "Indo-European"
    Locale["da"]["iso"]                = "dan"
    Locale["da"]["glotto"]             = "dani1285"
    Locale["da"]["script"]             = "Latn"

    #18 Dutch
    Locale["nl"]["name"]               = "Dutch"
    Locale["nl"]["endonym"]            = "Nederlands"
    Locale["nl"]["translations-of"]    = "Vertalingen van %s"
    Locale["nl"]["definitions-of"]     = "Definities van %s"
    Locale["nl"]["synonyms"]           = "Synoniemen"
    Locale["nl"]["examples"]           = "Voorbeelden"
    Locale["nl"]["see-also"]           = "Zie ook"
    Locale["nl"]["family"]             = "Indo-European"
    Locale["nl"]["iso"]                = "nld"
    Locale["nl"]["glotto"]             = "dutc1256"
    Locale["nl"]["script"]             = "Latn"
    Locale["nl"]["dictionary"]         = "true" # has dictionary

    #19 English (Standard English)
    Locale["en"]["name"]               = "English"
    Locale["en"]["endonym"]            = "English"
    Locale["en"]["translations-of"]    = "Translations of %s"
    Locale["en"]["definitions-of"]     = "Definitions of %s"
    Locale["en"]["synonyms"]           = "Synonyms"
    Locale["en"]["examples"]           = "Examples"
    Locale["en"]["see-also"]           = "See also"
    Locale["en"]["family"]             = "Indo-European"
    Locale["en"]["iso"]                = "eng"
    Locale["en"]["glotto"]             = "stan1293"
    Locale["en"]["script"]             = "Latn"
    Locale["en"]["dictionary"]         = "true" # has dictionary

    #20 Esperanto
    Locale["eo"]["name"]               = "Esperanto"
    Locale["eo"]["endonym"]            = "Esperanto"
    Locale["eo"]["translations-of"]    = "Tradukoj de %s"
    Locale["eo"]["definitions-of"]     = "Difinoj de %s"
    Locale["eo"]["synonyms"]           = "Sinonimoj"
    Locale["eo"]["examples"]           = "Ekzemploj"
    Locale["eo"]["see-also"]           = "Vidu ankaŭ"
    Locale["eo"]["family"]             = "Artificial Language"
    Locale["eo"]["iso"]                = "epo"
    Locale["eo"]["glotto"]             = "espe1235"
    Locale["eo"]["script"]             = "Latn"

    #21 Estonian
    Locale["et"]["name"]               = "Estonian"
    Locale["et"]["endonym"]            = "Eesti"
    Locale["et"]["translations-of"]    = "Sõna(de) %s tõlked"
    Locale["et"]["definitions-of"]     = "Sõna(de) %s definitsioonid"
    Locale["et"]["synonyms"]           = "Sünonüümid"
    Locale["et"]["examples"]           = "Näited"
    Locale["et"]["see-also"]           = "Vt ka"
    Locale["et"]["family"]             = "Uralic"
    Locale["et"]["iso"]                = "est"
    Locale["et"]["glotto"]             = "esto1258"
    Locale["et"]["script"]             = "Latn"

    #22 Filipino / Tagalog
    Locale["tl"]["name"]               = "Filipino"
    Locale["tl"]["endonym"]            = "Tagalog"
    Locale["tl"]["translations-of"]    = "Mga pagsasalin ng %s"
    Locale["tl"]["definitions-of"]     = "Mga kahulugan ng %s"
    Locale["tl"]["synonyms"]           = "Mga Kasingkahulugan"
    Locale["tl"]["examples"]           = "Mga Halimbawa"
    Locale["tl"]["see-also"]           = "Tingnan rin ang"
    Locale["tl"]["family"]             = "Austronesian"
    Locale["tl"]["iso"]                = "tgl"
    Locale["tl"]["glotto"]             = "taga1270"
    Locale["tl"]["script"]             = "Latn"

    #23 Finnish
    Locale["fi"]["name"]               = "Finnish"
    Locale["fi"]["endonym"]            = "Suomi"
    Locale["fi"]["translations-of"]    = "Käännökset tekstille %s"
    Locale["fi"]["definitions-of"]     = "Määritelmät kohteelle %s"
    Locale["fi"]["synonyms"]           = "Synonyymit"
    Locale["fi"]["examples"]           = "Esimerkkejä"
    Locale["fi"]["see-also"]           = "Katso myös"
    Locale["fi"]["family"]             = "Uralic"
    Locale["fi"]["iso"]                = "fin"
    Locale["fi"]["glotto"]             = "finn1318"
    Locale["fi"]["script"]             = "Latn"

    #24 French (Standard French)
    Locale["fr"]["name"]               = "French"
    Locale["fr"]["endonym"]            = "Français"
    Locale["fr"]["translations-of"]    = "Traductions de %s"
    Locale["fr"]["definitions-of"]     = "Définitions de %s"
    Locale["fr"]["synonyms"]           = "Synonymes"
    Locale["fr"]["examples"]           = "Exemples"
    Locale["fr"]["see-also"]           = "Voir aussi"
    Locale["fr"]["family"]             = "Indo-European"
    Locale["fr"]["iso"]                = "fra"
    Locale["fr"]["glotto"]             = "stan1290"
    Locale["fr"]["script"]             = "Latn"
    Locale["fr"]["dictionary"]         = "true" # has dictionary

    #25 Galician
    Locale["gl"]["name"]               = "Galician"
    Locale["gl"]["endonym"]            = "Galego"
    Locale["gl"]["translations-of"]    = "Traducións de %s"
    Locale["gl"]["definitions-of"]     = "Definicións de %s"
    Locale["gl"]["synonyms"]           = "Sinónimos"
    Locale["gl"]["examples"]           = "Exemplos"
    Locale["gl"]["see-also"]           = "Ver tamén"
    Locale["gl"]["family"]             = "Indo-European"
    Locale["gl"]["iso"]                = "glg"
    Locale["gl"]["glotto"]             = "gali1258"
    Locale["gl"]["script"]             = "Latn"

    #26 Georgian (Modern Georgian)
    Locale["ka"]["name"]               = "Georgian"
    Locale["ka"]["endonym"]            = "ქართული"
    Locale["ka"]["translations-of"]    = "%s-ის თარგმანები"
    Locale["ka"]["definitions-of"]     = "%s-ის განსაზღვრებები"
    Locale["ka"]["synonyms"]           = "სინონიმები"
    Locale["ka"]["examples"]           = "მაგალითები"
    Locale["ka"]["see-also"]           = "ასევე იხილეთ"
    Locale["ka"]["family"]             = "Kartvelian"
    Locale["ka"]["iso"]                = "kat"
    Locale["ka"]["glotto"]             = "nucl1302"
    Locale["ka"]["script"]             = "Geor"

    #27 German (Standard German)
    Locale["de"]["name"]               = "German"
    Locale["de"]["endonym"]            = "Deutsch"
    Locale["de"]["translations-of"]    = "Übersetzungen für %s"
    Locale["de"]["definitions-of"]     = "Definitionen von %s"
    Locale["de"]["synonyms"]           = "Synonyme"
    Locale["de"]["examples"]           = "Beispiele"
    Locale["de"]["see-also"]           = "Siehe auch"
    Locale["de"]["family"]             = "Indo-European"
    Locale["de"]["iso"]                = "deu"
    Locale["de"]["glotto"]             = "stan1295"
    Locale["de"]["script"]             = "Latn"
    Locale["de"]["dictionary"]         = "true" # has dictionary

    #28 Greek (Modern Greek)
    Locale["el"]["name"]               = "Greek"
    Locale["el"]["endonym"]            = "Ελληνικά"
    Locale["el"]["translations-of"]    = "Μεταφράσεις του %s"
    Locale["el"]["definitions-of"]     = "Όρισμοί %s"
    Locale["el"]["synonyms"]           = "Συνώνυμα"
    Locale["el"]["examples"]           = "Παραδείγματα"
    Locale["el"]["see-also"]           = "Δείτε επίσης"
    Locale["el"]["family"]             = "Indo-European"
    Locale["el"]["iso"]                = "ell"
    Locale["el"]["glotto"]             = "mode1248"
    Locale["el"]["script"]             = "Grek"

    #29 Gujarati
    Locale["gu"]["name"]               = "Gujarati"
    Locale["gu"]["endonym"]            = "ગુજરાતી"
    Locale["gu"]["translations-of"]    = "%s ના અનુવાદ"
    Locale["gu"]["definitions-of"]     = "%s ની વ્યાખ્યાઓ"
    Locale["gu"]["synonyms"]           = "સમાનાર્થી"
    Locale["gu"]["examples"]           = "ઉદાહરણો"
    Locale["gu"]["see-also"]           = "આ પણ જુઓ"
    Locale["gu"]["family"]             = "Indo-European"
    Locale["gu"]["iso"]                = "guj"
    Locale["gu"]["glotto"]             = "guja1252"
    Locale["gu"]["script"]             = "Gujr"

    #30 Haitian Creole
    Locale["ht"]["name"]               = "Haitian Creole"
    Locale["ht"]["endonym"]            = "Kreyòl Ayisyen"
    Locale["ht"]["translations-of"]    = "Tradiksyon %s"
    Locale["ht"]["definitions-of"]     = "Definisyon nan %s"
    Locale["ht"]["synonyms"]           = "Sinonim"
    Locale["ht"]["examples"]           = "Egzanp:"
    Locale["ht"]["see-also"]           = "Wè tou"
    Locale["ht"]["family"]             = "Indo-European"
    Locale["ht"]["iso"]                = "hat"
    Locale["ht"]["glotto"]             = "hait1244"
    Locale["ht"]["script"]             = "Latn"

    #31 Hausa, Latin alphabet
    Locale["ha"]["name"]               = "Hausa"
    Locale["ha"]["endonym"]            = "Hausa"
    Locale["ha"]["translations-of"]    = "Fassarar %s"
    Locale["ha"]["definitions-of"]     = "Ma'anoni na %s"
    Locale["ha"]["synonyms"]           = "Masu kamancin ma'ana"
    Locale["ha"]["examples"]           = "Misalai"
    Locale["ha"]["see-also"]           = "Duba kuma"
    Locale["ha"]["family"]             = "Afro-Asiatic"
    Locale["ha"]["iso"]                = "hau"
    Locale["ha"]["glotto"]             = "haus1257"
    Locale["ha"]["script"]             = "Latn"

    #32 Hebrew
    Locale["he"]["name"]               = "Hebrew"
    Locale["he"]["endonym"]            = "עִבְרִית"
    Locale["he"]["translations-of"]    = "תרגומים של %s"
    Locale["he"]["definitions-of"]     = "הגדרות של %s"
    Locale["he"]["synonyms"]           = "מילים נרדפות"
    Locale["he"]["examples"]           = "דוגמאות"
    Locale["he"]["see-also"]           = "ראה גם"
    Locale["he"]["family"]             = "Afro-Asiatic"
    Locale["he"]["iso"]                = "heb"
    Locale["he"]["glotto"]             = "hebr1245"
    Locale["he"]["script"]             = "Hebr"
    Locale["he"]["rtl"]                = "true" # RTL language

    #33 Hindi
    Locale["hi"]["name"]               = "Hindi"
    Locale["hi"]["endonym"]            = "हिन्दी"
    Locale["hi"]["translations-of"]    = "%s के अनुवाद"
    Locale["hi"]["definitions-of"]     = "%s की परिभाषाएं"
    Locale["hi"]["synonyms"]           = "समानार्थी"
    Locale["hi"]["examples"]           = "उदाहरण"
    Locale["hi"]["see-also"]           = "यह भी देखें"
    Locale["hi"]["family"]             = "Indo-European"
    Locale["hi"]["iso"]                = "hin"
    Locale["hi"]["glotto"]             = "hind1269"
    Locale["hi"]["script"]             = "Deva"

    #34 Hmong (First Vernacular Hmong)
    Locale["hmn"]["name"]              = "Hmong"
    Locale["hmn"]["endonym"]           = "Hmoob"
    Locale["hmn"]["translations-of"]   = "Lus txhais: %s"
    #Locale["hmn"]["definitions-of"]
    #Locale["hmn"]["synonyms"]
    #Locale["hmn"]["examples"]
    #Locale["hmn"]["see-also"]
    Locale["hmn"]["family"]            = "Hmong-Mien"
    Locale["hmn"]["iso"]               = "hmn"
    Locale["hmn"]["glotto"]            = "firs1234"
    Locale["hmn"]["script"]            = "Latn"

    #35 Hungarian
    Locale["hu"]["name"]               = "Hungarian"
    Locale["hu"]["endonym"]            = "Magyar"
    Locale["hu"]["translations-of"]    = "%s fordításai"
    Locale["hu"]["definitions-of"]     = "%s jelentései"
    Locale["hu"]["synonyms"]           = "Szinonimák"
    Locale["hu"]["examples"]           = "Példák"
    Locale["hu"]["see-also"]           = "Lásd még"
    Locale["hu"]["family"]             = "Uralic"
    Locale["hu"]["iso"]                = "hun"
    Locale["hu"]["glotto"]             = "hung1274"
    Locale["hu"]["script"]             = "Latn"

    #36 Icelandic
    Locale["is"]["name"]               = "Icelandic"
    Locale["is"]["endonym"]            = "Íslenska"
    Locale["is"]["translations-of"]    = "Þýðingar á %s"
    Locale["is"]["definitions-of"]     = "Skilgreiningar á"
    Locale["is"]["synonyms"]           = "Samheiti"
    Locale["is"]["examples"]           = "Dæmi"
    Locale["is"]["see-also"]           = "Sjá einnig"
    Locale["is"]["family"]             = "Indo-European"
    Locale["is"]["iso"]                = "isl"
    Locale["is"]["glotto"]             = "icel1247"
    Locale["is"]["script"]             = "Latn"

    #37 Igbo
    Locale["ig"]["name"]               = "Igbo"
    Locale["ig"]["endonym"]            = "Igbo"
    Locale["ig"]["translations-of"]    = "Ntụgharị asụsụ nke %s"
    Locale["ig"]["definitions-of"]     = "Nkọwapụta nke %s"
    Locale["ig"]["synonyms"]           = "Okwu oyiri"
    Locale["ig"]["examples"]           = "Ọmụmaatụ"
    Locale["ig"]["see-also"]           = "Hụkwuo"
    Locale["ig"]["family"]             = "Atlantic-Congo"
    Locale["ig"]["iso"]                = "ibo"
    Locale["ig"]["glotto"]             = "nucl1417"
    Locale["ig"]["script"]             = "Latn"

    #38 Indonesian
    Locale["id"]["name"]               = "Indonesian"
    Locale["id"]["endonym"]            = "Bahasa Indonesia"
    Locale["id"]["translations-of"]    = "Terjemahan dari %s"
    Locale["id"]["definitions-of"]     = "Definisi %s"
    Locale["id"]["synonyms"]           = "Sinonim"
    Locale["id"]["examples"]           = "Contoh"
    Locale["id"]["see-also"]           = "Lihat juga"
    Locale["id"]["family"]             = "Austronesian"
    Locale["id"]["iso"]                = "ind"
    Locale["id"]["glotto"]             = "indo1316"
    Locale["id"]["script"]             = "Latn"

    #39 Irish
    Locale["ga"]["name"]               = "Irish"
    Locale["ga"]["endonym"]            = "Gaeilge"
    Locale["ga"]["translations-of"]    = "Aistriúcháin ar %s"
    Locale["ga"]["definitions-of"]     = "Sainmhínithe ar %s"
    Locale["ga"]["synonyms"]           = "Comhchiallaigh"
    Locale["ga"]["examples"]           = "Samplaí"
    Locale["ga"]["see-also"]           = "féach freisin"
    Locale["ga"]["family"]             = "Indo-European"
    Locale["ga"]["iso"]                = "gle"
    Locale["ga"]["glotto"]             = "iris1253"
    Locale["ga"]["script"]             = "Latn"

    #40 Italian
    Locale["it"]["name"]               = "Italian"
    Locale["it"]["endonym"]            = "Italiano"
    Locale["it"]["translations-of"]    = "Traduzioni di %s"
    Locale["it"]["definitions-of"]     = "Definizioni di %s"
    Locale["it"]["synonyms"]           = "Sinonimi"
    Locale["it"]["examples"]           = "Esempi"
    Locale["it"]["see-also"]           = "Vedi anche"
    Locale["it"]["family"]             = "Indo-European"
    Locale["it"]["iso"]                = "ita"
    Locale["it"]["glotto"]             = "ital1282"
    Locale["it"]["script"]             = "Latn"
    Locale["it"]["dictionary"]         = "true" # has dictionary

    #41 Japanese
    Locale["ja"]["name"]               = "Japanese"
    Locale["ja"]["endonym"]            = "日本語"
    Locale["ja"]["translations-of"]    = "「%s」の翻訳"
    Locale["ja"]["definitions-of"]     = "%s の定義"
    Locale["ja"]["synonyms"]           = "同義語"
    Locale["ja"]["examples"]           = "例"
    Locale["ja"]["see-also"]           = "関連項目"
    Locale["ja"]["family"]             = "Japonic"
    Locale["ja"]["iso"]                = "jpn"
    Locale["ja"]["glotto"]             = "nucl1643"
    Locale["ja"]["script"]             = "Jpan"
    Locale["ja"]["dictionary"]         = "true" # has dictionary

    #42 Javanese, Latin alphabet
    Locale["jv"]["name"]               = "Javanese"
    Locale["jv"]["endonym"]            = "Basa Jawa"
    Locale["jv"]["translations-of"]    = "Terjemahan %s"
    Locale["jv"]["definitions-of"]     = "Arti %s"
    Locale["jv"]["synonyms"]           = "Sinonim"
    Locale["jv"]["examples"]           = "Conto"
    Locale["jv"]["see-also"]           = "Deleng uga"
    Locale["jv"]["family"]             = "Austronesian"
    Locale["jv"]["iso"]                = "jav"
    Locale["jv"]["glotto"]             = "java1254"
    Locale["jv"]["script"]             = "Latn"

    #43 Kannada (Modern Kannada)
    Locale["kn"]["name"]               = "Kannada"
    Locale["kn"]["endonym"]            = "ಕನ್ನಡ"
    Locale["kn"]["translations-of"]    = "%s ನ ಅನುವಾದಗಳು"
    Locale["kn"]["definitions-of"]     = "%s ನ ವ್ಯಾಖ್ಯಾನಗಳು"
    Locale["kn"]["synonyms"]           = "ಸಮಾನಾರ್ಥಕಗಳು"
    Locale["kn"]["examples"]           = "ಉದಾಹರಣೆಗಳು"
    Locale["kn"]["see-also"]           = "ಇದನ್ನೂ ಗಮನಿಸಿ"
    Locale["kn"]["family"]             = "Dravidian"
    Locale["kn"]["iso"]                = "kan"
    Locale["kn"]["glotto"]             = "nucl1305"
    Locale["kn"]["script"]             = "Knda"

    #44 Kazakh, Cyrillic alphabet
    Locale["kk"]["name"]               = "Kazakh"
    Locale["kk"]["endonym"]            = "Қазақ тілі"
    Locale["kk"]["translations-of"]    = "%s аудармалары"
    Locale["kk"]["definitions-of"]     = "%s анықтамалары"
    Locale["kk"]["synonyms"]           = "Синонимдер"
    Locale["kk"]["examples"]           = "Мысалдар"
    Locale["kk"]["see-also"]           = "Келесі тізімді де көріңіз:"
    Locale["kk"]["family"]             = "Turkic"
    Locale["kk"]["iso"]                = "kaz"
    Locale["kk"]["glotto"]             = "kaza1248"
    Locale["kk"]["script"]             = "Cyrl"

    #45 Khmer (Central Khmer)
    Locale["km"]["name"]               = "Khmer"
    Locale["km"]["endonym"]            = "ភាសាខ្មែរ"
    Locale["km"]["translations-of"]    = "ការ​បក​ប្រែ​នៃ %s"
    Locale["km"]["definitions-of"]     = "និយមន័យ​នៃ​ %s"
    Locale["km"]["synonyms"]           = "សទិសន័យ"
    Locale["km"]["examples"]           = "ឧទាហរណ៍"
    Locale["km"]["see-also"]           = "មើល​ផង​ដែរ"
    Locale["km"]["family"]             = "Austroasiatic"
    Locale["km"]["iso"]                = "khm"
    Locale["km"]["glotto"]             = "cent1989"
    Locale["km"]["script"]             = "Khmr"

    #46 Korean
    Locale["ko"]["name"]               = "Korean"
    Locale["ko"]["endonym"]            = "한국어"
    Locale["ko"]["translations-of"]    = "%s의 번역"
    Locale["ko"]["definitions-of"]     = "%s의 정의"
    Locale["ko"]["synonyms"]           = "동의어"
    Locale["ko"]["examples"]           = "예문"
    Locale["ko"]["see-also"]           = "참조"
    Locale["ko"]["family"]             = "Koreanic"
    Locale["ko"]["iso"]                = "kor"
    Locale["ko"]["glotto"]             = "kore1280"
    Locale["ko"]["script"]             = "Kore"
    Locale["ko"]["dictionary"]         = "true" # has dictionary

    #47 Lao
    Locale["lo"]["name"]               = "Lao"
    Locale["lo"]["endonym"]            = "ລາວ"
    Locale["lo"]["translations-of"]    = "ຄຳ​ແປ​ສຳລັບ %s"
    Locale["lo"]["definitions-of"]     = "ຄວາມໝາຍຂອງ %s"
    Locale["lo"]["synonyms"]           = "ຄຳທີ່ຄ້າຍກັນ %s"
    Locale["lo"]["examples"]           = "ຕົວຢ່າງ"
    Locale["lo"]["see-also"]           = "ເບິ່ງ​ເພີ່ມ​ເຕີມ"
    Locale["lo"]["family"]             = "Tai-Kadai"
    Locale["lo"]["iso"]                = "lao"
    Locale["lo"]["glotto"]             = "laoo1244"
    Locale["lo"]["script"]             = "Laoo"

    #48 Latin
    Locale["la"]["name"]               = "Latin"
    Locale["la"]["endonym"]            = "Latina"
    Locale["la"]["translations-of"]    = "Versio de %s"
    #Locale["la"]["definitions-of"]
    #Locale["la"]["synonyms"]
    #Locale["la"]["examples"]
    #Locale["la"]["see-also"]
    Locale["la"]["family"]             = "Indo-European"
    Locale["la"]["iso"]                = "lat"
    Locale["la"]["glotto"]             = "lati1261"
    Locale["la"]["script"]             = "Latn"

    #49 Latvian
    Locale["lv"]["name"]               = "Latvian"
    Locale["lv"]["endonym"]            = "Latviešu"
    Locale["lv"]["translations-of"]    = "%s tulkojumi"
    Locale["lv"]["definitions-of"]     = "%s definīcijas"
    Locale["lv"]["synonyms"]           = "Sinonīmi"
    Locale["lv"]["examples"]           = "Piemēri"
    Locale["lv"]["see-also"]           = "Skatiet arī"
    Locale["lv"]["family"]             = "Indo-European"
    Locale["lv"]["iso"]                = "lav"
    Locale["lv"]["glotto"]             = "latv1249"
    Locale["lv"]["script"]             = "Latn"

    #50 Lithuanian
    Locale["lt"]["name"]               = "Lithuanian"
    Locale["lt"]["endonym"]            = "Lietuvių"
    Locale["lt"]["translations-of"]    = "„%s“ vertimai"
    Locale["lt"]["definitions-of"]     = "„%s“ apibrėžimai"
    Locale["lt"]["synonyms"]           = "Sinonimai"
    Locale["lt"]["examples"]           = "Pavyzdžiai"
    Locale["lt"]["see-also"]           = "Taip pat žiūrėkite"
    Locale["lt"]["family"]             = "Indo-European"
    Locale["lt"]["iso"]                = "lit"
    Locale["lt"]["glotto"]             = "lith1251"
    Locale["lt"]["script"]             = "Latn"

    #51 Macedonian
    Locale["mk"]["name"]               = "Macedonian"
    Locale["mk"]["endonym"]            = "Македонски"
    Locale["mk"]["translations-of"]    = "Преводи на %s"
    Locale["mk"]["definitions-of"]     = "Дефиниции на %s"
    Locale["mk"]["synonyms"]           = "Синоними"
    Locale["mk"]["examples"]           = "Примери"
    Locale["mk"]["see-also"]           = "Види и"
    Locale["mk"]["family"]             = "Indo-European"
    Locale["mk"]["iso"]                = "mkd"
    Locale["mk"]["glotto"]             = "mace1250"
    Locale["mk"]["script"]             = "Cyrl"

    #52 Malagasy (Plateau Malagasy)
    Locale["mg"]["name"]               = "Malagasy"
    Locale["mg"]["endonym"]            = "Malagasy"
    Locale["mg"]["translations-of"]    = "Dikan'ny %s"
    Locale["mg"]["definitions-of"]     = "Famaritana ny %s"
    Locale["mg"]["synonyms"]           = "Mitovy hevitra"
    Locale["mg"]["examples"]           = "Ohatra"
    Locale["mg"]["see-also"]           = "Jereo ihany koa"
    Locale["mg"]["family"]             = "Austronesian"
    Locale["mg"]["iso"]                = "mlg"
    Locale["mg"]["glotto"]             = "plat1254"
    Locale["mg"]["script"]             = "Latn"

    #53 Malay (Standard Malay)
    Locale["ms"]["name"]               = "Malay"
    Locale["ms"]["endonym"]            = "Bahasa Melayu"
    Locale["ms"]["translations-of"]    = "Terjemahan %s"
    Locale["ms"]["definitions-of"]     = "Takrif %s"
    Locale["ms"]["synonyms"]           = "Sinonim"
    Locale["ms"]["examples"]           = "Contoh"
    Locale["ms"]["see-also"]           = "Lihat juga"
    Locale["ms"]["family"]             = "Austronesian"
    Locale["ms"]["iso"]                = "msa"
    Locale["ms"]["glotto"]             = "stan1306"
    Locale["ms"]["script"]             = "Latn"

    #54 Malayalam
    Locale["ml"]["name"]               = "Malayalam"
    Locale["ml"]["endonym"]            = "മലയാളം"
    Locale["ml"]["translations-of"]    = "%s എന്നതിന്റെ വിവർത്തനങ്ങൾ"
    Locale["ml"]["definitions-of"]     = "%s എന്നതിന്റെ നിർവ്വചനങ്ങൾ"
    Locale["ml"]["synonyms"]           = "പര്യായങ്ങള്‍"
    Locale["ml"]["examples"]           = "ഉദാഹരണങ്ങള്‍"
    Locale["ml"]["see-also"]           = "ഇതും കാണുക"
    Locale["ml"]["family"]             = "Dravidian"
    Locale["ml"]["iso"]                = "mal"
    Locale["ml"]["glotto"]             = "mala1464"
    Locale["ml"]["script"]             = "Mlym"

    #55 Maltese
    Locale["mt"]["name"]               = "Maltese"
    Locale["mt"]["endonym"]            = "Malti"
    Locale["mt"]["translations-of"]    = "Traduzzjonijiet ta' %s"
    Locale["mt"]["definitions-of"]     = "Definizzjonijiet ta' %s"
    Locale["mt"]["synonyms"]           = "Sinonimi"
    Locale["mt"]["examples"]           = "Eżempji"
    Locale["mt"]["see-also"]           = "Ara wkoll"
    Locale["mt"]["family"]             = "Afro-Asiatic"
    Locale["mt"]["iso"]                = "mlt"
    Locale["mt"]["glotto"]             = "malt1254"
    Locale["mt"]["script"]             = "Latn"

    #56 Maori
    Locale["mi"]["name"]               = "Maori"
    Locale["mi"]["endonym"]            = "Māori"
    Locale["mi"]["translations-of"]    = "Ngā whakamāoritanga o %s"
    Locale["mi"]["definitions-of"]     = "Ngā whakamārama o %s"
    Locale["mi"]["synonyms"]           = "Ngā Kupu Taurite"
    Locale["mi"]["examples"]           = "Ngā Tauira:"
    Locale["mi"]["see-also"]           = "Tiro hoki:"
    Locale["mi"]["family"]             = "Austronesian"
    Locale["mi"]["iso"]                = "mri"
    Locale["mi"]["glotto"]             = "maor1246"
    Locale["mi"]["script"]             = "Latn"

    #57 Marathi
    Locale["mr"]["name"]               = "Marathi"
    Locale["mr"]["endonym"]            = "मराठी"
    Locale["mr"]["translations-of"]    = "%s ची भाषांतरे"
    Locale["mr"]["definitions-of"]     = "%s च्या व्याख्या"
    Locale["mr"]["synonyms"]           = "समानार्थी शब्द"
    Locale["mr"]["examples"]           = "उदाहरणे"
    Locale["mr"]["see-also"]           = "हे देखील पहा"
    Locale["mr"]["family"]             = "Indo-European"
    Locale["mr"]["iso"]                = "mar"
    Locale["mr"]["glotto"]             = "mara1378"
    Locale["mr"]["script"]             = "Deva"

    #58 Mongolian, Cyrillic alphabet
    Locale["mn"]["name"]               = "Mongolian"
    Locale["mn"]["endonym"]            = "Монгол"
    Locale["mn"]["translations-of"]    = "%s-н орчуулга"
    Locale["mn"]["definitions-of"]     = "%s үгийн тодорхойлолт"
    Locale["mn"]["synonyms"]           = "Ойролцоо утгатай"
    Locale["mn"]["examples"]           = "Жишээнүүд"
    Locale["mn"]["see-also"]           = "Мөн харах"
    Locale["mn"]["family"]             = "Mongolic"
    Locale["mn"]["iso"]                = "mon"
    Locale["mn"]["glotto"]             = "mong1331"
    Locale["mn"]["script"]             = "Cyrl"

    #59 Myanmar / Burmese
    Locale["my"]["name"]               = "Myanmar"
    Locale["my"]["endonym"]            = "မြန်မာစာ"
    Locale["my"]["translations-of"]    = "%s၏ ဘာသာပြန်ဆိုချက်များ"
    Locale["my"]["definitions-of"]     = "%s၏ အနက်ဖွင့်ဆိုချက်များ"
    Locale["my"]["synonyms"]           = "ကြောင်းတူသံကွဲများ"
    Locale["my"]["examples"]           = "ဥပမာ"
    Locale["my"]["see-also"]           = "ဖော်ပြပါများကိုလဲ ကြည့်ပါ"
    Locale["my"]["family"]             = "Sino-Tibetan"
    Locale["my"]["iso"]                = "mya"
    Locale["my"]["glotto"]             = "nucl1310"
    Locale["my"]["script"]             = "Mymr"

    #60 Nepali
    Locale["ne"]["name"]               = "Nepali"
    Locale["ne"]["endonym"]            = "नेपाली"
    Locale["ne"]["translations-of"]    = "%sका अनुवाद"
    Locale["ne"]["definitions-of"]     = "%sको परिभाषा"
    Locale["ne"]["synonyms"]           = "समानार्थीहरू"
    Locale["ne"]["examples"]           = "उदाहरणहरु"
    Locale["ne"]["see-also"]           = "यो पनि हेर्नुहोस्"
    Locale["ne"]["family"]             = "Indo-European"
    Locale["ne"]["iso"]                = "nep"
    Locale["ne"]["glotto"]             = "nepa1254"
    Locale["ne"]["script"]             = "Deva"

    #61 Norwegian
    Locale["no"]["name"]               = "Norwegian"
    Locale["no"]["endonym"]            = "Norsk"
    Locale["no"]["translations-of"]    = "Oversettelser av %s"
    Locale["no"]["definitions-of"]     = "Definisjoner av %s"
    Locale["no"]["synonyms"]           = "Synonymer"
    Locale["no"]["examples"]           = "Eksempler"
    Locale["no"]["see-also"]           = "Se også"
    Locale["no"]["family"]             = "Indo-European"
    Locale["no"]["iso"]                = "nor"
    Locale["no"]["glotto"]             = "norw1258"
    Locale["no"]["script"]             = "Latn"

    #62 Persian (Western Farsi)
    Locale["fa"]["name"]               = "Persian"
    Locale["fa"]["endonym"]            = "فارسی"
    Locale["fa"]["translations-of"]    = "ترجمه‌های %s"
    Locale["fa"]["definitions-of"]     = "تعریف‌های %s"
    Locale["fa"]["synonyms"]           = "مترادف‌ها"
    Locale["fa"]["examples"]           = "مثال‌ها"
    Locale["fa"]["see-also"]           = "همچنین مراجعه کنید به"
    Locale["fa"]["family"]             = "Indo-European"
    Locale["fa"]["iso"]                = "fas"
    Locale["fa"]["glotto"]             = "west2369"
    Locale["fa"]["script"]             = "Arab"
    Locale["fa"]["rtl"]                = "true" # RTL language

    #63 Polish
    Locale["pl"]["name"]               = "Polish"
    Locale["pl"]["endonym"]            = "Polski"
    Locale["pl"]["translations-of"]    = "Tłumaczenia %s"
    Locale["pl"]["definitions-of"]     = "%s – definicje"
    Locale["pl"]["synonyms"]           = "Synonimy"
    Locale["pl"]["examples"]           = "Przykłady"
    Locale["pl"]["see-also"]           = "Zobacz też"
    Locale["pl"]["family"]             = "Indo-European"
    Locale["pl"]["iso"]                = "pol"
    Locale["pl"]["glotto"]             = "poli1260"
    Locale["pl"]["script"]             = "Latn"

    #64 Portuguese
    Locale["pt"]["name"]               = "Portuguese"
    Locale["pt"]["endonym"]            = "Português"
    Locale["pt"]["translations-of"]    = "Traduções de %s"
    Locale["pt"]["definitions-of"]     = "Definições de %s"
    Locale["pt"]["synonyms"]           = "Sinônimos"
    Locale["pt"]["examples"]           = "Exemplos"
    Locale["pt"]["see-also"]           = "Veja também"
    Locale["pt"]["family"]             = "Indo-European"
    Locale["pt"]["iso"]                = "por"
    Locale["pt"]["glotto"]             = "port1283"
    Locale["pt"]["script"]             = "Latn"
    Locale["pt"]["dictionary"]         = "true" # has dictionary

    #65 Punjabi, Gurmukhī alphabet
    Locale["pa"]["name"]               = "Punjabi"
    Locale["pa"]["endonym"]            = "ਪੰਜਾਬੀ"
    Locale["pa"]["translations-of"]    = "ਦੇ ਅਨੁਵਾਦ%s"
    Locale["pa"]["definitions-of"]     = "ਦੀਆਂ ਪਰਿਭਾਸ਼ਾ %s"
    Locale["pa"]["synonyms"]           = "ਸਮਾਨਾਰਥਕ ਸ਼ਬਦ"
    Locale["pa"]["examples"]           = "ਉਦਾਹਰਣਾਂ"
    Locale["pa"]["see-also"]           = "ਇਹ ਵੀ ਵੇਖੋ"
    Locale["pa"]["family"]             = "Indo-European"
    Locale["pa"]["iso"]                = "pan"
    Locale["pa"]["glotto"]             = "panj1256"
    Locale["pa"]["script"]             = "Guru"

    #66 Romanian
    Locale["ro"]["name"]               = "Romanian"
    Locale["ro"]["endonym"]            = "Română"
    Locale["ro"]["translations-of"]    = "Traduceri pentru %s"
    Locale["ro"]["definitions-of"]     = "Definiții pentru %s"
    Locale["ro"]["synonyms"]           = "Sinonime"
    Locale["ro"]["examples"]           = "Exemple"
    Locale["ro"]["see-also"]           = "Vedeți și"
    Locale["ro"]["family"]             = "Indo-European"
    Locale["ro"]["iso"]                = "ron"
    Locale["ro"]["glotto"]             = "roma1327"
    Locale["ro"]["script"]             = "Latn"

    #67 Russian
    Locale["ru"]["name"]               = "Russian"
    Locale["ru"]["endonym"]            = "Русский"
    Locale["ru"]["translations-of"]    = "%s: варианты перевода"
    Locale["ru"]["definitions-of"]     = "%s – определения"
    Locale["ru"]["synonyms"]           = "Синонимы"
    Locale["ru"]["examples"]           = "Примеры"
    Locale["ru"]["see-also"]           = "Похожие слова"
    Locale["ru"]["family"]             = "Indo-European"
    Locale["ru"]["iso"]                = "rus"
    Locale["ru"]["glotto"]             = "russ1263"
    Locale["ru"]["script"]             = "Cyrl"
    Locale["ru"]["dictionary"]         = "true" # has dictionary

    #68a Serbian, Cyrillic alphabet
    Locale["sr-Cyrl"]["name"]          = "Serbian (Cyrillic)"
    Locale["sr-Cyrl"]["endonym"]       = "српски"
    Locale["sr-Cyrl"]["translations-of"] = "Преводи за „%s“"
    Locale["sr-Cyrl"]["definitions-of"]  = "Дефиниције за %s"
    Locale["sr-Cyrl"]["synonyms"]      = "Синоними"
    Locale["sr-Cyrl"]["examples"]      = "Примери"
    Locale["sr-Cyrl"]["see-also"]      = "Погледајте такође"
    Locale["sr-Cyrl"]["family"]        = "Indo-European"
    Locale["sr-Cyrl"]["iso"]           = "srp-Cyrl"
    Locale["sr-Cyrl"]["glotto"]        = "serb1264"
    Locale["sr-Cyrl"]["script"]        = "Cyrl"

    #68b Serbian, Latin alphabet
    Locale["sr-Latn"]["name"]          = "Serbian (Latin)"
    Locale["sr-Latn"]["endonym"]       = "srpski"
    Locale["sr-Latn"]["translations-of"] = "Prevodi za „%s“"
    Locale["sr-Latn"]["definitions-of"]  = "Definicije za %s"
    Locale["sr-Latn"]["synonyms"]      = "Sinonimi"
    Locale["sr-Latn"]["examples"]      = "Primeri"
    Locale["sr-Latn"]["see-also"]      = "Pogledajte takođe"
    Locale["sr-Latn"]["family"]        = "Indo-European"
    Locale["sr-Latn"]["iso"]           = "srp-Latn"
    Locale["sr-Latn"]["glotto"]        = "serb1264"
    Locale["sr-Latn"]["script"]        = "Latn"

    #69 Sesotho (Southern Sotho)
    Locale["st"]["name"]               = "Sesotho"
    Locale["st"]["endonym"]            = "Sesotho"
    Locale["st"]["translations-of"]    = "Liphetolelo tsa %s"
    Locale["st"]["definitions-of"]     = "Meelelo ea %s"
    Locale["st"]["synonyms"]           = "Mantsoe a tšoanang ka moelelo"
    Locale["st"]["examples"]           = "Mehlala"
    Locale["st"]["see-also"]           = "Bona hape"
    Locale["st"]["family"]             = "Atlantic-Congo"
    Locale["st"]["iso"]                = "sot"
    Locale["st"]["glotto"]             = "sout2807"
    Locale["st"]["script"]             = "Latn"

    #70 Sinhala
    Locale["si"]["name"]               = "Sinhala"
    Locale["si"]["endonym"]            = "සිංහල"
    Locale["si"]["translations-of"]    = "%s හි පරිවර්තන"
    Locale["si"]["definitions-of"]     = "%s හි නිර්වචන"
    Locale["si"]["synonyms"]           = "සමානාර්ථ පද"
    Locale["si"]["examples"]           = "උදාහරණ"
    Locale["si"]["see-also"]           = "මෙයත් බලන්න"
    Locale["si"]["family"]             = "Indo-European"
    Locale["si"]["iso"]                = "sin"
    Locale["si"]["glotto"]             = "sinh1246"
    Locale["si"]["script"]             = "Sinh"

    #71 Slovak
    Locale["sk"]["name"]               = "Slovak"
    Locale["sk"]["endonym"]            = "Slovenčina"
    Locale["sk"]["translations-of"]    = "Preklady výrazu: %s"
    Locale["sk"]["definitions-of"]     = "Definície výrazu %s"
    Locale["sk"]["synonyms"]           = "Synonymá"
    Locale["sk"]["examples"]           = "Príklady"
    Locale["sk"]["see-also"]           = "Pozrite tiež"
    Locale["sk"]["family"]             = "Indo-European"
    Locale["sk"]["iso"]                = "slk"
    Locale["sk"]["glotto"]             = "slov1269"
    Locale["sk"]["script"]             = "Latn"

    #72 Slovenian / Slovene
    Locale["sl"]["name"]               = "Slovenian"
    Locale["sl"]["endonym"]            = "Slovenščina"
    Locale["sl"]["translations-of"]    = "Prevodi za %s"
    Locale["sl"]["definitions-of"]     = "Razlage za %s"
    Locale["sl"]["synonyms"]           = "Sopomenke"
    Locale["sl"]["examples"]           = "Primeri"
    Locale["sl"]["see-also"]           = "Glejte tudi"
    Locale["sl"]["family"]             = "Indo-European"
    Locale["sl"]["iso"]                = "slv"
    Locale["sl"]["glotto"]             = "slov1268"
    Locale["sl"]["script"]             = "Latn"

    #73 Somali
    Locale["so"]["name"]               = "Somali"
    Locale["so"]["endonym"]            = "Soomaali"
    Locale["so"]["translations-of"]    = "Turjumaada %s"
    Locale["so"]["definitions-of"]     = "Qeexitaannada %s"
    Locale["so"]["synonyms"]           = "La micne ah"
    Locale["so"]["examples"]           = "Tusaalooyin"
    Locale["so"]["see-also"]           = "Sidoo kale eeg"
    Locale["so"]["family"]             = "Afro-Asiatic"
    Locale["so"]["iso"]                = "som"
    Locale["so"]["glotto"]             = "soma1255"
    Locale["so"]["script"]             = "Latn"

    #74 Spanish
    Locale["es"]["name"]               = "Spanish"
    Locale["es"]["endonym"]            = "Español"
    Locale["es"]["translations-of"]    = "Traducciones de %s"
    Locale["es"]["definitions-of"]     = "Definiciones de %s"
    Locale["es"]["synonyms"]           = "Sinónimos"
    Locale["es"]["examples"]           = "Ejemplos"
    Locale["es"]["see-also"]           = "Ver también"
    Locale["es"]["family"]             = "Indo-European"
    Locale["es"]["iso"]                = "spa"
    Locale["es"]["glotto"]             = "stan1288"
    Locale["es"]["script"]             = "Latn"
    Locale["es"]["dictionary"]         = "true" # has dictionary

    #75 Sundanese, Latin alphabet
    Locale["su"]["name"]               = "Sundanese"
    Locale["su"]["endonym"]            = "Basa Sunda"
    Locale["su"]["translations-of"]    = "Tarjamahan tina %s"
    Locale["su"]["definitions-of"]     = "Panjelasan tina %s"
    Locale["su"]["synonyms"]           = "Sinonim"
    Locale["su"]["examples"]           = "Conto"
    Locale["su"]["see-also"]           = "Tingali ogé"
    Locale["su"]["family"]             = "Austronesian"
    Locale["su"]["iso"]                = "sun"
    Locale["su"]["glotto"]             = "sund1252"
    Locale["su"]["script"]             = "Latn"

    #76 Swahili
    Locale["sw"]["name"]               = "Swahili"
    Locale["sw"]["endonym"]            = "Kiswahili"
    Locale["sw"]["translations-of"]    = "Tafsiri ya %s"
    Locale["sw"]["definitions-of"]     = "Ufafanuzi wa %s"
    Locale["sw"]["synonyms"]           = "Visawe"
    Locale["sw"]["examples"]           = "Mifano"
    Locale["sw"]["see-also"]           = "Angalia pia"
    Locale["sw"]["family"]             = "Atlantic-Congo"
    Locale["sw"]["iso"]                = "swa"
    Locale["sw"]["glotto"]             = "swah1253"
    Locale["sw"]["script"]             = "Latn"

    #77 Swedish
    Locale["sv"]["name"]               = "Swedish"
    Locale["sv"]["endonym"]            = "Svenska"
    Locale["sv"]["translations-of"]    = "Översättningar av %s"
    Locale["sv"]["definitions-of"]     = "Definitioner av %s"
    Locale["sv"]["synonyms"]           = "Synonymer"
    Locale["sv"]["examples"]           = "Exempel"
    Locale["sv"]["see-also"]           = "Se även"
    Locale["sv"]["family"]             = "Indo-European"
    Locale["sv"]["iso"]                = "swe"
    Locale["sv"]["glotto"]             = "swed1254"
    Locale["sv"]["script"]             = "Latn"

    #78 Tajik, Cyrillic alphabet
    Locale["tg"]["name"]               = "Tajik"
    Locale["tg"]["endonym"]            = "Тоҷикӣ"
    Locale["tg"]["translations-of"]    = "Тарҷумаҳои %s"
    Locale["tg"]["definitions-of"]     = "Таърифҳои %s"
    Locale["tg"]["synonyms"]           = "Муродифҳо"
    Locale["tg"]["examples"]           = "Намунаҳо:"
    Locale["tg"]["see-also"]           = "Ҳамчунин Бинед"
    Locale["tg"]["family"]             = "Indo-European"
    Locale["tg"]["iso"]                = "tgk"
    Locale["tg"]["glotto"]             = "taji1245"
    Locale["tg"]["script"]             = "Cyrl"

    #79 Tamil
    Locale["ta"]["name"]               = "Tamil"
    Locale["ta"]["endonym"]            = "தமிழ்"
    Locale["ta"]["translations-of"]    = "%s இன் மொழிபெயர்ப்புகள்"
    Locale["ta"]["definitions-of"]     = "%s இன் வரையறைகள்"
    Locale["ta"]["synonyms"]           = "இணைச்சொற்கள்"
    Locale["ta"]["examples"]           = "எடுத்துக்காட்டுகள்"
    Locale["ta"]["see-also"]           = "இதையும் காண்க"
    Locale["ta"]["family"]             = "Dravidian"
    Locale["ta"]["iso"]                = "tam"
    Locale["ta"]["glotto"]             = "tami1289"
    Locale["ta"]["script"]             = "Taml"

    #80 Telugu
    Locale["te"]["name"]               = "Telugu"
    Locale["te"]["endonym"]            = "తెలుగు"
    Locale["te"]["translations-of"]    = "%s యొక్క అనువాదాలు"
    Locale["te"]["definitions-of"]     = "%s యొక్క నిర్వచనాలు"
    Locale["te"]["synonyms"]           = "పర్యాయపదాలు"
    Locale["te"]["examples"]           = "ఉదాహరణలు"
    Locale["te"]["see-also"]           = "వీటిని కూడా చూడండి"
    Locale["te"]["family"]             = "Dravidian"
    Locale["te"]["iso"]                = "tel"
    Locale["te"]["glotto"]             = "telu1262"
    Locale["te"]["script"]             = "Telu"

    #81 Thai
    Locale["th"]["name"]               = "Thai"
    Locale["th"]["endonym"]            = "ไทย"
    Locale["th"]["translations-of"]    = "คำแปลของ %s"
    Locale["th"]["definitions-of"]     = "คำจำกัดความของ %s"
    Locale["th"]["synonyms"]           = "คำพ้องความหมาย"
    Locale["th"]["examples"]           = "ตัวอย่าง"
    Locale["th"]["see-also"]           = "ดูเพิ่มเติม"
    Locale["th"]["family"]             = "Tai-Kadai"
    Locale["th"]["iso"]                = "tha"
    Locale["th"]["glotto"]             = "thai1261"
    Locale["th"]["script"]             = "Thai"

    #82 Turkish
    Locale["tr"]["name"]               = "Turkish"
    Locale["tr"]["endonym"]            = "Türkçe"
    Locale["tr"]["translations-of"]    = "%s çevirileri"
    Locale["tr"]["definitions-of"]     = "%s için tanımlar"
    Locale["tr"]["synonyms"]           = "Eş anlamlılar"
    Locale["tr"]["examples"]           = "Örnekler"
    Locale["tr"]["see-also"]           = "Ayrıca bkz."
    Locale["tr"]["family"]             = "Turkic"
    Locale["tr"]["iso"]                = "tur"
    Locale["tr"]["glotto"]             = "nucl1301"
    Locale["tr"]["script"]             = "Latn"

    #83 Ukrainian
    Locale["uk"]["name"]               = "Ukrainian"
    Locale["uk"]["endonym"]            = "Українська"
    Locale["uk"]["translations-of"]    = "Переклади слова або виразу \"%s\""
    Locale["uk"]["definitions-of"]     = "\"%s\" – визначення"
    Locale["uk"]["synonyms"]           = "Синоніми"
    Locale["uk"]["examples"]           = "Приклади"
    Locale["uk"]["see-also"]           = "Дивіться також"
    Locale["uk"]["family"]             = "Indo-European"
    Locale["uk"]["iso"]                = "ukr"
    Locale["uk"]["glotto"]             = "ukra1253"
    Locale["uk"]["script"]             = "Cyrl"

    #84 Urdu
    Locale["ur"]["name"]               = "Urdu"
    Locale["ur"]["endonym"]            = "اُردُو"
    Locale["ur"]["translations-of"]    = "کے ترجمے %s"
    Locale["ur"]["definitions-of"]     = "کی تعریفات %s"
    Locale["ur"]["synonyms"]           = "مترادفات"
    Locale["ur"]["examples"]           = "مثالیں"
    Locale["ur"]["see-also"]           = "نیز دیکھیں"
    Locale["ur"]["family"]             = "Indo-European"
    Locale["ur"]["iso"]                = "urd"
    Locale["ur"]["glotto"]             = "urdu1245"
    Locale["ur"]["script"]             = "Arab"
    Locale["ur"]["rtl"]                = "true" # RTL language

    #85 Uzbek, Latin alphabet
    Locale["uz"]["name"]               = "Uzbek"
    Locale["uz"]["endonym"]            = "Oʻzbek tili"
    Locale["uz"]["translations-of"]    = "%s: tarjima variantlari"
    Locale["uz"]["definitions-of"]     = "%s – ta’riflar"
    Locale["uz"]["synonyms"]           = "Sinonimlar"
    Locale["uz"]["examples"]           = "Namunalar"
    Locale["uz"]["see-also"]           = "O‘xshash so‘zlar"
    Locale["uz"]["family"]             = "Turkic"
    Locale["uz"]["iso"]                = "uzb"
    Locale["uz"]["glotto"]             = "uzbe1247"
    Locale["uz"]["script"]             = "Latn"

    #86 Vietnamese
    Locale["vi"]["name"]               = "Vietnamese"
    Locale["vi"]["endonym"]            = "Tiếng Việt"
    Locale["vi"]["translations-of"]    = "Bản dịch của %s"
    Locale["vi"]["definitions-of"]     = "Nghĩa của %s"
    Locale["vi"]["synonyms"]           = "Từ đồng nghĩa"
    Locale["vi"]["examples"]           = "Ví dụ"
    Locale["vi"]["see-also"]           = "Xem thêm"
    Locale["vi"]["family"]             = "Austroasiatic"
    Locale["vi"]["iso"]                = "vie"
    Locale["vi"]["glotto"]             = "viet1252"
    Locale["vi"]["script"]             = "Latn"

    #87 Welsh
    Locale["cy"]["name"]               = "Welsh"
    Locale["cy"]["endonym"]            = "Cymraeg"
    Locale["cy"]["translations-of"]    = "Cyfieithiadau %s"
    Locale["cy"]["definitions-of"]     = "Diffiniadau %s"
    Locale["cy"]["synonyms"]           = "Cyfystyron"
    Locale["cy"]["examples"]           = "Enghreifftiau"
    Locale["cy"]["see-also"]           = "Gweler hefyd"
    Locale["cy"]["family"]             = "Indo-European"
    Locale["cy"]["iso"]                = "cym"
    Locale["cy"]["glotto"]             = "wels1247"
    Locale["cy"]["script"]             = "Latn"

    #88 Yiddish
    Locale["yi"]["name"]               = "Yiddish"
    Locale["yi"]["endonym"]            = "ייִדיש"
    Locale["yi"]["translations-of"]    = "איבערזעצונגען פון %s"
    Locale["yi"]["definitions-of"]     = "דפיניציונען %s"
    Locale["yi"]["synonyms"]           = "סינאָנימען"
    Locale["yi"]["examples"]           = "ביישפילע"
    Locale["yi"]["see-also"]           = "זייען אויך"
    Locale["yi"]["family"]             = "Indo-European"
    Locale["yi"]["iso"]                = "yid"
    Locale["yi"]["glotto"]             = "yidd1255"
    Locale["yi"]["script"]             = "Hebr"
    Locale["yi"]["rtl"]                = "true" # RTL language

    #89 Yoruba
    Locale["yo"]["name"]               = "Yoruba"
    Locale["yo"]["endonym"]            = "Yorùbá"
    Locale["yo"]["translations-of"]    = "Awọn itumọ ti %s"
    Locale["yo"]["definitions-of"]     = "Awọn itumọ ti %s"
    Locale["yo"]["synonyms"]           = "Awọn ọrọ onitumọ"
    Locale["yo"]["examples"]           = "Awọn apẹrẹ"
    Locale["yo"]["see-also"]           = "Tun wo"
    Locale["yo"]["family"]             = "Atlantic-Congo"
    Locale["yo"]["iso"]                = "yor"
    Locale["yo"]["glotto"]             = "yoru1245"
    Locale["yo"]["script"]             = "Latn"

    #90 Zulu
    Locale["zu"]["name"]               = "Zulu"
    Locale["zu"]["endonym"]            = "isiZulu"
    Locale["zu"]["translations-of"]    = "Ukuhumusha i-%s"
    Locale["zu"]["definitions-of"]     = "Izincazelo ze-%s"
    Locale["zu"]["synonyms"]           = "Amagama afanayo"
    Locale["zu"]["examples"]           = "Izibonelo"
    Locale["zu"]["see-also"]           = "Bheka futhi"
    Locale["zu"]["family"]             = "Atlantic-Congo"
    Locale["zu"]["iso"]                = "zul"
    Locale["zu"]["glotto"]             = "zulu1248"
    Locale["zu"]["script"]             = "Latn"

    #* Hmong Daw
    Locale["mww"]["support"]           = "bing-only"
    Locale["mww"]["name"]              = "Hmong Daw"
    Locale["mww"]["endonym"]           = "Hmoob Daw"
    Locale["mww"]["family"]            = "Hmong-Mien"
    Locale["mww"]["iso"]               = "mww"
    Locale["mww"]["glotto"]            = "hmon1333"
    Locale["mww"]["script"]            = "Latn"

    #* Querétaro Otomi
    Locale["otq"]["support"]           = "bing-only"
    Locale["otq"]["name"]              = "Querétaro Otomi"
    Locale["otq"]["endonym"]           = "Hñąñho"
    Locale["otq"]["family"]            = "Oto-Manguean"
    Locale["otq"]["iso"]               = "otq"
    Locale["otq"]["glotto"]            = "quer1236"
    Locale["otq"]["script"]            = "Latn"

    #* Yucatec Maya
    Locale["yua"]["support"]           = "bing-only"
    Locale["yua"]["name"]              = "Yucatec Maya"
    Locale["yua"]["endonym"]           = "Màaya T'àan"
    Locale["yua"]["family"]            = "Mayan"
    Locale["yua"]["iso"]               = "yua"
    Locale["yua"]["glotto"]            = "yuca1254"
    Locale["yua"]["script"]            = "Latn"

    #* Klingon, Latin alphabet
    Locale["tlh"]["support"]           = "bing-only"
    Locale["tlh"]["name"]              = "Klingon"
    Locale["tlh"]["endonym"]           = "tlhIngan Hol"
    Locale["tlh"]["family"]            = "Artificial Language"
    Locale["tlh"]["iso"]               = "tlh"
    #Locale["tlh"]["glotto"]
    Locale["tlh"]["script"]            = "Latn"

    #* Klingon, pIqaD
    Locale["tlh-Qaak"]["support"]      = "bing-only"
    Locale["tlh-Qaak"]["name"]         = "Klingon (pIqaD)"
    Locale["tlh-Qaak"]["endonym"]      = " "
    Locale["tlh-Qaak"]["family"]       = "Artificial Language"
    Locale["tlh-Qaak"]["iso"]          = "tlh"
    #Locale["tlh-Qaak"]["glotto"]
    Locale["tlh-Qaak"]["script"]       = "Piqd"

    for (i in Locale) {
        # Initialize strings for displaying endonyms of locales
        Locale[i]["display"] = show(Locale[i]["endonym"], i)

        # ISO 639-3 codes as aliases
        LocaleAlias[Locale[i]["iso"]] = i

        # Names and endonyms as aliases
        LocaleAlias[tolower(Locale[i]["name"])] = i
        LocaleAlias[tolower(Locale[i]["endonym"])] = i
    }

    # Other aliases
    # See: <http://www.loc.gov/standards/iso639-2/php/code_changes.php>
    LocaleAlias["in"] = "id" # withdrawn language code for Indonesian
    LocaleAlias["iw"] = "he" # withdrawn language code for Hebrew
    LocaleAlias["ji"] = "yi" # withdrawn language code for Yiddish
    LocaleAlias["jw"] = "jv" # withdrawn language code for Javanese
    LocaleAlias["mo"] = "ro" # Moldavian or Moldovan considered a variant of the Romanian language
    LocaleAlias["nb"] = "no" # Google Translate does not distinguish between Bokmål and Nynorsk
    LocaleAlias["nn"] = "no"
    LocaleAlias["sh"]      = "sr-Cyrl" # Serbo-Croatian: default to Serbian
    LocaleAlias["sr"]      = "sr-Cyrl" # Serbian: default to Serbian Cyrillic
    LocaleAlias["srp"]     = "sr-Cyrl"
    LocaleAlias["serbian"] = "sr-Cyrl"
    LocaleAlias["zh"]      = "zh-CN" # Chinese: default to Chinese Simplified
    LocaleAlias["zh-CHS"]  = "zh-CN"
    LocaleAlias["zh-CHT"]  = "zh-TW"
    LocaleAlias["zho"]     = "zh-CN"
    LocaleAlias["chinese"] = "zh-CN"
    LocaleAlias["tlh-Latn"] = "tlh"
    LocaleAlias["tlh-Piqd"] = "tlh-Qaak"
    # TODO: more aliases
}

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
    case "Mlym": return "Malayalam"
    case "Mymr": return "Myanmar"
    case "Orya": return "Oriya"
    case "Piqd": return "Klingon (pIqaD)"
    case "Sinh": return "Sinhala"
    case "Taml": return "Tamil"
    case "Telu": return "Telugu"
    case "Thai": return "Thai"
    case "Tibt": return "Tibetan"
    default: return "Unknown"
    }
}

# Return detailed information of a language as a string.
function getDetails(code,    group, iso, language, script) {
    if (code == "auto" || !getCode(code)) {
        e("[ERROR] Language not found: " code "\n"                      \
          "        Run '-reference / -R' to see a list of available languages.")
        exit 1
    }

    script = scriptName(getScript(code))
    if (isRTL(code)) script = script " (R-to-L)"
    split(getISO(code), group, "-")
    iso = group[1]
    split(getName(code), group, " ")
    language = length(group) == 1 ? group[1] "_language" :
        group[2] ~ /^\(.*\)$/ ? group[1] "_language" : join(group, "_")
    return ansi("bold", sprintf("%s\n", getDisplay(code)))              \
        sprintf("%-22s%s\n", "Name", ansi("bold", getName(code)))       \
        sprintf("%-22s%s\n", "Family", ansi("bold", getFamily(code)))   \
        sprintf("%-22s%s\n", "Writing system", ansi("bold", script))    \
        sprintf("%-22s%s\n", "Code", ansi("bold", getCode(code)))       \
        sprintf("%-22s%s\n", "ISO 639-3", ansi("bold", iso))            \
        sprintf("%-22s%s\n", "SIL", ansi("bold", "http://www-01.sil.org/iso639-3/documentation.asp?id=" iso)) \
        sprintf("%-22s%s\n", "Glottolog", getGlotto(code) ?
                ansi("bold", "http://glottolog.org/resource/languoid/id/" getGlotto(code)) : "") \
        sprintf("%-22s%s", "Wikipedia", ansi("bold", "http://en.wikipedia.org/wiki/" language))
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
function show(text, code,    temp) {
    if (!code || isRTL(code)) {
        if (Cache[text][0])
            return Cache[text][0]
        else {
            if ((FriBidi || (code && isRTL(code))) && BiDiNoPad)
                ("echo " parameterize(text) PIPE BiDiNoPad) | getline temp
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
    if (!code || isRTL(code)) {
        if (!width) width = Option["width"]
        if (Cache[text][width])
            return Cache[text][width]
        else {
            if ((FriBidi || (code && isRTL(code))) && BiDi)
                ("echo " parameterize(text) PIPE sprintf(BiDi, width)) | getline temp
            else # non-RTL language, or FriBidi not installed
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
    if (lang = ENVIRON["LANGUAGE"]) {
        if (!UserLocale) UserLocale = lang
        utf = utf || tolower(lang) ~ /utf-?8$/
    }
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
