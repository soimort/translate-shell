####################################################################
# Help.awk                                                         #
####################################################################

# Return version as a string.
function getVersion(    build, gitHead, platform) {
    initAudioPlayer()
    initPager()
    platform = detectProgram("uname", "-o", 1)
    if (ENVIRON["TRANS_BUILD"])
        build = "-" ENVIRON["TRANS_BUILD"]
    else {
        gitHead = getGitHead()
        build = gitHead ? "-git:" gitHead : ""
    }

    return ansi("bold", sprintf("%-22s%s%s\n\n", Name, Version, build)) \
        sprintf("%-22s%s\n", "platform", platform)                      \
        sprintf("%-22s%s\n", "gawk (GNU Awk)", PROCINFO["version"])     \
        sprintf("%s\n", FriBidi ? FriBidi :
                "fribidi (GNU FriBidi) [NOT INSTALLED]")                \
        sprintf("%-22s%s\n", "audio player", AudioPlayer ? AudioPlayer :
                "[NOT INSTALLED]")                                      \
        sprintf("%-22s%s\n", "terminal pager", Pager ? Pager :
                "[NOT INSTALLED]")                                      \
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
        ins(2, "Check for upgrade of this program.") RS                 \
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
        ins(1, ansi("bold", "-theme ") ansi("underline", "FILENAME")) RS \
        ins(2, "Specify the theme to use.") RS                          \
        ins(1, ansi("bold", "-no-theme")) RS                            \
        ins(2, "Do not use any other theme than default.") RS           \
        ins(1, ansi("bold", "-no-ansi")) RS                             \
        ins(2, "Do not use ANSI escape codes.") RS                      \
        RS "Audio options:" RS                                          \
        ins(1, ansi("bold", "-p, -play")) RS                            \
        ins(2, "Listen to the translation.") RS                         \
        ins(1, ansi("bold", "-player ") ansi("underline", "PROGRAM")) RS \
        ins(2, "Specify the audio player to use, and listen to the translation.") RS \
        ins(1, ansi("bold", "-no-play")) RS                             \
        ins(2, "Do not listen to the translation.") RS                  \
        RS "Terminal paging and browsing options:" RS                   \
        ins(1, ansi("bold", "-v") ", " ansi("bold", "-view")) RS        \
        ins(2, "View the translation in a terminal pager.") RS          \
        ins(1, ansi("bold", "-pager ") ansi("underline", "PROGRAM")) RS \
        ins(2, "Specify the terminal pager to use, and view the translation.") RS \
        ins(1, ansi("bold", "-no-view")) RS                             \
        ins(2, "Do not view the translation in a terminal pager.") RS   \
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
        ins(1, ansi("bold", "-s ") ansi("underline", "CODE")            \
            ", " ansi("bold", "-sl ") ansi("underline", "CODE")         \
            ", " ansi("bold", "-source ") ansi("underline", "CODE")) RS \
        ins(2, "Specify the source language.") RS                       \
        ins(1, ansi("bold", "-t ") ansi("underline", "CODES")           \
            ", " ansi("bold", "-tl ") ansi("underline", "CODE")         \
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
    if (fileExists("man/" Command ".1"))
        system("man man/" Command ".1" SUPERR)
    else if (system("man " Command SUPERR))
        print getHelp()
}

# Return a reference table of languages as a string.
# Parameters:
#     displayName = "endonym" or "name"
function getReference(displayName,
                      ####
                      code, col, cols, i, j, name, r, rows, saveSortedIn, t, tt) {
    rows = int(length(Locale) / 3) + 1
    cols[0][0] = cols[1][0] = cols[2][0] = NULLSTR
    i = 0
    saveSortedIn = PROCINFO["sorted_in"]
    PROCINFO["sorted_in"] = displayName == "endonym" ? "@ind_num_asc" :
        "compName"
    for (code in Locale) {
        col = int(i / rows)
        append(cols[col], code)
        i++
    }
    PROCINFO["sorted_in"] = saveSortedIn

    if (displayName == "endonym") {
        r = "┌" replicate("─", 22) "┬" replicate("─", 23) "┬" replicate("─", 23) "┐" RS
        for (i = 0; i < rows; i++) {
            r = r "│ "
            for (j = 0; j < 3; j++) {
                if (cols[j][i]) {
                    t = cols[j][i] == "bo" ||
                        cols[j][i] == "dz" ||
                        cols[j][i] == "he" ||
                        cols[j][i] == "hi" ||
                        cols[j][i] == "hu" ||
                        cols[j][i] == "la" ||
                        cols[j][i] == "ml" ||
                        cols[j][i] == "mn" ||
                        cols[j][i] == "ne" ||
                        cols[j][i] == "ny" ||
                        cols[j][i] == "pa" ||
                        cols[j][i] == "pl" ||
                        cols[j][i] == "ro" ||
                        cols[j][i] == "sr" ||
                        cols[j][i] == "te" ||
                        cols[j][i] == "tg" ||
                        cols[j][i] == "tr" ||
                        cols[j][i] == "ur" ||
                        cols[j][i] == "wo" ||
                        cols[j][i] == "yi" ||
                        cols[j][i] == "yo" ||
                        (cols[j][i] != "zh-CN" && cols[j][i] != "zh-TW" &&
                         length(getEndonym(cols[j][i])) < 6) ? "\t\t " :
                        cols[j][i] == "id" ? "" :
                        "\t "
                    tt = length(cols[j][i]) == 3 ? " │" :
                        (cols[j][i] != "zh-CN" && cols[j][i] != "zh-TW") ? "  │" : ""
                    r = r getDisplay(cols[j][i]) t "- " ansi("bold", cols[j][i]) tt " "
                } else
                    r = r "\t\t       │"
            }
            r = r RS
        }
        r = r "└" replicate("─", 22) "┴" replicate("─", 23) "┴" replicate("─", 23) "┘"
    } else {
        r = "┌" replicate("─", 22) "┬" replicate("─", 23) "┬" replicate("─", 23) "┐" RS
        for (i = 0; i < rows; i++) {
            r = r "│ "
            for (j = 0; j < 3; j++) {
                if (cols[j][i]) {
                    t = cols[j][i] == "he" ||
                        cols[j][i] == "kk" ||
                        cols[j][i] == "ko" ||
                        cols[j][i] == "ky" ||
                        cols[j][i] == "ne" ||
                        cols[j][i] == "pl" ||
                        cols[j][i] == "ps" ||
                        cols[j][i] == "sd" ||
                        cols[j][i] == "sk" ||
                        cols[j][i] == "sm" ||
                        cols[j][i] == "so" ||
                        cols[j][i] == "te" ||
                        cols[j][i] == "ug" ||
                        cols[j][i] == "yo" ||
                        (cols[j][i] != "zh-CN" && cols[j][i] != "zh-TW" &&
                         length(getName(cols[j][i])) < 6) ? "\t\t " :
                        cols[j][i] == "fy" ||
                        cols[j][i] == "gd" ||
                        cols[j][i] == "ht" ? " " :
                        "\t "
                    tt = length(cols[j][i]) == 3 ? " │" :
                        (cols[j][i] != "zh-CN" && cols[j][i] != "zh-TW") ? "  │" : ""
                    name = getName(cols[j][i])
                    if (cols[j][i] == "zh-CN" ||
                        cols[j][i] == "zh-TW")
                        name = substr(name, 1, 12) "."
                    r = r name t "- " ansi("bold", cols[j][i]) tt " "
                } else
                    r = r "\t\t       │"
            }
            r = r RS
        }
        r = r "└" replicate("─", 22) "┴" replicate("─", 23) "┴" replicate("─", 23) "┘"
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
