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

# Return help message as a string.
function getHelp() {
    return "Usage:\t" Command " [options] [source]:[target] [" ansi("underline", "text") "] ..." RS \
        "\t" Command " [options] [source]:[target1]+[target2]+... [" ansi("underline", "text") "] ..." RS RS \
        "Options:" RS                                                   \
        ansi("bold", "-V, -version") RS                                 \
        ins(1, "Print version and exit.") RS                            \
        ansi("bold", "-H, -h, -help") RS                                \
        ins(1, "Print this help message and exit.") RS                  \
        ansi("bold", "-M, -m, -manual") RS                              \
        ins(1, "Show the manual.") RS                                   \
        ansi("bold", "-r, -reference") RS                               \
        ins(1, "Print a list of languages (displayed in endonyms) and their ISO 639 codes for reference, and exit.") RS \
        ansi("bold", "-R, -reference-english") RS                       \
        ins(1, "Print a list of languages (displayed in English names) and their ISO 639 codes for reference, and exit.") RS \
        ansi("bold", "-verbose") RS                                     \
        ins(1, "Verbose mode. (default)") RS                            \
        ansi("bold", "-d, -dictionary") RS                              \
        ins(1, "Dictionary mode.") RS                                   \
        ansi("bold", "-b, -brief") RS                                   \
        ins(1, "Brief mode.") RS                                        \
        ansi("bold", "-show-original [yes|no]") RS                      \
        ins(1, "Show original text or not. (default: yes)") RS          \
        ansi("bold", "-show-original-phonetics [yes|no]") RS            \
        ins(1, "Show phonetic notation of original text or not. (default: yes)") RS \
        ansi("bold", "-show-translation [yes|no]") RS                   \
        ins(1, "Show translation or not. (default: yes)") RS            \
        ansi("bold", "-show-translation-phonetics [yes|no]") RS         \
        ins(1, "Show phonetic notation of translation or not. (default: yes)") RS \
        ansi("bold", "-show-prompt-message [yes|no]") RS                \
        ins(1, "Show prompt message or not. (default: yes)") RS         \
        ansi("bold", "-show-languages [yes|no]") RS                     \
        ins(1, "Show source and target languages or not. (default: yes)") RS \
        ansi("bold", "-show-original-dictionary [yes|no]") RS           \
        ins(1, "Show dictionary entry of original text or not. (default: no)") RS \
        ansi("bold", "-show-dictionary [yes|no]") RS                    \
        ins(1, "Show dictionary entry of translation or not. (default: yes)") RS \
        ansi("bold", "-show-alternatives [yes|no]") RS                  \
        ins(1, "Show alternative translations or not. (default: yes)") RS \
        ansi("bold", "-theme [theme]") RS                               \
        ins(1, "Specify the theme to use. (default: default)") RS       \
        ansi("bold", "-no-ansi") RS                                     \
        ins(1, "Don't use ANSI escape codes in the translation.") RS    \
        ansi("bold", "-w [num], -width [num]") RS                       \
        ins(1, "Specify the screen width for padding when displaying right-to-left languages.") RS \
        ansi("bold", "-indent [num]") RS                                \
        ins(1, "Specify the size of indent (in terms of spaces). (default: 4)") RS \
        ansi("bold", "-v, -view") RS                                    \
        ins(1, "View the translation in a terminal pager.") RS          \
        ansi("bold", "-pager [program]") RS                             \
        ins(1, "Specify the terminal pager to use, and view the translation.") RS \
        ansi("bold", "-browser [program]") RS                           \
        ins(1, "Specify the web browser to use.") RS                    \
        ansi("bold", "-p, -play") RS                                    \
        ins(1, "Listen to the translation.") RS                         \
        ansi("bold", "-player [program]") RS                            \
        ins(1, "Specify the command-line audio player to use, and listen to the translation.") RS \
        ansi("bold", "-x [proxy], -proxy [proxy]") RS                   \
        ins(1, "Use proxy on given port.") RS                           \
        ansi("bold", "-u [agent], -user-agent [agent]") RS              \
        ins(1, "Specify the User-Agent to identify as.") RS             \
        ansi("bold", "-I, -interactive, -shell") RS                     \
        ins(1, "Start an interactive shell, invoking `rlwrap` whenever possible (unless `-no-rlwrap` is specified).") RS \
        ansi("bold", "-no-rlwrap") RS                                   \
        ins(1, "Don't invoke `rlwrap` when starting an interactive shell with `-I`.") RS \
        ansi("bold", "-E, -emacs") RS                                   \
        ins(1, "Start an interactive shell within GNU Emacs, invoking `emacs`.") RS \
        ansi("bold", "-prompt [prompt_string]") RS                      \
        ins(1, "Customize your prompt string in the interactive shell.") RS \
        ansi("bold", "-prompt-color [color_code]") RS                   \
        ins(1, "Customize your prompt color in the interactive shell.") RS \
        ansi("bold", "-i [file], -input [file]") RS                     \
        ins(1, "Specify the input file name.") RS                       \
        ansi("bold", "-o [file], -output [file]") RS                    \
        ins(1, "Specify the output file name.") RS                      \
        ansi("bold", "-l [code], -lang [code]") RS                      \
        ins(1, "Specify your own, native language (\"home/host language\").") RS \
        ansi("bold", "-s [code], -source [code]") RS                    \
        ins(1, "Specify the source language (language of the original text).") RS \
        ansi("bold", "-t [codes], -target [codes]") RS                  \
        ins(1, "Specify the target language(s) (language(s) of the translated text).") RS \
        ansi("bold", "-no-init") RS                                     \
        ins(1, "Do not load any initialization script.") RS     \
        RS "See the man page " Command "(1) for more information."
}

# Display man page.
function man(    temp) {
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
