####################################################################
# Help.awk                                                         #
####################################################################

# Return version as a string.
function getVersion(    build, gitHead) {
    if (ENVIRON["TRANS_BUILD"])
        build = "-" ENVIRON["TRANS_BUILD"]
    else {
        gitHead = getGitHead()
        build = gitHead ? "-git:" gitHead : ""
    }

    return sprintf(ansi("bold", "%-22s%s%s") "\n\n", Name, Version, build) \
        sprintf("%-22s%s\n", "gawk (GNU Awk)", PROCINFO["version"])     \
        sprintf("%s\n", FriBidi ? FriBidi : "fribidi (GNU FriBidi) [NOT INSTALLED]") \
        sprintf("%-22s%s\n", "terminal type", ENVIRON["TERM"])          \
        sprintf("%-22s%s (%s)\n", "user locale", UserLocale, getName(UserLang)) \
        sprintf("%-22s%s\n", "home language", Option["hl"])             \
        sprintf("%-22s%s\n", "source language", Option["sl"])           \
        sprintf("%-22s%s\n", "target language", join(Option["tl"], "+")) \
        sprintf("%-22s%s\n", "theme", Option["theme"])                  \
        sprintf("%-22s%s\n", "init file", InitScript ? InitScript : "[NONE]") \
        sprintf("\n%-22s%s", "Report bugs to:", "https://github.com/soimort/translate-shell/issues")
}

# Return help message as a string.
function getHelp() {
    return "Usage:  " ansi("bold", Command)                             \
        " [" ansi("underline", "OPTIONS") "]"                           \
        " [" ansi("underline", "SOURCE") "]"                            \
        ":[" ansi("underline", "TARGETS") "]"                           \
        " [" ansi("underline", "TEXT") "]..." RS                        \
        RS "Information options:" RS                                    \
        ins(1, ansi("bold", "-V") ", " ansi("bold", "-version")) RS     \
        ins(2, "Print version and exit.") RS                            \
        ins(1, ansi("bold", "-H") ", " ansi("bold", "-help")) RS        \
        ins(2, "Print help message and exit.") RS                       \
        ins(1, ansi("bold", "-M") ", " ansi("bold", "-man")) RS         \
        ins(2, "Show man page and exit.") RS                            \
        ins(1, ansi("bold", "-T") ", " ansi("bold", "-reference")) RS   \
        ins(2, "Print reference table of languages and exit.") RS       \
        ins(1, ansi("bold", "-R") ", " ansi("bold", "-reference-english")) RS \
        ins(2, "Print reference table of languages (in English names) and exit.") RS \
        ins(1, ansi("bold", "-L ") ansi("underline", "CODES")           \
            ", " ansi("bold", "-list ") ansi("underline", "CODES")) RS  \
        ins(2, "Print details of languages and exit.") RS               \
        ins(1, ansi("bold", "-U") ", " ansi("bold", "-upgrade")) RS     \
        ins(2, "Upgrade this program to latest version.") RS            \
        RS "Display options:" RS                                        \
        ins(1, ansi("bold", "-verbose")) RS                             \
        ins(2, "Verbose mode. (default)") RS                            \
        ins(1, ansi("bold", "-b") ", " ansi("bold", "-brief")) RS       \
        ins(2, "Brief mode.") RS                                        \
        ins(1, ansi("bold", "-d") ", " ansi("bold", "-dictionary")) RS  \
        ins(2, "Dictionary mode.") RS                                   \
        ins(1, ansi("bold", "-show-original ") ansi("underline", "Y/n")) RS \
        ins(2, "Show original text or not.") RS                         \
        ins(1, ansi("bold", "-show-original-phonetics ") ansi("underline", "Y/n")) RS \
        ins(2, "Show phonetic notation of original text or not.") RS    \
        ins(1, ansi("bold", "-show-translation ") ansi("underline", "Y/n")) RS \
        ins(2, "Show translation or not.") RS                           \
        ins(1, ansi("bold", "-show-translation-phonetics ") ansi("underline", "Y/n")) RS \
        ins(2, "Show phonetic notation of translation or not.") RS      \
        ins(1, ansi("bold", "-show-prompt-message ") ansi("underline", "Y/n")) RS \
        ins(2, "Show prompt message or not.") RS                        \
        ins(1, ansi("bold", "-show-languages ") ansi("underline", "Y/n")) RS \
        ins(2, "Show source and target languages or not.") RS           \
        ins(1, ansi("bold", "-show-original-dictionary ") ansi("underline", "y/N")) RS \
        ins(2, "Show dictionary entry of original text or not.") RS     \
        ins(1, ansi("bold", "-show-dictionary ") ansi("underline", "Y/n")) RS \
        ins(2, "Show dictionary entry of translation or not.") RS       \
        ins(1, ansi("bold", "-show-alternatives ") ansi("underline", "Y/n")) RS \
        ins(2, "Show alternative translations or not.") RS              \
        ins(1, ansi("bold", "-w ") ansi("underline", "NUM")             \
            ", " ansi("bold", "-width ") ansi("underline", "NUM")) RS   \
        ins(2, "Specify the screen width for padding.") RS              \
        ins(1, ansi("bold", "-indent ") ansi("underline", "NUM")) RS    \
        ins(2, "Specify the size of indent (number of spaces).") RS     \
        ins(1, ansi("bold", "-no-ansi")) RS                             \
        ins(2, "Do not use ANSI escape codes.") RS                      \
        ins(1, ansi("bold", "-no-theme")) RS                            \
        ins(2, "Do not use any other theme than default.") RS           \
        ins(1, ansi("bold", "-theme ") ansi("underline", "FILENAME")) RS \
        ins(2, "Specify the theme to use.") RS                          \
        RS "Audio options:" RS                                          \
        ins(1, ansi("bold", "-no-play")) RS                             \
        ins(2, "Do not listen to the translation.") RS                  \
        ins(1, ansi("bold", "-p, -play")) RS                            \
        ins(2, "Listen to the translation.") RS                         \
        ins(1, ansi("bold", "-player ") ansi("underline", "PROGRAM")) RS \
        ins(2, "Specify the audio player to use, and listen to the translation.") RS \
        RS "Terminal paging and browsing options:" RS                   \
        ins(1, ansi("bold", "-no-view")) RS                             \
        ins(2, "Do not view the translation in a terminal pager.") RS   \
        ins(1, ansi("bold", "-v") ", " ansi("bold", "-view")) RS        \
        ins(2, "View the translation in a terminal pager.") RS          \
        ins(1, ansi("bold", "-pager ") ansi("underline", "PROGRAM")) RS \
        ins(2, "Specify the terminal pager to use, and view the translation.") RS \
        ins(1, ansi("bold", "-browser ") ansi("underline", "PROGRAM")) RS \
        ins(2, "Specify the web browser to use.") RS                    \
        RS "Networking options:" RS                                     \
        ins(1, ansi("bold", "-x ") ansi("underline", "HOST:PORT")       \
            ", " ansi("bold", "-proxy ") ansi("underline", "HOST:PORT")) RS \
        ins(2, "Use HTTP proxy on given port.") RS                      \
        ins(1, ansi("bold", "-u ") ansi("underline", "STRING")          \
            ", " ansi("bold", "-user-agent ") ansi("underline", "STRING")) RS \
        ins(2, "Specify the User-Agent to identify as.") RS             \
        RS "Interactive shell options:" RS                              \
        ins(1, ansi("bold", "-no-rlwrap")) RS                           \
        ins(2, "Do not invoke rlwrap when starting an interactive shell.") RS \
        ins(1, ansi("bold", "-I") ", " ansi("bold", "-interactive") ", " ansi("bold", "-shell")) RS \
        ins(2, "Start an interactive shell.") RS                        \
        ins(1, ansi("bold", "-E") ", " ansi("bold", "-emacs")) RS       \
        ins(2, "Start the GNU Emacs front-end for an interactive shell.") RS \
        RS "I/O options:" RS                                            \
        ins(1, ansi("bold", "-i ") ansi("underline", "FILENAME")        \
            ", " ansi("bold", "-input ") ansi("underline", "FILENAME")) RS \
        ins(2, "Specify the input file.") RS                            \
        ins(1, ansi("bold", "-o ") ansi("underline", "FILENAME")        \
            ", " ansi("bold", "-output ") ansi("underline", "FILENAME")) RS \
        ins(2, "Specify the output file.") RS                           \
        RS "Language preference options:" RS                            \
        ins(1, ansi("bold", "-l ") ansi("underline", "CODE")            \
            ", " ansi("bold", "-lang ") ansi("underline", "CODE")) RS   \
        ins(2, "Specify your home language.") RS                        \
        ins(1, ansi("bold", "-s ") ansi("underline", "CODE")            \
            ", " ansi("bold", "-source ") ansi("underline", "CODE")) RS \
        ins(2, "Specify the source language.") RS                       \
        ins(1, ansi("bold", "-t ") ansi("underline", "CODES")           \
            ", " ansi("bold", "-target ") ansi("underline", "CODES")) RS \
        ins(2, "Specify the target language(s), joined by '+'.") RS     \
        RS "Other options:" RS                                          \
        ins(1, ansi("bold", "-no-init")) RS                             \
        ins(2, "Do not load any initialization script.") RS             \
        RS "See the man page " Command "(1) for more information."
}

# Show man page.
function showMan(    temp) {
    if (ENVIRON["TRANS_MANPAGE"]) {
        initPager()
        temp = "echo -E \"${TRANS_MANPAGE}\""
        temp = temp PIPE                                                \
            "groff -Wall -mtty-char -mandoc -Tutf8 -rLL=${COLUMNS}n -rLT=${COLUMNS}n"
        switch (Pager) {
        case "less":
            temp = temp PIPE Pager " -s -P\"\\ \\Manual page " Command "(1) line %lt (press h for help or q to quit)\""
            break
        case "most":
            temp = temp PIPE Pager " -Cs"
            break
        default: # more
            temp = temp PIPE Pager
        }
        system(temp)
    } else if (system("man " Command SUPERR))
        print getHelp()
}

# Return a reference table of languages as a string.
# Parameters:
#     displayName = "endonym" or "name"
function getReference(displayName) {
    if (displayName == "name")
        return "┌─────────────────────────────┬──────────────────────┬─────────────────┐" RS \
            "│ " getName("af") "           - " ansi("bold", "af") "    │ " \
            getName("ha") "          - " ansi("bold", "ha") "  │ "      \
            getName("fa") "    - " ansi("bold", "fa") " │" RS           \
            "│ " getName("sq") "            - " ansi("bold", "sq") "    │ " \
            getName("he") "         - " ansi("bold", "he") "  │ "       \
            getName("pl") "     - " ansi("bold", "pl") " │" RS          \
            "│ " getName("ar") "              - " ansi("bold", "ar") "    │ " \
            getName("hi") "          - " ansi("bold", "hi") "  │ "      \
            getName("pt") " - " ansi("bold", "pt") " │" RS              \
            "│ " getName("hy") "            - " ansi("bold", "hy") "    │ " \
            getName("hmn") "          - " ansi("bold", "hmn") " │ "     \
            getName("pa") "    - " ansi("bold", "pa") " │" RS           \
            "│ " getName("az") "         - " ansi("bold", "az") "    │ " \
            getName("hu") "      - " ansi("bold", "hu") "  │ "          \
            getName("ro") "   - " ansi("bold", "ro") " │" RS            \
            "│ " getName("eu") "              - " ansi("bold", "eu") "    │ " \
            getName("is") "      - " ansi("bold", "is") "  │ "          \
            getName("ru") "    - " ansi("bold", "ru") " │" RS           \
            "│ " getName("be") "          - " ansi("bold", "be") "    │ " \
            getName("ig") "           - " ansi("bold", "ig") "  │ "     \
            getName("sr") "    - " ansi("bold", "sr") " │" RS           \
            "│ " getName("bn") "             - " ansi("bold", "bn") "    │ " \
            getName("id") "     - " ansi("bold", "id") "  │ "           \
            getName("st") "    - " ansi("bold", "st") " │" RS           \
            "│ " getName("bs") "             - " ansi("bold", "bs") "    │ " \
            getName("ga") "          - " ansi("bold", "ga") "  │ "      \
            getName("si") "    - " ansi("bold", "si") " │" RS           \
            "│ " getName("bg") "           - " ansi("bold", "bg") "    │ " \
            getName("it") "        - " ansi("bold", "it") "  │ "        \
            getName("sk") "     - " ansi("bold", "sk") " │" RS          \
            "│ " getName("ca") "             - " ansi("bold", "ca") "    │ " \
            getName("ja") "       - " ansi("bold", "ja") "  │ "         \
            getName("sl") "  - " ansi("bold", "sl") " │" RS             \
            "│ " getName("ceb") "             - " ansi("bold", "ceb") "   │ " \
            getName("jv") "       - " ansi("bold", "jv") "  │ "         \
            getName("so") "     - " ansi("bold", "so") " │" RS          \
            "│ " getName("ny") "            - " ansi("bold", "ny") "    │ " \
            getName("kn") "        - " ansi("bold", "kn") "  │ "        \
            getName("es") "    - " ansi("bold", "es") " │" RS           \
            "│ " getName("zh-CN") "  - " ansi("bold", "zh-CN") " │ "    \
            getName("kk") "         - " ansi("bold", "kk") "  │ "       \
            getName("su") "  - " ansi("bold", "su") " │" RS             \
            "│ " getName("zh-TW") " - " ansi("bold", "zh-TW") " │ "     \
            getName("km") "          - " ansi("bold", "km") "  │ "      \
            getName("sw") "    - " ansi("bold", "sw") " │" RS           \
            "│ " getName("hr") "            - " ansi("bold", "hr") "    │ " \
            getName("ko") "         - " ansi("bold", "ko") "  │ "       \
            getName("sv") "    - " ansi("bold", "sv") " │" RS           \
            "│ " getName("cs") "               - " ansi("bold", "cs") "    │ " \
            getName("lo") "            - " ansi("bold", "lo") "  │ "    \
            getName("tg") "      - " ansi("bold", "tg") " │" RS         \
            "│ " getName("da") "              - " ansi("bold", "da") "    │ " \
            getName("la") "          - " ansi("bold", "la") "  │ "      \
            getName("ta") "      - " ansi("bold", "ta") " │" RS         \
            "│ " getName("nl") "               - " ansi("bold", "nl") "    │ " \
            getName("lv") "        - " ansi("bold", "lv") "  │ "        \
            getName("te") "     - " ansi("bold", "te") " │" RS          \
            "│ " getName("en") "             - " ansi("bold", "en") "    │ " \
            getName("lt") "     - " ansi("bold", "lt") "  │ "           \
            getName("th") "       - " ansi("bold", "th") " │" RS        \
            "│ " getName("eo") "           - " ansi("bold", "eo") "    │ " \
            getName("mk") "     - " ansi("bold", "mk") "  │ "           \
            getName("tr") "    - " ansi("bold", "tr") " │" RS           \
            "│ " getName("et") "            - " ansi("bold", "et") "    │ " \
            getName("mg") "       - " ansi("bold", "mg") "  │ "         \
            getName("uk") "  - " ansi("bold", "uk") " │" RS             \
            "│ " getName("tl") "            - " ansi("bold", "tl") "    │ " \
            getName("ms") "          - " ansi("bold", "ms") "  │ "      \
            getName("ur") "       - " ansi("bold", "ur") " │" RS        \
            "│ " getName("fi") "             - " ansi("bold", "fi") "    │ " \
            getName("ml") "      - " ansi("bold", "ml") "  │ "          \
            getName("uz") "      - " ansi("bold", "uz") " │" RS         \
            "│ " getName("fr") "              - " ansi("bold", "fr") "    │ " \
            getName("mt") "        - " ansi("bold", "mt") "  │ "        \
            getName("vi") " - " ansi("bold", "vi") " │" RS              \
            "│ " getName("gl") "            - " ansi("bold", "gl") "    │ " \
            getName("mi") "          - " ansi("bold", "mi") "  │ "      \
            getName("cy") "      - " ansi("bold", "cy") " │" RS         \
            "│ " getName("ka") "            - " ansi("bold", "ka") "    │ " \
            getName("mr") "        - " ansi("bold", "mr") "  │ "        \
            getName("yi") "    - " ansi("bold", "yi") " │" RS           \
            "│ " getName("de") "              - " ansi("bold", "de") "    │ " \
            getName("mn") "      - " ansi("bold", "mn") "  │ "          \
            getName("yo") "     - " ansi("bold", "yo") " │" RS          \
            "│ " getName("el") "               - " ansi("bold", "el") "    │ " \
            getName("my") "        - " ansi("bold", "my") "  │ "        \
            getName("zu") "       - " ansi("bold", "zu") " │" RS        \
            "│ " getName("gu") "            - " ansi("bold", "gu") "    │ " \
            getName("ne") "         - " ansi("bold", "ne") "  │ "       \
            "                │" RS                                      \
            "│ " getName("ht") "      - " ansi("bold", "ht") "    │ "   \
            getName("no") "      - " ansi("bold", "no") "  │ "          \
            "                │" RS                                      \
            "└─────────────────────────────┴──────────────────────┴─────────────────┘"
    else
        return "┌──────────────────────┬───────────────────────┬─────────────────────┐" RS \
            "│ " getDisplay("af") "      - " ansi("bold", "af") "  │ "  \
            getDisplay("hu") "           - " ansi("bold", "hu") " │ "   \
            getDisplay("pl") "      - " ansi("bold", "pl") "    │" RS   \
            "│ " getDisplay("ar") "        - " ansi("bold", "ar") "  │ " \
            getDisplay("hy") "          - " ansi("bold", "hy") " │ "    \
            getDisplay("pt") "   - " ansi("bold", "pt") "    │" RS      \
            "│ " getDisplay("az") "   - " ansi("bold", "az") "  │ "     \
            getDisplay("id") " - " ansi("bold", "id") " │ "             \
            getDisplay("ro") "      - " ansi("bold", "ro") "    │" RS   \
            "│ " getDisplay("be") "     - " ansi("bold", "be") "  │ "   \
            getDisplay("ig") "             - " ansi("bold", "ig") " │ " \
            getDisplay("ru") "     - " ansi("bold", "ru") "    │" RS    \
            "│ " getDisplay("bg") "      - " ansi("bold", "bg") "  │ "  \
            getDisplay("is") "         - " ansi("bold", "is") " │ "     \
            getDisplay("si") "        - " ansi("bold", "si") "    │" RS \
            "│ " getDisplay("bn") "          - " ansi("bold", "bn") "  │ " \
            getDisplay("it") "         - " ansi("bold", "it") " │ "     \
            getDisplay("sk") "  - " ansi("bold", "sk") "    │" RS       \
            "│ " getDisplay("bs") "       - " ansi("bold", "bs") "  │ " \
            getDisplay("ja") "           - " ansi("bold", "ja") " │ "   \
            getDisplay("sl") " - " ansi("bold", "sl") "    │" RS        \
            "│ " getDisplay("ca") "         - " ansi("bold", "ca") "  │ " \
            getDisplay("jv") "        - " ansi("bold", "jv") " │ "      \
            getDisplay("so") "    - " ansi("bold", "so") "    │" RS     \
            "│ " getDisplay("ceb") "        - " ansi("bold", "ceb") " │ " \
            getDisplay("ka") "          - " ansi("bold", "ka") " │ "    \
            getDisplay("sq") "       - " ansi("bold", "sq") "    │" RS  \
            "│ " getDisplay("cs") "        - " ansi("bold", "cs") "  │ " \
            getDisplay("kk") "       - " ansi("bold", "kk") " │ "       \
            getDisplay("sr") "      - " ansi("bold", "sr") "    │" RS   \
            "│ " getDisplay("cy") "        - " ansi("bold", "cy") "  │ " \
            getDisplay("km") "         - " ansi("bold", "km") " │ "     \
            getDisplay("st") "     - " ansi("bold", "st") "    │" RS    \
            "│ " getDisplay("da") "          - " ansi("bold", "da") "  │ " \
            getDisplay("kn") "             - " ansi("bold", "kn") " │ " \
            getDisplay("su") "  - " ansi("bold", "su") "    │" RS       \
            "│ " getDisplay("de") "        - " ansi("bold", "de") "  │ " \
            getDisplay("ko") "           - " ansi("bold", "ko") " │ "   \
            getDisplay("sv") "     - " ansi("bold", "sv") "    │" RS    \
            "│ " getDisplay("el") "       - " ansi("bold", "el") "  │ " \
            getDisplay("la") "           - " ansi("bold", "la") " │ "   \
            getDisplay("sw") "   - " ansi("bold", "sw") "    │" RS      \
            "│ " getDisplay("en") "        - " ansi("bold", "en") "  │ " \
            getDisplay("lo") "              - " ansi("bold", "lo") " │ " \
            getDisplay("ta") "        - " ansi("bold", "ta") "    │" RS \
            "│ " getDisplay("eo") "      - " ansi("bold", "eo") "  │ "  \
            getDisplay("lt") "         - " ansi("bold", "lt") " │ "     \
            getDisplay("te") "       - " ansi("bold", "te") "    │" RS  \
            "│ " getDisplay("es") "        - " ansi("bold", "es") "  │ " \
            getDisplay("lv") "         - " ansi("bold", "lv") " │ "     \
            getDisplay("tg") "      - " ansi("bold", "tg") "    │" RS   \
            "│ " getDisplay("et") "          - " ansi("bold", "et") "  │ " \
            getDisplay("mg") "         - " ansi("bold", "mg") " │ "     \
            getDisplay("th") "         - " ansi("bold", "th") "    │" RS \
            "│ " getDisplay("eu") "        - " ansi("bold", "eu") "  │ " \
            getDisplay("mi") "            - " ansi("bold", "mi") " │ "  \
            getDisplay("tl") "     - " ansi("bold", "tl") "    │" RS    \
            "│ " getDisplay("fa") "          - " ansi("bold", "fa") "  │ " \
            getDisplay("mk") "       - " ansi("bold", "mk") " │ "       \
            getDisplay("tr") "      - " ansi("bold", "tr") "    │" RS   \
            "│ " getDisplay("fi") "          - " ansi("bold", "fi") "  │ " \
            getDisplay("ml") "           - " ansi("bold", "ml") " │ "   \
            getDisplay("uk") "  - " ansi("bold", "uk") "    │" RS       \
            "│ " getDisplay("fr") "       - " ansi("bold", "fr") "  │ " \
            getDisplay("mn") "           - " ansi("bold", "mn") " │ "   \
            getDisplay("ur") "        - " ansi("bold", "ur") "    │" RS \
            "│ " getDisplay("ga") "        - " ansi("bold", "ga") "  │ " \
            getDisplay("mr") "            - " ansi("bold", "mr") " │ "  \
            getDisplay("uz") " - " ansi("bold", "uz") "    │" RS        \
            "│ " getDisplay("gl") "         - " ansi("bold", "gl") "  │ " \
            getDisplay("ms") "    - " ansi("bold", "ms") " │ "          \
            getDisplay("vi") "  - " ansi("bold", "vi") "    │" RS       \
            "│ " getDisplay("gu") "         - " ansi("bold", "gu") "  │ " \
            getDisplay("mt") "            - " ansi("bold", "mt") " │ "  \
            getDisplay("yi") "       - " ansi("bold", "yi") "    │" RS  \
            "│ " getDisplay("ha") "          - " ansi("bold", "ha") "  │ " \
            getDisplay("my") "          - " ansi("bold", "my") " │ "    \
            getDisplay("yo") "      - " ansi("bold", "yo") "    │" RS   \
            "│ " getDisplay("he") "          - " ansi("bold", "he") "  │ " \
            getDisplay("ne") "            - " ansi("bold", "ne") " │ "  \
            getDisplay("zh-CN") "    - " ansi("bold", "zh-CN") " │" RS  \
            "│ " getDisplay("hi") "          - " ansi("bold", "hi") "  │ " \
            getDisplay("nl") "       - " ansi("bold", "nl") " │ "       \
            getDisplay("zh-TW") "    - " ansi("bold", "zh-TW") " │" RS  \
            "│ " getDisplay("hmn") "          - " ansi("bold", "hmn") " │ " \
            getDisplay("no") "            - " ansi("bold", "no") " │ "  \
            getDisplay("zu") "     - " ansi("bold", "zu") "    │" RS    \
            "│ " getDisplay("hr") "       - " ansi("bold", "hr") "  │ " \
            getDisplay("ny") "           - " ansi("bold", "ny") " │ "   \
            "                    │" RS                                  \
            "│ " getDisplay("ht") " - " ansi("bold", "ht") "  │ "       \
            getDisplay("pa") "            - " ansi("bold", "pa") " │ "  \
            "                    │" RS                                  \
            "└──────────────────────┴───────────────────────┴─────────────────────┘"
}

# Return detailed information of languages as a string.
function getList(codes,    code, i, r, saveSortedIn) {
    r = NULLSTR
    if (!isarray(codes))
        r = getDetails(codes)
    else if (anything(codes)) {
        saveSortedIn = PROCINFO["sorted_in"]
        PROCINFO["sorted_in"] = "@ind_num_asc"
        for (i in codes)
            r = (r ? r RS prettify("target-seperator", replicate(Option["chr-target-seperator"], Option["width"])) RS \
                 : r) getDetails(codes[i])
        PROCINFO["sorted_in"] = saveSortedIn
    } else
        r = getDetails(Option["hl"])
    return r
}
