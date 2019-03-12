####################################################################
# Main.awk                                                         #
####################################################################

# Initialization.
function init() {
    initGawk()
    initBiDiTerm()
    initBiDi()

    # (Languages.awk)
    initLocale()
    initLocaleAlias()
    initUserLang()

    RS = "\n"

    ExitCode = 0

    Option["debug"] = 0

    # Translation engine
    Option["engine"] = "google"

    # Display
    Option["verbose"] = 1
    Option["show-original"] = 1
    Option["show-original-phonetics"] = 1
    Option["show-translation"] = 1
    Option["show-translation-phonetics"] = 1
    Option["show-prompt-message"] = 1
    Option["show-languages"] = 1
    Option["show-original-dictionary"] = 0
    Option["show-dictionary"] = 1
    Option["show-alternatives"] = 1
    Option["width"] = ENVIRON["COLUMNS"] ? ENVIRON["COLUMNS"] - 2 : 0
    Option["indent"] = 4
    Option["no-ansi"] = 0
    Option["no-autocorrect"] = 0
    Option["no-bidi"] = 0
    Option["force-bidi"] = 0
    Option["no-warn"] = 0
    Option["theme"] = "default"
    Option["dump"] = 0

    # Audio
    Option["play"] = 0
    Option["narrator"] = "female"
    Option["player"] = ENVIRON["PLAYER"]
    Option["no-translate"] = 0
    Option["download-audio"] = 0
    Option["download-audio-as"] = NULLSTR

    # Terminal paging and browsing
    Option["view"] = 0
    Option["pager"] = ENVIRON["PAGER"]
    Option["browser"] = ENVIRON["BROWSER"]

    # Networking
    Option["proxy"] = ENVIRON["HTTP_PROXY"] ? ENVIRON["HTTP_PROXY"] : ENVIRON["http_proxy"]
    Option["user-agent"] = ENVIRON["USER_AGENT"] ? ENVIRON["USER_AGENT"] :
        "Mozilla/5.0 (X11; Linux x86_64) "                   \
        "AppleWebKit/602.1 (KHTML, like Gecko) Version/8.0 " \
        "Safari/602.1 Epiphany/3.18.2"

    # Interactive shell
    Option["no-rlwrap"] = 0
    Option["interactive"] = 0
    Option["emacs"] = 0

    # I/O
    Option["input"] = NULLSTR
    Option["output"] = STDOUT

    # Language preference
    Option["hl"] = ENVIRON["HOME_LANG"] ? ENVIRON["HOME_LANG"] : UserLang
    Option["sl"] = ENVIRON["SOURCE_LANG"] ? ENVIRON["SOURCE_LANG"] : "auto"
    Option["sls"][1] = Option["sl"]
    Option["tl"][1] = ENVIRON["TARGET_LANG"] ? ENVIRON["TARGET_LANG"] : UserLang
}

# Initialization script.
function initScript(    file, line, script, temp) {
    # Find the initialization file
    file = ".trans"
    if (!fileExists(file)) {
        file = ENVIRON["HOME"] "/.translate-shell/init.trans"
        if (!fileExists(file)) {
            file = ENVIRON["XDG_CONFIG_HOME"] "/translate-shell/init.trans"
            if (!fileExists(file)) {
                file = ENVIRON["HOME"] "/.config/translate-shell/init.trans"
                if (!fileExists(file)) {
                    file = "/etc/translate-shell"
                    if (!fileExists(file)) return
                }
            }
        }
    }

    InitScript = file
    script = NULLSTR
    while (getline line < InitScript)
        script = script "\n" line
    loadOptions(script)

    # HACK: Option["tl"] must be an array
    if (!isarray(Option["tl"])) {
        temp = Option["tl"]
        delete Option["tl"]
        Option["tl"][1] = temp
    }
}

# Miscellany initialization.
function initMisc(    command, group, temp) {
    # (Translate.awk)
    initHttpService()

    # Initialize screen width if not set
    if (!Option["width"] && detectProgram("tput", "-V")) {
        command = "tput cols" SUPERR
        command | getline temp
        close(command)
        Option["width"] = temp > 5 ? temp - 2 : 64  # minimum screen width: 4
    }

    # Disable ANSI escape codes if required
    if (Option["no-ansi"])
        delete AnsiCode

    # Disable conversion of bidirectional texts if required or supported by emulator
    if (Option["no-bidi"] || BiDiTerm == "mlterm")
        # mlterm implements its own padding
        BiDi = BiDiNoPad = NULLSTR
    else if (!Option["force-bidi"] && BiDiTerm == "konsole") {
        # konsole implements no padding; we should handle this
        BiDiNoPad = NULLSTR
        BiDi = "sed \"s/'/\\\\\\'/\" | xargs -0 printf '%%%ss'"
    }

    # (Languages.awk)
    initLocaleDisplay()

    # Disable everything stderr
    if (Option["no-warn"])
        STDERR = "/dev/null"

    # Initialize audio player or speech synthesizer
    if (Option["play"]) {
        if (!Option["player"]) {
            initAudioPlayer()
            Option["player"] = AudioPlayer ? AudioPlayer : Option["player"]
            if (!Option["player"])
                initSpeechSynthesizer()
        }

        if (!Option["player"] && !SpeechSynthesizer) {
            w("[WARNING] No available audio player or speech synthesizer.")
            Option["play"] = 0
        }
    }

    # Initialize pager
    if (Option["view"]) {
        if (!Option["pager"]) {
            initPager()
            Option["pager"] = Pager
        }

        if (!Option["pager"]) {
            w("[WARNING] No available terminal pager.")
            Option["view"] = 0
        }
    }

    # Initialize browser
    if (!Option["browser"]) {
        Platform = detectProgram("uname", "-s", 1)
        Option["browser"] = Platform == "Darwin" ? "open" : "xdg-open"
    }
}

# Main entry point.
BEGIN {
    init()

    if (!(belongsTo("-no-init", ARGV) || belongsTo("--no-init", ARGV)))
        initScript() # initialization script overrides default setting

    # Command-line options override initialization script
    pos = 0
    noargc = 0
    while (ARGV[++pos]) {
        ## Information options

        # -V, -version
        match(ARGV[pos], /^--?(V|vers(i(on?)?)?)$/)
        if (RSTART) {
            InfoOnly = "version"
            continue
        }

        # -H, -help
        match(ARGV[pos], /^--?(H|h(e(lp?)?)?)$/)
        if (RSTART) {
            InfoOnly = "help"
            continue
        }

        # -M, -man
        match(ARGV[pos], /^--?(M|m(a(n(u(al?)?)?)?)?)$/)
        if (RSTART) {
            InfoOnly = "manual"
            continue
        }

        # -T, -reference
        match(ARGV[pos], /^--?(T|ref(e(r(e(n(ce?)?)?)?)?)?)$/)
        if (RSTART) {
            InfoOnly = "reference"
            continue
        }

        # FIXME[1.0]: to be removed
        match(ARGV[pos], /^--?r$/)
        if (RSTART) {
            w("[WARNING] Option '-r' has been deprecated since version 0.9.\n" \
              "          Use option '-T' or '-reference' instead.")
            exit 1
        }

        # -R, -reference-english
        match(ARGV[pos], /^--?(R|reference-e(n(g(l(i(sh?)?)?)?)?)?)$/)
        if (RSTART) {
            InfoOnly = "reference-english"
            continue
        }

        # -L CODES, -list CODES
        match(ARGV[pos], /^--?(L|list)(=(.*)?)?$/, group)
        if (RSTART) {
            InfoOnly = "list"
            if (group[2]) {
                if (group[3]) split(group[3], Option["tl"], "+")
            } else
                split(ARGV[++pos], Option["tl"], "+")
            continue
        }

        # -S, -list-engines
        match(ARGV[pos], /^--?(S|list-e(n(g(i(n(es?)?)?)?)?)?)$/)
        if (RSTART) {
            InfoOnly = "list-engines"
            continue
        }

        # -U, -upgrade
        match(ARGV[pos], /^--?(U|upgrade)$/)
        if (RSTART) {
            InfoOnly = "upgrade"
            continue
        }

        # -N, -nothing
        match(ARGV[pos], /^--?(N|nothing)$/)
        if (RSTART) {
            InfoOnly = "nothing"
            continue
        }

        ## Translator options

        # -e ENGINE, -engine ENGINE
        match(ARGV[pos], /^--?(e|engine)(=(.*)?)?$/, group)
        if (RSTART) {
            Option["engine"] = group[2] ?
                (group[3] ? group[3] : Option["engine"]) :
                ARGV[++pos]
            continue
        }

        # Shortcut format
        # '/ENGINE'
        match(ARGV[pos], /^\/(.*)$/, group)
        if (RSTART) {
            Option["engine"] = group[1]
            continue
        }

        ## Display options

        # -verbose
        match(ARGV[pos], /^--?verbose$/)
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

        # -d, -dictionary
        match(ARGV[pos], /^--?d(i(c(t(i(o(n(a(ry?)?)?)?)?)?)?)?)?$/)
        if (RSTART) {
            Option["show-original-dictionary"] = 1
            Option["show-dictionary"] = 0
            Option["show-alternatives"] = 0
            continue
        }

        # -identify
        match(ARGV[pos], /^--?id(e(n(t(i(fy?)?)?)?)?)?$/)
        if (RSTART) {
            Option["verbose"] = Option["verbose"] - 2
            continue
        }

        # -show-original Y/n
        match(ARGV[pos], /^--?show-original(=(.*)?)?$/, group)
        if (RSTART) {
            Option["show-original"] = yn(group[1] ? group[2] : ARGV[++pos])
            continue
        }

        # -show-original-phonetics Y/n
        match(ARGV[pos], /^--?show-original-phonetics(=(.*)?)?$/, group)
        if (RSTART) {
            Option["show-original-phonetics"] = yn(group[1] ? group[2] : ARGV[++pos])
            continue
        }

        # -show-translation Y/n
        match(ARGV[pos], /^--?show-translation(=(.*)?)?$/, group)
        if (RSTART) {
            Option["show-translation"] = yn(group[1] ? group[2] : ARGV[++pos])
            continue
        }

        # -show-translation-phonetics Y/n
        match(ARGV[pos], /^--?show-translation-phonetics(=(.*)?)?$/, group)
        if (RSTART) {
            Option["show-translation-phonetics"] = yn(group[1] ? group[2] : ARGV[++pos])
            continue
        }

        # -show-prompt-message Y/n
        match(ARGV[pos], /^--?show-prompt-message(=(.*)?)?$/, group)
        if (RSTART) {
            Option["show-prompt-message"] = yn(group[1] ? group[2] : ARGV[++pos])
            continue
        }

        # -show-languages Y/n
        match(ARGV[pos], /^--?show-languages(=(.*)?)?$/, group)
        if (RSTART) {
            Option["show-languages"] = yn(group[1] ? group[2] : ARGV[++pos])
            continue
        }

        # -show-original-dictionary y/N
        match(ARGV[pos], /^--?show-original-dictionary(=(.*)?)?$/, group)
        if (RSTART) {
            Option["show-original-dictionary"] = yn(group[1] ? group[2] : ARGV[++pos])
            continue
        }

        # -show-dictionary Y/n
        match(ARGV[pos], /^--?show-dictionary(=(.*)?)?$/, group)
        if (RSTART) {
            Option["show-dictionary"] = yn(group[1] ? group[2] : ARGV[++pos])
            continue
        }

        # -show-alternatives Y/n
        match(ARGV[pos], /^--?show-alternatives(=(.*)?)?$/, group)
        if (RSTART) {
            Option["show-alternatives"] = yn(group[1] ? group[2] : ARGV[++pos])
            continue
        }

        # -w NUM, -width NUM
        match(ARGV[pos], /^--?w(i(d(th?)?)?)?(=(.*)?)?$/, group)
        if (RSTART) {
            Option["width"] = group[4] ?
                (group[5] ? group[5] : Option["width"]) :
                ARGV[++pos]
            continue
        }

        # -indent NUM
        match(ARGV[pos], /^--?indent(=(.*)?)?$/, group)
        if (RSTART) {
            Option["indent"] = group[1] ?
                (group[2] ? group[2] : Option["indent"]) :
                ARGV[++pos]
            continue
        }

        # -theme FILENAME
        match(ARGV[pos], /^--?theme(=(.*)?)?$/, group)
        if (RSTART) {
            Option["theme"] = group[1] ?
                (group[2] ? group[2] : Option["theme"]) :
                ARGV[++pos]
            continue
        }

        # -no-theme
        match(ARGV[pos], /^--?no-theme$/)
        if (RSTART) {
            Option["theme"] = NULLSTR
            continue
        }

        # -no-ansi
        match(ARGV[pos], /^--?no-ansi$/)
        if (RSTART) {
            Option["no-ansi"] = 1
            continue
        }

        # -no-autocorrect
        match(ARGV[pos], /^--?no-auto(correct)?$/)
        if (RSTART) {
            Option["no-autocorrect"] = 1
            continue
        }

        # -no-bidi
        match(ARGV[pos], /^--?no-bidi/)
        if (RSTART) {
            Option["no-bidi"] = 1
            continue
        }

        # -bidi
        match(ARGV[pos], /^--?bidi/)
        if (RSTART) {
            Option["force-bidi"] = 1
            continue
        }

        # -no-warn
        match(ARGV[pos], /^--?no-warn/)
        if (RSTART) {
            Option["no-warn"] = 1
            continue
        }

        # -dump
        match(ARGV[pos], /^--?dump/)
        if (RSTART) {
            Option["dump"] = 1
            continue
        }

        ## Audio options

        # -p, -play
        match(ARGV[pos], /^--?p(l(ay?)?)?$/)
        if (RSTART) {
            Option["play"] = 1
            continue
        }

        # -speak
        match(ARGV[pos], /^--?sp(e(ak?)?)?$/)
        if (RSTART) {
            Option["play"] = 2
            continue
        }

        # -n VOICE, -narrator VOICE
        match(ARGV[pos], /^--?(n|narrator)(=(.*)?)?$/, group)
        if (RSTART) {
            if (!Option["play"]) Option["play"] = 1 # -play by default
            Option["narrator"] = group[2] ?
                (group[3] ? group[3] : Option["narrator"]) :
                ARGV[++pos]
            continue
        }

        # -player PROGRAM
        match(ARGV[pos], /^--?player(=(.*)?)?$/, group)
        if (RSTART) {
            if (!Option["play"]) Option["play"] = 1 # -play by default
            Option["player"] = group[1] ?
                (group[2] ? group[2] : Option["player"]) :
                ARGV[++pos]
            continue
        }

        # -no-play
        match(ARGV[pos], /^--?no-play$/)
        if (RSTART) {
            Option["play"] = 0
            continue
        }

        # -no-translate
        match(ARGV[pos], /^--?no-tran(s(l(a(te?)?)?)?)?$/)
        if (RSTART) {
            Option["no-translate"] = 1
            continue
        }

        # -download-audio
        match(ARGV[pos], /^--?download-a(u(d(io?)?)?)?$/)
        if (RSTART) {
            Option["download-audio"] = 1
            continue
        }

        # -download-audio-as
        match(ARGV[pos], /^--?download-audio-as(=(.*)?)?$/, group)
        if (RSTART) {
            if (!Option["download-audio"]) Option["download-audio"] = 1
            Option["download-audio-as"] = group[1] ?
                (group[2] ? group[2] : Option["download-audio-as"]) :
                ARGV[++pos]
            continue
        }

        ## Terminal paging and browsing options

        # -v, -view
        match(ARGV[pos], /^--?v(i(ew?)?)?$/)
        if (RSTART) {
            Option["view"] = 1
            continue
        }

        # -pager PROGRAM
        match(ARGV[pos], /^--?pager(=(.*)?)?$/, group)
        if (RSTART) {
            Option["view"] = 1
            Option["pager"] = group[1] ?
                (group[2] ? group[2] : Option["pager"]) :
                ARGV[++pos]
            continue
        }

        # -no-view
        match(ARGV[pos], /^--?no-view$/)
        if (RSTART) {
            Option["view"] = 0
            continue
        }

        # -browser PROGRAM
        match(ARGV[pos], /^--?browser(=(.*)?)?$/, group)
        if (RSTART) {
            Option["browser"] = group[1] ?
                (group[2] ? group[2] : Option["browser"]) :
                ARGV[++pos]
            continue
        }

        ## Networking options

        # -x HOST:PORT, -proxy HOST:PORT
        match(ARGV[pos], /^--?(x|proxy)(=(.*)?)?$/, group)
        if (RSTART) {
            Option["proxy"] = group[2] ?
                (group[3] ? group[3] : Option["proxy"]) :
                ARGV[++pos]
            continue
        }

        # -u STRING, -user-agent STRING
        match(ARGV[pos], /^--?(u|user-agent)(=(.*)?)?$/, group)
        if (RSTART) {
            Option["user-agent"] = group[2] ?
                (group[3] ? group[3] : Option["user-agent"]) :
                ARGV[++pos]
            continue
        }

        ## Interactive shell options

        # -I, -interactive, -shell
        match(ARGV[pos], /^--?(I|int(e(r(a(c(t(i(ve?)?)?)?)?)?)?)?|shell)$/)
        if (RSTART) {
            Option["interactive"] = 1
            continue
        }

        # -E, -emacs
        match(ARGV[pos], /^--?(E|emacs)$/)
        if (RSTART) {
            Option["emacs"] = 1
            continue
        }

        # -no-rlwrap
        match(ARGV[pos], /^--?no-rlwrap$/)
        if (RSTART) {
            Option["no-rlwrap"] = 1
            continue
        }

        # FIXME[1.0]: to be removed
        # -prompt PROMPT_STRING
        match(ARGV[pos], /^--?prompt(=(.*)?)?$/, group)
        if (RSTART) {
            w("[ERROR] Option '-prompt' has been deprecated since version 0.9.\n" \
              "        Use configuration variable 'fmt-prompt' instead.")
            exit 1
        }

        # FIXME[1.0]: to be removed
        # -prompt-color COLOR_CODE
        match(ARGV[pos], /^--?prompt-color(=(.*)?)?$/, group)
        if (RSTART) {
            w("[ERROR] Option '-prompt-color' has been deprecated since version 0.9.\n" \
              "        Use configuration variable 'sgr-prompt' instead.")
            exit 1
        }

        ## I/O options

        # -i FILENAME, -input FILENAME
        match(ARGV[pos], /^--?i(n(p(ut?)?)?)?(=(.*)?)?$/, group)
        if (RSTART) {
            Option["input"] = group[4] ?
                (group[5] ? group[5] : Option["input"]) :
                ARGV[++pos]
            continue
        }

        # -o FILENAME, -output FILENAME
        match(ARGV[pos], /^--?o(u(t(p(ut?)?)?)?)?(=(.*)?)?$/, group)
        if (RSTART) {
            Option["output"] = group[5] ?
                (group[6] ? group[6] : Option["output"]) :
                ARGV[++pos]
            continue
        }

        ## Language preference options

        # -l CODE, -hl CODE, -lang CODE
        match(ARGV[pos], /^--?(l(a(ng?)?)?|hl)(=(.*)?)?$/, group)
        if (RSTART) {
            Option["hl"] = group[4] ?
                (group[5] ? group[5] : Option["hl"]) :
                ARGV[++pos]
            continue
        }

        # -s CODES, -sl CODES, -source CODES, -f CODES, -from CODES
        match(ARGV[pos], /^--?(s(o(u(r(ce?)?)?)?|l)?|f|from)(=(.*)?)?$/, group)
        if (RSTART) {
            if (group[6]) {
                if (group[7]) split(group[7], Option["sls"], "+")
            } else
                split(ARGV[++pos], Option["sls"], "+")
            Option["sl"] = Option["sls"][1]
            continue
        }

        # -t CODES, -tl CODES, -target CODES, -to CODES
        match(ARGV[pos], /^--?t(a(r(g(et?)?)?)?|l|o)?(=(.*)?)?$/, group)
        if (RSTART) {
            if (group[5]) {
                if (group[6]) split(group[6], Option["tl"], "+")
            } else
                split(ARGV[++pos], Option["tl"], "+")
            continue
        }

        # Shortcut format
        # 'CODE:CODE+...' or 'CODE=CODE+...'
        match(ARGV[pos], /^[{(\[]?((@?[[:alpha:]][[:alpha:]][[:alpha:]]?(-[[:alpha:]][[:alpha:]][[:alpha:]]?[[:alpha:]]?)?\+)*(@?[[:alpha:]][[:alpha:]][[:alpha:]]?(-[[:alpha:]][[:alpha:]][[:alpha:]]?[[:alpha:]]?)?)?)?(:|=)((@?[[:alpha:]][[:alpha:]][[:alpha:]]?(-[[:alpha:]][[:alpha:]][[:alpha:]]?[[:alpha:]]?)?\+)*(@?[[:alpha:]][[:alpha:]][[:alpha:]]?(-[[:alpha:]][[:alpha:]][[:alpha:]]?[[:alpha:]]?)?)?)[})\]]?$/, group)
        if (RSTART) {
            if (group[1]) {
                split(group[1], Option["sls"], "+")
                Option["sl"] = Option["sls"][1]
            }
            if (group[7]) split(group[7], Option["tl"], "+")
            continue
        }

        ## Other options

        # -D, -debug
        match(ARGV[pos], /^--?(D|debug)$/)
        if (RSTART) {
            Option["debug"] = 1
            continue
        }

        # -no-init
        match(ARGV[pos], /^--?no-init/)
        if (RSTART) continue # skip

        # -, -no-op
        match(ARGV[pos], /^-(-?no-op)?$/)
        if (RSTART) continue # no operation, skip

        # --
        match(ARGV[pos], /^--$/)
        if (RSTART) {
            ++pos # skip the end-of-options option
            break # no more option from here
        }

        # non-option argument
        noargv[noargc++] = ARGV[pos]
    }

    # Handle interactive shell
    if (Option["interactive"] && !Option["no-rlwrap"])
        rlwrapMe() # interactive mode
    else if (Option["emacs"] && !Option["interactive"] && !Option["no-rlwrap"])
        if (emacsMe()) # emacs front-end
            Option["interactive"] = 1 # fallback to interactive mode

    # Get started

    initMisc()

    # Information-only session
    switch (InfoOnly) {
    case "version":
        print getVersion()
        exit ExitCode
    case "help":
        print getHelp()
        exit ExitCode
    case "manual":
        showMan()
        exit ExitCode
    case "reference":
        print getReference("endonym")
        exit ExitCode
    case "reference-english":
        print getReference("name")
        exit ExitCode
    case "list":
        print getList(Option["tl"])
        exit ExitCode
    case "list-engines":
        for (translator in Translator)
            print (Option["engine"] == translator ? "* " : "  ") translator
        exit ExitCode
    case "upgrade":
        upgrade()
        exit ExitCode
    case "nothing":
        exit ExitCode
    }

    # Load theme (overrides command-line options) - slow
    setTheme()

    if (Option["interactive"])
        welcome()

    # More remaining non-option arguments
    if (pos < ARGC)
        for (i = pos; i < ARGC; i++)
            noargv[noargc++] = ARGV[i]

    if (noargc) {
        # Translate all non-option arguments
        for (i = 0; i < noargc; i++) {
            # Verbose mode: separator between sources
            if (Option["verbose"] && i > pos)
                p(prettify("source-seperator", replicate(Option["chr-source-seperator"], Option["width"])))

            translates(noargv[i], 1) # inline mode
        }

        # If input not specified, we're done
    } else {
        # If input not specified, use stdin
        if (!Option["input"]) Option["input"] = STDIN
    }

    # If input specified, start translating
    if (Option["input"])
        translateMain()

    exit ExitCode
}
