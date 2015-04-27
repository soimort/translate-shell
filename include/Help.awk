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
            "│ " Locale["af"]["name"] "           - " ansi("bold", "af") "    │ " \
            Locale["ha"]["name"] "          - " ansi("bold", "ha") "  │ " \
            Locale["fa"]["name"] "    - " ansi("bold", "fa") " │" RS    \
            "│ " Locale["sq"]["name"] "            - " ansi("bold", "sq") "    │ " \
            Locale["he"]["name"] "         - " ansi("bold", "he") "  │ " \
            Locale["pl"]["name"] "     - " ansi("bold", "pl") " │" RS   \
            "│ " Locale["ar"]["name"] "              - " ansi("bold", "ar") "    │ " \
            Locale["hi"]["name"] "          - " ansi("bold", "hi") "  │ " \
            Locale["pt"]["name"] " - " ansi("bold", "pt") " │" RS       \
            "│ " Locale["hy"]["name"] "            - " ansi("bold", "hy") "    │ " \
            Locale["hmn"]["name"] "          - " ansi("bold", "hmn") " │ " \
            Locale["pa"]["name"] "    - " ansi("bold", "pa") " │" RS    \
            "│ " Locale["az"]["name"] "         - " ansi("bold", "az") "    │ " \
            Locale["hu"]["name"] "      - " ansi("bold", "hu") "  │ "   \
            Locale["ro"]["name"] "   - " ansi("bold", "ro") " │" RS     \
            "│ " Locale["eu"]["name"] "              - " ansi("bold", "eu") "    │ " \
            Locale["is"]["name"] "      - " ansi("bold", "is") "  │ "   \
            Locale["ru"]["name"] "    - " ansi("bold", "ru") " │" RS    \
            "│ " Locale["be"]["name"] "          - " ansi("bold", "be") "    │ " \
            Locale["ig"]["name"] "           - " ansi("bold", "ig") "  │ " \
            Locale["sr"]["name"] "    - " ansi("bold", "sr") " │" RS    \
            "│ " Locale["bn"]["name"] "             - " ansi("bold", "bn") "    │ " \
            Locale["id"]["name"] "     - " ansi("bold", "id") "  │ "    \
            Locale["st"]["name"] "    - " ansi("bold", "st") " │" RS    \
            "│ " Locale["bs"]["name"] "             - " ansi("bold", "bs") "    │ " \
            Locale["ga"]["name"] "          - " ansi("bold", "ga") "  │ " \
            Locale["si"]["name"] "    - " ansi("bold", "si") " │" RS    \
            "│ " Locale["bg"]["name"] "           - " ansi("bold", "bg") "    │ " \
            Locale["it"]["name"] "        - " ansi("bold", "it") "  │ " \
            Locale["sk"]["name"] "     - " ansi("bold", "sk") " │" RS   \
            "│ " Locale["ca"]["name"] "             - " ansi("bold", "ca") "    │ " \
            Locale["ja"]["name"] "       - " ansi("bold", "ja") "  │ "  \
            Locale["sl"]["name"] "  - " ansi("bold", "sl") " │" RS      \
            "│ " Locale["ceb"]["name"] "             - " ansi("bold", "ceb") "   │ " \
            Locale["jv"]["name"] "       - " ansi("bold", "jv") "  │ "  \
            Locale["so"]["name"] "     - " ansi("bold", "so") " │" RS   \
            "│ " Locale["ny"]["name"] "            - " ansi("bold", "ny") "    │ " \
            Locale["kn"]["name"] "        - " ansi("bold", "kn") "  │ " \
            Locale["es"]["name"] "    - " ansi("bold", "es") " │" RS    \
            "│ " Locale["zh-CN"]["name"] "  - " ansi("bold", "zh-CN") " │ " \
            Locale["kk"]["name"] "         - " ansi("bold", "kk") "  │ " \
            Locale["su"]["name"] "  - " ansi("bold", "su") " │" RS      \
            "│ " Locale["zh-TW"]["name"] " - " ansi("bold", "zh-TW") " │ " \
            Locale["km"]["name"] "          - " ansi("bold", "km") "  │ " \
            Locale["sw"]["name"] "    - " ansi("bold", "sw") " │" RS    \
            "│ " Locale["hr"]["name"] "            - " ansi("bold", "hr") "    │ " \
            Locale["ko"]["name"] "         - " ansi("bold", "ko") "  │ " \
            Locale["sv"]["name"] "    - " ansi("bold", "sv") " │" RS    \
            "│ " Locale["cs"]["name"] "               - " ansi("bold", "cs") "    │ " \
            Locale["lo"]["name"] "            - " ansi("bold", "lo") "  │ " \
            Locale["tg"]["name"] "      - " ansi("bold", "tg") " │" RS  \
            "│ " Locale["da"]["name"] "              - " ansi("bold", "da") "    │ " \
            Locale["la"]["name"] "          - " ansi("bold", "la") "  │ " \
            Locale["ta"]["name"] "      - " ansi("bold", "ta") " │" RS \
            "│ " Locale["nl"]["name"] "               - " ansi("bold", "nl") "    │ " \
            Locale["lv"]["name"] "        - " ansi("bold", "lv") "  │ " \
            Locale["te"]["name"] "     - " ansi("bold", "te") " │" RS   \
            "│ " Locale["en"]["name"] "             - " ansi("bold", "en") "    │ " \
            Locale["lt"]["name"] "     - " ansi("bold", "lt") "  │ "    \
            Locale["th"]["name"] "       - " ansi("bold", "th") " │" RS \
            "│ " Locale["eo"]["name"] "           - " ansi("bold", "eo") "    │ " \
            Locale["mk"]["name"] "     - " ansi("bold", "mk") "  │ "    \
            Locale["tr"]["name"] "    - " ansi("bold", "tr") " │" RS    \
            "│ " Locale["et"]["name"] "            - " ansi("bold", "et") "    │ " \
            Locale["mg"]["name"] "       - " ansi("bold", "mg") "  │ " \
            Locale["uk"]["name"] "  - " ansi("bold", "uk") " │" RS      \
            "│ " Locale["tl"]["name"] "            - " ansi("bold", "tl") "    │ " \
            Locale["ms"]["name"] "          - " ansi("bold", "ms") "  │ " \
            Locale["ur"]["name"] "       - " ansi("bold", "ur") " │" RS \
            "│ " Locale["fi"]["name"] "             - " ansi("bold", "fi") "    │ " \
            Locale["ml"]["name"] "      - " ansi("bold", "ml") "  │ " \
            Locale["uz"]["name"] "      - " ansi("bold", "uz") " │" RS \
            "│ " Locale["fr"]["name"] "              - " ansi("bold", "fr") "    │ " \
            Locale["mt"]["name"] "        - " ansi("bold", "mt") "  │ " \
            Locale["vi"]["name"] " - " ansi("bold", "vi") " │" RS \
            "│ " Locale["gl"]["name"] "            - " ansi("bold", "gl") "    │ " \
            Locale["mi"]["name"] "          - " ansi("bold", "mi") "  │ " \
            Locale["cy"]["name"] "      - " ansi("bold", "cy") " │" RS \
            "│ " Locale["ka"]["name"] "            - " ansi("bold", "ka") "    │ " \
            Locale["mr"]["name"] "        - " ansi("bold", "mr") "  │ " \
            Locale["yi"]["name"] "    - " ansi("bold", "yi") " │" RS \
            "│ " Locale["de"]["name"] "              - " ansi("bold", "de") "    │ " \
            Locale["mn"]["name"] "      - " ansi("bold", "mn") "  │ " \
            Locale["yo"]["name"] "     - " ansi("bold", "yo") " │" RS \
            "│ " Locale["el"]["name"] "               - " ansi("bold", "el") "    │ " \
            Locale["my"]["name"] "        - " ansi("bold", "my") "  │ " \
            Locale["zu"]["name"] "       - " ansi("bold", "zu") " │" RS \
            "│ " Locale["gu"]["name"] "            - " ansi("bold", "gu") "    │ " \
            Locale["ne"]["name"] "         - " ansi("bold", "ne") "  │ " \
            "                │" RS \
            "│ " Locale["ht"]["name"] "      - " ansi("bold", "ht") "    │ " \
            Locale["no"]["name"] "      - " ansi("bold", "no") "  │ " \
            "                │" RS \
            "└─────────────────────────────┴──────────────────────┴─────────────────┘"
    else
        return "┌──────────────────────┬───────────────────────┬─────────────────────┐" RS \
            "│ " Locale["af"]["display"] "      - " ansi("bold", "af") "  │ " \
            Locale["hu"]["display"] "           - " ansi("bold", "hu") " │ " \
            Locale["pl"]["display"] "      - " ansi("bold", "pl") "    │" RS \
            "│ " Locale["ar"]["display"] "        - " ansi("bold", "ar") "  │ " \
            Locale["hy"]["display"] "          - " ansi("bold", "hy") " │ " \
            Locale["pt"]["display"] "   - " ansi("bold", "pt") "    │" RS \
            "│ " Locale["az"]["display"] "   - " ansi("bold", "az") "  │ " \
            Locale["id"]["display"] " - " ansi("bold", "id") " │ " \
            Locale["ro"]["display"] "      - " ansi("bold", "ro") "    │" RS \
            "│ " Locale["be"]["display"] "     - " ansi("bold", "be") "  │ " \
            Locale["ig"]["display"] "             - " ansi("bold", "ig") " │ " \
            Locale["ru"]["display"] "     - " ansi("bold", "ru") "    │" RS \
            "│ " Locale["bg"]["display"] "      - " ansi("bold", "bg") "  │ " \
            Locale["is"]["display"] "         - " ansi("bold", "is") " │ " \
            Locale["si"]["display"] "        - " ansi("bold", "si") "    │" RS \
            "│ " Locale["bn"]["display"] "          - " ansi("bold", "bn") "  │ " \
            Locale["it"]["display"] "         - " ansi("bold", "it") " │ " \
            Locale["sk"]["display"] "  - " ansi("bold", "sk") "    │" RS \
            "│ " Locale["bs"]["display"] "       - " ansi("bold", "bs") "  │ " \
            Locale["ja"]["display"] "           - " ansi("bold", "ja") " │ " \
            Locale["sl"]["display"] " - " ansi("bold", "sl") "    │" RS \
            "│ " Locale["ca"]["display"] "         - " ansi("bold", "ca") "  │ " \
            Locale["jv"]["display"] "        - " ansi("bold", "jv") " │ " \
            Locale["so"]["display"] "    - " ansi("bold", "so") "    │" RS \
            "│ " Locale["ceb"]["display"] "        - " ansi("bold", "ceb") " │ " \
            Locale["ka"]["display"] "          - " ansi("bold", "ka") " │ " \
            Locale["sq"]["display"] "       - " ansi("bold", "sq") "    │" RS \
            "│ " Locale["cs"]["display"] "        - " ansi("bold", "cs") "  │ " \
            Locale["kk"]["display"] "       - " ansi("bold", "kk") " │ " \
            Locale["sr"]["display"] "      - " ansi("bold", "sr") "    │" RS \
            "│ " Locale["cy"]["display"] "        - " ansi("bold", "cy") "  │ " \
            Locale["km"]["display"] "         - " ansi("bold", "km") " │ " \
            Locale["st"]["display"] "     - " ansi("bold", "st") "    │" RS \
            "│ " Locale["da"]["display"] "          - " ansi("bold", "da") "  │ " \
            Locale["kn"]["display"] "             - " ansi("bold", "kn") " │ " \
            Locale["su"]["display"] "  - " ansi("bold", "su") "    │" RS \
            "│ " Locale["de"]["display"] "        - " ansi("bold", "de") "  │ " \
            Locale["ko"]["display"] "           - " ansi("bold", "ko") " │ " \
            Locale["sv"]["display"] "     - " ansi("bold", "sv") "    │" RS \
            "│ " Locale["el"]["display"] "       - " ansi("bold", "el") "  │ " \
            Locale["la"]["display"] "           - " ansi("bold", "la") " │ " \
            Locale["sw"]["display"] "   - " ansi("bold", "sw") "    │" RS \
            "│ " Locale["en"]["display"] "        - " ansi("bold", "en") "  │ " \
            Locale["lo"]["display"] "              - " ansi("bold", "lo") " │ " \
            Locale["ta"]["display"] "        - " ansi("bold", "ta") "    │" RS \
            "│ " Locale["eo"]["display"] "      - " ansi("bold", "eo") "  │ " \
            Locale["lt"]["display"] "         - " ansi("bold", "lt") " │ " \
            Locale["te"]["display"] "       - " ansi("bold", "te") "    │" RS \
            "│ " Locale["es"]["display"] "        - " ansi("bold", "es") "  │ " \
            Locale["lv"]["display"] "         - " ansi("bold", "lv") " │ " \
            Locale["tg"]["display"] "      - " ansi("bold", "tg") "    │" RS \
            "│ " Locale["et"]["display"] "          - " ansi("bold", "et") "  │ " \
            Locale["mg"]["display"] "         - " ansi("bold", "mg") " │ " \
            Locale["th"]["display"] "         - " ansi("bold", "th") "    │" RS \
            "│ " Locale["eu"]["display"] "        - " ansi("bold", "eu") "  │ " \
            Locale["mi"]["display"] "            - " ansi("bold", "mi") " │ " \
            Locale["tl"]["display"] "     - " ansi("bold", "tl") "    │" RS \
            "│ " Locale["fa"]["display"] "          - " ansi("bold", "fa") "  │ " \
            Locale["mk"]["display"] "       - " ansi("bold", "mk") " │ " \
            Locale["tr"]["display"] "      - " ansi("bold", "tr") "    │" RS \
            "│ " Locale["fi"]["display"] "          - " ansi("bold", "fi") "  │ " \
            Locale["ml"]["display"] "           - " ansi("bold", "ml") " │ " \
            Locale["uk"]["display"] "  - " ansi("bold", "uk") "    │" RS \
            "│ " Locale["fr"]["display"] "       - " ansi("bold", "fr") "  │ " \
            Locale["mn"]["display"] "           - " ansi("bold", "mn") " │ " \
            Locale["ur"]["display"] "        - " ansi("bold", "ur") "    │" RS \
            "│ " Locale["ga"]["display"] "        - " ansi("bold", "ga") "  │ " \
            Locale["mr"]["display"] "            - " ansi("bold", "mr") " │ " \
            Locale["uz"]["display"] " - " ansi("bold", "uz") "    │" RS \
            "│ " Locale["gl"]["display"] "         - " ansi("bold", "gl") "  │ " \
            Locale["ms"]["display"] "    - " ansi("bold", "ms") " │ " \
            Locale["vi"]["display"] "  - " ansi("bold", "vi") "    │" RS \
            "│ " Locale["gu"]["display"] "         - " ansi("bold", "gu") "  │ " \
            Locale["mt"]["display"] "            - " ansi("bold", "mt") " │ " \
            Locale["yi"]["display"] "       - " ansi("bold", "yi") "    │" RS \
            "│ " Locale["ha"]["display"] "          - " ansi("bold", "ha") "  │ " \
            Locale["my"]["display"] "          - " ansi("bold", "my") " │ " \
            Locale["yo"]["display"] "      - " ansi("bold", "yo") "    │" RS \
            "│ " Locale["he"]["display"] "          - " ansi("bold", "he") "  │ " \
            Locale["ne"]["display"] "            - " ansi("bold", "ne") " │ " \
            Locale["zh-CN"]["display"] "    - " ansi("bold", "zh-CN") " │" RS \
            "│ " Locale["hi"]["display"] "          - " ansi("bold", "hi") "  │ " \
            Locale["nl"]["display"] "       - " ansi("bold", "nl") " │ " \
            Locale["zh-TW"]["display"] "    - " ansi("bold", "zh-TW") " │" RS \
            "│ " Locale["hmn"]["display"] "          - " ansi("bold", "hmn") " │ " \
            Locale["no"]["display"] "            - " ansi("bold", "no") " │ " \
            Locale["zu"]["display"] "     - " ansi("bold", "zu") "    │" RS \
            "│ " Locale["hr"]["display"] "       - " ansi("bold", "hr") "  │ " \
            Locale["ny"]["display"] "           - " ansi("bold", "ny") " │ " \
            "                    │" RS \
            "│ " Locale["ht"]["display"] " - " ansi("bold", "ht") "  │ " \
            Locale["pa"]["display"] "            - " ansi("bold", "pa") " │ " \
            "                    │" RS \
            "└──────────────────────┴───────────────────────┴─────────────────────┘"
}

# Return help message as a string.
function getHelp() {
    return "Usage:\t" Command " [options] [source]:[target] [" ansi("underline", "text") "] ..." RS \
        "\t" Command " [options] [source]:[target1]+[target2]+... [" ansi("underline", "text") "] ..." RS RS \
        "Options:" RS                                                   \
        I ansi("bold", "-V, -version") RS                               \
        I I "Print version and exit." RS                                \
        I ansi("bold", "-H, -h, -help") RS                              \
        I I "Print this help message and exit." RS                      \
        I ansi("bold", "-M, -m, -manual") RS                            \
        I I "Show the manual." RS                                       \
        I ansi("bold", "-r, -reference") RS                             \
        I I "Print a list of languages (displayed in endonyms) and their ISO 639 codes for reference, and exit." RS \
        I ansi("bold", "-R, -reference-english") RS                     \
        I I "Print a list of languages (displayed in English names) and their ISO 639 codes for reference, and exit." RS \
        I ansi("bold", "-v, -verbose") RS                               \
        I I "Verbose mode. (default)" RS                                \
        I ansi("bold", "-b, -brief") RS                                 \
        I I "Brief mode." RS                                            \
        I ansi("bold", "-no-ansi") RS                                   \
        I I "Don't use ANSI escape codes in the translation." RS        \
        I ansi("bold", "-w [num], -width [num]") RS                     \
        I I "Specify the screen width for padding when displaying right-to-left languages." RS \
        I ansi("bold", "-browser [program]") RS                         \
        I I "Specify the web browser to use." RS                        \
        I ansi("bold", "-p, -play") RS                                  \
        I I "Listen to the translation." RS                             \
        I ansi("bold", "-player [program]") RS                          \
        I I "Specify the command-line audio player to use, and listen to the translation." RS \
        I ansi("bold", "-x [proxy], -proxy [proxy]") RS                 \
        I I "Use proxy on given port." RS                               \
        I ansi("bold", "-I, -interactive") RS                           \
        I I "Start an interactive shell, invoking `rlwrap` whenever possible (unless `-no-rlwrap` is specified)." RS \
        I ansi("bold", "-no-rlwrap") RS                                 \
        I I "Don't invoke `rlwrap` when starting an interactive shell with `-I`." RS \
        I ansi("bold", "-E, -emacs") RS                                 \
        I I "Start an interactive shell within GNU Emacs, invoking `emacs`." RS \
        I ansi("bold", "-prompt [prompt_string]") RS                    \
        I I "Customize your prompt string in the interactive shell." RS \
        I ansi("bold", "-prompt-color [color_code]") RS                 \
        I I "Customize your prompt color in the interactive shell." RS  \
        I ansi("bold", "-i [file], -input [file]") RS                   \
        I I "Specify the input file name." RS                           \
        I ansi("bold", "-o [file], -output [file]") RS                  \
        I I "Specify the output file name." RS                          \
        I ansi("bold", "-l [code], -lang [code]") RS                    \
        I I "Specify your own, native language (\"home/host language\")." RS \
        I ansi("bold", "-s [code], -source [code]") RS                  \
        I I "Specify the source language (language of the original text)." RS \
        I ansi("bold", "-t [codes], -target [codes]") RS                \
        I I "Specify the target language(s) (language(s) of the translated text)." RS RS \
        "See the man page " Command "(1) for more information."
}
