####################################################################
# Help.awk                                                         #
####################################################################

# Return version as a string.
function getVersion(    build, gitHead) {
    initAudioPlayer()
    initPager()
    Platform = Platform ? Platform : detectProgram("uname", "-s", 1)
    if (ENVIRON["TRANS_BUILD"])
        build = "-" ENVIRON["TRANS_BUILD"]
    else {
        gitHead = getGitHead()
        build = gitHead ? "-git:" gitHead : ""
    }

    return ansi("bold", sprintf("%-22s%s%s\n\n", Name, Version, build)) \
        sprintf("%-22s%s\n", "platform", Platform)                      \
        sprintf("%-22s%s\n", "terminal type", ENVIRON["TERM"])          \
        sprintf("%-22s%s\n", "bi-di emulator", BiDiTerm ? BiDiTerm :
                "[N/A]")                                                \
        sprintf("%-22s%s\n", "gawk (GNU Awk)", PROCINFO["version"])     \
        sprintf("%s\n", FriBidi ? FriBidi :
                "fribidi (GNU FriBidi) [NOT INSTALLED]")                \
        sprintf("%-22s%s\n", "audio player", AudioPlayer ? AudioPlayer :
                "[NOT INSTALLED]")                                      \
        sprintf("%-22s%s\n", "terminal pager", Pager ? Pager :
                "[NOT INSTALLED]")                                      \
        sprintf("%-22s%s\n", "web browser", Option["browser"] != NONE ?
                Option["browser"] :"[NONE]")                            \
        sprintf("%-22s%s (%s)\n", "user locale", UserLocale, getName(UserLang)) \
        sprintf("%-22s%s\n", "home language", Option["hl"])             \
        sprintf("%-22s%s\n", "source language", join(Option["sls"], "+")) \
        sprintf("%-22s%s\n", "target language", join(Option["tl"], "+")) \
        sprintf("%-22s%s\n", "translation engine", Option["engine"])    \
        sprintf("%-22s%s\n", "proxy", Option["proxy"] ? Option["proxy"] :
                "[NONE]")                                               \
        sprintf("%-22s%s\n", "user-agent", Option["user-agent"] ? Option["user-agent"] :
                "[NONE]")                                               \
        sprintf("%-22s%s\n", "ip version", Option["ip-version"] ? Option["ip-version"] :
                "[DEFAULT]")                                            \
        sprintf("%-22s%s\n", "theme", Option["theme"])                  \
        sprintf("%-22s%s\n", "init file", InitScript ? InitScript : "[NONE]") \
        sprintf("\n%-22s%s", "Report bugs to:", "https://github.com/soimort/translate-shell/issues")
}

# Return help message as a string.
function getHelp() {
    return "Usage:  " ansi("bold", Command)                             \
        " [" ansi("underline", "OPTIONS") "]"                           \
        " [" ansi("underline", "SOURCES") "]"                           \
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
        ins(1, ansi("bold", "-S") ", " ansi("bold", "-list-engines")) RS \
        ins(2, "List available translation engines and exit.") RS       \
        ins(1, ansi("bold", "-U") ", " ansi("bold", "-upgrade")) RS     \
        ins(2, "Check for upgrade of this program.") RS                 \
        RS "Translator options:" RS                                     \
        ins(1, ansi("bold", "-e ") ansi("underline", "ENGINE")          \
            ", " ansi("bold", "-engine ") ansi("underline", "ENGINE")) RS \
        ins(2, "Specify the translation engine to use.") RS             \
        RS "Display options:" RS                                        \
        ins(1, ansi("bold", "-verbose")) RS                             \
        ins(2, "Verbose mode. (default)") RS                            \
        ins(1, ansi("bold", "-b") ", " ansi("bold", "-brief")) RS       \
        ins(2, "Brief mode.") RS                                        \
        ins(1, ansi("bold", "-d") ", " ansi("bold", "-dictionary")) RS  \
        ins(2, "Dictionary mode.") RS                                   \
        ins(1, ansi("bold", "-identify")) RS                            \
        ins(2, "Language identification.") RS                           \
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
        ins(1, ansi("bold", "-theme ") ansi("underline", "FILENAME")) RS \
        ins(2, "Specify the theme to use.") RS                          \
        ins(1, ansi("bold", "-no-theme")) RS                            \
        ins(2, "Do not use any other theme than default.") RS           \
        ins(1, ansi("bold", "-no-ansi")) RS                             \
        ins(2, "Do not use ANSI escape codes.") RS                      \
        ins(1, ansi("bold", "-no-autocorrect")) RS                      \
        ins(2, "Do not autocorrect. (if defaulted by the translation engine)") RS \
        ins(1, ansi("bold", "-no-bidi")) RS                             \
        ins(2, "Do not convert bidirectional texts.") RS                \
        ins(1, ansi("bold", "-bidi")) RS                                \
        ins(2, "Always convert bidirectional texts.") RS                \
        ins(1, ansi("bold", "-no-warn")) RS                             \
        ins(2, "Do not write warning messages to stderr.") RS           \
        ins(1, ansi("bold", "-dump")) RS                                \
        ins(2, "Print raw API response instead.") RS                    \
        RS "Audio options:" RS                                          \
        ins(1, ansi("bold", "-p, -play")) RS                            \
        ins(2, "Listen to the translation.") RS                         \
        ins(1, ansi("bold", "-speak")) RS                               \
        ins(2, "Listen to the original text.") RS                       \
        ins(1, ansi("bold", "-n ") ansi("underline", "VOICE")           \
            ", " ansi("bold", "-narrator ") ansi("underline", "VOICE")) RS \
        ins(2, "Specify the narrator, and listen to the translation.") RS \
        ins(1, ansi("bold", "-player ") ansi("underline", "PROGRAM")) RS \
        ins(2, "Specify the audio player to use, and listen to the translation.") RS \
        ins(1, ansi("bold", "-no-play")) RS                             \
        ins(2, "Do not listen to the translation.") RS                  \
        ins(1, ansi("bold", "-no-translate")) RS                        \
        ins(2, "Do not translate anything when using -speak.") RS       \
        ins(1, ansi("bold", "-download-audio")) RS                      \
        ins(2, "Download the audio to the current directory.") RS       \
        ins(1, ansi("bold", "-download-audio-as ") ansi("underline", "FILENAME")) RS \
        ins(2, "Download the audio to the specified file.") RS          \
        RS "Terminal paging and browsing options:" RS                   \
        ins(1, ansi("bold", "-v") ", " ansi("bold", "-view")) RS        \
        ins(2, "View the translation in a terminal pager.") RS          \
        ins(1, ansi("bold", "-pager ") ansi("underline", "PROGRAM")) RS \
        ins(2, "Specify the terminal pager to use, and view the translation.") RS \
        ins(1, ansi("bold", "-no-view") ", " ansi("bold", "-no-pager")) RS \
        ins(2, "Do not view the translation in a terminal pager.") RS   \
        ins(1, ansi("bold", "-browser ") ansi("underline", "PROGRAM")) RS \
        ins(2, "Specify the web browser to use.") RS                    \
        ins(1, ansi("bold", "-no-browser")) RS                          \
        ins(2, "Do not open the web browser.") RS                       \
        RS "Networking options:" RS                                     \
        ins(1, ansi("bold", "-x ") ansi("underline", "HOST:PORT")       \
            ", " ansi("bold", "-proxy ") ansi("underline", "HOST:PORT")) RS \
        ins(2, "Use HTTP proxy on given port.") RS                      \
        ins(1, ansi("bold", "-u ") ansi("underline", "STRING")          \
            ", " ansi("bold", "-user-agent ") ansi("underline", "STRING")) RS \
        ins(2, "Specify the User-Agent to identify as.") RS             \
        ins(1, ansi("bold", "-4") ", " ansi("bold", "-ipv4")            \
            ", " ansi("bold", "-inet4-only")) RS                        \
        ins(2, "Connect only to IPv4 addresses.") RS                    \
        ins(1, ansi("bold", "-6") ", " ansi("bold", "-ipv6")            \
            ", " ansi("bold", "-inet6-only")) RS                        \
        ins(2, "Connect only to IPv6 addresses.") RS                    \
        RS "Interactive shell options:" RS                              \
        ins(1, ansi("bold", "-I") ", " ansi("bold", "-interactive") ", " ansi("bold", "-shell")) RS \
        ins(2, "Start an interactive shell.") RS                        \
        ins(1, ansi("bold", "-E") ", " ansi("bold", "-emacs")) RS       \
        ins(2, "Start the GNU Emacs front-end for an interactive shell.") RS \
        ins(1, ansi("bold", "-no-rlwrap")) RS                           \
        ins(2, "Do not invoke rlwrap when starting an interactive shell.") RS \
        RS "I/O options:" RS                                            \
        ins(1, ansi("bold", "-i ") ansi("underline", "FILENAME")        \
            ", " ansi("bold", "-input ") ansi("underline", "FILENAME")) RS \
        ins(2, "Specify the input file.") RS                            \
        ins(1, ansi("bold", "-o ") ansi("underline", "FILENAME")        \
            ", " ansi("bold", "-output ") ansi("underline", "FILENAME")) RS \
        ins(2, "Specify the output file.") RS                           \
        RS "Language preference options:" RS                            \
        ins(1, ansi("bold", "-l ") ansi("underline", "CODE")            \
            ", " ansi("bold", "-hl ") ansi("underline", "CODE")         \
            ", " ansi("bold", "-lang ") ansi("underline", "CODE")) RS   \
        ins(2, "Specify your home language.") RS                        \
        ins(1, ansi("bold", "-s ") ansi("underline", "CODES")           \
            ", " ansi("bold", "-sl ") ansi("underline", "CODES")        \
            ", " ansi("bold", "-source ") ansi("underline", "CODES")    \
            ", " ansi("bold", "-from ") ansi("underline", "CODES")) RS  \
        ins(2, "Specify the source language(s), joined by '+'.") RS     \
        ins(1, ansi("bold", "-t ") ansi("underline", "CODES")           \
            ", " ansi("bold", "-tl ") ansi("underline", "CODES")        \
            ", " ansi("bold", "-target ") ansi("underline", "CODES")    \
            ", " ansi("bold", "-to ") ansi("underline", "CODES")) RS    \
        ins(2, "Specify the target language(s), joined by '+'.") RS     \
        RS "Text preprocessing options:" RS                             \
        ins(1, ansi("bold", "-j") ", " ansi("bold", "-join-sentence")) RS \
        ins(2, "Treat all arguments as one single sentence.") RS        \
        RS "Other options:" RS                                          \
        ins(1, ansi("bold", "-no-init")) RS                             \
        ins(2, "Do not load any initialization script.") RS             \
        RS "See the man page " Command "(1) for more information."
}

# Show man page.
function showMan(    temp) {
    if (ENVIRON["TRANS_MANPAGE"]) {
        initPager()
        Groff = detectProgram("groff", "--version")
        if (Pager && Groff) {
            temp = "echo -E \"${TRANS_MANPAGE}\""
            temp = temp PIPE                                            \
                Groff " -Wall -mtty-char -mandoc -Tutf8 "               \
                "-rLL=" Option["width"] "n -rLT=" Option["width"] "n"
            switch (Pager) {
            case "less":
                temp = temp PIPE                                        \
                    Pager " -s -P\"\\ \\Manual page " Command "(1) line %lt (press h for help or q to quit)\""
                break
            case "most":
                temp = temp PIPE Pager " -Cs"
                break
            default: # more
                temp = temp PIPE Pager
            }
            system(temp)
            return
        }
    }
    if (fileExists(ENVIRON["TRANS_DIR"] "/man/" Command ".1"))
        system("man " parameterize(ENVIRON["TRANS_DIR"] "/man/" Command ".1") SUPERR)
    else if (system("man " Command SUPERR))
        print getHelp()
}

# Return a reference table of languages as a string.
# Parameters:
#     displayName = "endonym" or "name"
function getReference(displayName,
                      ####
                      code, col, cols, colNum, i, j, name, num, offset, r, rows, saveSortedIn,
                      t1, t2) {
    # number of language codes with stable support
    num = 0
    for (code in Locale) {
        # only show languages that are supported
        if (Locale[code]["supported-by"])
           num++
    }
    colNum = (Option["width"] >= 104) ? 4 : 3
    if (colNum == 4) {
        rows = int(num / 4) + (num % 4 ? 1 : 0)
        cols[0][0] = cols[1][0] = cols[2][0] = cols[3][0] = NULLSTR
    } else {
        rows = int(num / 3) + (num % 3 ? 1 : 0)
        cols[0][0] = cols[1][0] = cols[2][0] = NULLSTR
    }
    i = 0
    saveSortedIn = PROCINFO["sorted_in"]
    PROCINFO["sorted_in"] = displayName == "endonym" ? "@ind_num_asc" :
        "compName"
    for (code in Locale) {
        # only show languages that are supported
        if (Locale[code]["supported-by"]) {
            col = int(i / rows)
            append(cols[col], code)
            i++
        }
    }
    PROCINFO["sorted_in"] = saveSortedIn

    if (displayName == "endonym") {
        if (colNum == 4) {  # 4-column
            offset = int((Option["width"] - 104) / 4)
            r = "┌" replicate("─", 25 + offset) "┬" replicate("─", 25 + offset) \
                "┬" replicate("─", 25 + offset) "┬" replicate("─", 25 + offset) "┐" RS
            for (i = 0; i < rows; i++) {
                r = r "│"
                for (j = 0; j < 4; j++) {
                    if (cols[j][i]) {
                        t1 = getDisplay(cols[j][i])
                        if (length(t1) > 17 + offset)
                            t1 = substr(t1, 1, 14 + offset) "..."
                        switch (cols[j][i]) { # fix rendered text width
                            case "sa":
                                t1 = sprintf(" %-"21+offset"s", t1)
                                break
                            case "he": case "dv":
                                t1 = sprintf(" %-"20+offset"s", t1)
                                break
                            case "bo": case "or": case "ur":
                                t1 = sprintf(" %-"19+offset"s", t1)
                                break
                            case "as": case "gom": case "mai":
                            case "gu": case "hi": case "bho":
                            case "ta": case "te": case "my":
                            case "ne": case "pa": case "km":
                            case "kn": case "yi": case "si":
                                t1 = sprintf(" %-"18+offset"s", t1)
                                break
                            case "lzh": case "yue":
                                t1 = sprintf(" %-"15+offset"s", t1)
                                break
                            case "ja": case "ko":
                                t1 = sprintf(" %-"14+offset"s", t1)
                                break
                            case "zh-CN": case "zh-TW":
                                t1 = sprintf(" %-"13+offset"s", t1)
                                break
                            default:
                                if (length(t1) <= 17+offset)
                                    t1 = sprintf(" %-"17+offset"s", t1)
                        }
                        switch (length(cols[j][i])) {
                            case 1: case 2: case 3: case 4:
                                t2 = sprintf("- %s │", ansi("bold", sprintf("%4s", cols[j][i])))
                                break
                            case 5:
                                t2 = sprintf("- %s│", ansi("bold", cols[j][i]))
                                break
                            case 6:
                                t2 = sprintf("-%s│", ansi("bold", cols[j][i]))
                                break
                            case 7:
                                t2 = sprintf("-%s", ansi("bold", cols[j][i]))
                                break
                            default:
                                t2 = ansi("bold", cols[j][i])
                        }
                        r = r t1 t2
                    } else
                        r = r sprintf("%"25+offset"s│", NULLSTR)
                }
                r = r RS
            }
            r = r "└" replicate("─", 25 + offset) "┴" replicate("─", 25 + offset) \
                "┴" replicate("─", 25 + offset) "┴" replicate("─", 25 + offset) "┘"
        } else {  # fixed-width 3-column
            r = "┌" replicate("─", 25) "┬" replicate("─", 25) "┬" replicate("─", 25) "┐" RS
            for (i = 0; i < rows; i++) {
                r = r "│"
                for (j = 0; j < 3; j++) {
                    if (cols[j][i]) {
                        t1 = getDisplay(cols[j][i])
                        if (length(t1) > 17)
                            t1 = substr(t1, 1, 14) "..."
                        switch (cols[j][i]) { # fix rendered text width
                            case "sa":
                                t1 = sprintf(" %-21s", t1)
                                break
                            case "he": case "dv":
                                t1 = sprintf(" %-20s", t1)
                                break
                            case "bo": case "or": case "ur":
                                t1 = sprintf(" %-19s", t1)
                                break
                            case "as": case "gom": case "mai":
                            case "gu": case "hi": case "bho":
                            case "ta": case "te": case "my":
                            case "ne": case "pa": case "km":
                            case "kn": case "yi": case "si":
                                t1 = sprintf(" %-18s", t1)
                                break
                            case "lzh": case "yue":
                                t1 = sprintf(" %-15s", t1)
                                break
                            case "ja": case "ko":
                                t1 = sprintf(" %-14s", t1)
                                break
                            case "zh-CN": case "zh-TW":
                                t1 = sprintf(" %-13s", t1)
                                break
                            default:
                                if (length(t1) <= 17)
                                    t1 = sprintf(" %-17s", t1)
                        }
                        switch (length(cols[j][i])) {
                            case 1: case 2: case 3: case 4:
                                t2 = sprintf("- %s │", ansi("bold", sprintf("%4s", cols[j][i])))
                                break
                            case 5:
                                t2 = sprintf("- %s│", ansi("bold", cols[j][i]))
                                break
                            case 6:
                                t2 = sprintf("-%s│", ansi("bold", cols[j][i]))
                                break
                            case 7:
                                t2 = sprintf("-%s", ansi("bold", cols[j][i]))
                                break
                            default:
                                t2 = ansi("bold", cols[j][i])
                        }
                        r = r t1 t2
                    } else
                        r = r sprintf("%25s│", NULLSTR)
                }
                r = r RS
            }
            r = r "└" replicate("─", 25) "┴" replicate("─", 25) "┴" replicate("─", 25) "┘"
        }
    } else {
        if (colNum == 4) {  # 4-column
            offset = int((Option["width"] - 104) / 4)
            r = "┌" replicate("─", 25 + offset) "┬" replicate("─", 25 + offset) \
                "┬" replicate("─", 25 + offset) "┬" replicate("─", 25 + offset) "┐" RS
            for (i = 0; i < rows; i++) {
                r = r "│"
                for (j = 0; j < 4; j++) {
                    if (cols[j][i]) {
                        t1 = getName(cols[j][i])
                        if (length(t1) > 17 + offset)
                            t1 = substr(t1, 1, 14 + offset) "..."
                        t1 = sprintf(" %-"17+offset"s", t1)
                        switch (length(cols[j][i])) {
                            case 1: case 2: case 3: case 4:
                                t2 = sprintf("- %s │", ansi("bold", sprintf("%4s", cols[j][i])))
                                break
                            case 5:
                                t2 = sprintf("- %s│", ansi("bold", cols[j][i]))
                                break
                            case 6:
                                t2 = sprintf("-%s│", ansi("bold", cols[j][i]))
                                break
                            case 7:
                                t2 = sprintf("-%s", ansi("bold", cols[j][i]))
                                break
                            default:
                                t2 = ansi("bold", cols[j][i])
                        }
                        r = r t1 t2
                    } else
                        r = r sprintf("%"25+offset"s│", NULLSTR)
                }
                r = r RS
            }
            r = r "└" replicate("─", 25 + offset) "┴" replicate("─", 25 + offset) \
                "┴" replicate("─", 25 + offset) "┴" replicate("─", 25 + offset) "┘"
        } else {  # fixed-width 3-column
            r = "┌" replicate("─", 25) "┬" replicate("─", 25) "┬" replicate("─", 25) "┐" RS
            for (i = 0; i < rows; i++) {
                r = r "│"
                for (j = 0; j < 3; j++) {
                    if (cols[j][i]) {
                        t1 = getName(cols[j][i])
                        if (length(t1) > 17)
                            t1 = substr(t1, 1, 14) "..."
                        t1 = sprintf(" %-17s", t1)
                        switch (length(cols[j][i])) {
                            case 1: case 2: case 3: case 4:
                                t2 = sprintf("- %s │", ansi("bold", sprintf("%4s", cols[j][i])))
                                break
                            case 5:
                                t2 = sprintf("- %s│", ansi("bold", cols[j][i]))
                                break
                            case 6:
                                t2 = sprintf("-%s│", ansi("bold", cols[j][i]))
                                break
                            case 7:
                                t2 = sprintf("-%s", ansi("bold", cols[j][i]))
                                break
                            default:
                                t2 = ansi("bold", cols[j][i])
                        }
                        r = r t1 t2
                    } else
                        r = r sprintf("%25s│", NULLSTR)
                }
                r = r RS
            }
            r = r "└" replicate("─", 25) "┴" replicate("─", 25) "┴" replicate("─", 25) "┘"
        }
    }
    return r
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
