
# Return version as a string.
function getVersion() {
    return Name " " Version
}

# Compare indices.
# Used by: getCodeReference()
function codeComparison(i1, v1, i2, v2) {
    return i1 > i2
}

# Compare "name" values.
# Used by: getCodeReference()
function nameComparison(i1, v1, i2, v2) {
    return "name" in v1 ? v1["name"] > v2["name"] : 0
}

# Compare "relevance" values.
# Used by: getTranslation()
function relevanceComparison(i1, v1, i2, v2) {
    return "relevance" in v1 ? v1["relevance"] < v2["relevance"] : 0
}

# Return code reference list as a string.
# Parameters:
#     sortBy = "name" or "code"
function getCodeReference(sortBy,    i, r, saveSortedIn) {
    r = sprintf("%10s  %-20s %s\n", "[code]", "[language]", "[endonym]")
    r = r "    ─────────────────────────────────────────────" "\n"
    saveSortedIn = PROCINFO["sorted_in"]
    PROCINFO["sorted_in"] = sortBy "Comparison"
    for (i in Locale)
        r = r sprintf(AnsiCode["bold"] "%10s" AnsiCode["no bold"] "  %-20s %s\n", i, Locale[i]["name"], Locale[i]["display"], i)
    r = r "    ─────────────────────────────────────────────"
    PROCINFO["sorted_in"] = saveSortedIn
    return r
}

# Return code reference table as a string.
# Parameters:
#     displayName = "endonym" or "name"
function getCodeReferenceTable(displayName) {
    if (displayName == "name")
        return "┌─────────────────────────────┬──────────────────────┬─────────────────┐\n" \
            "│ " Locale["af"]["name"] "           - " AnsiCode["bold"] "af" AnsiCode["no bold"] "    │ " Locale["el"]["name"] "          - " AnsiCode["bold"] "el" AnsiCode["no bold"] "  │ " Locale["mn"]["name"] "  - " AnsiCode["bold"] "mn" AnsiCode["no bold"] " │\n" \
            "│ " Locale["sq"]["name"] "            - " AnsiCode["bold"] "sq" AnsiCode["no bold"] "    │ " Locale["gu"]["name"] "       - " AnsiCode["bold"] "gu" AnsiCode["no bold"] "  │ " Locale["ne"]["name"] "     - " AnsiCode["bold"] "ne" AnsiCode["no bold"] " │\n" \
            "│ " Locale["ar"]["name"] "              - " AnsiCode["bold"] "ar" AnsiCode["no bold"] "    │ " Locale["ht"]["name"] " - " AnsiCode["bold"] "ht" AnsiCode["no bold"] "  │ " Locale["no"]["name"] "  - " AnsiCode["bold"] "no" AnsiCode["no bold"] " │\n" \
            "│ " Locale["hy"]["name"] "            - " AnsiCode["bold"] "hy" AnsiCode["no bold"] "    │ " Locale["ha"]["name"] "          - " AnsiCode["bold"] "ha" AnsiCode["no bold"] "  │ " Locale["fa"]["name"] "    - " AnsiCode["bold"] "fa" AnsiCode["no bold"] " │\n" \
            "│ " Locale["az"]["name"] "         - " AnsiCode["bold"] "az" AnsiCode["no bold"] "    │ " Locale["he"]["name"] "         - " AnsiCode["bold"] "he" AnsiCode["no bold"] "  │ " Locale["pl"]["name"] "     - " AnsiCode["bold"] "pl" AnsiCode["no bold"] " │\n" \
            "│ " Locale["eu"]["name"] "              - " AnsiCode["bold"] "eu" AnsiCode["no bold"] "    │ " Locale["hi"]["name"] "          - " AnsiCode["bold"] "hi" AnsiCode["no bold"] "  │ " Locale["pt"]["name"] " - " AnsiCode["bold"] "pt" AnsiCode["no bold"] " │\n" \
            "│ " Locale["be"]["name"] "          - " AnsiCode["bold"] "be" AnsiCode["no bold"] "    │ " Locale["hmn"]["name"] "          - " AnsiCode["bold"] "hmn" AnsiCode["no bold"] " │ " Locale["pa"]["name"] "    - " AnsiCode["bold"] "pa" AnsiCode["no bold"] " │\n" \
            "│ " Locale["bn"]["name"] "             - " AnsiCode["bold"] "bn" AnsiCode["no bold"] "    │ " Locale["hu"]["name"] "      - " AnsiCode["bold"] "hu" AnsiCode["no bold"] "  │ " Locale["ro"]["name"] "   - " AnsiCode["bold"] "ro" AnsiCode["no bold"] " │\n" \
            "│ " Locale["bs"]["name"] "             - " AnsiCode["bold"] "bs" AnsiCode["no bold"] "    │ " Locale["is"]["name"] "      - " AnsiCode["bold"] "is" AnsiCode["no bold"] "  │ " Locale["ru"]["name"] "    - " AnsiCode["bold"] "ru" AnsiCode["no bold"] " │\n" \
            "│ " Locale["bg"]["name"] "           - " AnsiCode["bold"] "bg" AnsiCode["no bold"] "    │ " Locale["ig"]["name"] "           - " AnsiCode["bold"] "ig" AnsiCode["no bold"] "  │ " Locale["sr"]["name"] "    - " AnsiCode["bold"] "sr" AnsiCode["no bold"] " │\n" \
            "│ " Locale["ca"]["name"] "             - " AnsiCode["bold"] "ca" AnsiCode["no bold"] "    │ " Locale["id"]["name"] "     - " AnsiCode["bold"] "id" AnsiCode["no bold"] "  │ " Locale["sk"]["name"] "     - " AnsiCode["bold"] "sk" AnsiCode["no bold"] " │\n" \
            "│ " Locale["ceb"]["name"] "             - " AnsiCode["bold"] "ceb" AnsiCode["no bold"] "   │ " Locale["ga"]["name"] "          - " AnsiCode["bold"] "ga" AnsiCode["no bold"] "  │ " Locale["sl"]["name"] "  - " AnsiCode["bold"] "sl" AnsiCode["no bold"] " │\n" \
            "│ " Locale["zh-CN"]["name"] "  - " AnsiCode["bold"] "zh-CN" AnsiCode["no bold"] " │ " Locale["it"]["name"] "        - " AnsiCode["bold"] "it" AnsiCode["no bold"] "  │ " Locale["so"]["name"] "     - " AnsiCode["bold"] "so" AnsiCode["no bold"] " │\n" \
            "│ " Locale["zh-TW"]["name"] " - " AnsiCode["bold"] "zh-TW" AnsiCode["no bold"] " │ " Locale["ja"]["name"] "       - " AnsiCode["bold"] "ja" AnsiCode["no bold"] "  │ " Locale["es"]["name"] "    - " AnsiCode["bold"] "es" AnsiCode["no bold"] " │\n" \
            "│ " Locale["hr"]["name"] "            - " AnsiCode["bold"] "hr" AnsiCode["no bold"] "    │ " Locale["jv"]["name"] "       - " AnsiCode["bold"] "jv" AnsiCode["no bold"] "  │ " Locale["sw"]["name"] "    - " AnsiCode["bold"] "sw" AnsiCode["no bold"] " │\n" \
            "│ " Locale["cs"]["name"] "               - " AnsiCode["bold"] "cs" AnsiCode["no bold"] "    │ " Locale["kn"]["name"] "        - " AnsiCode["bold"] "kn" AnsiCode["no bold"] "  │ " Locale["sv"]["name"] "    - " AnsiCode["bold"] "sv" AnsiCode["no bold"] " │\n" \
            "│ " Locale["da"]["name"] "              - " AnsiCode["bold"] "da" AnsiCode["no bold"] "    │ " Locale["km"]["name"] "          - " AnsiCode["bold"] "km" AnsiCode["no bold"] "  │ " Locale["ta"]["name"] "      - " AnsiCode["bold"] "ta" AnsiCode["no bold"] " │\n" \
            "│ " Locale["nl"]["name"] "               - " AnsiCode["bold"] "nl" AnsiCode["no bold"] "    │ " Locale["ko"]["name"] "         - " AnsiCode["bold"] "ko" AnsiCode["no bold"] "  │ " Locale["te"]["name"] "     - " AnsiCode["bold"] "te" AnsiCode["no bold"] " │\n" \
            "│ " Locale["en"]["name"] "             - " AnsiCode["bold"] "en" AnsiCode["no bold"] "    │ " Locale["lo"]["name"] "            - " AnsiCode["bold"] "lo" AnsiCode["no bold"] "  │ " Locale["th"]["name"] "       - " AnsiCode["bold"] "th" AnsiCode["no bold"] " │\n" \
            "│ " Locale["eo"]["name"] "           - " AnsiCode["bold"] "eo" AnsiCode["no bold"] "    │ " Locale["la"]["name"] "          - " AnsiCode["bold"] "la" AnsiCode["no bold"] "  │ " Locale["tr"]["name"] "    - " AnsiCode["bold"] "tr" AnsiCode["no bold"] " │\n" \
            "│ " Locale["et"]["name"] "            - " AnsiCode["bold"] "et" AnsiCode["no bold"] "    │ " Locale["lv"]["name"] "        - " AnsiCode["bold"] "lv" AnsiCode["no bold"] "  │ " Locale["uk"]["name"] "  - " AnsiCode["bold"] "uk" AnsiCode["no bold"] " │\n" \
            "│ " Locale["tl"]["name"] "            - " AnsiCode["bold"] "tl" AnsiCode["no bold"] "    │ " Locale["lt"]["name"] "     - " AnsiCode["bold"] "lt" AnsiCode["no bold"] "  │ " Locale["ur"]["name"] "       - " AnsiCode["bold"] "ur" AnsiCode["no bold"] " │\n" \
            "│ " Locale["fi"]["name"] "             - " AnsiCode["bold"] "fi" AnsiCode["no bold"] "    │ " Locale["mk"]["name"] "     - " AnsiCode["bold"] "mk" AnsiCode["no bold"] "  │ " Locale["vi"]["name"] " - " AnsiCode["bold"] "vi" AnsiCode["no bold"] " │\n" \
            "│ " Locale["fr"]["name"] "              - " AnsiCode["bold"] "fr" AnsiCode["no bold"] "    │ " Locale["ms"]["name"] "          - " AnsiCode["bold"] "ms" AnsiCode["no bold"] "  │ " Locale["cy"]["name"] "      - " AnsiCode["bold"] "cy" AnsiCode["no bold"] " │\n" \
            "│ " Locale["gl"]["name"] "            - " AnsiCode["bold"] "gl" AnsiCode["no bold"] "    │ " Locale["mt"]["name"] "        - " AnsiCode["bold"] "mt" AnsiCode["no bold"] "  │ " Locale["yi"]["name"] "    - " AnsiCode["bold"] "yi" AnsiCode["no bold"] " │\n" \
            "│ " Locale["ka"]["name"] "            - " AnsiCode["bold"] "ka" AnsiCode["no bold"] "    │ " Locale["mi"]["name"] "          - " AnsiCode["bold"] "mi" AnsiCode["no bold"] "  │ " Locale["yo"]["name"] "     - " AnsiCode["bold"] "yo" AnsiCode["no bold"] " │\n" \
            "│ " Locale["de"]["name"] "              - " AnsiCode["bold"] "de" AnsiCode["no bold"] "    │ " Locale["mr"]["name"] "        - " AnsiCode["bold"] "mr" AnsiCode["no bold"] "  │ " Locale["zu"]["name"] "       - " AnsiCode["bold"] "zu" AnsiCode["no bold"] " │\n" \
            "└─────────────────────────────┴──────────────────────┴─────────────────┘"
    else
        return "┌────────────────────┬────────────────────────┬─────────────────────┐\n" \
            "│ " Locale["af"]["display"] "    - " AnsiCode["bold"] "af" AnsiCode["no bold"] "  │ " Locale["hi"]["display"] "            - " AnsiCode["bold"] "hi" AnsiCode["no bold"] "  │ " Locale["nl"]["display"] "  - " AnsiCode["bold"] "nl" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["ar"]["display"] "      - " AnsiCode["bold"] "ar" AnsiCode["no bold"] "  │ " Locale["hmn"]["display"] "            - " AnsiCode["bold"] "hmn" AnsiCode["no bold"] " │ " Locale["no"]["display"] "       - " AnsiCode["bold"] "no" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["az"]["display"] " - " AnsiCode["bold"] "az" AnsiCode["no bold"] "  │ " Locale["hr"]["display"] "         - " AnsiCode["bold"] "hr" AnsiCode["no bold"] "  │ " Locale["pa"]["display"] "       - " AnsiCode["bold"] "pa" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["be"]["display"] "   - " AnsiCode["bold"] "be" AnsiCode["no bold"] "  │ " Locale["ht"]["display"] "   - " AnsiCode["bold"] "ht" AnsiCode["no bold"] "  │ " Locale["pl"]["display"] "      - " AnsiCode["bold"] "pl" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["bg"]["display"] "    - " AnsiCode["bold"] "bg" AnsiCode["no bold"] "  │ " Locale["hu"]["display"] "           - " AnsiCode["bold"] "hu" AnsiCode["no bold"] "  │ " Locale["pt"]["display"] "   - " AnsiCode["bold"] "pt" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["bn"]["display"] "        - " AnsiCode["bold"] "bn" AnsiCode["no bold"] "  │ " Locale["hy"]["display"] "          - " AnsiCode["bold"] "hy" AnsiCode["no bold"] "  │ " Locale["ro"]["display"] "      - " AnsiCode["bold"] "ro" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["bs"]["display"] "     - " AnsiCode["bold"] "bs" AnsiCode["no bold"] "  │ " Locale["id"]["display"] " - " AnsiCode["bold"] "id" AnsiCode["no bold"] "  │ " Locale["ru"]["display"] "     - " AnsiCode["bold"] "ru" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["ca"]["display"] "       - " AnsiCode["bold"] "ca" AnsiCode["no bold"] "  │ " Locale["ig"]["display"] "             - " AnsiCode["bold"] "ig" AnsiCode["no bold"] "  │ " Locale["sk"]["display"] "  - " AnsiCode["bold"] "sk" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["ceb"]["display"] "      - " AnsiCode["bold"] "ceb" AnsiCode["no bold"] " │ " Locale["is"]["display"] "         - " AnsiCode["bold"] "is" AnsiCode["no bold"] "  │ " Locale["sl"]["display"] " - " AnsiCode["bold"] "sl" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["cs"]["display"] "      - " AnsiCode["bold"] "cs" AnsiCode["no bold"] "  │ " Locale["it"]["display"] "         - " AnsiCode["bold"] "it" AnsiCode["no bold"] "  │ " Locale["so"]["display"] "    - " AnsiCode["bold"] "so" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["cy"]["display"] "      - " AnsiCode["bold"] "cy" AnsiCode["no bold"] "  │ " Locale["ja"]["display"] "           - " AnsiCode["bold"] "ja" AnsiCode["no bold"] "  │ " Locale["sq"]["display"] "       - " AnsiCode["bold"] "sq" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["da"]["display"] "        - " AnsiCode["bold"] "da" AnsiCode["no bold"] "  │ " Locale["jv"]["display"] "        - " AnsiCode["bold"] "jv" AnsiCode["no bold"] "  │ " Locale["sr"]["display"] "      - " AnsiCode["bold"] "sr" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["de"]["display"] "      - " AnsiCode["bold"] "de" AnsiCode["no bold"] "  │ " Locale["ka"]["display"] "          - " AnsiCode["bold"] "ka" AnsiCode["no bold"] "  │ " Locale["sv"]["display"] "     - " AnsiCode["bold"] "sv" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["el"]["display"] "     - " AnsiCode["bold"] "el" AnsiCode["no bold"] "  │ " Locale["km"]["display"] "         - " AnsiCode["bold"] "km" AnsiCode["no bold"] "  │ " Locale["sw"]["display"] "   - " AnsiCode["bold"] "sw" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["en"]["display"] "      - " AnsiCode["bold"] "en" AnsiCode["no bold"] "  │ " Locale["kn"]["display"] "             - " AnsiCode["bold"] "kn" AnsiCode["no bold"] "  │ " Locale["ta"]["display"] "        - " AnsiCode["bold"] "ta" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["eo"]["display"] "    - " AnsiCode["bold"] "eo" AnsiCode["no bold"] "  │ " Locale["ko"]["display"] "           - " AnsiCode["bold"] "ko" AnsiCode["no bold"] "  │ " Locale["te"]["display"] "       - " AnsiCode["bold"] "te" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["es"]["display"] "      - " AnsiCode["bold"] "es" AnsiCode["no bold"] "  │ " Locale["la"]["display"] "           - " AnsiCode["bold"] "la" AnsiCode["no bold"] "  │ " Locale["th"]["display"] "         - " AnsiCode["bold"] "th" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["et"]["display"] "        - " AnsiCode["bold"] "et" AnsiCode["no bold"] "  │ " Locale["lo"]["display"] "              - " AnsiCode["bold"] "lo" AnsiCode["no bold"] "  │ " Locale["tl"]["display"] "     - " AnsiCode["bold"] "tl" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["eu"]["display"] "      - " AnsiCode["bold"] "eu" AnsiCode["no bold"] "  │ " Locale["lt"]["display"] "         - " AnsiCode["bold"] "lt" AnsiCode["no bold"] "  │ " Locale["tr"]["display"] "      - " AnsiCode["bold"] "tr" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["fa"]["display"] "        - " AnsiCode["bold"] "fa" AnsiCode["no bold"] "  │ " Locale["lv"]["display"] "         - " AnsiCode["bold"] "lv" AnsiCode["no bold"] "  │ " Locale["uk"]["display"] "  - " AnsiCode["bold"] "uk" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["fi"]["display"] "        - " AnsiCode["bold"] "fi" AnsiCode["no bold"] "  │ " Locale["mi"]["display"] "            - " AnsiCode["bold"] "mi" AnsiCode["no bold"] "  │ " Locale["ur"]["display"] "        - " AnsiCode["bold"] "ur" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["fr"]["display"] "     - " AnsiCode["bold"] "fr" AnsiCode["no bold"] "  │ " Locale["mk"]["display"] "       - " AnsiCode["bold"] "mk" AnsiCode["no bold"] "  │ " Locale["vi"]["display"] "  - " AnsiCode["bold"] "vi" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["ga"]["display"] "      - " AnsiCode["bold"] "ga" AnsiCode["no bold"] "  │ " Locale["mn"]["display"] "           - " AnsiCode["bold"] "mn" AnsiCode["no bold"] "  │ " Locale["yi"]["display"] "       - " AnsiCode["bold"] "yi" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["gl"]["display"] "       - " AnsiCode["bold"] "gl" AnsiCode["no bold"] "  │ " Locale["mr"]["display"] "            - " AnsiCode["bold"] "mr" AnsiCode["no bold"] "  │ " Locale["yo"]["display"] "      - " AnsiCode["bold"] "yo" AnsiCode["no bold"] "    │\n" \
            "│ " Locale["gu"]["display"] "       - " AnsiCode["bold"] "gu" AnsiCode["no bold"] "  │ " Locale["ms"]["display"] "    - " AnsiCode["bold"] "ms" AnsiCode["no bold"] "  │ " Locale["zh-CN"]["display"] "    - " AnsiCode["bold"] "zh-CN" AnsiCode["no bold"] " │\n" \
            "│ " Locale["ha"]["display"] "        - " AnsiCode["bold"] "ha" AnsiCode["no bold"] "  │ " Locale["mt"]["display"] "            - " AnsiCode["bold"] "mt" AnsiCode["no bold"] "  │ " Locale["zh-TW"]["display"] "    - " AnsiCode["bold"] "zh-TW" AnsiCode["no bold"] " │\n" \
            "│ " Locale["he"]["display"] "        - " AnsiCode["bold"] "he" AnsiCode["no bold"] "  │ " Locale["ne"]["display"] "            - " AnsiCode["bold"] "ne" AnsiCode["no bold"] "  │ " Locale["zu"]["display"] "     - " AnsiCode["bold"] "zu" AnsiCode["no bold"] "    │\n" \
            "└────────────────────┴────────────────────────┴─────────────────────┘"
}

# Return help as a string.
# Parameters:
#     displayName = "endonym" or "name"
function getHelp(displayName) {
    return "Usage: translate {[source]=[target]} text ...\n" \
        "       translate {[source]=[target1]+[target2]+...} text ...\n" \
        "       translate text ...\n\n" \
        "Language codes for [source] and [target]:\n" getCodeReferenceTable(displayName)
}
